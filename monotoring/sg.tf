resource "aws_security_group" "tjtest" {
  count = var.create ? 1 : 0

  name_prefix = "tjtest"

  tags = {
    Name = "tjtest"
  }

  #   vpc_id = "vpc-0dc44b66"
  vpc_id = data.aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh" {
  count = 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.test_pc_cidr
  security_group_id = aws_security_group.tjtest[0].id
}

resource "aws_security_group_rule" "http" {
  count = var.create ? 1 : 0

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.test_pc_cidr
  security_group_id = aws_security_group.tjtest[0].id
}

resource "aws_security_group_rule" "egress" {
  count = var.create ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tjtest[0].id
}
