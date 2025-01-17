targetScope = 'subscription'

/*
  This Bicep template adds the subscription as an assignable scope on the required permissions to enable CrowdStrike
  Indicator of Misconfiguration (IOM)
  Copyright (c) 2024 CrowdStrike, Inc.
*/

@description('Subscription Id of the targeted Azure Subscription.')
param subscriptionId string

param customRole object = {
  roleName: 'cs-website-reader'
  roleDescription: 'CrowdStrike custom role to allow read access to App Service and Function.'
  roleActions: [
    'Microsoft.Web/sites/Read'
    'Microsoft.Web/sites/config/Read'
    'Microsoft.Web/sites/config/list/Action'
  ]
}

// resource existingCustomRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
//   name: guid(customRole.roleName, subscription().id)
// }

module assignableScope 'getAssignableScope.bicep' = {
    name: guid('getAssignableScope',customRole.roleName, subscription().id)
    params: {
        customRoleName: customRole.roleName
      }
    }

resource modifyExistingCustomRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(customRole.roleName, subscription().id)
  properties: {
    assignableScopes: concat(assignableScope.outputs.assignableScopes,[subscriptionId])
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

output customRoleDefinitionId string = modifyExistingCustomRoleDefinition.id
