# Instalar Ansible & Dependencias
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y docker.io docker-compose ansible
pip3 install boto boto3 netaddr passlib f5-sdk bigsuds deepdiff 'ansible[azure]' 

# Instalar Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

