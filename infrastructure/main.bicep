param location string = resourceGroup().location

var prefix = 'ecp'

module vnet 'vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    resourceNamePrefix: prefix
  }
}

module appService 'app-service.bicep' = {
  name: 'appService'
  params: {
    location: location
    resourceNamePrefix: prefix
    subnetAppServiceResourceId: vnet.outputs.subnetAppServiceResourceId
  }
}

module appServiceDns 'app-service-dns.bicep' = {
  name: 'appServiceDns'
  params: {
    appServiceEnvironmentDnsSuffix: appService.outputs.appServiceEnvironmentDnsSuffix
    virtualNetworkResourceId: vnet.outputs.vnetResourceId
  }
}

module privateEndpoint 'private-endpoint.bicep' = {
  name: 'privateEndpoint'
  params: {
    location: location
    resourceNamePrefix: prefix
    subnetPrivateEndpointResourceId: vnet.outputs.subnetPrivateEndpointResourceId
    appServiceResourceId: appService.outputs.appServiceResourceId
  }
}

module gateway 'gateway.bicep' = {
  name: 'gateway'
  params: {
    location: location
    resourceNamePrefix: prefix
    subnetResourceId: vnet.outputs.subnetApplicationGatewayResourceId
    backendTarget: appService.outputs.appServiceFqdn
  }
}

module storage 'storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    resourceNamePrefix: prefix
    allowAccessSubnetResourceId: vnet.outputs.subnetAppServiceResourceId
  }
}
