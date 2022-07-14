AWS IAAC through Terraform 
----------------------------------------------------------------------------------------
This code is written for POC of a basic apache instance creation with the load balancers on a high level view. Please watch my config files for more detailed description.
On a high level We have created: VPC-1, Public Subnets -2, Private Subnets -3 with the required infra components. Along with the, 3 Ec2 with public LB and 3 with private LB. 



Pre-Requisites:
-----------------------------------------------------------------
AWS Free tier account
AWS CLI
Intellije Developement KIT for writing the Terraform Code
Terraform latest version
create a key pair for EC2 access
create a S3 bucket in us-west-2 and create two folders. One for Infrastructure and second for EC2 Instance creation. We are going to store our state files in this locations.
create your folder structure according to the Requirements.


------------------------------------------------------------------------------------------------------------------------
********************Note: Presuming All gthe above pre-Reqs are installed and verified therougly. *********************
------------------------------------------------------------------------------------------------------------------------

Open intellije and browse to the below as i have created my folders under this section.
cd C:\AWS\terraform_AWS\Projects\LendInvestCode\Infrastructure
Create infrastructure-lendinvest.config and update the file as below

region="us-west-2"
key="layer1/infrastructure.tfstate"
bucket="lendinvest-terraformstatefile-14-07-2022"

Create vpc.tf and perform below tasks, we have to create variables.tf for CIDRs of subnets and VPC. Please see the config files for the code.

create a VPC and enable DNS host Names = true

Create 3 subnets for public and 3 for private

Create Route Table One for Public subnets and another one for Private

Associate Route Table with Subnets 3 public subnets with public route and 3 private subnets with private.

Create a EIP for NAT gateway

create NateGateway and add it to private route tables.

Create InternetGateway and add it to public route table.

create lendinvest.tfvars for our variables for CIDR values, we are going to pass this while executing our terraform apply.

create output.tf so that our next phase EC2 resource creation can use these values.
---------------------------------------------------------------------------------------------------------------------------------------


Launching the code:
---------------------------------------------------------------------------
cd C:\AWS\terraform_AWS\Projects\LendInvestCode\Infrastructure
terraform.exe init -backend-config="infrastructure-lendinvest.config"
terraform.exe plan -var-file="lendinvest.tfvars" 
terraform.exe apply -var-file="lendinvest.tfvars"
terraform.exe destroy -var-file="lendinvest.tfvars"


****************************************************************************************************************************************
EC2 Instance creation
****************************************************************************************************************************************
Create backend-lendinvest.config and update with the S3 backend details
region="us-west-2"
key="layer2/backend.tfstate"
bucket="lendinvest-terraformstatefile-14-07-2022"
 
Create instances.tf and update with
-----------------------------------------------------------------------------------------------------------------------------------------
Create the provider module to download the necesary plugins for aws resources.

create the terraform module to use the s3 backend.

create data module for fecthing the infrastructure statefile output values.

create security group resources for private and public, 

Update public security groups allowing the traffic anything on 80, but SSH only from my desktop whereas egress is allowed for all.

Update the private security group allowing traffic just from the elastic load balancer SG.

create the Elastic Loadbalancer Security Group and make it publicly accessible.

create IAM Role, IAM policy, Instance profile and attach to ASG inorder to ASG launch the instances.

create ami data module for always use most recent AMI.

create private and Public Launch configuration for ASG. Update the User data with the refference of Instance name, so that we can verify when we browse the URL.

create Elastic load balancer for private and public ec2 instances, so that they can communicate each other inorder to gain high availability.

create ASG policies to launch the instances for bothe public and private.

------------------------------------------------------------------------------------------------------------------------------------------------

Launching the code:
---------------------------------------------------------------------------
cdC:\AWS\terraform_AWS\Projects\LendInvestCode\Instances
terraform.exe init -backend-config="backend-lendinvest.config"
terraform.exe plan -var-file="lendinvest.tfvars" 
terraform.exe apply -var-file="lendinvest.tfvars"
terraform.exe destroy -var-file="lendinvest.tfvars"


To change the terraform statefile from one bucket to another:
-------------------------------------------------------------------------------

terraform init -migrate-state -backend-config=C:\AWS\terraform_AWS\Projects\lendinvest_Production_Infra\lendinvest_Prod_Infra.config
