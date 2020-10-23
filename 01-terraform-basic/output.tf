output "s3_bucket_versioning_enabled" {
  value = aws_s3_bucket.s3_bucket.versioning[0].enabled
}

output "s3_bucket_versioning_complete" {
  value = aws_s3_bucket.s3_bucket.versioning
}