# Deploying DataClarity Is Free Forever (DIFF) to AWS

## Prerequisite for VPC version
* An AWS key pair created
* A VPC and subnet created if you want to install to a non-default VPC
* Permission to create Security Groups

#### Launch VPC version
[![AWS Cloudformation](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://us-east-2.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?templateURL=https://dataclaritycorp.s3.amazonaws.com/aws-cloud-formation/dataclarity_cf_vpc.yaml&stackName=DataClarity)


#### Launch non VPC version
[![AWS Cloudformation](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://us-east-2.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?templateURL=https://dataclaritycorp.s3.amazonaws.com/aws-cloud-formation/dataclarity_cf.yaml&stackName=DataClarity)
