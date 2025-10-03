output "aws_s3_bucket_arn" {
    value = aws_s3_bucket.bucket.arn
    description = "The ARN of the S3 bucket."
}

output "name" {
    value = aws_s3_bucket.bucket.bucket
    description = "The name of the S3 bucket."
}

output "bucket" {
    value = aws_s3_bucket.bucket
    description = "The S3 bucket resource."
}