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
Tests creating new simple virtualNetwork.
#>
function Test-VirtualNetworkCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    $resourceTypeParent = "Microsoft.Network/VirtualNetworks"
    $location = Get-ProviderLocation $resourceTypeParent
    $AddressPrefix = 10.0.0.0/8


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $Subnet = New-AzureRMVirtualNetworkSubnetConfig -Name SubnetName -AddressPrefix 10.0.1.0/24;

        $vVirtualNetwork = New-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname -Location $location -AddressPrefix 10.0.0.0/8;
        Assert-AreEqualArray ([array]"10.0.0.0/8".Split(",").Trim()) $vVirtualNetwork.addressSpace.AddressPrefixes;

        $vVirtualNetwork = Get-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname;
        Assert-AreEqualArray ([array]"10.0.0.0/8".Split(",").Trim()) $vVirtualNetwork.addressSpace.AddressPrefixes;

        $removeVirtualNetwork = Remove-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname -PassThru -Force;

        Assert-AreEqual true $removeVirtualNetwork;

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-VirtualNetworkCRUDAllParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    # TODO: place real values below
    $resourceTypeParent = "Microsoft.Network/VirtualNetworks"
    $location = Get-ProviderLocation $resourceTypeParent
    $AddressPrefix = 10.0.0.0/8
    $DnsServer = 10.0.0.42
    $Tag = @{tag1='test'}


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $Subnet = New-AzureRMVirtualNetworkSubnetConfig -Name SubnetName -AddressPrefix 10.0.1.0/24;

        $vVirtualNetwork = New-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname -Location $location -Subnet $Subnet -AddressPrefix 10.0.0.0/8 -DnsServer 10.0.0.42 -Tag @{tag1='test'};
        Assert-AreEqualArray ([array]"10.0.0.0/8".Split(",").Trim()) $vVirtualNetwork.addressSpace.AddressPrefixes;
        Assert-AreEqualArray ([array]"10.0.0.42".Split(",").Trim()) $vVirtualNetwork.dhcpOptions.DnsServers;
        Assert-AreEqualObjectProperties @{tag1='test'} $vVirtualNetwork.Tag;

        $vVirtualNetwork = Get-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname;
        Assert-AreEqualArray ([array]"10.0.0.0/8".Split(",").Trim()) $vVirtualNetwork.addressSpace.AddressPrefixes;
        Assert-AreEqualArray ([array]"10.0.0.42".Split(",").Trim()) $vVirtualNetwork.dhcpOptions.DnsServers;
        Assert-AreEqualObjectProperties @{tag1='test'} $vVirtualNetwork.Tag;

        $removeVirtualNetwork = Remove-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname -PassThru -Force;

        Assert-AreEqual true $removeVirtualNetwork;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-SubnetCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    $resourceTypeParent = "Microsoft.Network/VirtualNetworks";
    $location = Get-ProviderLocation $resourceTypeParent;
    $AddressPrefix = 10.0.0.0/8


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $NetworkSecurityGroup = New-AzureRMNetworkSecurityGroup -ResourceGroupName $rgname -Location $location -Name NetworkSecurityGroupName;
        $RouteTable = New-AzureRMRouteTable -ResourceGroupName $rgname -Location $location -Name RouteTableName;

        $vSubnet = New-AzureRMVirtualNetworkSubnetConfig -Name $rname -AddressPrefix 10.0.1.0/24 -NetworkSecurityGroup $NetworkSecurityGroup -RouteTable $RouteTable
        $vVirtualNetwork = New-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname -Subnet $vSubnet -AddressPrefix 10.0.0.0/8 -Location $location
        Assert-AreEqual "10.0.1.0/24" $vSubnet.AddressPrefix;

        $vSubnet = Get-AzureRMVirtualNetworkSubnetConfig -VirtualNetwork $vVirtualNetwork -Name $rname
        Assert-AreEqual "10.0.1.0/24" $vSubnet.AddressPrefix;

        $vSubnet = Add-AzureRMVirtualNetworkSubnetConfig -Name "${rname}Add" -VirtualNetwork $vVirtualNetwork -AddressPrefix 10.0.2.0/24
        # TODO: Add assertions for added
        Set-AzureRMVirtualNetwork -VirtualNetwork $vVirtualNetwork
        Remove-AzureRMVirtualNetworkSubnetConfig -VirtualNetwork $vVirtualNetwork -Name $vSubnet.Name
        Set-AzureRMVirtualNetwork -VirtualNetwork $vVirtualNetwork

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-SubnetCRUDAllParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    # TODO: place real values below
    $resourceTypeParent = "Microsoft.Network/VirtualNetworks";
    $location = Get-ProviderLocation $resourceTypeParent;
    $AddressPrefix = "10.0.1.0/24"
    $ServiceEndpoint = "Microsoft.Sql"


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $NetworkSecurityGroup = New-AzureRMNetworkSecurityGroup -ResourceGroupName $rgname -Location $location -Name NetworkSecurityGroupName;
        $RouteTable = New-AzureRMRouteTable -ResourceGroupName $rgname -Location $location -Name RouteTableName;

        $vSubnet = New-AzureRMVirtualNetworkSubnetConfig -Name $rname -NetworkSecurityGroup $NetworkSecurityGroup -RouteTable $RouteTable -AddressPrefix 10.0.1.0/24 -ServiceEndpoint Microsoft.Sql;

        $vVirtualNetwork = New-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname -Subnet $vSubnet -AddressPrefix 10.0.0.0/8 -Location $location
        $vVirtualNetwork = Get-AzureRMVirtualNetwork -ResourceGroupName $rgname -Name $rname;
        Assert-AreEqual "10.0.1.0/24" $vSubnet.AddressPrefix;

        $vSubnet = Get-AzureRMVirtualNetworkSubnetConfig -VirtualNetwork $vVirtualNetwork -Name $rname
        Assert-AreEqual "10.0.1.0/24" $vSubnet.AddressPrefix;


        Set-AzureRMVirtualNetwork -VirtualNetwork $vVirtualNetwork
        Remove-AzureRMVirtualNetworkSubnetConfig -VirtualNetwork $vVirtualNetwork -Name $vSubnet.Name
        Set-AzureRMVirtualNetwork -VirtualNetwork $vVirtualNetwork
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}


