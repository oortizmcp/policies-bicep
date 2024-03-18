targetScope = 'subscription'

// Parameters
param policyName string
param policyDescription string
param tagName string
param category string
param effect string

resource policyDef 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: policyName
  properties: {
    displayName: policyDescription
    policyType: 'Custom'
    mode: 'All'
    description: policyDescription
    metadata: {
      category: category
    }
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: tagName
          description: policyDescription
        }
      }
      effect: {
        type: 'String'
        defaultValue: effect
        allowedValues: [
          'Audit'
          'Modify'
          'Disabled'
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
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
            exists: 'false'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
        details: {
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          operations: [
            {
              operation: 'add'
              field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              value: '[utcNow()]'
            }
          ]
        }
      }
    }
  }
}

output policyId string = policyDef.id
output policyName string = policyDef.name
