param location string
param resourceNamePrefix string

var vnetName = '${resourceNamePrefix}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetApplicationGatewayAddressPrefix = cidrSubnet(vnetAddressPrefix, 24, 0)
var subnetPrivateEndpointPrefix = cidrSubnet(vnetAddressPrefix, 24, 1)
var subnetAppServiceAddressPrefix = cidrSubnet(vnetAddressPrefix, 24, 2)

resource subnetApplicationGateway 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  parent: virtualNetwork
  name: '${resourceNamePrefix}-subnet-application-gateway'
  properties: {
    addressPrefix: subnetApplicationGatewayAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    serviceEndpoints: [
      {
        service: 'Microsoft.Web'
      }
    ]
  }
}

resource subnetPrivateEndpoint 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  parent: virtualNetwork
  name: '${resourceNamePrefix}-subnet-private-endpoint'
  properties: {
    addressPrefix: subnetPrivateEndpointPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnetAppService 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  parent: virtualNetwork
  name: '${resourceNamePrefix}-subnet-app-service'
  properties: {
    addressPrefix: subnetAppServiceAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: [
      {
        name: 'appServiceDelegation'
        properties: {
          serviceName: 'Microsoft.Web/hostingEnvironments'
        }
      }
    ]
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    enableDdosProtection: false
    enableVmProtection: false
  }
}

output vnetResourceId string = virtualNetwork.id
output subnetApplicationGatewayResourceId string = subnetApplicationGateway.id
output subnetPrivateEndpointResourceId string = subnetPrivateEndpoint.id
output subnetAppServiceResourceId string = subnetAppService.id
