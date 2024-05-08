provider "aws" {
  	region  = "us-east-1"
  	profile = "default"
}

resource "aws_s3_bucket" "s3" {
	bucket = "bucket923-by-tf"
}

resource "aws_s3_bucket_policy" "s3-bucket-policy" {
    bucket = aws_s3_bucket.s3.id
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "Allow-specific-ip_addresses"
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::bucket923-by-tf/*",
          "Condition": {
            "IpAddress": {
              "aws:SourceIp": [
                "46.162.196.212",
                "195.0.46.128"
              ]
            }
          }
        }
      ]
    })
}

resource "aws_s3_object" "upload-file" {
	bucket       = aws_s3_bucket.s3.id
  	key          = "index.html"
  	source       = "./index.html"
  	content_type = "text/html"   //with the help
  	#etag        = filemd5("${path.module}/./index.html")
}

/*
resource "aws_s3_bucket_policy" "Allow-specific-ip" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Id        = "MyBacketPolicy"
    Statement = [
      {
        Sid       = "Allow-specific-ip"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = [
          aws_s3_bucket.s3.arn,
          "${aws_s3_bucket.s3.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "46.162.196.212"
          }
        }
      },
    ]
  })
}
*/
