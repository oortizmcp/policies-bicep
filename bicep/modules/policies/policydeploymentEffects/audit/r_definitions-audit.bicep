targetScope = 'subscription'

// Parameters
@description('Audit creation of resources if not deploying in any of the allowed regions')
param allowedLocations array

@description('Audit creation if Environment tag is not included in the allowed values')
param environmenttagallowedValues array

@description('Audit creation of VM if size is not in the allowed list')
param allowedSkus array

// Create a policy definition to Audit creation of resource Group is not deploying in any of the allowed regions
module rgallowedregions '../../categories/general/Allowed-RG-Locations/definition/pdef-allowed-locations-resourceGroups.bicep' = {
  name: 'allowedregions-rg'
  params: {
    category: 'General'
    policyName: 'Custom - Audit resourceGroups-allowed-locations'
    policydisplayName: 'Custom - Audit resource Group creation (only allowed regions).'
    policyDescription: 'Audit creation of resource Group if not deploying in any of the allowed regions list.'
    allowedLocations: allowedLocations
    effect: 'Audit'
  }
}

// Create a policy definition to Audit creation of resources if not deploying in any of the allowed regions
module allowedregions '../../categories/general/Allowed-Resources-Locations/definition/pdef-allowed-locations-resources.bicep' = {
  name: 'audit-allowedregions-resources'
  params: {
    category: 'General'
    policyName: 'Custom - Audit resources-allowed-locations'
    policydisplayName: 'Custom - Audit resource creation (only allowed regions).'
    policyDescription: 'Audit creation of resources if not deploying in any of the allowed regions list.'
    effect: 'Audit'
  }
}

// Create a policy definition to Audit creation of resources if not including the required tags
// Tag name: Environment
module requiredtagenvironment '../../categories/tags/Require-Tag-Environment-RG/pdef-require-tags-Environment-resourceGroups.bicep' = {
  name: 'audit-requiredtagenvironment-rg'
  params: {
    category: 'Tags'
    policyName: 'Custom - Audit missing-requiredTag-environment-resourceGroup'
    tagName: 'Environment'
    policydisplayName: 'Custom - Audit missing Environment tag on Resource Group'
    policyDescription: 'When missing "Environment" tag on Resource Group, deployment is denied.'
    tagallowedValues: environmenttagallowedValues
    effect: 'Audit'
  }
}

// Create a policy definition to Audit creation of resource if not including the required tags
// Tag name: Owner
module requiredtagowner '../../categories/tags/Require-Tag-Owner-RG/pdef-require-tags-Owner-resourceGroup.bicep' = {
  name: 'audit-requiredtagowner-rg'
  params: {
    category: 'Tags'
    policyName: 'Custom - Audit missing-requiredTag-owner-resourceGroup'
    tagName: 'Owner'
    policydisplayName: 'Custom - Audit missing Owner tag on Resource Group'
    policyDescription: 'When missing "Owner" tag on Resource Group, deployment is denied.'
    effect: 'Audit'
  }
}

// Tag Name: Department
module requiredtagdepartment '../../categories/tags/Require-Tag-Department-RG/pdef-require-tags-Department-resourceGroup.bicep' = {
  name: '-audit-requiredtagdepartment-rg'
  params: {
    category: 'Tags'
    policyName: 'Custom - Audit missing-requiredTag-department-resourceGroup'
    tagName: 'Department'
    policydisplayName: 'Custom - Audit missing Department tag on Resource Group'
    policyDescription: 'When missing "Department" tag on Resource Group, deployment is denied.'
    effect: 'Audit'
  }
}

// Create a policy definition to Audit creation of VM if size is not in the allowed list
module allowedvmsizes '../../categories/compute/Allowed-VMSkus/pdef-allowed-vmSkus.bicep' = {
  name: 'audit-allowedvmsizes'
  params: {
    category: 'Compute'
    policyName: 'Custom - Audit VM size is not in the allowedVmSizes list'
    policydisplayName: 'Custom - Audit Audit if VM size selected is not in the allowedVmSizes list.'
    policyDescription: 'When VM selected size is not in the allowedVmSizes list, deployment is denied.'
    allowedSkus: allowedSkus
    effect: 'Audit'
  }
}

// OUTPUTS
output environmenttagpolicydefinitionId string = requiredtagenvironment.outputs.policyDefinitionId
output ownertagpolicydefinitionId string = requiredtagowner.outputs.policyDefinitionId
output departmenttagpolicydefinitionId string = requiredtagdepartment.outputs.policyDefinitionId
output allowedregionspolicydefinitionId string = allowedregions.outputs.policyId
output allowedvmsizespolicydefinitionId string = allowedvmsizes.outputs.policyDefinitionId
output rgallowedregionspolicydefinitionId string = rgallowedregions.outputs.policyId
