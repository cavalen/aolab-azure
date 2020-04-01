# aolab-azure

## Automation & Orchestration Lab in Azure

Requeriments:
- A Linux Server (Ubuntu 18.04 recommended) with Internet access
- Azure Account 

This lab contains 3 parts:
- Ansible & Dependecies installation in a Linux server 
- Lab/Infrasctructure deployment in Azure
- A&O Lab (Provided PDF Guide)

### Part 1: 
Install Ansible and additional requeriments in a Linux server (or Virtual Machine) to deploy infrastructure in Azure.
You can use MacOS but you need to install Ansible and Python-pip using a package manger like `brew`.

Check/run `install_ansible.sh` if using Linux:

```
# Install Ansible & Dependencies (For Ubuntu 18.04 LTS)
sudo apt-add-repository --yes ppa:ansible/ansible
sudo apt update && sudo apt -y upgrade
sudo apt install -y docker.io python3-pip docker-compose ansible
pip3 install boto boto3 netaddr passlib f5-sdk fi-cli bigsuds deepdiff 'ansible[azure]' 

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Clone Repo
git clone https://github.com/cavalen/aolab-azure/
```
### Part 2:
2a) Azure Credentials. 
You need to know the Subscription ID, Client ID, Secret and Tenant ID.

Create/edit the file `$HOME/.azure/credentials` with the following syntax and using your account info:
```
# [default]
# subscription_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# client_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# secret=xxxxxxxxxxxxxxxxx
# tenant=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

2b) Deploy Azure infrastructure using Ansible:

Go to `./aolab-azure/deploy-lab`, edit the `config.yml` file and change the `STUDENT_ID` paramenter, using lowercase letters and numbers ONLY.

Go to `./aolab-azure/deploy-lab` and run the playbooks in order:
```
ansible_playbook 01_deploy_ubuntu_docker_azure.yml
ansible_playbook 02_deploy_bigip_1nic_azure.yml
```

### Part 3:

===> RTFM <===
 

## DELETING THE LAB
At the end of the Lab do not forget to delete the resources created to avoid unwanted charges.

You can delete the Lab using a provided Ansible Playbook or manually deleting the Resource Group in the Azure Portal 
 
Go to `./aolab-azure/deploy-lab` and run:

```
ansible_playbook 03_delete_lab_azure.yml
```

