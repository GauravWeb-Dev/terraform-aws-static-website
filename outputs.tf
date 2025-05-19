output "website_url" {
  description = "S3 Static Website Endpoint"
  value       = aws_s3_bucket_website_configuration.mywebapp.website_endpoint
}

