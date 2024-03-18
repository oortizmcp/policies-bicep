targetScope = 'subscription'

@description('Audit creation if Environment tag is not included in the allowed values')
param environmenttagallowedValues array

@description('Policy definition Id for Environment tag')
param environmenttagpolicydefinitionId string

@description('Policy definition Id for Owner tag')
param ownertagpolicydefinitionId string

@description('Policy definition Id for Department tag')
param departmenttagpolicydefinitionId string

@description('Allowed locations for resource Groups and resources')
param rglocationspolicydefinitionId string
param locationsresourcepolicydefinitionId string
param allowedLocations array

@description('Policy definition Id for allowed VM SKUs')
param allowedSkus array
param allowedvmskuspolicydefinitionId string

// Policy Initiative for Tags
module tagginginitiative '../../categories/tags/initiative/polinit-tags.bicep' = {
  name: 'audit-policyinitiative-tags'
  params: {
    initiativeDefinitionName: 'Custom Initiative - Audit Tagging'
    initiativeDescription: 'Custom Initiative - Audit Tagging'
    category: 'Tags'
    environmenttagallowedValues: environmenttagallowedValues
    environmenttagpolicydefinitionId: environmenttagpolicydefinitionId
    ownertagpolicydefinitionId: ownertagpolicydefinitionId
    departmenttagpolicydefinitionId: departmenttagpolicydefinitionId
    effect: 'Audit'
  }
}

// Policy Initiative for Allowed Regions
module initiativeallowedregions '../../categories/general/initiatives/polinit-allowedLocations.bicep' = {
  name: 'audit-policyinitiative-allowedregions'
  params: {
    initiativeDefinitionName: 'Custom Initiative - Audit General - Allowed Locations'
    initiativeDescription: 'Custom Initiative - Audit General - Allowed Locations'
    category: 'General'
    allowedLocations: allowedLocations
    rglocationspolicydefinitionId: rglocationspolicydefinitionId
    locationsresourcepolicydefinitionId: locationsresourcepolicydefinitionId
    effect: 'Audit'
  }
}

module initiativeallowedvmskus '../../categories/compute/initiative/polinit-allowedSkus.bicep' = {
  name: 'audit-policyinitiative-allowedvmskus'
  params: {
    initiativeDefinitionName: 'Custom Initiative - Audit Compute - Allowed VM SKUs'
    initiativeDescription: 'Custom Initiative - Audit Compute - Allowed VM SKUs'
    category: 'Compute'
    allowedSkus: allowedSkus
    allowedvmskuspolicydefinitionId: allowedvmskuspolicydefinitionId
    effect: 'Audit'
  }
}

// Outputs
output tagpolicyinitiativeid string = tagginginitiative.outputs.initiativeDefinitionId
output allowedregionspolicyinitiativeid string = initiativeallowedregions.outputs.initiativeDefinitionId
output allowedvmskuspolicyinitiativeid string = initiativeallowedvmskus.outputs.initiativeDefinitionId
