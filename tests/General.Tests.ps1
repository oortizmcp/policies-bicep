
Describe "Resource Group Creation Policy" {
    Context "When creating a Resource Group in disallowed locations" {
        It "Should deny the creation" {
            # Arrange
            $resourceGroupName = "TestRGlocations"
            $tags = @{
                "Environment" = "SBOX"
                "Department" = "Finance"
                "Owner" = "test@youremail.com" # TODO: Replace with your company's email
            }

            $disallowedLocations = @("South Central US", "West Europe", "West US 3" ) # Add your disallowed locations here
            # Act
            foreach ($location in $disallowedLocations) {
                $result = New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tags -ErrorAction SilentlyContinue
                $result | Should -BeNullOrEmpty
                #Clean up
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
    Context "When creating a Resource Group in allowed locations" {
        It "Should allow the creation" {
            # Arrange
            $resourceGroupName = "TestRGlocations"
            $tags = @{
                "Environment" = "SBOX"
                "Department" = "Finance"
                "Owner" = "test@youremail.com" # TODO: Replace with your company's email
            }
            $allowedLocations = @("East US") 
            # Act
            foreach ($location in $allowedLocations) {
                $result = New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tags -ErrorAction SilentlyContinue
                $result | Should -Not -BeNullOrEmpty
                # Clean up
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
}
