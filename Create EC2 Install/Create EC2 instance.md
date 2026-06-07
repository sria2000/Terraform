Create a AWS EC2 Instance

1) Set the config
PS D:\Sri Claude\uigen> aws configure

Tip: You can deliver temporary credentials to the AWS CLI using your AWS Console session by running the command 'aws login'.

AWS Access Key ID [None]: YOUR_AWS_ACCESS_KEY
AWS Secret Access Key [None]: YOUR_AWS_SECRET_ACCESS_KEY
Default region name [None]: eu-west-2
Default output format [None]: 
PS D:\Sri Claude\uigen>

2) Create a terraform file

3) 

terraform init                      #Initialize config
terraform plan 			# Dry run before you apply
terraform apply                   # Creates a EC2 instance
yerraform destroy             # Delete the EC2 instance
