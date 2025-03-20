resource "random_uuid" "bucket_name" {}

resource "aws_s3_bucket" "webapp_bucket" {
  bucket        = random_uuid.bucket_name.result
  force_destroy = true

  tags = {
    Name        = "WebApp Bucket"
    Environment = "Dev"
  }
}

# Ownership Controls
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.webapp_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Public Access Block
resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket = aws_s3_bucket.webapp_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.webapp_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.webapp_bucket.id

  rule {
    id     = "TransitionToIA"
    status = "Enabled"

    filter {
      prefix = "" # Apply to all objects
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.webapp_bucket.bucket
  description = "Name of the S3 bucket created."
}
