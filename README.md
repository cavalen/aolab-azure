# aolab-azure

## F5 Automation & Orchestration Lab in Azure.

**Requeriments**\
To run this lab you will need:
- A machine capable to run Ansible or Terraform with Internet access. (A docker container is provided if needed).
- Azure Account Information
  - [Subscription ID](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Billing/SubscriptionsBlade)
  - [Client ID (Application ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Secret (Client Secret)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Tenant ID (Directory ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview)

This lab contains 3 parts:
1.  Run a Docker Container with Ansible, Terraform and other tools needed to deploy the Lab Environment
2.  Lab/Infrasctructure deployment in Azure
3.  A&O Lab (Provided PDF Guide) inside the `guide` folder of this Github repo

:pencil: **Note:** You can run this lab in your own machine without using the container image, just make sure Ansible and/or Terraform are installed 


### Part 1: Download Ubuntu Container with all the necessary tools
You need a machine with Docker. You can get Docker for Windows/Mac at [this link](https://www.docker.com/products/docker-desktop)\
Now, use the pre-configured Docker Container to deploy the infrastructure:

Open an interactive console to the container: 
```
docker run -it --name vlab cavalen/ubuntu-vlab
```

### Part 2: Infrasctructure deployment in Azure
This is a Automation and Orchestration Lab, so you can deploy using Terraform or Ansible. Pick one.

<details>
<summary>Terraform Instructions :earth_americas:</summary>

You need your [Subscription ID](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Billing/SubscriptionsBlade), [Client ID (Application ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade), [Secret (Client Secret)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade) and [Tenant ID (Directory ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview).

Inside the container: 
- Clone this repository
- Move to the `deploy-tf` folder
- Copy the file `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars` and replace the values using your account info
  - sp_subscription_id
  - sp_client_id
  - sp_client_secret
  - sp_tenant_id
  - prefix (***use lowercase letters only, max 10 characters***)
- run terraform init, terraform plan, terraform apply (type **yes** when asked) 

Instructions:
```
cd
git clone https://github.com/cavalen/aolab-azure
cd /home/ubuntu/aolab-azure/deploy-tf
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
terraform init
terraform plan
teraform apply
```
This can take some time (up to 15 min).
<br />

### Output:
Terraform will output the Lab's information, like Mgmt IP & DNS, Public IPs, users, password, etc.
If you want to see this output, at any time run `terraform output`

</details>

<details>
<summary>Ansible Instructions :a:</summary>
  
You need your [Subscription ID](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Billing/SubscriptionsBlade), [Client ID (Application ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade), [Secret (Client Secret)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade) and [Tenant ID (Directory ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview).

Inside the container:
- Clone this repository
- Edit `/home/ubuntu/.azure/credentials` and replace the values using your account info
  - subscription_id
  - client_id
  - secret
  - sp_tenant_id
  - tenant
- Move to the `deploy-ans` folder  
- run `deploy.sh` script, it will ask for a Prefix (***use lowercase letters only, max 10 characters***)

Instructions:
```
cd
nano /home/ubuntu/.azure/credentials
git clone https://github.com/cavalen/aolab-azure
cd /home/ubuntu/aolab-azure/deploy-ans
sh deploy.sh
```
This can take some time (up to 20 min). 
<br />

### Output:
Ansible will output the Lab's information, like Mgmg IP & DNS, Public IPs, users, password, etc.
If you want to see this output, check the `info.txt` file in the deploy-ans folder, or at any time run `ansible-playbook 05_get_information.yml`

</details>

If you have an Azure Account and get a 403 error like this:
```
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Error checking for existence of name AO-LAB-student - 403 Client Error:
Forbidden for url: https://management.azure.com/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/AO-LAB-student?api-version=2017-05-10"}

```
You need to add a **Contributor Role** to your Registered Application in Azure. See the PDF guide for more info.

**Deployment Description:**\
Ansible or Terraform will deploy the following resources in Azure:
- A Resource Group, a Security Group and a VNET (10.1.0.0/16) with 3 Subnets: Management (10.1.1.0/24), External (10.1.10.0/24) and Internal (10.1.20.0/24)
- An Ubuntu Server with Docker and the following services (Pool members): 
  - Port 8080 (Hackazon)  
  - Port 8081 (DVWA)
  - Port 8082 (Hello World, simple HTTP page)
  - Port 8083 (OWASP Juice Shop)
  - Port 8084 (OWASP bWAPP) 
  - Port 8085 (NGINX default homepage)
  - Port 8443 (Hackazon HTTPS)
- A 2-NIC BIG-IP instance with:
  - Management Interface (10.1.1.245)
  - External Interface (10.1.10.245) 
  - Self-IP (10.1.1.246)
  - Automation Toolchain installed (AS3, DO, TS)
<br />

### Part 3:
Import Lab's Postman Collection & Environment, Click here:\
[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/caf3c5bdd97b03eafc17#?env%5BA%26O%20Latam%20-%20Azure%5D=W3sia2V5IjoiYmlnaXAxIiwidmFsdWUiOiJmNS1jYXJsb3N2LmVhc3R1cy5jbG91ZGFwcC5henVyZS5jb20iLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwX2FkbWluX3VzZXIiLCJ2YWx1ZSI6ImF6dXJldXNlciIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfYWRtaW5fcGFzc3dvcmQiLCJ2YWx1ZSI6ImY1REVNT3M0dUxBVEFNIiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJiaWdpcF9yb290X3Bhc3N3b3JkIiwidmFsdWUiOiJmNURFTU9zNHVMQVRBTSIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfMV9hdXRoX3Rva2VuIiwidmFsdWUiOiJQU0RIUU9HVldEUVM1RjdLUEpXS1FOTFdNTyIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoibWdtdF9wb3J0IiwidmFsdWUiOiI0NDMiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwX2Ruc19zZXJ2ZXJzIiwidmFsdWUiOiI0LjIuMi4yLDguOC44LjgiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwX25ldF9pbnRlcm5hbCIsInZhbHVlIjoiMS4xLGZhbHNlLDEwIiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJiaWdpcF9uZXRfaW50ZXJuYWxfaXBzIiwidmFsdWUiOiIxMC4xLjEwLjEwLzI0LDEwLjEuMTAuMTEvMjQsMTAuMS4xMC4xMy8yNCIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfbmV0X2RlZmF1bHRndyIsInZhbHVlIjoiMTAuMS4yMC4xIiwiZW5hYmxlZCI6dHJ1ZX1d) \
[Postman Collection and Environment are available in the 'postman' folder](https://github.com/cavalen/aolab-azure/tree/master/postman) 

### Part 4:
Follow the A&O lab guide. :book: :book:\
[PDF in the 'guide' folder](https://github.com/cavalen/aolab-azure/tree/master/guide)
<br />
<br />
<br />
  
## :heavy_exclamation_mark: DELETING THE LAB :heavy_exclamation_mark:
At the end of the Lab do not forget to delete the resources created to avoid unwanted charges.

Manually delete the Resource Group in the Azure Portal
 
If using Terraform , go to `/home/ubuntu/aolab-azure/deploy-tf` and run:
```
terraform destroy
``` 

If using Ansible, go to `/home/ubuntu/aolab-azure/deploy-ans` and run:
```
ansible_playbook 99_delete_lab_azure.yml
```

<br />
<br />
<br />
  
:poop:
