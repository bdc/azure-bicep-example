param location string
param resourceNamePrefix string
param subnetResourceId string
param backendTarget string

var applicationGatewayName = '${resourceNamePrefix}-gateway'

resource gatewayPublicIPAddress 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${resourceNamePrefix}-gateway-ip-address'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

resource gatewayFirewallPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2021-08-01' = {
  name: '${resourceNamePrefix}-gateway-firewall-policy'
  location: location
  properties: {
    policySettings: {
      state: 'Enabled'
      mode: 'Prevention'
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.1'
        }
      ]
    }
  }
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: applicationGatewayName
  location: location
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    enableHttp2: false
    autoscaleConfiguration: {
      minCapacity: 1
      maxCapacity: 10
    }
    gatewayIPConfigurations: [
      {
        name: 'applicationGatewayIpConfig'
        properties: {
          subnet: {
            id: subnetResourceId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'applicationGatewayFrontendPort'
        properties: {
          port: 80
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'applicationGatewayPublicFrontendIp'
        properties: {
          publicIPAddress: {
            id: gatewayPublicIPAddress.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'backendAddressPool'
        properties: {
          backendAddresses: [
            {
              fqdn: backendTarget
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'backendHttpSetting1'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
        }
      }
    ]
    httpListeners: [
      {
        name: 'applicationGatewayHttpListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/frontendIPConfigurations',
              applicationGatewayName,
              'applicationGatewayPublicFrontendIp'
            )
          }
          frontendPort: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/frontendPorts',
              applicationGatewayName,
              'applicationGatewayFrontendPort'
            )
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'requestRoutingRule1'
        properties: {
          ruleType: 'Basic'
          priority: 1
          httpListener: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/httpListeners',
              applicationGatewayName,
              'applicationGatewayHttpListener'
            )
          }
          backendAddressPool: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/backendAddressPools',
              applicationGatewayName,
              'backendAddressPool'
            )
          }
          backendHttpSettings: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/backendHttpSettingsCollection',
              applicationGatewayName,
              'backendHttpSetting1'
            )
          }
        }
      }
    ]
    firewallPolicy: {
      id: gatewayFirewallPolicy.id
    }
  }
}
