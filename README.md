# Introduction

This repo is meant to be a collection of policies to be implemented as POC for future Landing Zones to enforce compliance while deploying new resources in Azure.

These policies enforce different rules and effects over your resources, so those resources stay compliant with your corporate standards and service level agreements.

In our case, the policies we will be implementing will be used to enforce the following rules:

1. Tagging: All resources must have a tag with the following keys.

   - Owner: value should have the email of the owner of the resource.
   - Department: value should have the name of the department that owns the resource. Ideally the organization should provide a list of allowed departments to deploy resources to Azure to control costs.
   - Environment: value should have the name of the environment the resource is deployed to. At the moment, the allowed values are SBOX-DEV-STG-PROD. The organization should provide details on what are the allowed values for this tag and adjust accordingly.
   - CreationDate: In case this tag is missing while creating the resource group, the policy will add the tag automatically with the current date.

     > [!NOTE]
     > The policy will not overwrite/modify existing resource groups, only the ones that are created after the policy is assigned.

2. Allowed Locations: The organization should provide a list of allowed locations to deploy resources to Azure. The policy will enforce that the resource Groups are deployed to the allowed locations only and resources inside the resource groups will need to match the location where the resource group has been deployed to.
3. Allowed VM Sku Sizes: The organization should provide a list of allowed VM Sku sizes to deploy resources to Azure. The policy will enforce that the VMs are deployed with the allowed VM sizes only.

# Folder Structure

The repository is organized as follows:

```sh
|
| -bicep
|  |-modules
|    |-policies
|      |-categories --> This folder contains the different categories (example: Compute, Tags, etc.)
|        |-mycategory
|          |-policyname --> This folder is the name of the policy
|            |-policydefinition1.bicep --> This file is the policy definition
|          |-initiative
|            |-policyinitiative.bicep --> Policy initiative file for this category
|    |-policyassignments-template
|    |-policydeploymentEffects
```

### Folders Structure explained

#### Bicep

1. bicep- In this folder you will find the main.bicep file which is the file that will do all the deployments of the policies. The main.bicep file calls other modules that create the definitions, initiatives and assignments of the policies.
   - modules/policies - This has the categories, policy assignments-templates and the policy deployment effects.
   - categories - This folder contains the different categories (example: Compute, Tags, etc.)
     - mycategory - This folder is the name of the category
       - policyname - This folder is the name of the policy
         - policydefinition1.bicep - This file is the policy definition
       - initiative - This folder contains the policy initiative For this category.
         - policyinitiative.bicep - Policy initiative
     - policyassignments-template - This folder has policy assignments template in which all policies will be based on. You will need to define the parameters in the assignments.bicep which contains all the parameters for the policy that will be implemented.
     - policydeploymentEffects - This folder contains the policy deployment effects (Example: Audit, Deny, Modify). In this folder you will find the all the modules that the main.bicep makes reference to.
       - r_definition.bicep - This file has all the custom policy definitions to be created, which is calling the policy modules under modules/categories/<#yourcategory>/<#nameofpolicy>/policydefinition.bicep. If there is any new policy to be added, first create the template with the same folder structure mentioned above, then add the policy on the definition's bicep file to be deployed. Same with other policy deployment effects (audit, deny, modify, etc.).

#### Pipelines

pipelines - This folder contains the pipeline yaml file that will be used to deploy the policies to Azure. The pipeline will be triggered when a PR is created to the main branch. The pipeline will deploy the policies to the subscription and will be tested to make sure the policies are working as expected.

There is a branch policy configured that will not allow any PR to be merged to the main branch if the CI-Build.yaml pipeline fails. This makes sure that the code create a builds successfully before it can be merged to the main branch.

#### Tests

tests - This folder has the test scripts that will be used to test the policies after they are deployed. The tests will be run as part of the pipeline to make sure the policies are working as expected.

#### .ps-rule

.ps-rule - This repo uses PSRule to test the policies. This folder contains the PSRule configuration file that will be used to test the policies before they are getting deployed. This tool is meant to apply principals of Azure Well-Architected Framework to your workloads. This tool leverages over 400 pre-built rules to test Azure resources and checks your code against Azure infrastructure best practices. As a result, it provides feedback on how to improve your Infrastructure as Code.

## References

PS Rule - For details about how to implement , review the documentation [here](https://azure.github.io/PSRule.Rules.Azure/).

Blog by Tao Yang - [Testing Bicep Code Using PSRule in Azure Pipeline](https://blog.tyang.org/2022/03/20/azure-pipeline-psrule-bicep-test).

Azure Policy as Code - [Design Azure Policy as Code workflows](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/policy-as-code)
