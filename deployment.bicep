param name string = 'sclcrudgroup'
param containerName string = 'svlcrudcontainer'
param location string = resourceGroup().location
param image string = 'mcr.microsoft.com/azuredocs/aci-helloworld'
param port int = 80
param cpuCores int = 1
param memoryGb int = 1
param publicIpName string = 'myPublicIP'
param vnetName string = 'svlvnet'
param dnsname string = 'svldns'

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: publicIpName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: dnsname
    }
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}



resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: name
  location: location
  properties: {
    containers: [
      {
        name: containerName
        properties: {
          image: image
          ports: [
            {
              port: port
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryGb
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
          port: 80
        }
      ]
    }
  }
}
