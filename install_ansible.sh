# For Ubuntu 18.04 LTS
# Install Ansible & Dependencies
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y docker.io python3-pip docker-compose ansible
pip3 install boto boto3 netaddr passlib f5-sdk fi-cli bigsuds deepdiff 'ansible[azure]' 

# Instalar Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Clone Repo
git clone https://github.com/cavalen/aolab-azure/
