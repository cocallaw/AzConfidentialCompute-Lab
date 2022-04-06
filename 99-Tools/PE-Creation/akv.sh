$region = "westus"
$vnetName = ""
$vnetRG = ""
$subnetName = ""
$akvRID = ""

az network vnet subnet update --name $subnetName --resource-group $vnetRG --vnet-name $vnetName --disable-private-endpoint-network-policies true

az network private-dns zone create --resource-group $vnetRG --name privatelink.vaultcore.azure.net

az network private-dns link vnet create --resource-group $vnetRG --virtual-network $vnetName --zone-name privatelink.vaultcore.azure.net --name accakvdns --registration-enabled false

az network private-endpoint create --resource-group $vnetRG --vnet-name $vnetName --subnet $subnetName --name akv-pewu --private-connection-resource-id $akvRID --group-id vault --connection-name akvconn01 --location $region