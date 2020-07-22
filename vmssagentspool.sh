#Source : https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents?view=azure-devops

#Run the following command to verify your default Azure subscription.
az account list -o table

#If your desired subscription isn't listed as the default, select your desired subscription.
az account set -s WebhelpFrance

#Create a resource group for your virtual machine scale set.
az group create -l westeurope -n whp-fr-prd-ado --tags env=prd region=fr project=azure_devops project_owner=julien.ancel@webhelp.com

#Create a virtual machine scale set in your resource group. In this example the UbuntuLTS VM image is specified.
az vmss create \
--name whp-corp-ado-vmss1 \
--resource-group whp-fr-prd-ado \
--image UbuntuLTS \
--vm-sku Standard_D2_v3 \
--storage-sku StandardSSD_LRS \
--authentication-type SSH --generate-ssh-keys \
--instance-count 1 \
--disable-overprovision \
--upgrade-policy-mode manual \
--single-placement-group false \
--platform-fault-domain-count 1 \
--load-balancer "" \
--dns-servers 10.253.254.5 10.253.254.6 \
--subnet "/subscriptions/ce1591d3-1842-4b70-924c-d0d840db423b/resourceGroups/WHFRAZURE-VLAN01-Migrated/providers/Microsoft.Network/virtualNetworks/WHFRAZURE-VLAN01/subnets/Subnet-1" \
--tags env=prd region=corp project=azure_devops project_owner=julien.ancel@webhelp.com
