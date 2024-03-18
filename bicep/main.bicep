targetScope = 'subscription'

@description('Allowed locations for Resource Groups & resources.')
param allowedLocations array = [
  'eastus2'
  'eastus'
  'centralus'
  'westus'
  'westus2'
]

@description('Allowed values for Environment tag.')
param environmenttagallowedValues array = [
  'SBOX'
  'DEV'
  'STG'
  'PROD'
]

@description('Allowed Sizes for VMs.')
param allowedSkus array = [
  'Standard_D2s_v3'
  'Standard_D4s_v3'
]

// Create Policy Definitions
module auditdefinitions './modules/policies/policydeploymentEffects/audit/r_definitions-audit.bicep' = {
  name: 'auditdefinitions'
  params: {
    allowedLocations: allowedLocations
    environmenttagallowedValues: environmenttagallowedValues
    allowedSkus: allowedSkus
  }
}

module denydefinitions './modules/policies/policydeploymentEffects/deny/r_definitions-deny.bicep' = {
  name: 'denydefinitions'
  params: {
    allowedLocations: allowedLocations
    environmenttagallowedValues: environmenttagallowedValues
    allowedSkus: allowedSkus
  }
}

module modifydefinitions './modules/policies/policydeploymentEffects/modify/r_definitions-modify.bicep' = {
  name: 'modifydefinitions'
}

// Create Policy Initiatives
module auditinitiatives './modules/policies/policydeploymentEffects/audit/r_initiatives-audit.bicep' = {
  name: 'auditinitiatives'
  params: {
    environmenttagallowedValues: environmenttagallowedValues
    environmenttagpolicydefinitionId: auditdefinitions.outputs.environmenttagpolicydefinitionId
    ownertagpolicydefinitionId: auditdefinitions.outputs.ownertagpolicydefinitionId
    departmenttagpolicydefinitionId: auditdefinitions.outputs.departmenttagpolicydefinitionId
    rglocationspolicydefinitionId: auditdefinitions.outputs.rgallowedregionspolicydefinitionId
    locationsresourcepolicydefinitionId: auditdefinitions.outputs.allowedregionspolicydefinitionId
    allowedLocations: allowedLocations
    allowedSkus: allowedSkus
    allowedvmskuspolicydefinitionId: auditdefinitions.outputs.allowedvmsizespolicydefinitionId
  }
  dependsOn: [
    auditdefinitions
    denydefinitions
    modifydefinitions
  ]
}

module denyinitiatives './modules/policies/policydeploymentEffects/deny/r_initiatives-deny.bicep' = {
  name: 'denyinitiatives'
  params: {
    environmenttagallowedValues: environmenttagallowedValues
    environmenttagpolicydefinitionId: denydefinitions.outputs.environmenttagpolicydefinitionId
    ownertagpolicydefinitionId: denydefinitions.outputs.ownertagpolicydefinitionId
    departmenttagpolicydefinitionId: denydefinitions.outputs.departmenttagpolicydefinitionId
    rglocationspolicydefinitionId: denydefinitions.outputs.rgallowedregionspolicydefinitionId
    locationsresourcepolicydefinitionId: denydefinitions.outputs.allowedregionspolicydefinitionId
    allowedLocations: allowedLocations
    allowedSkus: allowedSkus
    allowedvmskuspolicydefinitionId: denydefinitions.outputs.allowedvmsizespolicydefinitionId
  }
  dependsOn: [
    auditdefinitions
    denydefinitions
    modifydefinitions
  ]
}

module modifyinitiatives './modules/policies/policydeploymentEffects/modify/r_initiatives-modify.bicep' = {
  name: 'modifyinitiatives'
  params: {
    creationdatepolicydefinitionId: modifydefinitions.outputs.creationdatepolicydefinitionId
  }
  dependsOn: [
    auditdefinitions
    denydefinitions
    modifydefinitions
  ]
}

// Create Policy Assignments
module auditassignments './modules/policies/policydeploymentEffects/audit/r_assignments-audit.bicep' = {
  name: 'auditassignments'
  params: {
    allowedLocations: allowedLocations
    environmenttagallowedValues: environmenttagallowedValues
    allowedSkus: allowedSkus
  }
  dependsOn: [
    auditinitiatives
    denyinitiatives
    modifyinitiatives
  ]
}

module denyassignments './modules/policies/policydeploymentEffects/deny/r_assignments-deny.bicep' = {
  name: 'denyassignments'
  params: {
    allowedLocations: allowedLocations
    environmenttagallowedValues: environmenttagallowedValues
    allowedSkus: allowedSkus
  }
  dependsOn: [
    auditinitiatives
    denyinitiatives
    modifyinitiatives
  ]
}

module modifyassignments './modules/policies/policydeploymentEffects/modify/r_assignments-modify.bicep' = {
  name: 'modifyassignments'
  dependsOn: [
    auditinitiatives
    denyinitiatives
    modifyinitiatives
  ]
}

// OUTPUTS
//Definitions
output auditdefinitionsids array = [
  auditdefinitions.outputs.environmenttagpolicydefinitionId
  auditdefinitions.outputs.ownertagpolicydefinitionId
  auditdefinitions.outputs.departmenttagpolicydefinitionId
  auditdefinitions.outputs.rgallowedregionspolicydefinitionId
  auditdefinitions.outputs.allowedregionspolicydefinitionId
  auditdefinitions.outputs.allowedvmsizespolicydefinitionId
]

output denydefinitionsids array = [
  denydefinitions.outputs.environmenttagpolicydefinitionId
  denydefinitions.outputs.ownertagpolicydefinitionId
  denydefinitions.outputs.departmenttagpolicydefinitionId
  denydefinitions.outputs.rgallowedregionspolicydefinitionId
  denydefinitions.outputs.allowedregionspolicydefinitionId
  denydefinitions.outputs.allowedvmsizespolicydefinitionId
]

output modifydefinitionsids array = [
  modifydefinitions.outputs.creationdatepolicydefinitionId
]

//Initiatives
output auditinitiativesids array = [
  auditinitiatives.outputs.allowedregionspolicyinitiativeid
  auditinitiatives.outputs.allowedvmskuspolicyinitiativeid
  auditinitiatives.outputs.tagpolicyinitiativeid

]

output denyinitiativesids array = [
  denyinitiatives.outputs.allowedregionspolicyinitiativeid
  denyinitiatives.outputs.allowedvmskuspolicyinitiativeid
  denyinitiatives.outputs.tagpolicyinitiativeid
]

output modifyinitiativesids array = [
  modifyinitiatives.outputs.creationdatetagpolicyinitiativeid
]

// Assignments
output auditassignmentsids array = [
  auditassignments.outputs.initiativeregionassignmentid
  auditassignments.outputs.initiativevmskusassignmentid
  auditassignments.outputs.initiativetagassignmentid
]

output denyassignmentsids array = [
  denyassignments.outputs.initiativeregionassignmentid
  denyassignments.outputs.initiativevmskusassignmentid
  denyassignments.outputs.initiativetagassignmentid
]

output modifyassignmentsids array = [
  modifyassignments.outputs.initiativecreationdatetagassignmentid
]
