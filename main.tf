terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}

provider "aws"{
    region = "us-east-1"
}

resource "aws_s3_bucket" "game_bucket"{
    bucket_prefix = "2048-game-s3-123"
    force_destroy = true
}

resource "aws_s3_object" "docker_file"{
    bucket = aws_s3_bucket.game_bucket.id
    key = "Dokerfile"
    source = "Dockerfile"
}

resource "aws_elastic_beanstalk_application" "game-app"{
  name = "2048-game-terraform"
  description = "2048 Game deployed via terraform using Docker file only"
}

resource "aws_elastic_beanstalk_application_version" "game_version"{
  name = "v1-dockerfile"
  application = aws_elastic_beanstalk_application.game-app.name
  description = "Initial Version"
  bucket = aws_s3_bucket.game_bucket.id
  key = aws_s3_object.docker_file.key
}

data "aws_elastic_beanstalk_solution_stack" "docker"{
  most_recent = true
  name_regex = "^64bit Amazon Linux 2023 v.* running Docker$"
}

resource "aws_elastic_beanstalk_environment" "game_env" {
  name = "2048-game-env"
  application = aws_elastic_beanstalk_application.game-app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.docker.name
  version_label = aws_elastic_beanstalk_application_version.game_version.name

setting {
  namespace = "aws:autoscaling:launchconfiguration"
  name = "IamInstanceProfile"
  value = "aws-elasticbeanstalk-ec2-role"
}

setting {
  namespace = "aws:elasticbeanstalk:environment"
  name = "EnvironmentType"
  value = "SingleInstance"
}

}

output "game_url" {
  value = "http://${aws_elastic_beanstalk_environment.game_env.cname}"
  description = "Click on the link to play the game."
}



