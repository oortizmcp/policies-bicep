targetScope = 'subscription'

// Parameters
@description('Deny creation of resources if not deploying in any of the allowed regions')
param allowedLocations array

@description('Deny creation if Environment tag is not included in the allowed values')
param environmenttagallowedValues array

@description('Deny creation of VM if size is not in the allowed list')
param allowedSkus array

// Create a policy definition to Deny creation of resource Group is not deploying in any of the allowed regions
module rgallowedregions '../../categories/general/Allowed-RG-Locations/definition/pdef-allowed-locations-resourceGroups.bicep' = {
  name: 'deny-allowedregions-rg'
  params: {
    category: 'General'
    policyName: 'Custom - Deny resourceGroups-allowed-locations'
    policydisplayName: 'Custom - Deny resource Group creation (only allowed regions).'
    policyDescription: 'Deny creation of resource Group if not deploying in any of the allowed regions list.'
    allowedLocations: allowedLocations
    effect: 'Deny'
  }
}

// Create a policy definition to Deny creation of resources if not deploying in any of the allowed regions
module allowedregions '../../categories/general/Allowed-Resources-Locations/definition/pdef-allowed-locations-resources.bicep' = {
  name: 'deny-allowedregions-resources'
  params: {
    category: 'General'
    policyName: 'Custom - Deny resources-allowed-locations'
    policydisplayName: 'Custom - Deny resource creation (only allowed regions).'
    policyDescription: 'Deny creation of resources if not deploying in any of the allowed regions list.'
    effect: 'Deny'
  }
}

// Create a policy definition to Deny creation of resources if not including the required tags
// Tag name: Environment
module requiredtagenvironment '../../categories/tags/Require-Tag-Environment-RG/pdef-require-tags-Environment-resourceGroups.bicep' = {
  name: 'deny-requiredtagenvironment-rg'
  params: {
    category: 'Tags'
    policyName: 'Custom - Deny missing-requiredTag-environment-resourceGroup'
    tagName: 'Environment'
    policydisplayName: 'Custom - Deny missing Environment tag on Resource Group'
    policyDescription: 'When missing "Environment" tag on Resource Group, deployment is denied.'
    tagallowedValues: environmenttagallowedValues
    effect: 'Deny'
  }
}

// Create a policy definition to Deny creation of resource if not including the required tags
// Tag name: Owner
module requiredtagowner '../../categories/tags/Require-Tag-Owner-RG/pdef-require-tags-Owner-resourceGroup.bicep' = {
  name: 'deny-requiredtagowner-rg'
  params: {
    category: 'Tags'
    policyName: 'Custom - Deny missing-requiredTag-owner-resourceGroup'
    tagName: 'Owner'
    policydisplayName: 'Custom - Deny missing Owner tag on Resource Group'
    policyDescription: 'When missing "Owner" tag on Resource Group, deployment is denied.'
    effect: 'Deny'
  }
}

// Tag Name: Department
module requiredtagdepartment '../../categories/tags/Require-Tag-Department-RG/pdef-require-tags-Department-resourceGroup.bicep' = {
  name: 'deny-requiredtagdepartment-rg'
  params: {
    category: 'Tags'
    policyName: 'Custom - Deny missing-requiredTag-department-resourceGroup'
    tagName: 'Department'
    policydisplayName: 'Custom - Deny missing Department tag on Resource Group'
    policyDescription: 'When missing "Department" tag on Resource Group, deployment is denied.'
    effect: 'Deny'
  }
}

// Create a policy definition to Deny creation of VM if size is not in the allowed list
module allowedvmsizes '../../categories/compute/Allowed-VMSkus/pdef-allowed-vmSkus.bicep' = {
  name: 'deny-allowedvmsizes'
  params: {
    category: 'Compute'
    policyName: 'Custom - Deny VM size if not in the allowedVmSizes list'
    policydisplayName: 'Custom - Deny if VM size selected is not in the allowedVmSizes list.'
    policyDescription: 'When VM selected size is not in the allowedVmSizes list, deployment is denied.'
    allowedSkus: allowedSkus
    effect: 'Deny'
  }
}

// OUTPUTS
output environmenttagpolicydefinitionId string = requiredtagenvironment.outputs.policyDefinitionId
output ownertagpolicydefinitionId string = requiredtagowner.outputs.policyDefinitionId
output departmenttagpolicydefinitionId string = requiredtagdepartment.outputs.policyDefinitionId
output allowedregionspolicydefinitionId string = allowedregions.outputs.policyId
output allowedvmsizespolicydefinitionId string = allowedvmsizes.outputs.policyDefinitionId
output rgallowedregionspolicydefinitionId string = rgallowedregions.outputs.policyId
