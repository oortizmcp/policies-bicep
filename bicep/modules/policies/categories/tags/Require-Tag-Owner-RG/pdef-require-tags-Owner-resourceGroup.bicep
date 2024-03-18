targetScope = 'subscription'

// Temp effect is audit, will change to deny, once policy is tested

@description('Policy Name')
param policyName string

@description('Explains what policy does in Azure policy on description')
param policyDescription string

@description('Category of the policy')
param category string

@description('How policy shows in Azure policy on display Name')
param policydisplayName string

@description('Tag name to require')
param tagName string

@description('Effect of the policy either audit or deny')
param effect string

// Create policy definition
resource policyDef 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyName
  properties: {
    description: policyDescription
    displayName: policydisplayName
    policyType: 'Custom'
    mode: 'All'
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: tagName
          description: 'Name of the tag'
        }
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
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
            notLike: '*@youremail.com'
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
