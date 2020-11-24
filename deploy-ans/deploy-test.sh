#!/bin/bash
#RED='\e[0;91m'
#REDBL='\e[5;10m'
#NC='\e[0m'
echo "===================================================="
echo "Cual es su Prefix ? (ej, su nombre, o sus iniciales): "
echo "Usar maximo 10, solo letras"
echo ""
read -p "Prefix: " prefix
prefix=$(echo "$prefix" | tr -dc '[:alpha:]' | tr '[:upper:]' '[:lower:]' | head -c 10)

if [ -z "$prefix" ] || [ ${#prefix} -lt 2 ]
then
   echo "Usando Prefix por defecto -student-"
   prefix="student"
   sed -i 's/.*STUDENT_ID:.*/STUDENT_ID: student/' config.yml
   echo ""
else
   echo "Usando Prefix $prefix"
   #sed -i 's/STUDENT_ID: cav/STUDENT_ID: '$prefix'/g' config.yml
   sed -i 's/.*STUDENT_ID:.*/STUDENT_ID: '$prefix'/' config.yml
   echo ""
fi
echo ""
echo "Desplegando .... "
echo "$(date)"
echo ""
ansible-playbook 01_deploy_rg_vnet_azure.yml && ansible-playbook 02_deploy_ubuntu_docker_azure.yml && ansible-playbook 03_test.yml && ansible-playbook 05_get_information.yml
echo "Finalizado .... "
echo "$(date)"
