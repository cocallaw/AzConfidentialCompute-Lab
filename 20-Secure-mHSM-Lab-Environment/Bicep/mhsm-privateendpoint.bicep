resource symbolicname 'Microsoft.KeyVault/managedHSMs/privateEndpointConnections@2021-11-01-preview' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  sku: {
    family: 'B'
    name: 'string'
  }
  parent: resourceSymbolicName
  etag: 'string'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      actionsRequired: 'None'
      description: 'string'
      status: 'string'
    }
    provisioningState: 'string'
  }
}
