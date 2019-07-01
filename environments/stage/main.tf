provider "aws" {
#Credentials of access key for accessing AWS account. These are for the user "flac_work_pc"

#Credentials saved on variables in the variables.tf file. NEVER SHARE the varaibles.tf FILE!!
	access_key 	= var.access_key
	secret_key 	= var.secret_key
	region 			= var.region
	version			= "~> 2.10"
}


module "custom_vpc" {
	source 					= "../../modules/vpc/"

	vpc_cidr_block 	= "10.0.0.0/16"

	public_sn_cidr_block 					= ["10.0.0.0/24", "10.0.1.0/24"]
#	public_sn_availability_zone 	=	"us-east-1a" #removed, now usiung data.aws_availability_zones.azs.names which retrieves list of AZ available.

	private_sn_cidr_block 				= ["10.0.2.0/24"]
#	private_sn_availability_zone 	=	"us-east-1b" #removed, now usiung data.aws_availability_zones.azs.names which retrieves list of AZ available.
	private_sn_map_public_ip_on_launch = false
}

module "webserver_sg" {
	source 							=	"../../modules/webserver-sg/"
	webserver_sg_vpc_id = module.custom_vpc.vpc_id
	webserver_sg_ssh_ip = ["0.0.0.0/0"]
}

module "dbserver_sg" {
	source 							=	"../../modules/dbserver-sg/"
	dbserver_sg_vpc_id = module.custom_vpc.vpc_id
	dbserver_sg_ssh_ip = [module.custom_vpc.cidr_block]
}

module "webserver" {
#This creates a new EC2 instance
source 															=	"../../modules/ec2/"
ec2_ami															=	data.aws_ami.amazon-linux-2.id //data.aws_ami looks for latest ami on AWS. Defined on varaibles.tf
ec2_instance_number									= 1
ec2_instance_type										= "t2.micro"
ec2_key_name												= var.key_pairs[var.region] #KeyPair to be used on EC2
ec2_vpc_security_group_ids					=	[module.webserver_sg.id] #Attach existing SG, value expects a list of SG NAMES []
ec2_module_custom_vpc_private_sn_id	=	module.custom_vpc.public_sn_id[0]
ec2_user_data												= "${file("Bootscript_Webservers.sh")}" #reads Bootscript_Webservers.sh file from current directory and loads it as a bootstrap script

ec2_tags_name 											= "WebServer"
}

//	provisioner "local-exec"{
//	command = "echo ${aws_instance.WebServer01.public_ip} > ip_address.txt" #executes command locally, here gets the Public IP of the instance and saves it on a file
//	}
//}


module "dbserver" {
	source 															=	"../../modules/ec2/"
	ec2_ami															=	data.aws_ami.ubuntu.id //data.aws_ami looks for latest ami on AWS. Defined on varaibles.tf
	ec2_instance_number									= 1
	ec2_instance_type										= "t2.micro"
	ec2_key_name												= var.key_pairs[var.region] #KeyPair to be used on EC2
	ec2_vpc_security_group_ids					=	[module.dbserver_sg.id] #Attach existing SG, value expects a list of SG NAMES []
	ec2_module_custom_vpc_private_sn_id	=	module.custom_vpc.private_sn_id[0]
	#ec2_user_data												= "${file("Bootscript_Webservers.sh")}" #reads Bootscript_Webservers.sh file from current directory and loads it as a bootstrap script

	ec2_tags_name 											= "AppServer"
}


/*
resource "aws_eip" "ip" {
#This created a new Elastic IP and assigns it to instance created above
#Dependency Instance needed for this EIP will be created before. Terraform will create the instance first then apply EIP.
	instance = aws_instance.WebServer01.id
}
*/

/*
resource "aws_s3_bucket" "BootScriptBuket" {
  bucket 	= "terraform-getting-started-BootScriptBucket"
  acl 		= "private"
}

resource "aws_instance" "WebServer02" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
	#Dependecies aren't awlays explicit, if that is the case, we can make them explicit with the argument 'depends_on'
  # Tells Terraform that this EC2 instance must be created only after the S3 bucket has been created.
  depends_on = ["aws_s3_bucket.BootScriptBuket"]
}
*/
