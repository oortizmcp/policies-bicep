targetScope = 'subscription'

param policyName string
param policyDescription string
param category string
param effect string

resource policydefinitioninherittags 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: policyName
  properties: {
    displayName: policyDescription
    policyType: 'Custom'
    mode: 'Indexed'
    description: policyDescription
    metadata: {
      category: category
    }
    parameters: {
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
            field: 'tags'
            exists: 'false'
          }
          {
            value: '[resourceGroup().tags]'
            notEquals: ''
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
        details: {
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          operations: [
            {
              operation: 'add'
              field: 'tags'
              value: '[resourceGroup().tags]'
            }
          ]
        }
      }
    }
  }
}

output policydefinitioninherittagsId string = policydefinitioninherittags.id
