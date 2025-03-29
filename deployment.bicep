param location string = resourceGroup().location
param containerGroupName string = 'myContainerGroup'
param containerName string = 'my-container'
param containerImage string = 'svlacr2.azurecr.io/svlcrud:latest'
param containerPort int = 80
param publicIpName string = 'myPublicIP'
param dnsNameLabel string = 'myuniquecontainerdns'

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIpName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: dnsNameLabel
    }
  }
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: containerGroupName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    containers: [
      {
        name: containerName
        properties: {
          image: containerImage
          ports: [
            {
              protocol: 'TCP'
              port: containerPort
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
        }
      }
    ]
    restartPolicy: 'OnFailure'
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'TCP'
          port: containerPort
        }
      ]
      dnsNameLabel: dnsNameLabel
    }
  }
}

output containerGroupId string = containerGroup.id
output containerGroupFqdn string = containerGroup.properties.ipAddress.fqdn
output publicIpId string = publicIp.id
output publicIpAddress string = publicIp.properties.ipAddress
