targetScope = 'subscription'

/*
  This Bicep template defines the required permissions at Azure Subscription scope to enable CrowdStrike
  Indicator of Misconfiguration (IOM)
  Copyright (c) 2024 CrowdStrike, Inc.
*/

param customRole object = {
  roleName: 'cs-website-reader'
  roleDescription: 'CrowdStrike custom role to allow read access to App Service and Function.'
  roleActions: [
    'Microsoft.Web/sites/Read'
    'Microsoft.Web/sites/config/Read'
    'Microsoft.Web/sites/config/list/Action'
  ]
}

resource customRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(customRole.roleName, subscription().id,'test')
  properties: {
    assignableScopes: [subscription().id]
    description: customRole.roleDescription
    permissions: [
      {
        actions: customRole.roleActions
        notActions: []
      }
    ]
    roleName: customRole.roleName
    type: 'CustomRole'
  }
}

output customRoleDefinitionId string = customRoleDefinition.id