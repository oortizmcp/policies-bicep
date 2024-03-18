targetScope = 'subscription'

param allowedLocations array
param environmenttagallowedValues array

param allowedSkus array

// // Initiatives Assignments for Tagging
module initiativetagassignment '../../policyassignments-template/passig.bicep' = {
  name: 'deny-initiativetagassignment'
  params: {
    assignmentDescription: 'Deny Assignment for Initiative Tag'
    assignmentDisplayName: 'Tag - Deny Assignment'
    noncomplianceMessage: 'Check for required Tags "Environment", "Owner" and "Department" '
    policySetDefinitionName: 'Custom Initiative - Deny Tagging'
    policyParameters: {
      tagName: {
        value: 'Environment'
      }
      tagValue: {
        value: environmenttagallowedValues
      }
      effect: {
        value: 'Deny'
      }
    }
  }
}

// // Initiative Assignment for allowed regions
module initiativeregionassignment '../../policyassignments-template/passig.bicep' = {
  name: 'deny-initiativeallowedlocationsassignment'
  params: {
    assignmentDescription: 'Deny Assignment for Initiative Allowed Locations'
    assignmentDisplayName: 'Allowed Regions - Deny Assignment'
    noncomplianceMessage: 'Check for allowed regions list to make sure is allowed and resources are in the same region as the resource group'
    policySetDefinitionName: 'Custom Initiative - Deny General - Allowed Locations'
    policyParameters: {
      listOfAllowedLocations: {
        value: allowedLocations
      }
      effect: {
        value: 'Deny'
      }
    }
  }
}

// // Initiative Assignment for allowed VM Sizes
module initiativevmskusassignment '../../policyassignments-template/passig.bicep' = {
  name: 'deny-initiativevmskusassignment'
  params: {
    assignmentDescription: 'Deny Assignment for Initiative Allowed VM Skus'
    assignmentDisplayName: 'Allowed VM Skus - Deny Assignment'
    noncomplianceMessage: 'Check for allowed VM sizes list to make sure is allowed'
    policySetDefinitionName: 'Custom Initiative - Deny Compute - Allowed VM SKUs'
    policyParameters: {
      allowedSkus: {
        value: allowedSkus
      }
      effect: {
        value: 'Deny'
      }
    }
  }
}

// OUTPUTS
output initiativetagassignmentid string = initiativetagassignment.outputs.policyAssignmentId
output initiativeregionassignmentid string = initiativeregionassignment.outputs.policyAssignmentId
output initiativevmskusassignmentid string = initiativevmskusassignment.outputs.policyAssignmentId
