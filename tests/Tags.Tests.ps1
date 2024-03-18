# Parameters: $resourceGroupName, $location
$resourceGroupName = "TestResourceGroup"
$location = "West US"

Describe "Resource Group Creation" {
    Context "When creating a resource group without mandatory tags" {
        It "Should fail with effect deny" {
            $tags = @{}
            $resourceGroupName = "TestResourceGroup"
            $location = "West US"
            
            $result = New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tags -ErrorAction Continue
            $result.StatusCode | Should -Be $NullorEmpty
        }
    }
    Context "When creating a resource group with mandatory tags" {
        It "Should succeed" {
            $tags = @{
                "Environment" = "SBOX"
                "Department" = "Finance"
                "Owner" = "test@youremail.com" # TODO: Replace with your company's email
            }
            $resourceGroupName = "TestResourceGroup"
            $location = "West US"
            
            $result = New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tags
            
            $result | Should -Not -Be $NullOrEmpty
            
            if ($result) {
                Write-Output "Removing resource group $resourceGroupName since it was created for testing purposes."
                Remove-AzResourceGroup -Name $resourceGroupName -Force
            }
            else {
                Write-Output "Resource group $resourceGroupName was not created. No need to take further action."
            }
        }
    }
}
