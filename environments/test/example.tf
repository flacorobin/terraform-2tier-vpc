provider "aws" {
#Credentials of access key for accessing AWS account. These are for the user "flac_work_pc"

#Credentials saved on variables in the variables.tf file. NEVER SHARE the varaibles.tf FILE!!
	access_key 	= var.access_key
	secret_key 	= var.secret_key
	region 			= var.region
	version			= "~> 2.10"
}



module "MyVPC" {
	source 					= "./modules/VPC/"
	vpc_cidr_block 	= "10.0.0.0/16"

	public_subnet_cidr_block = "10.0.1.0/24"
}
