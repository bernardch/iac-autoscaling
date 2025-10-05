# Infrastructure-as-code using Terraform that provisions a basic service with auto-scaling capabilities.

## Pre-requisites
Make sure you have Docker and Terraform installed locally.

You will need an AWS Amazon account with CLI credentials to freely deploy Terraform resources.

You WILL need to manually create your own private AWS ECR repository, and supply a docker image to be run as a service on AWS ECS.
Commands will be provided; please replace any ```<TAG>``` with relevant information.

Be sure to update the variables in the dev.tfvars file as well!

### Build and push docker images
A basic Python flask app has been provided in the ./docker-python directory. 

You can run the following command to build, tag, and push the new image to your ECR repo.


Login to set temporary creds
```bash
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
```
Build and push Python flask image
```bash
docker build <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<IMAGE-NAME>:latest --push ./
```

## Build ECS infrastructure

Update the variables in dev.tfvars to fit your own environment.

```bash
terraform apply -var-file="dev.tfvars"
```

## Live application can be inspected through AWS Console
A new cluster will be provisioned, viewable through the AWS Console. This cluster will be running our Python image as an auto-scaling service.

#### Observe: 
ECS: New cluster, containing a new autoscaling enabled service, which contains tasks - each corresponding to the Python image we built earlier.

EC2: New instances are used as Container instance "infrastructure" in ECS, deployed via Launch Template and Auto Scaling Groups.
The application is reachable via the Load Balancer's DNS Name.

CloudWatch: Logs from the application are accessible from CloudWatch at the defined `logs_group` variable path.

Feel free to adjust/tweak numbers in each resource to your liking!

## Clean Up ECS infrastructure
```
terraform destroy
```

## Review
For this short demo, we assume that the application will receive outside traffic / will receive enough traffic such that the application will actually auto scale. To simulate this situation, we can manually adjust the values / update our Terraform to tell the application how many instances of each task we want.

If given more time, more consideration should be put into locking down permissions for the various services/end users accessing the application (allowing all connections on port 5000 is not ideal). We could also add a few more services to show auto-scaling dependent on other factors/metrics.