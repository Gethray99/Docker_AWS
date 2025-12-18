terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1. Provider Configuration
provider "aws" {
  region = "us-east-1" # Change this if you want a different region (e.g., "ap-south-1")
}

# 2. S3 Bucket to store the Dockerfile
resource "aws_s3_bucket" "game_bucket" {
  # This generates a random unique name like "2048-game-terraform-12345..."
  bucket_prefix = "2048-game-terraform-" 
  force_destroy = true # Allows deleting bucket even if it has files when you run 'destroy'
}

# 3. Upload the Dockerfile to S3
resource "aws_s3_object" "docker_file" {
  bucket = aws_s3_bucket.game_bucket.id
  key    = "Dockerfile"   # The name of the file in S3
  source = "Dockerfile"   # The actual file on your laptop (must exist!)
}

# 4. Create the Beanstalk Application
resource "aws_elastic_beanstalk_application" "game_app" {
  name        = "2048-game-terraform"
  description = "2048 Game deployed via Terraform using Dockerfile only"
}

# 5. Create the Application Version
# This links the "App" to the specific file in S3
resource "aws_elastic_beanstalk_application_version" "game_version" {
  name        = "v1-dockerfile"
  application = aws_elastic_beanstalk_application.game_app.name
  description = "Initial version"
  bucket      = aws_s3_bucket.game_bucket.id
  key         = aws_s3_object.docker_file.key
}

# 6. Look up the latest Docker Platform automatically
# This prevents errors if AWS updates the version number (e.g., v4.4.1 -> v4.4.2)
data "aws_elastic_beanstalk_solution_stack" "docker" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux 2023 v.* running Docker$"
}

# 7. Create the Environment (The actual server)
resource "aws_elastic_beanstalk_environment" "game_env" {
  name                = "2048-game-env"
  application         = aws_elastic_beanstalk_application.game_app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.docker.name
  version_label       = aws_elastic_beanstalk_application_version.game_version.name

  # --- CRITICAL SETTING: IAM Instance Profile ---
  # This grants the EC2 instance permission to talk to Beanstalk/ECS.
  # This role is usually created automatically by the AWS Console wizard.
  # If Terraform fails here, ensure this role exists in IAM.
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  # Use a Single Instance to stay Free Tier eligible (no Load Balancer cost)
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
}

# 8. Output the Game URL
output "game_url" {
  value       = "http://${aws_elastic_beanstalk_environment.game_env.cname}"
  description = "Click this URL to play the game"
}