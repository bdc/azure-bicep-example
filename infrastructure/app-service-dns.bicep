param virtualNetworkResourceId string
param appServiceEnvironmentDnsSuffix string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: appServiceEnvironmentDnsSuffix
  location: 'global'
  properties: {}
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'privateDnsZoneLink'
  location: 'global'
  parent: privateDnsZone
  properties: {
    virtualNetwork: {
      id: virtualNetworkResourceId
    }
    registrationEnabled: true
  }
}
