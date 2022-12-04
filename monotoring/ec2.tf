data "aws_vpc" "default" {
  default = true
}

# find default vpc - ap-northeast-2a subnet id
data "aws_subnet" "az_2a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-northeast-2a"]
  }
}

# find ubunt 20.0.4 ami id
data "aws_ami" "ubuntu_focal" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "template_file" "cloudinit" {
  template = file("${path.module}/files/cloud-init.cfg")

  vars = {
    timezone = "${var.timezone}"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/files/install_cloud_watch_agent.sh")

  vars = {
    region         = "${var.region}"
    param_cw_agent = "${var.param_cw_agent}"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudinit.rendered
  }
  part {
    filename     = "common-init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data.rendered
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "tjtest" {
  count = var.create ? 2 : 0

  ami = data.aws_ami.ubuntu_focal.id

  availability_zone = "ap-northeast-2a"
  instance_type     = "t2.micro"
  key_name          = var.key_name

  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }

  # subnet_id = "subnet-bca21bd7"
  subnet_id = data.aws_subnet.az_2a.id

  tags = {
    Name   = "tjtest-${count.index}"
    tostop = true
  }

  vpc_security_group_ids = [aws_security_group.tjtest[0].id]
  # vpc_security_group_ids = ["sg-a712a9da"] # default

  iam_instance_profile = "ec2-common-role"

  user_data = data.template_cloudinit_config.config.rendered
  # user_data  = templatefile("install_cloud_watch_agent.sh", { region = var.region })
  # user_data_replace_on_change = true

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      # user_data,
      ami
    ]
  }
}


## IAM role
resource "aws_iam_role" "ec2_common_role" {
  name = "ec2-common-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_role" {
  name = "ec2-common-role"
  role = aws_iam_role.ec2_common_role.name
}


# ec2 instance scheduler
module "stop_ec2_instance" {
  source  = "diodonfrost/lambda-scheduler-stop-start/aws"
  version = "3.1.3"

  name                           = "ec2_stop"
  cloudwatch_schedule_expression = "cron(0 10 * * ? *)"
  schedule_action                = "stop"
  autoscaling_schedule           = "false"
  ec2_schedule                   = "true"
  rds_schedule                   = "false"
  resources_tag = {
    key   = "tostop"
    value = "true"
  }
}
