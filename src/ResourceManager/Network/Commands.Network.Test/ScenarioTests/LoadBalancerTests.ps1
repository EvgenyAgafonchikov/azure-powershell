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

function Test-LoadBalancerCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    $resourceTypeParent = "Microsoft.Network/LoadBalancers"
    $location = Get-ProviderLocation $resourceTypeParent


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $PublicIPAddress = New-AzureRMPublicIPAddress -ResourceGroupName $rgname -Location $location -Name PublicIPAddressName -AllocationMethod Static;
        $FrontendIPConfiguration = New-AzureRMLoadBalancerFrontendIPConfig -Name FrontendIPConfigurationName -PublicIPAddress $PublicIPAddress;
        $BackendAddressPool = New-AzureRMLoadBalancerBackendAddressPoolConfig -Name BackendAddressPoolName;
        $Probe = New-AzureRMLoadBalancerProbeConfig -Name ProbeName -Port 2424 -IntervalInSeconds 6 -ProbeCount 4;
        $InboundNatPool = New-AzureRMLoadBalancerInboundNatPoolConfig -Name InboundNatPoolName -FrontendIPConfiguration $FrontendIPConfiguration -Protocol Udp -FrontendPortRangeStart 555 -FrontendPortRangeEnd 999 -BackendPort 987;

        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -Location $location;

        $vLoadBalancer = Get-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname;

        $removeLoadBalancer = Remove-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -PassThru -Force;

        Assert-AreEqual true $removeLoadBalancer;

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-LoadBalancerCRUDAllParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    # TODO: place real values below
    $resourceTypeParent = "Microsoft.Network/LoadBalancers";
    $location = Get-ProviderLocation $resourceTypeParent;
    $Tag = @{tag1='test'}
    $Sku = "Basic"


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $PublicIPAddress = New-AzureRMPublicIPAddress -ResourceGroupName $rgname -Location $location -Name PublicIPAddressName -AllocationMethod Static;
        $FrontendIPConfiguration = New-AzureRMLoadBalancerFrontendIPConfig -Name FrontendIPConfigurationName -PublicIPAddress $PublicIPAddress;
        $BackendAddressPool = New-AzureRMLoadBalancerBackendAddressPoolConfig -Name BackendAddressPoolName;
        $Probe = New-AzureRMLoadBalancerProbeConfig -Name ProbeName -Port 2424 -IntervalInSeconds 6 -ProbeCount 4;
        $InboundNatPool = New-AzureRMLoadBalancerInboundNatPoolConfig -Name InboundNatPoolName -FrontendIPConfiguration $FrontendIPConfiguration -Protocol Udp -FrontendPortRangeStart 555 -FrontendPortRangeEnd 999 -BackendPort 987;

        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -Location $location -FrontendIPConfiguration $FrontendIPConfiguration -BackendAddressPool $BackendAddressPool -Probe $Probe -InboundNatPool $InboundNatPool -Tag @{tag1='test'} -Sku Basic;
        Assert-AreEqualObjectProperties @{tag1='test'} $vLoadBalancer.Tag;
        Assert-AreEqual "Basic" $vLoadBalancer.Sku.Name;

        $vLoadBalancer = Get-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname;
        Assert-AreEqualObjectProperties @{tag1='test'} $vLoadBalancer.Tag;
        Assert-AreEqual "Basic" $vLoadBalancer.Sku.Name;

        $removeLoadBalancer = Remove-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -PassThru -Force;

        Assert-AreEqual true $removeLoadBalancer;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-BackendAddressPoolCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    $resourceTypeParent = "Microsoft.Network/LoadBalancers"
    $location = Get-ProviderLocation $resourceTypeParent


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $PublicIPAddress = New-AzureRMPublicIPAddress -ResourceGroupName $rgname -Location $location -Name PublicIPAddressName -AllocationMethod Static;
        $FrontendIPConfiguration = New-AzureRMLoadBalancerFrontendIPConfig -Name FrontendIPConfigurationName -PublicIPAddress $PublicIPAddress;

        $vBackendAddressPool = New-AzureRMLoadBalancerBackendAddressPoolConfig -Name $rname
        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -BackendAddressPool $vBackendAddressPool -FrontendIPConfiguration $FrontendIPConfiguration -Location $location

        $vBackendAddressPool = Get-AzureRMLoadBalancerBackendAddressPoolConfig -LoadBalancer $vLoadBalancer -Name $rname

        $vBackendAddressPool = Add-AzureRMLoadBalancerBackendAddressPoolConfig -Name "${rname}Add" -LoadBalancer $vLoadBalancer
        # TODO: Add assertions for added
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
        Remove-AzureRMLoadBalancerBackendAddressPoolConfig -LoadBalancer $vLoadBalancer -Name $vBackendAddressPool.Name
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-FrontendIPConfigurationCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    $resourceTypeParent = "Microsoft.Network/LoadBalancers"
    $location = Get-ProviderLocation $resourceTypeParent


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $Subnet = New-AzureRMVirtualNetworkSubnetConfig -Name SubnetName -AddressPrefix 10.0.1.0/24;
        $VirtualNetwork = New-AzureRMVirtualNetwork -ResourceGroupName $rgname -Location $location -Name VirtualNetworkName -Subnet $Subnet -AddressPrefix 10.0.0.0/8;

        if(-not $Subnet.Id)
        {
            $Subnet = Get-AzureRMVirtualNetworkSubnetConfig -Name SubnetName -VirtualNetwork $VirtualNetwork;
        }
        $VirtualNetworkAdd = New-AzureRMVirtualNetwork -ResourceGroupName $rgname -Location $location -Name VirtualNetworkNameAdd -Subnet $SubnetAdd -AddressPrefix 10.0.0.0/8;

        $vFrontendIPConfiguration = New-AzureRmLoadBalancerFrontendIpConfig -Name $rname -Subnet $Subnet
        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -FrontendIPConfiguration $vFrontendIPConfiguration -Location $location

        $vFrontendIPConfiguration = Get-AzureRmLoadBalancerFrontendIpConfig -LoadBalancer $vLoadBalancer -Name $rname

        $vFrontendIPConfiguration = Add-AzureRmLoadBalancerFrontendIpConfig -Name "${rname}Add" -LoadBalancer $vLoadBalancer -Subnet $Subnet
        # TODO: Add assertions for added
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
        Remove-AzureRmLoadBalancerFrontendIpConfig -LoadBalancer $vLoadBalancer -Name $vFrontendIPConfiguration.Name
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-InboundNatPoolCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    $resourceTypeParent = "Microsoft.Network/LoadBalancers"
    $location = Get-ProviderLocation $resourceTypeParent


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $PublicIPAddress = New-AzureRMPublicIPAddress -ResourceGroupName $rgname -Location $location -Name PublicIPAddressName -AllocationMethod Static;
        $FrontendIPConfiguration = New-AzureRMLoadBalancerFrontendIPConfig -Name FrontendIPConfigurationName -PublicIPAddress $PublicIPAddress;

        $vInboundNatPool = New-AzureRMLoadBalancerInboundNatPoolConfig -Name $rname -Protocol Udp -FrontendPortRangeStart 555 -FrontendPortRangeEnd 999 -BackendPort 987 -FrontendIPConfiguration $FrontendIPConfiguration
        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -InboundNatPool $vInboundNatPool -FrontendIPConfiguration $FrontendIPConfiguration -Location $location
        Assert-AreEqual "Udp" $vInboundNatPool.Protocol;
        Assert-AreEqual 555 $vInboundNatPool.FrontendPortRangeStart;
        Assert-AreEqual 999 $vInboundNatPool.FrontendPortRangeEnd;
        Assert-AreEqual 987 $vInboundNatPool.BackendPort;

        $vInboundNatPool = Get-AzureRMLoadBalancerInboundNatPoolConfig -LoadBalancer $vLoadBalancer -Name $rname
        Assert-AreEqual "Udp" $vInboundNatPool.Protocol;
        Assert-AreEqual 555 $vInboundNatPool.FrontendPortRangeStart;
        Assert-AreEqual 999 $vInboundNatPool.FrontendPortRangeEnd;
        Assert-AreEqual 987 $vInboundNatPool.BackendPort;

        $vInboundNatPool = Add-AzureRMLoadBalancerInboundNatPoolConfig -Name "${rname}Add" -LoadBalancer $vLoadBalancer -FrontendIPConfiguration $FrontendIPConfiguration -Protocol Tcp -FrontendPortRangeStart 444 -FrontendPortRangeEnd 445 -BackendPort 8080
        # TODO: Add assertions for added
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
        Remove-AzureRMLoadBalancerInboundNatPoolConfig -LoadBalancer $vLoadBalancer -Name $vInboundNatPool.Name
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-InboundNatRuleCRUDAllParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    # TODO: place real values below
    $resourceTypeParent = "Microsoft.Network/LoadBalancers";
    $location = Get-ProviderLocation $resourceTypeParent;
    $Protocol = "Udp"
    $FrontendPort = 123
    $BackendPort = 456
    $IdleTimeoutInMinutes = 7
    $EnableFloatingIP = true


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $Subnet = New-AzureRMVirtualNetworkSubnetConfig -Name SubnetName -AddressPrefix 10.0.1.0/24;
        $VirtualNetwork = New-AzureRMVirtualNetwork -ResourceGroupName $rgname -Location $location -Name VirtualNetworkName -Subnet $Subnet -AddressPrefix 10.0.0.0/8;

        if(-not $Subnet.Id)
        {
            $Subnet = Get-AzureRMVirtualNetworkSubnetConfig -Name SubnetName -VirtualNetwork $VirtualNetwork;
        }
        $FrontendIPConfiguration = New-AzureRMLoadBalancerFrontendIPConfig -Name FrontendIPConfigurationName -Subnet $Subnet;

        $vInboundNatRule = New-AzureRMLoadBalancerInboundNatRuleConfig -Name $rname -FrontendIPConfiguration $FrontendIPConfiguration -Protocol Udp -FrontendPort 123 -BackendPort 456 -IdleTimeoutInMinutes 7 -EnableFloatingIP;

        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -InboundNatRule $vInboundNatRule -FrontendIPConfiguration $FrontendIPConfiguration -Location $location
        $vLoadBalancer = Get-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname;
        Assert-AreEqual "Udp" $vInboundNatRule.Protocol;
        Assert-AreEqual true $vInboundNatRule.EnableFloatingIP;

        $vInboundNatRule = Get-AzureRMLoadBalancerInboundNatRuleConfig -LoadBalancer $vLoadBalancer -Name $rname
        Assert-AreEqual "Udp" $vInboundNatRule.Protocol;
        Assert-AreEqual true $vInboundNatRule.EnableFloatingIP;


        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
        Remove-AzureRMLoadBalancerInboundNatRuleConfig -LoadBalancer $vLoadBalancer -Name $vInboundNatRule.Name
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}


function Test-LoadBalancingRuleCRUDAllParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    # TODO: place real values below
    $resourceTypeParent = "Microsoft.Network/LoadBalancers";
    $location = Get-ProviderLocation $resourceTypeParent;
    $Protocol = "Udp"
    $LoadDistribution = "Default"
    $FrontendPort = 1024
    $BackendPort = 4096
    $IdleTimeoutInMinutes = 5
    $EnableFloatingIP = true


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $Subnet = New-AzureRMVirtualNetworkSubnetConfig -Name SubnetName -AddressPrefix 10.0.1.0/24;
        $VirtualNetwork = New-AzureRMVirtualNetwork -ResourceGroupName $rgname -Location $location -Name VirtualNetworkName -Subnet $Subnet -AddressPrefix 10.0.0.0/8;

        if(-not $Subnet.Id)
        {
            $Subnet = Get-AzureRMVirtualNetworkSubnetConfig -Name SubnetName -VirtualNetwork $VirtualNetwork;
        }
        $FrontendIPConfiguration = New-AzureRMLoadBalancerFrontendIPConfig -Name FrontendIPConfigurationName -Subnet $Subnet;

        $vLoadBalancingRule = New-AzureRmLoadBalancerRuleConfig -Name $rname -FrontendIPConfiguration $FrontendIPConfiguration -Protocol Udp -LoadDistribution Default -FrontendPort 1024 -BackendPort 4096 -IdleTimeoutInMinutes 5 -EnableFloatingIP;

        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -LoadBalancingRule $vLoadBalancingRule -FrontendIPConfiguration $FrontendIPConfiguration -Location $location
        $vLoadBalancer = Get-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname;
        Assert-AreEqual "Udp" $vLoadBalancingRule.Protocol;
        Assert-AreEqual "Default" $vLoadBalancingRule.LoadDistribution;
        Assert-AreEqual 1024 $vLoadBalancingRule.FrontendPort;
        Assert-AreEqual true $vLoadBalancingRule.EnableFloatingIP;

        $vLoadBalancingRule = Get-AzureRmLoadBalancerRuleConfig -LoadBalancer $vLoadBalancer -Name $rname
        Assert-AreEqual "Udp" $vLoadBalancingRule.Protocol;
        Assert-AreEqual "Default" $vLoadBalancingRule.LoadDistribution;
        Assert-AreEqual 1024 $vLoadBalancingRule.FrontendPort;
        Assert-AreEqual true $vLoadBalancingRule.EnableFloatingIP;


        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
        Remove-AzureRmLoadBalancerRuleConfig -LoadBalancer $vLoadBalancer -Name $vLoadBalancingRule.Name
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-ProbeCRUDMinimalParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    $resourceTypeParent = "Microsoft.Network/LoadBalancers"
    $location = Get-ProviderLocation $resourceTypeParent


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $PublicIPAddress = New-AzureRMPublicIPAddress -ResourceGroupName $rgname -Location $location -Name PublicIPAddressName -AllocationMethod Static;
        $FrontendIPConfiguration = New-AzureRMLoadBalancerFrontendIPConfig -Name FrontendIPConfigurationName -PublicIPAddress $PublicIPAddress;

        $vProbe = New-AzureRMLoadBalancerProbeConfig -Name $rname -Port 2424 -IntervalInSeconds 6 -ProbeCount 4
        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -Probe $vProbe -FrontendIPConfiguration $FrontendIPConfiguration -Location $location
        Assert-AreEqual 2424 $vProbe.Port;

        $vProbe = Get-AzureRMLoadBalancerProbeConfig -LoadBalancer $vLoadBalancer -Name $rname
        Assert-AreEqual 2424 $vProbe.Port;

        $vProbe = Add-AzureRMLoadBalancerProbeConfig -Name "${rname}Add" -LoadBalancer $vLoadBalancer -Port 4242 -IntervalInSeconds 11 -ProbeCount 5
        # TODO: Add assertions for added
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
        Remove-AzureRMLoadBalancerProbeConfig -LoadBalancer $vLoadBalancer -Name $vProbe.Name
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

