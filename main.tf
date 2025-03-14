# Create an S3 bucket
resource "aws_s3_bucket" "mybucket" {
  # The bucket name is provided by the variable 'bucketname'
  bucket = var.bucketname
}

# Configure the ownership controls for the bucket
resource "aws_s3_bucket_ownership_controls" "example" {
  # Reference the bucket created earlier
  bucket = aws_s3_bucket.mybucket.id

  # Set object ownership to 'BucketOwnerPreferred', meaning the bucket owner 
  # will have full ownership of the objects in the bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure the public access block settings for the bucket
resource "aws_s3_bucket_public_access_block" "example" {
  # Reference the bucket created earlier
  bucket = aws_s3_bucket.mybucket.id

  # Allow public access to the bucket (false values)
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set the ACL (Access Control List) of the bucket to allow public read access
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    # Ensure ownership controls and public access block are applied before the ACL
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  # Reference the bucket created earlier
  bucket = aws_s3_bucket.mybucket.id
  # Set ACL to 'public-read', meaning the objects in the bucket can be read by anyone
  acl    = "public-read"
}

# Upload the 'index.html' file to the S3 bucket
resource "aws_s3_object" "index" {
  # Reference the bucket created earlier
  bucket = aws_s3_bucket.mybucket.id
  # Key for the object (this will be the file name in the bucket)
  key = "index.html"
  # Source file on the local machine to upload
  source = "index.html"
  # Set ACL to 'public-read' for the file
  acl = "public-read"
  # Set the content type for the HTML file
  content_type = "text/html"
}

# Upload the 'error.html' file to the S3 bucket
resource "aws_s3_object" "error" {
  # Reference the bucket created earlier
  bucket = aws_s3_bucket.mybucket.id
  # Key for the object (this will be the file name in the bucket)
  key = "error.html"
  # Source file on the local machine to upload
  source = "error.html"
  # Set ACL to 'public-read' for the file
  acl = "public-read"
  # Set the content type for the HTML file
  content_type = "text/html"
}

# Upload the 'profile.png' image to the S3 bucket
resource "aws_s3_object" "profile" {
  # Reference the bucket created earlier
  bucket = aws_s3_bucket.mybucket.id
  # Key for the object (this will be the file name in the bucket)
  key = "profile.png"
  # Source file on the local machine to upload
  source = "profile.png"
  # Set ACL to 'public-read' for the file
  acl = "public-read"
}

# Configure the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  # Reference the bucket created earlier
  bucket = aws_s3_bucket.mybucket.id
  
  # Set the index document to be 'index.html'
  index_document {
    suffix = "index.html"
  }

  # Set the error document to be 'error.html'
  error_document {
    key = "error.html"
  }

  # Ensure that the ACL is set before configuring the website
  depends_on = [ aws_s3_bucket_acl.example ]
}
