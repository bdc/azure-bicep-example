param location string
param resourceNamePrefix string
param subnetAppServiceResourceId string

resource appServiceHostingEnvironment 'Microsoft.Web/hostingEnvironments@2023-12-01' = {
  name: '${resourceNamePrefix}-app-service-hosting-environment'
  location: location
  kind: 'ASEV3'
  properties: {
    virtualNetwork: {
      id: subnetAppServiceResourceId
    }
    networkingConfiguration: {
      properties: {
        allowNewPrivateEndpointConnections: true
      }
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${resourceNamePrefix}-app-service-plan'
  location: location
  kind: 'app,linux'
  sku: {
    name: 'I1v2'
    tier: 'IsolatedV2'
  }
  properties: {
    reserved: true
    hostingEnvironmentProfile: {
      id: appServiceHostingEnvironment.id
    }
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: '${resourceNamePrefix}-app-service'
  location: location
  // 'kind' key: @see https://github.com/Azure/app-service-linux-docs/blob/master/Things_You_Should_Know/kind_property.md
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    vnetRouteAllEnabled: true
    publicNetworkAccess: 'Disabled'
    hostingEnvironmentProfile: {
      id: appServiceHostingEnvironment.id
    }
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.12'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output appServiceFqdn string = appService.properties.defaultHostName
output appServiceResourceId string = appService.id
output appServiceEnvironmentDnsSuffix string = appServiceHostingEnvironment.properties.dnsSuffix
