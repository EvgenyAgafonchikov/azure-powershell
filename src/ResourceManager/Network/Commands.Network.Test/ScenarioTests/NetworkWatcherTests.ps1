# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.SYNOPSIS
Tests creating new simple public networkinterface.
#>
function Test-NetworkWatcherCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    $resourceTypeParent = "Microsoft.Network/NetworkWatchers"
    $location = Get-ProviderLocation $resourceTypeParent


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;

        $vNetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Name $rname -Location $location;

        $vNetworkWatcher = Get-AzureRMNetworkWatcher -ResourceGroupName $rgname -Name $rname;

        $removeNetworkWatcher = Remove-AzureRMNetworkWatcher -ResourceGroupName $rgname -Name $rname -PassThru;

        Assert-AreEqual true $removeNetworkWatcher;

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-NetworkWatcherCRUDAllParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    # TODO: place real values below
    $resourceTypeParent = "Microsoft.Network/NetworkWatchers"
    $location = Get-ProviderLocation $resourceTypeParent
    $Tag = @{tag1='test'}


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;

        $vNetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Name $rname -Location $location -Tag @{tag1='test'};
        Assert-AreEqualObjectProperties @{tag1='test'} $vNetworkWatcher.Tag;

        $vNetworkWatcher = Get-AzureRMNetworkWatcher -ResourceGroupName $rgname -Name $rname;
        Assert-AreEqualObjectProperties @{tag1='test'} $vNetworkWatcher.Tag;

        $removeNetworkWatcher = Remove-AzureRMNetworkWatcher -ResourceGroupName $rgname -Name $rname -PassThru;

        Assert-AreEqual true $removeNetworkWatcher;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}


