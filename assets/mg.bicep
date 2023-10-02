param id string
param displayName string
param parent string

resource mgp 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: parent
  scope: tenant()
}

resource mg 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: id
  properties: {
    displayName: displayName
    details: {
      parent: {
        id: mgp.id
      }
    }
  }
  scope: tenant()
}
