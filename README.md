AWS Infrastructure Setup with Terraform

Provisioning Networking Resources in AWS Using Terraform

1. Overview

This project automates the provisioning of AWS networking resources using Terraform. The setup includes:

A Virtual Private Cloud (VPC)

Public and Private Subnets across multiple Availability Zones

An Internet Gateway (IGW)

Public and Private Route Tables with appropriate associations

Route configurations for internet access

2. Prerequisites

Before you begin, ensure the following prerequisites are met:

2.1. Install Required Tools

AWS CLI (Installation Guide)

Terraform (Installation Guide)

Git (Installation Guide)

2.2. AWS Credentials Configuration

Set up an IAM user in AWS with programmatic access.

Configure AWS CLI with your IAM credentials:

aws configure --profile dev

Provide:

AWS Access Key ID

AWS Secret Access Key

Default Region: us-east-1

Default Output Format: json

Verify the AWS profile:

aws configure list --profile dev

You should see your configured profile.

3. Project Structure

The Terraform code is structured as follows:

tf-aws-infra/
│── modules/
│   ├── vpc.tf                 # Defines VPC
│   ├── subnets.tf              # Defines Public and Private Subnets
│   ├── internet_gateway.tf     # Defines Internet Gateway
│   ├── route_tables.tf         # Defines Public and Private Route Tables
│   ├── variables.tf            # Variables for Terraform
│   ├── route_table_association             
│── env/
│   ├── dev.tfvars              # Dev environment variables
│── providers.tf                 # AWS Provider Configuration
│── version.tf                   # Terraform Version Config
│── README.md                    # Documentation
│── .gitignore                    # Git Ignore File

1. Setting Up the Infrastructure

4.1. Clone the Repository

git clone git@github.com:shettyga7/tf-aws-infrafork.git
cd tf-aws-infrafork

4.2. Initialize Terraform

Run the following command to initialize Terraform and download necessary providers:

terraform init

4.3. Validate Terraform Configuration

terraform validate

This checks the correctness of your Terraform configuration.

4.4. Plan Terraform Deployment

Before applying the changes, review the execution plan:

terraform plan -var-file="env/dev.tfvars"

4.5. Apply Terraform Configuration

To create the resources in AWS, execute:

terraform apply -var-file="env/dev.tfvars"

Type yes when prompted.

5. Infrastructure Components

5.1. Virtual Private Cloud (VPC)

A VPC with a CIDR block of 10.0.0.0/16.

5.2. Subnets

3 Public Subnets (one in each Availability Zone).

3 Private Subnets (one in each Availability Zone).

5.3. Internet Gateway (IGW)

Attached to the VPC to allow internet access for public subnets.

5.4. Route Tables

Public Route Table (with a route to IGW).

Private Route Table (isolated for internal traffic).

6. Destroying the Infrastructure

To delete all provisioned AWS resources, run:

terraform destroy -var-file="env/dev.tfvars"

Type yes to confirm.

7. Best Practices

✔ Use Terraform state management properly.✔ Avoid committing Terraform state files (terraform.tfstate).✔ Implement GitHub Actions CI/CD for Terraform validation.✔ Always use var-files (dev.tfvars, prod.tfvars) to manage configurations.

8. Troubleshooting

Error: Profile Not Found

If Terraform cannot read the AWS profile:

aws configure list-profiles

Ensure dev profile exists.

Error: Resource Already Exists

Run terraform state list to check existing resources.

Use terraform state rm <resource> to remove orphaned resources.



