param location string
param resourceNamePrefix string
param allowAccessSubnetResourceId string

resource rawBlobStore 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: '${resourceNamePrefix}blobstore1'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'BlobStorage'
  properties: {
    accessTier: 'Cool'
    networkAcls: {
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: allowAccessSubnetResourceId
          action: 'Allow'
        }
      ]
    }
  }
}
