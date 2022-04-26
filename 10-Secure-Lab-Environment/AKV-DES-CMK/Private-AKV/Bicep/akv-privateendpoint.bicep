@description('The name of the AKV')
param keyVaultName string

@description('The name of the Virtual Network to use')
param virtualNetworkName string

@description('The name of the subnet to be used for AKV PE')
param keyVaultSubnetName string

@description('Location for all resources.')
param location string = resourceGroup().location

var vnetId = resourceId('Microsoft.Network/virtualNetworks', virtualNetworkName)
var subnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, keyVaultSubnetName)
var keyVaultId = resourceId('Microsoft.KeyVault/vaults', keyVaultName)
var keyVaultPrivateEndpointName_var = 'pe-${keyVaultName}'
var keyVaultPrivateNetworkLinkName_var = '${keyVaultPrivateDnsZoneName_var}/link_to_${toLower(virtualNetworkName)}'
var keyVaultPrivateDnsZoneName_var = 'privatelink.vaultcore.azure.net'
var keyVaultPrivateEndpointGroupName = 'vault'
var keyVaultPrivateDnsZoneId = keyVaultPrivateDnsZoneName.id
var keyVaultPrivateEndpointId = keyVaultPrivateEndpointName.id
var keyVaultPrivateDnsZoneGroupName_var = '${keyVaultPrivateEndpointName_var}/${keyVaultPrivateEndpointGroupName}PrivateDnsZoneGroup'

resource keyVaultPrivateDnsZoneName 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: keyVaultPrivateDnsZoneName_var
  location: 'global'
  properties: {}
}

resource keyVaultPrivateNetworkLinkName 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: keyVaultPrivateNetworkLinkName_var
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: vnetId
    }
  }
}

resource keyVaultPrivateEndpointName 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: keyVaultPrivateEndpointName_var
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: keyVaultPrivateEndpointName_var
        properties: {
          privateLinkServiceId: keyVaultId
          groupIds: [
            keyVaultPrivateEndpointGroupName
          ]
        }
      }
    ]
    subnet: {
      id: subnetId
    }
    customDnsConfigs: [
      {
        fqdn: '${keyVaultName}${keyVaultPrivateDnsZoneName_var}'
      }
    ]
  }
}

resource keyVaultPrivateDnsZoneGroupName 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  name: keyVaultPrivateDnsZoneGroupName_var
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink_vaultcore_azure_net'
        properties: {
          privateDnsZoneId: keyVaultPrivateDnsZoneId
        }
      }
    ]
  }
}
