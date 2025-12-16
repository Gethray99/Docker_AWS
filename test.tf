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

