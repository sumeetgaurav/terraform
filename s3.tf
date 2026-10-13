resource "aws_s3_bucket" "my_bucket" {

  bucket = "ai-powered-devops-bucket-demo"

  tags = {
    Name        = "example"
    Environment = "dev"
  }
}
