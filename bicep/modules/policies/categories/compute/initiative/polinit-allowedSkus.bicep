targetScope = 'subscription'

param initiativeDefinitionName string
param initiativeDescription string
param category string
param allowedSkus array
param allowedvmskuspolicydefinitionId string
param effect string

resource policyinitiativedefinition 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: initiativeDefinitionName
  properties: {
    displayName: initiativeDefinitionName
    description: initiativeDescription
    policyType: 'Custom'
    metadata: {
      category: category
    }
    parameters: {
      allowedSkus: {
        type: 'Array'
        allowedValues: allowedSkus
        defaultValue: allowedSkus
      }
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        defaultValue: effect
        allowedValues: [
          'Audit'
          'Deny'
        ]
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: allowedvmskuspolicydefinitionId
        parameters: {
          allowedSkus: {
            value: '[parameters(\'allowedSkus\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
    ]
  }
}

output initiativeDefinitionId string = policyinitiativedefinition.id
