# Docker_AWS
2048 Game Deployment - Docker & AWS Terraform
This project demonstrates a complete DevOps lifecycle by containerizing a web application (the 2048 game) using Docker and deploying it to AWS Elastic Beanstalk using Infrastructure as Code (Terraform).

🚀 Project Overview
Application: 2048 Game (Static Web App served via Nginx)

Containerization: Docker (Alpine-based Nginx image)

Infrastructure: AWS Elastic Beanstalk (Paas)

IaC Tool: Terraform

Cloud Provider: AWS (US-East-1)

🛠️ Prerequisites
Docker Desktop installed locally.

Terraform installed (brew install terraform).

AWS CLI configured with valid credentials.

📂 Project Structure
Plaintext
.
├── Dockerfile          # Instructions to build the game image (Nginx + Game Code)
├── main.tf             # Terraform code to provision S3 and Elastic Beanstalk
└── README.md           # This documentation
🏗️ How to Deploy
1. Initialize Terraform

Download the required AWS providers.

Bash
terraform init
2. Plan and Apply

Review the infrastructure plan and deploy to AWS.

Bash
terraform apply
Type yes when prompted.

3. Access the Game

Once deployment finishes (approx. 5 mins), Terraform will output the live URL:

Bash
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:
game_url = "http://2048-game-env.eba-xxxx.us-east-1.elasticbeanstalk.com"
Click the link to play the game live on the internet!

🧪 Local Testing (Docker)
If you want to run the game locally on your machine before deploying:

Bash
# Build the image
docker build -t 2048-game .

# Run container (Mapped to port 8080 to avoid Mac port conflicts)
docker run -d -p 8080:80 2048-game
Access locally at: http://localhost:8080

🧹 Clean Up
To avoid AWS charges, destroy the infrastructure when finished:

Bash
terraform destroy

💡 Key Learnings & Troubleshooting
Docker & Nginx: Switched from ubuntu base image to nginx:alpine for a smaller footprint and better security.

Port Conflicts: Resolved macOS blocking Port 80 by mapping traffic to Port 8080 during local testing.

Infrastructure as Code: Automated the upload of the Dockerfile to S3 and the provisioning of Elastic Beanstalk environments without using the AWS Console manually.
