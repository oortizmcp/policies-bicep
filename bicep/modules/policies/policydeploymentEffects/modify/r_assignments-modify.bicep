targetScope = 'subscription'

// Initiative Assignment for CreationDate Tag
module initiativecreationdatetagassignment '../../policyassignments-template/passig-MI.bicep' = {
  name: 'modify-initiativecreationdatetagassignment'
  params: {
    assignmentDescription: 'DINE Assignment for Initiative CreationDate Tag'
    assignmentDisplayName: 'CreationDate Tag - DINE Assignment'
    location: 'eastus'
    noncomplianceMessage: 'Missing "CreationDate" tag on Resource Group.'
    policySetDefinitionName: 'Custom Initiative - DINE - Creation Date Tag'
    policyParameters: {
      tagName: {
        value: 'CreationDate'
      }
      effect: {
        value: 'Modify'
      }
    }
  }
}

// OUTPUTS
output initiativecreationdatetagassignmentid string = initiativecreationdatetagassignment.outputs.policyAssignmentId
