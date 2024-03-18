targetScope = 'subscription'

// Temp effect is audit, will change to deny, once policy is tested

@description('Name of the policy definition')
param policyName string

@description('Name of the tag')
param tagName string

@description('How policy shows in Azure policy on display Name')
param policydisplayName string

@description('Category of the policy')
param category string

@description('Describes what policy does in Azure policy')
param policyDescription string

@description('Allowed values for the tag')
param tagallowedValues array

@description('Effect of the policy either audit or deny')
param effect string

// Create a policy definition
resource policyDef 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: policyName
  properties: {
    displayName: policydisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'All'
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: tagName
          description: 'Name of the tag'
        }
        defaultValue: tagName
      }
      tagValue: {
        type: 'Array'
        metadata: {
          displayName: 'Tag Value'
          description: 'Value of the tag'
        }
        allowedValues: tagallowedValues
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
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
          {
            not: {
              field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              in: '[parameters(\'tagValue\')]'
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

output policyDefinitionId string = policyDef.id
output policyName string = policyDef.name
