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
1.  Ansible & Dependecies installation in a Linux server 
2.  Lab/Infrasctructure deployment in Azure
3.  A&O Lab (Provided PDF Guide)



### Part 1: Download Ubuntu Container with all the necessary tools
You need a machine with Docker. You can get Docker for Windows/Mac at [this link](https://www.docker.com/products/docker-desktop)\
Now, use a pre-configured Docker Container running Ubuntu and Ansible to deploy the infrastructure:\
Open an interactive console to the container: 

```
docker run -it --name ubuntu-vlab cavalen/ubuntu18-vlab
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
[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/010e2e076c229e5ccffb#?env%5BA%26O%20Latam%20-%20Azure%5D=W3sia2V5IjoiYmlnaXAxIiwidmFsdWUiOiJiaWdpcGxhYi1jYXYuYnJhemlsc291dGguY2xvdWRhcHAuYXp1cmUuY29tIiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJiaWdpcF9hZG1pbl91c2VyIiwidmFsdWUiOiJhenVyZXVzZXIiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwX2FkbWluX3Bhc3N3b3JkIiwidmFsdWUiOiJmNURFTU9zNHVMQVRBTSIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfcm9vdF9wYXNzd29yZCIsInZhbHVlIjoiZjVERU1PczR1TEFUQU0iLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwXzFfYXV0aF90b2tlbiIsInZhbHVlIjoiV0JVR1dCSjRGNTJEMklKV1FDVFJWRzJRTUoiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6Im1nbXRfcG9ydCIsInZhbHVlIjoiNDQzIiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJiaWdpcF9kbnNfc2VydmVycyIsInZhbHVlIjoiNC4yLjIuMiw4LjguOC44IiwiZW5hYmxlZCI6dHJ1ZX0seyJrZXkiOiJiaWdpcF9uZXRfaW50ZXJuYWwiLCJ2YWx1ZSI6IjEuMSxmYWxzZSwxMCIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfbmV0X2ludGVybmFsX2lwcyIsInZhbHVlIjoiMTAuMS4xMC4xMC8yNCwxMC4xLjEwLjExLzI0LDEwLjEuMTAuMTMvMjQiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImJpZ2lwX25ldF9kZWZhdWx0Z3ciLCJ2YWx1ZSI6IjEwLjEuMjAuMSIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYmlnaXBfdHJhbnNhY3Rpb25faWQiLCJ2YWx1ZSI6IiIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiYXMzX2ZpbGVuYW1lIiwidmFsdWUiOiJmNS1hcHBzdmNzLTMuMTcuMS0xLm5vYXJjaC5ycG0iLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6ImFzM19maWxlbGVuIiwidmFsdWUiOiIxNTkyNDM0MyIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiZG9fZmlsZW5hbWUiLCJ2YWx1ZSI6ImY1LWRlY2xhcmF0aXZlLW9uYm9hcmRpbmctMS4xMC4wLTIubm9hcmNoLnJwbSIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiZG9fZmlsZWxlbiIsInZhbHVlIjoiMTYwMTgzNyIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoidHNfZmlsZW5hbWUiLCJ2YWx1ZSI6ImY1LXRlbGVtZXRyeS0xLjkuMC0xLm5vYXJjaC5ycG0iLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6InRzX2ZpbGVsZW4iLCJ2YWx1ZSI6Ijk1NDQyMzciLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6Il9hczNfaW5zdGFsbF91dWlkIiwidmFsdWUiOiJkMDYyNmQ3Ni05ZDM2LTQ1MTUtYTU5MS05YTZlZDQ3NzA4NDQiLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6Il9kb19pbnN0YWxsX3V1aWQiLCJ2YWx1ZSI6ImQ2MjEwYWIwLTU2MDUtNGI5OC1hZjNlLTk1NWY4OGNjZWIwZCIsImVuYWJsZWQiOnRydWV9LHsia2V5IjoiX3RzX2luc3RhbGxfdXVpZCIsInZhbHVlIjoiZGYwYTVlODYtNDdjNC00ZWY1LTk3YzgtMTY1OTE5YjZjMTg3IiwiZW5hYmxlZCI6dHJ1ZX1d)\
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
