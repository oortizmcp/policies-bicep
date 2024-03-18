targetScope = 'subscription'

@description('Policy definition Id for Creation Date tag')
param creationdatepolicydefinitionId string

module initiativecreationdatetag '../../categories/DINE/initiatives/polinit-dine-creationdatetag.bicep' = {
  name: 'modify-policyinitiative-creationdatetag'
  params: {
    initiativeDefinitionName: 'Custom Initiative - DINE - Creation Date Tag'
    initiativeDescription: 'Custom Initiative - DINE - Creation Date Tag'
    category: 'DINE'
    creationdatepolicydefinitionId: creationdatepolicydefinitionId
    effect: 'Modify'
  }
}

// Outputs
output creationdatetagpolicyinitiativeid string = initiativecreationdatetag.outputs.creationdatepolicyinitiativeId
