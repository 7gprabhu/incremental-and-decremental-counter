resource "aws_s3_bucket" "website_bucket" {
  bucket = "incremental-and-decremental-counter-bucket"
  acl    = "public-read"
}
