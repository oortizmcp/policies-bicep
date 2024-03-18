targetScope = 'subscription'

// Temp effect is audit, will change to deny, once policy is tested

@description('Policy name starting with custom')
param policyName string

@description('Category of the policy')
param category string

@description('Describe what the policy does')
param policyDescription string

@description('How policy shows in Azure policy on display Name')
param policydisplayName string

@description('Allowed locations for resource Groups')
param allowedLocations array

@description('Effect of the policy either audit or deny')
param effect string

// Policy Definition
resource allowLocations 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: policyName
  properties: {
    displayName: policydisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'All'
    parameters: {
      listOfAllowedLocations: {
        type: 'Array'
        allowedValues: allowedLocations
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
            field: 'location'
            notIn: '[parameters(\'listOfAllowedLocations\')]'
          }
          {
            field: 'location'
            notEquals: 'global'
          }
          {
            field: 'type'
            notEquals: 'Microsoft.AzureActiveDirectory/b2cDirectories'
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

output policyId string = allowLocations.id
output policyName string = allowLocations.name