<#
.SYNOPSIS
Tests checking Virtual Network Usage feature.
#>
function Test-VirtualNetworkUsage
{
    # Setup
    $rgname = Get-ResourceGroupName
    $vnetName = Get-ResourceName
    $subnetName = Get-ResourceName
    $subnet2Name = Get-ResourceName
    $nicName = Get-ResourceName
    $domainNameLabel = Get-ResourceName
    $rglocation = Get-ProviderLocation ResourceManagement
    $resourceTypeParent = "Microsoft.Network/virtualNetworks"
    $location = Get-ProviderLocation $resourceTypeParent

    try
    {
        # Create the resource group
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation -Tags @{ testtag = "testval" } 

        # Create the Virtual Network
        $subnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.1.0/24
        New-AzureRmvirtualNetwork -Name $vnetName -ResourceGroupName $rgname -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet
        $vnet = Get-AzureRmvirtualNetwork -Name $vnetName -ResourceGroupName $rgname

        Assert-NotNull $vnet;
        Assert-NotNull $vnet.Subnets;

        $subnetId = $vnet.Subnets[0].Id;

        $usage = Get-AzureRMVirtualNetworkUsageList -ResourceGroupName $rgname -Name $vnetName;

        Assert-NotNull $usage;
        $currentUsage = $usage.CurrentValue;

        # Add Network Interface to change usage current value
        New-AzureRmNetworkInterface -Location $location -Name $nicName -ResourceGroupName $rgname -SubnetId $subnetId;
        $usage = Get-AzureRMVirtualNetworkUsageList -ResourceGroupName $rgname -Name $vnetName;
        $currentUsageNew = $usage.CurrentValue;

        Assert-AreEqual $currentUsage $($currentUsageNew - 1);
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

<#
.SYNOPSIS
Tests checking Virtual Network Subnet Service Endpoint feature.
#>
function Test-VirtualNetworkSubnetServiceEndpoint
{
    # Setup
    $rgname = Get-ResourceGroupName
    $vnetName = Get-ResourceName
    $subnetName = Get-ResourceName
    $rglocation = Get-ProviderLocation ResourceManagement
    $resourceTypeParent = "Microsoft.Network/virtualNetworks"
    $location = Get-ProviderLocation $resourceTypeParent
    $serviceEndpoint = "Microsoft.Storage"

    try
    {
        # Create the resource group
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation -Tags @{ testtag = "testval" };

        # Create the Virtual Network
        $subnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.1.0/24 -ServiceEndpoint $serviceEndpoint;
        New-AzureRmvirtualNetwork -Name $vnetName -ResourceGroupName $rgname -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet;
        $vnet = Get-AzureRmvirtualNetwork -Name $vnetName -ResourceGroupName $rgname;

        Assert-NotNull $vnet;
        Assert-NotNull $vnet.Subnets;

        $subnet = $vnet.Subnets[0];
        Assert-AreEqual $serviceEndpoint $subnet.serviceEndpoints[0].Service;

        Set-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet -AddressPrefix 10.0.1.0/24 -ServiceEndpoint $null;
        $vnet = Set-AzureRmVirtualNetwork -VirtualNetwork $vnet;
        $subnet = $vnet.Subnets[0];

        Assert-Null $subnet.serviceEndpoints;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}
