# IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "ec2_secretsmanager_access" {
  name = "secretsmanager-access"
  role = aws_iam_role.ec2_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = aws_secretsmanager_secret.db_password.arn
      }
    ]
  })
}
# IAM Policy for S3 Access
resource "aws_iam_policy" "s3_policy" {
  name        = "S3BucketAccessPolicy"
  description = "IAM policy for S3 bucket access"
  policy      = file("${path.module}/S3BucketPolicy.json")
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role       = aws_iam_role.ec2_role.name
}

# IAM Policy for CloudWatch Agent Access
resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name   = "cloudwatch-agent-policy"
  policy = file("${path.module}/cloudwatch-agent-policy.json")
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
  role       = aws_iam_role.ec2_role.name
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_policy" "kms_ec2_policy" {
  name        = "kms-ec2-access"
  description = "Allow EC2 to use KMS for decrypting secrets and EBS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowUseOfKMSKey",
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        Resource = [
          module.kms.ec2_key_arn,
          module.kms.rds_key_arn,
          module.kms.s3_key_arn,
          module.kms.secretsmanager_key_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kms_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.kms_ec2_policy.arn
}