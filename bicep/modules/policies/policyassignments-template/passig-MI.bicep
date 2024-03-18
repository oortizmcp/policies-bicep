targetScope = 'subscription'

//PARAMETERS
param assignmentDescription string
param assignmentDisplayName string
param noncomplianceMessage string
param policyDefinitionName string = ''
param policySetDefinitionName string = ''
param policyParameters object
param location string

var isPolicyDefinition = !empty(policyDefinitionName)
var isPolicySetDefinition = !empty(policySetDefinitionName)

// Existing policy Definition
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2023-04-01' existing = if (isPolicyDefinition) {
  name: policyDefinitionName
}

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2023-04-01' existing = if (isPolicySetDefinition) {
  name: policySetDefinitionName
}

// Policy Assignment
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: '${isPolicyDefinition ? policyDefinition.name : policySetDefinition.name}-Assign'
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  properties: {
    metadata: {
      assignedBy: 'DevOps Pipeline'
    }
    description: assignmentDescription
    displayName: assignmentDisplayName
    nonComplianceMessages: [
      {
        message: noncomplianceMessage
      }
    ]
    parameters: policyParameters
    policyDefinitionId: isPolicyDefinition ? policyDefinition.id : policySetDefinition.id
  }
}

// Role Assignments - required for policy assignment managed identity to have permissions to assignment scope
// This assigns the policy assignment managed identity the Contributor role at the subscription scope
// resource tagging_roleassignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid(policyAssignment.name, policyAssignment.type, subscription().id)
//   properties: {
//     principalId: policyAssignment.identity.principalId
//     principalType: 'ServicePrincipal'
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor for DINE/modify effects
//   }
// }

// OUTPUTS
output policyAssignmentId string = policyAssignment.id
output policyassignmentmanagedIdentity string = policyAssignment.identity.principalId