function Test-ProbeCRUDAllParameters
{
    # Setup
    $rgname = Get-ResourceGroupName
    # TODO: generate names/values for required resources
    $rglocation = Get-ProviderLocation ResourceManagement
    $rname = Get-ResourceName
    # TODO: place real values below
    $resourceTypeParent = "Microsoft.Network/LoadBalancers";
    $location = Get-ProviderLocation $resourceTypeParent;
    $Protocol = "Http"
    $Port = 2424
    $IntervalInSeconds = 6
    $ProbeCount = 4
    $RequestPath = "/create"


    try
    {
        $resourceGroup = New-AzureRmResourceGroup -Name $rgname -Location $rglocation;
        $PublicIPAddress = New-AzureRMPublicIPAddress -ResourceGroupName $rgname -Location $location -Name PublicIPAddressName -AllocationMethod Static;
        $FrontendIPConfiguration = New-AzureRMLoadBalancerFrontendIPConfig -Name FrontendIPConfigurationName -PublicIPAddress $PublicIPAddress;

        $vProbe = New-AzureRMLoadBalancerProbeConfig -Name $rname -Protocol Http -Port 2424 -IntervalInSeconds 6 -ProbeCount 4 -RequestPath /create;

        $vLoadBalancer = New-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname -Probe $vProbe -FrontendIPConfiguration $FrontendIPConfiguration -Location $location
        $vLoadBalancer = Get-AzureRMLoadBalancer -ResourceGroupName $rgname -Name $rname;
        Assert-AreEqual "Http" $vProbe.Protocol;
        Assert-AreEqual 2424 $vProbe.Port;
        Assert-AreEqual "/create" $vProbe.RequestPath;

        $vProbe = Get-AzureRMLoadBalancerProbeConfig -LoadBalancer $vLoadBalancer -Name $rname
        Assert-AreEqual "Http" $vProbe.Protocol;
        Assert-AreEqual 2424 $vProbe.Port;
        Assert-AreEqual "/create" $vProbe.RequestPath;


        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
        Remove-AzureRMLoadBalancerProbeConfig -LoadBalancer $vLoadBalancer -Name $vProbe.Name
        Set-AzureRMLoadBalancer -LoadBalancer $vLoadBalancer
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}
