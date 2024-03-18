targetScope = 'subscription'

param initiativeDefinitionName string
param initiativeDescription string
param category string
param environmenttagallowedValues array
param environmenttagpolicydefinitionId string
param ownertagpolicydefinitionId string
param departmenttagpolicydefinitionId string
param effect string

resource tagspolicyinitiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: initiativeDefinitionName
  properties: {
    displayName: initiativeDefinitionName
    description: initiativeDescription
    policyType: 'Custom'
    metadata: {
      category: category
    }
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag Name'
          description: 'Name of the tag'
        }
      }
      tagValue: {
        type: 'Array'
        metadata: {
          displayName: 'Tag Value'
          description: 'Value of the tag'
        }
        allowedValues: environmenttagallowedValues
        defaultValue: environmenttagallowedValues
      }
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        defaultValue: effect
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: environmenttagpolicydefinitionId
        parameters: {
          tagName: {
            value: '[parameters(\'tagName\')]'
          }
          tagValue: {
            value: '[parameters(\'tagValue\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: ownertagpolicydefinitionId
        parameters: {
          tagName: {
            value: 'Owner'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: departmenttagpolicydefinitionId
        parameters: {
          tagName: {
            value: 'Department'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
    ]
  }
}

output initiativeDefinitionId string = tagspolicyinitiative.id
