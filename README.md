# AWS Secure VPC Demo
This is a demo I built to put together the scaffolding for a secure, scalable AWS VPC setup. This utilizes Terraform for the infrastructure automation and Packer to build the EC2 AMIs. Right now it just sets up a single EC2 instance running a Python simple server.

# Layout and Design
A diagram would do this more justice, and I can put one together, but for now, here's the rough design:
* 3 VPCs: Application, Database, and Management
* The Application VPC has a public and a private subnet. The public subnet houses an Application Load Balancer and the private subnet houses Application Servers as EC2 instances.
* The Database VPC is 100% private as there is no Internet Gateway. The application servers connect from the private subnet via a VPC peering connection. The database servers would be RDS instances.
* The Management VPC is locked from the outside world via a VPN and is meant to be an extension of your network. You would utilize this VPC to SSH to the Application or Database servers securely and privately over VPC peering connections
* The security groups are built to be as restrictive as possible. The only public internet traffic allows is HTTP/HTTPS traffic to the Application VPC.
* This structure ensures that there is only one public way in (two if you count hacking a VPN)
* This structure also ensures that if someone manages to get access to the Application VPC, they don't necessarily get access to the databases as they only have access to the public subnet in the Application VPC which has no database access.
* The ALB only allows HTTPS and will redirect any HTTP traffic to HTTPS

# Usage
1. Ensure that you have proper AWS credentials setup locally. On Unix, this means you've got a ~/.aws/credentials file
2. Build the demo AMI `packer build packer.json`
3. Build the AWS Infrastructure `terraform apply`

And that's it! This is utilizing my runt9.tk domain so obviously this isn't meant to work for anyone other than me at the moment.
