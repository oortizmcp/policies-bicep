targetScope = 'subscription'

// Create a policy to Add CreationDate tag in resource group if missing
module addcreationdate '../../categories/DINE/Add-CreationDate-Tag-ifMissing/pdef-add-creationdate-tag-if-missing.bicep' = {
  name: 'modify-addcreationdate'
  params: {
    policyName: 'Custom - DINE CreationDate Tag'
    policyDescription: 'Custom - Add CreationDate tag to Resource Group if tag is missing.'
    category: 'DINE'
    tagName: 'CreationDate'
    effect: 'Modify'
  }
}

// OUTPUTS
output creationdatepolicydefinitionId string = addcreationdate.outputs.policyId
