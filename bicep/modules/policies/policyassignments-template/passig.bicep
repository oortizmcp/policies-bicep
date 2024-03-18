targetScope = 'subscription'

//PARAMETERS
param assignmentDescription string
param assignmentDisplayName string
param noncomplianceMessage string
param policyDefinitionName string = ''
param policySetDefinitionName string = ''
param policyParameters object

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

// OUTPUTS
output policyAssignmentId string = policyAssignment.id
