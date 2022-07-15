param managedHSMs_ACCLab01_name string = 'ACCLab01'
param privateEndpoints_PE_MHSM_name string = 'PE-MHSM'
param virtualNetworks_vnet_mhsm_01_name string = 'vnet-mhsm-01'
param privateDnsZones_privatelink_managedhsm_azure_net_name string = 'privatelink.managedhsm.azure.net'
param networkInterfaces_PE_MHSM_nic_337943c2_75d6_4e6c_b8cf_c55f7f92e9a1_name string = 'PE-MHSM.nic.337943c2-75d6-4e6c-b8cf-c55f7f92e9a1'

resource managedHSMs_ACCLab01_name_resource 'Microsoft.KeyVault/managedHSMs@2021-11-01-preview' = {
  name: managedHSMs_ACCLab01_name
  location: 'westeurope'
  sku: {
    name: 'Standard_B1'
    family: 'B'
  }
  properties: {
    tenantId: '605a7cf2-e5e8-4035-8caf-72f19d4ce34f'
    initialAdminObjectIds: [
      '58540918-faeb-4cbc-a19e-ce071144d404'
    ]
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enablePurgeProtection: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource privateDnsZones_privatelink_managedhsm_azure_net_name_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_managedhsm_azure_net_name
  location: 'global'
  properties: {
    maxNumberOfRecordSets: 25000
    maxNumberOfVirtualNetworkLinks: 1000
    maxNumberOfVirtualNetworkLinksWithRegistration: 100
    numberOfRecordSets: 2
    numberOfVirtualNetworkLinks: 1
    numberOfVirtualNetworkLinksWithRegistration: 1
    provisioningState: 'Succeeded'
  }
}

resource virtualNetworks_vnet_mhsm_01_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_vnet_mhsm_01_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'sn00'
        properties: {
          addressPrefix: '10.1.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'sn01'
        properties: {
          addressPrefix: '10.1.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource managedHSMs_ACCLab01_name_MHSM_Connect 'Microsoft.KeyVault/managedHSMs/privateEndpointConnections@2021-11-01-preview' = {
  parent: managedHSMs_ACCLab01_name_resource
  name: 'MHSM-Connect'
  properties: {
    provisioningState: 'Succeeded'
    privateEndpoint: {
    }
    privateLinkServiceConnectionState: {
      status: 'Approved'
      actionsRequired: 'None'
    }
  }
}

resource networkInterfaces_PE_MHSM_nic_337943c2_75d6_4e6c_b8cf_c55f7f92e9a1_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_PE_MHSM_nic_337943c2_75d6_4e6c_b8cf_c55f7f92e9a1_name
  location: 'westeurope'
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.828d6235-b8d5-4361-87b0-5abf05ca2fc3'
        properties: {
          privateIPAddress: '10.1.1.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet_mhsm_01_name_sn01.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource privateDnsZones_privatelink_managedhsm_azure_net_name_acclab01 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: privateDnsZones_privatelink_managedhsm_azure_net_name_resource
  name: 'acclab01'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.1.1.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_managedhsm_azure_net_name 'Microsoft.Network/privateDnsZones/SOA@2018-09-01' = {
  parent: privateDnsZones_privatelink_managedhsm_azure_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource virtualNetworks_vnet_mhsm_01_name_sn00 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_vnet_mhsm_01_name_resource
  name: 'sn00'
  properties: {
    addressPrefix: '10.1.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_vnet_mhsm_01_name_sn01 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_vnet_mhsm_01_name_resource
  name: 'sn01'
  properties: {
    addressPrefix: '10.1.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource privateDnsZones_privatelink_managedhsm_azure_net_name_accmhsmlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones_privatelink_managedhsm_azure_net_name_resource
  name: 'accmhsmlink'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_vnet_mhsm_01_name_resource.id
    }
  }
}

resource privateEndpoints_PE_MHSM_name_resource 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: privateEndpoints_PE_MHSM_name
  location: 'westeurope'
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'MHSM-Connect'
        properties: {
          privateLinkServiceId: managedHSMs_ACCLab01_name_resource.id
          groupIds: [
            'managedhsm'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_vnet_mhsm_01_name_sn01.id
    }
    customDnsConfigs: [
      {
        fqdn: 'acclab01.managedhsm.azure.net'
        ipAddresses: [
          '10.1.1.4'
        ]
      }
    ]
  }
}