resource "aws_iam_role_policy_attachment" "ssm_role" {
  role       = aws_iam_role.ec2_common_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  # policy_arn = aws_iam_policy.session_manager_minimum.arn
}

resource "aws_ssm_document" "session_manager" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName                = ""
      s3KeyPrefix                 = ""
      s3EncryptionEnabled         = true
      cloudWatchLogGroupName      = ""
      cloudWatchEncryptionEnabled = true
      kmsKeyId                    = ""
      # idleSessionTimeout          = "20" 
      shellProfile = {
        linux   = ""
        windows = ""
      }


    }
  })
}
