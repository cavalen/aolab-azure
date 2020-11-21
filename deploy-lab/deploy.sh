RED='\033[0;91m'
REDBL='\033[5;91m'
NC='\033[0m'
echo "===================================================="
echo "Cual es su Prefix ? (ej, su nombre, o sus iniciales): "
echo "${RED}Usar maximo 10, solo letras\n${NC}"
read -p "Prefix: " prefix
prefix=$(echo "$prefix" | tr -dc '[:alpha:]' | tr '[:upper:]' '[:lower:]' | head -c 10)

if [ -z "$prefix" ] || [ ${#prefix} -lt 2 ]
then
   echo "Usando Prefix por defecto -student-"
   prefix="student"
   sed -i 's/STUDENT_ID: cav/STUDENT_ID: student/g' config.yml
   echo ""
else
   echo "Usando Prefix $prefix"
   sed -i 's/STUDENT_ID: cav/STUDENT_ID: '$prefix'/g' config.yml
   echo ""
fi
echo "${REDBL}Desplegando .... \n\n${NC}"
ansible-playbook 01_deploy_rg_vnet_azure.yml && ansible-playbook 02_deploy_ubuntu_docker_azure.yml && ansible-playbook 03_deploy_bigip_2nic_azure.yml && ansible-playbook 04_install_as3_ts_do.yml && ansible-playbook 05_get_information.yml &&
