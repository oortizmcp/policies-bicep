targetScope = 'subscription'

param initiativeDefinitionName string
param initiativeDescription string
param category string
param allowedLocations array
param rglocationspolicydefinitionId string
param locationsresourcepolicydefinitionId string
param effect string

resource policyinitiativedefinititon 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: initiativeDefinitionName
  properties: {
    displayName: initiativeDefinitionName
    description: initiativeDescription
    policyType: 'Custom'
    metadata: {
      category: category
    }
    parameters: {
      listOfAllowedLocations: {
        type: 'Array'
        allowedValues: allowedLocations
        defaultValue: allowedLocations
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
        policyDefinitionId: rglocationspolicydefinitionId
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'listOfAllowedLocations\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: locationsresourcepolicydefinitionId
      }
    ]
  }
}

output initiativeDefinitionId string = policyinitiativedefinititon.id
