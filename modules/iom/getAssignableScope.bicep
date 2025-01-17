targetScope = 'subscription'

param customRoleName string

resource existingCustomRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: guid(customRoleName, subscription().id)
}

output assignableScopes array = existingCustomRoleDefinition.properties.assignableScopes
