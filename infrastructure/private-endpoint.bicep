param location string
param resourceNamePrefix string
param subnetPrivateEndpointResourceId string
param appServiceResourceId string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: '${resourceNamePrefix}-private-endpoint'
  location: location
  properties: {
    subnet: {
      id: subnetPrivateEndpointResourceId
    }
    privateLinkServiceConnections: [
      {
        name: 'app-service-connection'
        properties: {
          groupIds: ['sites']
          privateLinkServiceId: appServiceResourceId
        }
      }
    ]
  }
}
