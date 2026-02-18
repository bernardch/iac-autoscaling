# Infrastructure-as-code using Terraform that provisions a basic service with auto-scaling capabilities.

## Pre-requisites
Make sure you have Docker and Terraform installed locally.

You will need an AWS Amazon account with CLI credentials to freely deploy Terraform resources.

You WILL need to manually create your own private AWS ECR repository. A basic Python Docker image has been provided for this demo.
Commands will be provided; please replace any ```<TAG>``` with relevant information.

Be sure to update the variables in the `dev.tfvars` file as well!!

### Which cloud to deploy (AWS vs Azure)

Use the **`cloud`** variable to deploy either AWS or Azure. Only one is active per apply.

- **AWS:** `terraform apply -var="cloud=aws" -var-file="dev.aws.tfvars"`
- **Azure:** `terraform apply -var="cloud=azure" -var-file="dev.azure.tfvars"`

You can also set `cloud = "aws"` or `cloud = "azure"` inside your tfvars file. Valid values are `"aws"` and `"azure"` only.

### Build and push docker images
A basic Python flask app has been provided in the ./docker-python directory. 

You can run the following command to build, tag, and push the new image to your ECR repo.

Login to set temporary creds
```bash
aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
```
Build and push Python flask image
```bash
docker build -t <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<IMAGE-NAME>:latest --push ./
```

## Build ECS infrastructure (AWS)

Update the variables in `dev.aws.tfvars` to fit your own environment, then:

```bash
terraform apply -var="cloud=aws" -var-file="dev.aws.tfvars"
```

## Live application can be inspected through AWS Console
A new cluster will be provisioned, viewable through the AWS Console. This cluster will be running our Python image as an auto-scaling service.

#### Observe: 
##### ECS: 
New cluster, containing a new autoscaling enabled service, which contains tasks - each corresponding to the Python image we built earlier.

##### EC2: 
New instances are used as Container instance "infrastructure" in ECS, deployed via Launch Template and Auto Scaling Groups.
The application is reachable via the Load Balancer's DNS Name. (Check Outputs, or grab via console)

To trigger auto-scaling out (scale up), visit the Load Balancer's /burn route (i.e. python-lb-1497354134.us-west-2.elb.amazonaws.com/burn) This will time out on the web page; this is expected. Check the logs to see that the route has been triggered. Just be careful of triggering the burn route multiple times, as this will cause the app to stay scaled up for some time.

You can check the Python Docker image to see that this route will simulate CPU load, which should cause the service to automatically scale up for the next few minutes (to the max of 3 tasks, as we have configured 3 EC2 instances max). NOTE THAT THIS WILL TAKE A FEW MINUTES TO BE TRIGGERED! (5-10 minutes)

CloudWatch: Logs from the application are accessible from CloudWatch at the defined `logs_group` variable path.

Feel free to adjust/tweak numbers in each resource to your liking!

---

## Azure: Container Apps on VMSS (Dedicated workload profile)

The Azure module runs **Container Apps on a Dedicated workload profile**, which uses **VMSS** under the hood—analogous to ECS on EC2:

- **Minimal VMSS instances** by default (e.g. `min_size = 1`).
- When the container app **scales up** (more replicas / CPU load), the platform **provisions more VMSS instances** as needed, up to `max_size`.

| AWS | Azure |
|-----|--------|
| ECS cluster | Container Apps Environment |
| EC2 ASG | Dedicated workload profile (VMSS) |
| ECS service + Application Auto Scaling | Container App + CPU scale rule |

### Deploy

1. Set **`azure_acr_id`** and **`azure_acr_login_server`** (and optionally other vars) in `dev.azure.tfvars`.
2. **Dedicated profile quota:** The subscription must have non-zero quota for **Dedicated workload profile** cores. If you see `WorkloadProfileMaximumCoresConstraint: maximum cores ... cannot be more than 0`, request an increase: **Portal → Subscription → Usage + quotas** → search "Container Apps" or "Microsoft.App" → increase the **Dedicated workload profile** (cores) quota. See [Container Apps quotas](https://learn.microsoft.com/en-us/azure/container-apps/quotas).
3. Apply:
   ```bash
   terraform apply -var-file="dev.azure.tfvars"
   ```
4. Use the **`app_url`** output (e.g. `https://...`) and `/burn` to trigger CPU load and scaling.

### How to check base image and container runtime (Azure)

- **Image in use**: Container App → **Containers** in the portal, or Terraform: `container_image` in `modules/azure/main.tf`.
- **Base image**: Your **Dockerfile** (e.g. `FROM python:3.11-slim`) or `docker history <acr-image>` locally.
- **Runtime**: Dedicated profile runs on **VMSS** (containerd). In the portal: Container Apps Environment → **Workload profiles** → your Dedicated profile → instance count and details.

---

## Clean Up ECS infrastructure
```
terraform destroy
```

## Review
For this short demo, we simulate CPU load to cause the application (ECS Service) to automatically scale in and out. This autoscaling only affects tasks, not the EC2 instances.



If given more time, we can further optimize by adding auto-scaling to our EC2 instances, either via traditional ASG auto-scaling policies based on Cloudwatch metrics or through the newer Capacity Provider integration with ECS. The decision was made deliberately to implement this with EC2 instances instead of Fargate so that we have direct access and control over our underlying EC2 infrastructure. Additional services could also be added to show auto-scaling on an individual application-level basis. With only 3 tasks and 3 EC2 instances, it can be difficult to see the auto-scaling work quickly; more time could be spent to optimize / increase the amount of tasks such that our scale-in policies trigger more frequently.