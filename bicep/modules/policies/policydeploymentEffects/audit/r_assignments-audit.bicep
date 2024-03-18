targetScope = 'subscription'

param allowedLocations array
param environmenttagallowedValues array

param allowedSkus array

// // Initiatives Assignments for Tagging
module initiativetagassignment '../../policyassignments-template/passig.bicep' = {
  name: 'audit-initiativetagassignment'
  params: {
    assignmentDescription: 'Audit Assignment for Initiative Tag'
    assignmentDisplayName: 'Tag - Audit Assignment'
    noncomplianceMessage: 'Check for required Tags "Environment", "Owner" and "Department". Owner Tag Value must be in email format *@lunavi.com '
    policySetDefinitionName: 'Custom Initiative - Audit Tagging'
    policyParameters: {
      tagName: {
        value: 'Environment'
      }
      tagValue: {
        value: environmenttagallowedValues
      }
      effect: {
        value: 'Audit'
      }
    }
  }
}

// // Initiative Assignment for allowed regions
module initiativeregionassignment '../../policyassignments-template/passig.bicep' = {
  name: 'audit-initiativeallowedlocationsassignment'
  params: {
    assignmentDescription: 'Audit Assignment for Initiative Allowed Locations'
    assignmentDisplayName: 'Allowed Regions - Audit Assignment'
    noncomplianceMessage: 'Check for allowed regions list to make sure is allowed and resources are in the same region as the resource group'
    policySetDefinitionName: 'Custom Initiative - Audit General - Allowed Locations'
    policyParameters: {
      listOfAllowedLocations: {
        value: allowedLocations
      }
      effect: {
        value: 'Audit'
      }
    }
  }
}

// // Initiative Assignment for allowed VM Sizes
module initiativevmskusassignment '../../policyassignments-template/passig.bicep' = {
  name: 'audit-initiativevmskusassignment'
  params: {
    assignmentDescription: 'Audit Assignment for Initiative Allowed VM Skus'
    assignmentDisplayName: 'Allowed VM Skus - Audit Assignment'
    noncomplianceMessage: 'Check for allowed VM sizes list to make sure is allowed'
    policySetDefinitionName: 'Custom Initiative - Audit Compute - Allowed VM SKUs'
    policyParameters: {
      allowedSkus: {
        value: allowedSkus
      }
      effect: {
        value: 'Audit'
      }
    }
  }
}

// OUTPUTS
output initiativetagassignmentid string = initiativetagassignment.outputs.policyAssignmentId
output initiativeregionassignmentid string = initiativeregionassignment.outputs.policyAssignmentId
output initiativevmskusassignmentid string = initiativevmskusassignment.outputs.policyAssignmentId
