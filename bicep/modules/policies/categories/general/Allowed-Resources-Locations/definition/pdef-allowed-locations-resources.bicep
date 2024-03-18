targetScope = 'subscription'

@description('Policy Name started with custom')
param policyName string

@description('Describe what the policy does')
param policyDescription string

@description('Category of the policy')
param category string

@description('How policy shows in Azure policy on display Name')
param policydisplayName string

@description('Effect of the policy either audit or deny')
param effect string

resource policy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: policyName
  properties: {
    displayName: policydisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'All'
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
          'Deny'
        ]
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups/resources'
          }
          {
            field: 'location'
            notEquals: '[resourceGroup().location]'
          }
          {
            field: 'location'
            notEquals: 'global'
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

output allowedLocations string = subscriptionResourceId('Microsoft.Authorization/policyDefinitions', policyName)
output policyName string = policy.name
output policyId string = policy.id
