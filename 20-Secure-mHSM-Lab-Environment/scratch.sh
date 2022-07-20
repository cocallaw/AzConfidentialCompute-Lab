oid=$(az ad signed-in-user show --query objectId -o tsv)
$oid = "58540918-faeb-4cbc-a19e-ce071144d404
az keyvault create --hsm-name "ACCLab01" --resource-group "Lab-MHSM-Test" --location "West Europe" --administrators $oid --retention-days 7

$SUBID = "349cb960-7c0b-448c-8d87-7db4014c6ca8"
$RG = "Lab-MHSM-Test"
$Region = "West Europe"
$HSMName = "ACCLab01"
$VNetName = "vnet-mhsm-01"
$SubnetName = "sn01"
$PEName = "PE-MHSM"



az login                                                                   # Login to Azure CLI
az account set --subscription {SUBSCRIPTION ID}                            # Select your Azure Subscription
az group create -n {RESOURCE GROUP} -l {REGION}                            # Create a new Resource Group
az provider register -n Microsoft.KeyVault                                 # Register KeyVault as a provider

# Turn on firewall
az keyvault update-hsm --hsm-name $HSMName -g $RG --default-action deny 

# Create a Virtual Network
az network vnet create -g $RG -n $VNetName --location $Region   

# Create a Subnet
az network vnet subnet create -g $RG --vnet-name $VNetName --name $SubnetName --address-prefixes {addressPrefix}

    # Disable Virtual Network Policies
az network vnet subnet update --name $SubnetName --resource-group $RG --vnet-name $VNetName --disable-private-endpoint-network-policies true

    # Create a Private DNS Zone
az network private-dns zone create --resource-group $RG --name privatelink.managedhsm.azure.net

    # Link the Private DNS Zone to the Virtual Network
az network private-dns link vnet create --resource-group $RG --virtual-network $VNetName --zone-name privatelink.managedhsm.azure.net --name "ACCMHSMLink" --registration-enabled true

az keyvault update-hsm --hsm-name $HSMName -g $RG --default-action deny --bypass AzureServices

az network private-endpoint create --resource-group $RG --vnet-name $VNetName --subnet $SubnetName --name $PEName  --private-connection-resource-id "/subscriptions/$SUBID/resourceGroups/$RG/providers/Microsoft.KeyVault/managedHSMs/$HSMName" --group-id managedhsm --connection-name "MHSM-Connect" --location $Region

# Determine the Private Endpoint IP address
az network private-endpoint show -g $RG -n $PEName      # look for the property networkInterfaces then id; the value must be placed on {PE NIC} below.
az network nic show --ids {PE NIC}                         # look for the property ipConfigurations then privateIpAddress; the value must be placed on {NIC IP} below.

# https://docs.microsoft.com/en-us/azure/dns/private-dns-getstarted-cli#create-an-additional-dns-record
az network private-dns zone list -g $RG
az network private-dns record-set a add-record -g $RG -z "privatelink.managedhsm.azure.net" -n $HSMName -a "10.1.1.4"
az network private-dns record-set list -g $RG -z "privatelink.managedhsm.azure.net"

# From home/public network, you wil get a public IP. If inside a vnet with private zone, nslookup will resolve to the private ip.
nslookup $HSMName.managedhsm.azure.net
nslookup $HSMName.privatelink.managedhsm.azure.net