$region = "westus"
$vnetName = ""
$vnetRG = ""
$subnetName = ""
$paasRGName = ""
$stgName = ""
$stgRID = ""

az storage account create --name $stgName --resource-group $paasRGName --location $region --sku Standard_LRS --kind StorageV2

az network vnet subnet update --name $subnetName --resource-group $vnetRG --vnet-name $vnetName --disable-private-endpoint-network-policies false

az network private-dns zone create --resource-group $vnetRG --name privatelink.blob.core.windows.net

az network private-dns link vnet create --resource-group $vnetRG --virtual-network $vnetName --zone-name privatelink.blob.core.windows.net --name accblobdns --registration-enabled true

az network private-endpoint create --resource-group $vnetRG --vnet-name $vnetName --subnet $subnetName --name blob-pewu --private-connection-resource-id $stgRID --group-id blob --connection-name blobconn01 --location $region