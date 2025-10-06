# Infrastructure-as-code using Terraform that provisions a basic service with auto-scaling capabilities.

## Pre-requisites
Make sure you have Docker and Terraform installed locally.

You will need an AWS Amazon account with CLI credentials to freely deploy Terraform resources.

You WILL need to manually create your own private AWS ECR repository. A basic Python Docker image has been provided for this demo.
Commands will be provided; please replace any ```<TAG>``` with relevant information.

Be sure to update the variables in the `dev.tfvars` file as well!!

### Build and push docker images
A basic Python flask app has been provided in the ./docker-python directory. 

You can run the following command to build, tag, and push the new image to your ECR repo.

Login to set temporary creds
```bash
aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
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
##### ECS: 
New cluster, containing a new autoscaling enabled service, which contains tasks - each corresponding to the Python image we built earlier.

##### EC2: 
New instances are used as Container instance "infrastructure" in ECS, deployed via Launch Template and Auto Scaling Groups.
The application is reachable via the Load Balancer's DNS Name. 

To trigger auto-scaling out (scale up), visit the Load Balancer's /burn route (i.e. python-lb-1497354134.us-west-2.elb.amazonaws.com/burn) This will time out on the web page; this is expected. Check the logs to see that the route has been triggered.

You can check the Python Docker image to see that this route will simulate CPU load, which should cause the service to automatically scale up for the next few minutes (to the max of 3 tasks, as we have configured 3 EC2 instances max). NOTE THAT THIS WILL TAKE A FEW MINUTES TO BE TRIGGERED!

CloudWatch: Logs from the application are accessible from CloudWatch at the defined `logs_group` variable path.

Feel free to adjust/tweak numbers in each resource to your liking!

## Clean Up ECS infrastructure
```
terraform destroy
```

## Review
For this short demo, we simulate CPU load to cause the application (ECS Service) to automatically scale in and out. This autoscaling only affects tasks, not the EC2 instances.

If given more time, we can further optimize by adding auto-scaling to our EC2 instances, either via traditional ASG auto-scaling policies based on Cloudwatch metrics or through the newer Capacity Provider integration with ECS. The decision was made deliberately to implement this with EC2 instances instead of Fargate so that we have direct access and control over our underlying EC2 infrastructure. Additional services could also be added to show auto-scaling on an individual application-level basis. 




## AI Assistance Policy
ChatGPT was used for general questions and to generate base boilerplate code for Terraform configuration.
Basic prompt: "Please generate basic boilerplate code for an ECS cluster on AWS". From this prompt, I then modified it to include other required services and to fit the purpose of demo-ing an auto-scaling application deployed on AWS using EC2 Instances as ECS Cluster Infrastructure. 
AI-produced c ode was manually reviewed and tested after deployment to an AWS account.