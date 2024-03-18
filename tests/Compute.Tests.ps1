



Describe "Policy denies creation of VM if VM Sku is not in the allowed vmSKUS" {
    Context "When creating VM with not allowed VM SKU" {
        It "Should deny VM creation" {
            # Arrange
            $allowedVmSkus = @("Standard_M32ls")
            $tags = @{
                "Environment" = "SBOX"
                "Department" = "Finance"
                "Owner" = "test@youremail.com" # TODO: Replace with your company's email
            }
            $vmName = "TestVM"
            $resourceGroupName = "TestResourceGroup"
            $location = "West US"
            
            if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
                New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tags
            }

            try {
                foreach($vmSize in $allowedVmSkus){
                $vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
                $vm = New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig -ErrorAction SilentlyContinue
                $vm.StatusCode | Should -Be 403 
                }
            }
            catch {
                $_.ErrorDetails.Message | Should -Match $null
            }
        }
    } 
    Context "When creating VM with allowed VM Sku" {
        It "Should allow VM creation" {
            # Arrange
            $allowedVmSkus = @("Standard_D2s_v3")
            $vmName = "TestVM"
            $resourceGroupName = "TestResourceGroup"
            $location = "West US"
            
            try {
                foreach($vmSize in $allowedVmSkus){
                $vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
                $vm = New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig -ErrorAction SilentlyContinue
                $vm.StatusCode | Should -Not -Be 403 
                }
            }
            catch {
                $_.Exception.Message | Should -Not -Match $null
            }

            if (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue) {
                Write-Output "Removing resource group $resourceGroupName"
                Remove-AzResourceGroup -Name $resourceGroupName -Force
            }
        }
    }
}


