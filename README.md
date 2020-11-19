# aolab-azure

## F5 Automation & Orchestration Lab in Azure

**Requeriments**\
To run this lab you will need:
- A Linux Server with Internet access (Ubuntu 18.04 Virtual Machine recommended) 
- Azure Account Information
  - [Subscription ID](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Billing/SubscriptionsBlade)
  - [Client ID (Application ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Secret (Client Secret)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Tenant ID (Directory ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview)

This lab contains 3 parts:
1.  Run a Docker Container with Ansible and other tools needed to deploy the Lab Environment
2.  Lab/Infrasctructure deployment in Azure
3.  A&O Lab (Provided PDF Guide)



### Part 1: Download Ubuntu Container with all the necessary tools
You need a machine with Docker. You can get Docker for Windows/Mac at [this link](https://www.docker.com/products/docker-desktop)\
Now, use a pre-configured Docker Container running Ubuntu and Ansible to deploy the infrastructure:\
Open an interactive console to the container: 

```
docker run -it --name ubuntu-vlab cavalen/ubuntu-vlab
```
You will be using user `ubuntu` for the rest of the lab.

### Part 2:
2a) Azure Credentials. 
You need your Subscription ID, Client ID, Secret and Tenant ID.

Create or edit the file `$HOME/.azure/credentials` with the following syntax and using your account info:
```
[default]
subscription_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
client_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
secret=xxxxxxxxxxxxxxxxx
tenant=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

2b) Deploy Azure infrastructure using Ansible:

Go to folder `/home/ubuntu/aolab-azure/deploy-lab`\
Edit `config.yml` and change the `STUDENT_ID` parameter. ***Use lowercase letters and numbers only.***

In the `deploy-lab` folder run the playbooks in order:
```
ansible-playbook 01_deploy_rg_vnet_azure.yml
ansible-playbook 02_deploy_ubuntu_docker_azure.yml
ansible-playbook 03_deploy_bigip_2nic_azure.yml
ansible-playbook 04_get_information.yml
```
<br />

If you already have an Azure Account and get a 403 error like this:
```
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Error checking for existence of name AO-LAB-student - 403 Client Error:
Forbidden for url: https://management.azure.com/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/AO-LAB-student?api-version=2017-05-10"}

```
You need to add a **Contributor Role** to your Registered Application in Azure. See the PDF guide for more info.

**Playbook Description:**\
**Playbook 01 - Azure resources**\
The first playbook creates a Resource Group, a Security Group and a VNET (10.1.0.0/16) with 3 Subnets: Management (10.1.1.0/24), External (10.1.10.0/24) and Internal (10.1.20.0/24)

**Playbook 02 - Ubuntu Docker Server**\
The second playbook deploys an Ubuntu Server with Docker and the following services, used as Pool members: 
- Port 8080 (Hackazon)
- Port 8443 (Hackazon HTTPS)
- Port 8081 (DVWA)
- Port 8082 (OWASP bWAPP)
- Port 8083 (OWASP Juice Shop)
- Port 8084 (Hello World, simple HTTP page)
- Port 8085 (NGINX default homepage)

**Playbook 03 - BIG-IP**\
The third playbook deploys a 2-NIC BIG-IP instance (PAYG) using a supported ARM template:\
https://github.com/F5Networks/f5-azure-arm-templates/tree/master/supported/standalone/2nic/existing-stack/payg

**Playbook 04 - Get Infrastructure Information**\
The last playbook displays information relevant for the lab, and saves that information in a local file: **info.txt**
- Lamp Server Public IP and DNS Record
- BIG-IP Management URL
- Virtual Servers Public IP and DNS Record

<br />


### Part 3:
Import Lab's Postman Collection:\
[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/caf3c5bdd97b03eafc17#?env%5BA%26O%20Latam%20-%20Azure%5D=W3sia2V5IjoiYmlnaXAxIiwidmFsdWUiOiJmNS1jYXJsb3N2LmVhc3R1cy5jbG91ZGFwcC5henVyZS5jb20iLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwX2FkbWluX3VzZXIiLCJ2YWx1ZSI6ImF6dXJldXNlciIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfYWRtaW5fcGFzc3dvcmQiLCJ2YWx1ZSI6ImY1REVNT3M0dUxBVEFNIiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJiaWdpcF9yb290X3Bhc3N3b3JkIiwidmFsdWUiOiJmNURFTU9zNHVMQVRBTSIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfMV9hdXRoX3Rva2VuIiwidmFsdWUiOiJQU0RIUU9HVldEUVM1RjdLUEpXS1FOTFdNTyIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoibWdtdF9wb3J0IiwidmFsdWUiOiI0NDMiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwX2Ruc19zZXJ2ZXJzIiwidmFsdWUiOiI0LjIuMi4yLDguOC44LjgiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwX25ldF9pbnRlcm5hbCIsInZhbHVlIjoiMS4xLGZhbHNlLDEwIiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJiaWdpcF9uZXRfaW50ZXJuYWxfaXBzIiwidmFsdWUiOiIxMC4xLjEwLjEwLzI0LDEwLjEuMTAuMTEvMjQsMTAuMS4xMC4xMy8yNCIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfbmV0X2RlZmF1bHRndyIsInZhbHVlIjoiMTAuMS4yMC4xIiwiZW5hYmxlZCI6dHJ1ZX1d) \
And refer to the provided PDF guide to run through the A&O lab. :book: :book:\
<br />
<br />
<br />
  
## :heavy_exclamation_mark: DELETING THE LAB :heavy_exclamation_mark:
At the end of the Lab do not forget to delete the resources created to avoid unwanted charges.

You can delete the Lab using the provided Ansible Playbook or manually deleting the Resource Group in Azure Portal
 
Go to `./aolab-azure/deploy-lab` and run:

```
ansible_playbook 99_delete_lab_azure.yml
```
<br />
<br />
<br />
  
:poop:
