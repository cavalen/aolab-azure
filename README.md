# aolab-azure

## F5 Automation & Orchestration Lab in Azure

**Requeriments**\
To run this lab you will need:
- A Linux Server with Internet access (Ubuntu 18.04 Virtual Machine recommended) 
- Azure Account 

This lab contains 3 parts:
1.  Ansible & Dependecies installation in a Linux server 
2.  Lab/Infrasctructure deployment in Azure
3.  A&O Lab (Provided PDF Guide)

### Part 1: 
In your Linux Server install Ansible and additional requeriments needed to deploy the infrastructure in Azure. *You can use MacOS but you need to install ansible and python-pip using a package manger like `brew`.*

SSH to your Linux server, clone this repo and check/run `install_ansible.sh`:

```
# install_ansible.sh

# Install Ansible & Dependencies (For Ubuntu 18.04 LTS)
sudo apt-add-repository --yes ppa:ansible/ansible
sudo apt update && sudo apt -y upgrade
sudo apt install -y docker.io python3-pip docker-compose ansible
pip3 install boto boto3 netaddr passlib f5-sdk f5-cli bigsuds deepdiff 'ansible[azure]' 

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

```

:warning: ***Please reboot you linux server after installing all packages !!!*** :warning:
<br />

### Part 2:
2a) Azure Credentials. 
You need your Subscription ID, Client ID, Secret and Tenant ID.

Create/edit the file `$HOME/.azure/credentials` with the following syntax and using your account info:
```
# [default]
# subscription_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# client_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# secret=xxxxxxxxxxxxxxxxx
# tenant=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

2b) Deploy Azure infrastructure using Ansible:

Go to `./aolab-azure/deploy-lab`, edit `config.yml` and change the `STUDENT_ID` paramenter using ***lowercase letters and numbers ONLY.***

In the `deploy-lab` folder run the playbooks in order:
```
ansible_playbook 01_deploy_rg_vnet_azure.yml
ansible_playbook 02_deploy_ubuntu_docker_azure.yml
ansible_playbook 03_deploy_bigip_2nic_azure.yml
```
<br />

**01 Azure resources**
The first playbook creates a Resource Group, a Security Group and a VNET (10.1.0.0/16) with 3 Subnets: Management (10.1.1.0/24), External (10.1.10.0/24) and Internal (10.1.20.0)

**02 Ubuntu Docker Server**\
The second playbook deploys an Ubuntu Server with Docker and the following services, used as Pool members: 
- Port 80   (Hackazon)
- Port 443  (Hackazon)
- Port 8081 (DVWA)
- Port 8082 (Hello World, simple HTTP page)
- Port 8083 (OWASP Juice Shop)
- Port 8084 (NGINX default homepage)
- Port 8085 (NGINX default homepage)

**03 BIG-IP**\
The third playbook deploys a 2-NIC BIG-IP (PAYG) instance using a supported ARM template:\
https://github.com/F5Networks/f5-azure-arm-templates/tree/master/supported/standalone/2nic/existing-stack/payg
<br />


### Part 3:

:book: **RTFM** :book:
<br />
<br />
<br />
  
## DELETING THE LAB :bangbang:
At the end of the Lab do not forget to delete the resources created to avoid unwanted charges.

You can delete the Lab using a provided Ansible Playbook or manually deleting the Resource Group in the Azure Portal 
 
Go to `./aolab-azure/deploy-lab` and run:

```
ansible_playbook 03_delete_lab_azure.yml
```
<br />
<br />
<br />
  
:poop:
