targetScope = 'subscription'

param initiativeDefinitionName string
param initiativeDescription string
param category string
param inherittagpolicydefinitionId string
param effect string

resource creationdatepolicyinitiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: initiativeDefinitionName
  properties: {
    displayName: initiativeDefinitionName
    description: initiativeDescription
    policyType: 'Custom'
    metadata: {
      category: category
    }
    parameters: {
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        defaultValue: effect
        allowedValues: [
          'Audit'
          'Modify'
          'Disabled'
        ]
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: inherittagpolicydefinitionId
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
    ]
  }
}

output creationdatepolicyinitiativeId string = creationdatepolicyinitiative.id
