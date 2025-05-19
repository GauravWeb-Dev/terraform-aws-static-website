
# Hosting Static Website on AWS S3 using Terraform  
*By Gaurav Sardar*

---

## 🚀 Project Overview

This project automates the hosting of a static website on AWS S3 using Terraform.
 It demonstrates how Infrastructure as Code (IaC) helps deploy and manage cloud infrastructure efficiently, enabling version control, repeatability, and automation.

---

## 🧱 Tech Stack

- Terraform  
- AWS S3  
- HTML/CSS  
- Linux Terminal  
- AWS CLI  

---

## 📁 Project Folder Structure

Below is the structure of the project files including Terraform scripts and website files.

![Folder Structure](images/01-folder-structure.png)  
*Project organized with Terraform config files and website assets.*

---

## Terraform Code Snippets with Explanations

### provider.tf

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}
```

This file configures Terraform to use the AWS and Random providers with specific versions. The AWS provider is set to the `eu-north-1` region, which tells Terraform where to create AWS resources.

---

### random\_id Resource

```hcl
resource "random_id" "rand_id" {
  byte_length = 8
}
```

Generates a unique random ID of 8 bytes used to create a unique S3 bucket name. This avoids naming conflicts since S3 bucket names must be globally unique.

---

### S3 Bucket Resource

```hcl
resource "aws_s3_bucket" "mywebapp_bucket" {
  bucket = "mywebapp-bucket-${random_id.rand_id.hex}"
}
```

Creates an S3 bucket with a dynamic name that includes the random ID generated above, ensuring uniqueness.

---

### S3 Bucket Public Access Block

```hcl
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mywebapp_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

Configures the bucket’s public access settings to allow public access. This is essential for hosting a public static website.

---

### S3 Bucket Policy

```hcl
resource "aws_s3_bucket_policy" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp_bucket.id

  depends_on = [aws_s3_bucket_public_access_block.example]

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject",
          Resource  = "${aws_s3_bucket.mywebapp_bucket.arn}/*"
        }
      ]
    }
  )
}
```

Applies a bucket policy that grants public read access to all objects in the bucket, allowing anyone to view the website files.

---

### S3 Bucket Website Configuration

```hcl
resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp_bucket.id

  index_document {
    suffix = "index.html"
  }
}
```

Enables static website hosting on the bucket and sets `index.html` as the default landing page.

---

### Upload index.html to S3

```hcl
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.mywebapp_bucket.bucket
  source       = "./index.html"
  key          = "index.html"
  content_type = "text/html"
}
```

Uploads the local `index.html` file to the S3 bucket as the main page of the website.

---

### Upload styles.css to S3

```hcl
resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.mywebapp_bucket.bucket
  source       = "./styles.css"
  key          = "styles.css"
  content_type = "text/css"
}
```

Uploads the `styles.css` stylesheet to the bucket to style the website.

---

### output.tf

```hcl
output "website_url" {
  description = "S3 Static Website Endpoint"
  value       = aws_s3_bucket_website_configuration.mywebapp.website_endpoint
}
```

Outputs the public URL of the static website once Terraform finishes applying, so you can easily access your hosted site.

---

## ⚡ Terraform Deployment Workflow

### Terraform Init

![Terraform Init](images/02-terraform-init.png)
*Initializes Terraform configuration and downloads necessary AWS providers.*

---

### Terraform Plan

![Terraform Plan](images/03-terraform-plan.png)
*Shows the planned AWS resources Terraform will create or change.*

---

### Terraform Apply

![Terraform Apply](images/04-terraform-apply.png)
*Applies the plan, creating S3 bucket, policies, and uploading website files.*

---

## ☁️ AWS Console Verification

### S3 Bucket Created

![S3 Bucket](images/05-aws-console-s3-bucket.png)
*Verifies the S3 bucket exists in the AWS Console.*

---

### Uploaded Website Files

![S3 Upload Files](images/06-s3-upload-files.png)
*Confirms the HTML and CSS files are uploaded to the S3 bucket.*

---

### Static Website Hosting Enabled

![S3 Static Website Settings](images/07-s3-static-website-settings.png)
*Shows static website hosting configuration with index document.*

---

### Final Website Preview

![Website Preview](images/08-website-preview.png)
*Live preview of the hosted static website from S3.*

---

## 🎓 What I Learned

* Automating AWS infrastructure using Terraform
* Writing public read bucket policies for static websites
* Structuring Terraform code for reusability and clarity
* Managing website deployment with Infrastructure as Code

---

## 📩 Connect with Me

* [LinkedIn](https://www.linkedin.com/in/gaurav-sardar)
* Email: [gauravsardar85@gmail.com](mailto:gauravsardar85@gmail.com)
* Phone: +91 7499004477

---

## 📢 Hashtags

 #terraform #aws #devops #cloudcomputing #iac #s3 #staticwebsite #cloudengineer #openforwork #GauravSardar
