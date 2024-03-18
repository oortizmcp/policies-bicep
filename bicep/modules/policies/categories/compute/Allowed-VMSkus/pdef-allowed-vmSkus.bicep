targetScope = 'subscription'

// Temp effect is audit, will change to deny, once policy is tested

@description('Name of Policy Definition')
param policyName string

@description('Display Name of Policy Definition')
param policydisplayName string

@description('Category of the policy')
param category string

@description('Describes what the policy does in Azure Policy')
param policyDescription string

@description('Allowed VM Sizes')
param allowedSkus array

@description('Effect of the policy either audit or deny')
param effect string

// Create a policy definition
resource policyDef 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyName
  properties: {
    description: policyDescription
    displayName: policydisplayName
    policyType: 'Custom'
    mode: 'All'
    parameters: {
      allowedSkus: {
        type: 'Array'
        metadata: {
          description: 'The list of allowed VM sizes'
        }
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
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Compute/virtualMachines'
          }
          {
            not: {
              field: 'Microsoft.Compute/virtualMachines/sku.name'
              in: '[parameters(\'allowedSkus\')]'
            }
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
    metadata: {
      category: category
    }
  }
}

// OUTPUTS
output policyDefinitionId string = policyDef.id
output policyName string = policyDef.name
