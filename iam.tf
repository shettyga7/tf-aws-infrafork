resource "aws_iam_policy" "s3_policy" {
  name        = "S3BucketAccessPolicy"
  description = "IAM policy for S3 bucket access"
  policy      = file("S3BucketPolicy.json")
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role       = aws_iam_role.ec2_role.name
}