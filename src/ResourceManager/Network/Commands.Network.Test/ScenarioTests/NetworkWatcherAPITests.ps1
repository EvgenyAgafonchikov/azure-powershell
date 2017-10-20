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
Deployment of resources: VM, storage account, network interface, nsg, virtual network and route table.
#>
$envContents = {};
function Get-TestResourcesDeployment($virtualMachineName, $storageAccountName, $routeTableName, $virtualNetworkName, $networkInterfaceName,
                                     $networkSecurityGroupName, $storageAccountType, $rgName, $location, $publicIpAddressName, $vpnGatewayName)
{
        $templateFile = "..\..\TestData\Deployment.json"
        $paramFile = "..\..\TestData\DeploymentParameters.json"
        $diagnosticsStorageAccountName = ((Get-ResourceName) + "diagacc");
        $envContents = @{};

		$paramContent =
@"
{
			"rgName": {
			"value": "$rgName"
			},
			"location": {
			"value": "$location"
			},
			"virtualMachineName": {
			"value": "$virtualMachineName"
			},
			"virtualMachineSize": {
			"value": "Standard_DS1_v2"
			},
			"adminUsername": {
			"value": "netanaytics12"
			},
			"storageAccountName": {
			"value": "$storageAccountName"
			},
			"routeTableName": {
			"value": "$routeTableName"
			},
			"virtualNetworkName": {
			"value": "$virtualNetworkName"
			},
			"networkInterfaceName": {
			"value": "$networkInterfaceName"
			},
			"networkSecurityGroupName": {
			"value": "$networkSecurityGroupName"
			},
			"adminPassword": {
			"value": "netanalytics-32${resourceGroupName}"
			},
			"storageAccountType": {
			"value": "Premium_LRS"
			},
			"diagnosticsStorageAccountName": {
			"value": "$diagnosticsStorageAccountName"
			},
			"diagnosticsStorageAccountId": {
			"value": "Microsoft.Storage/storageAccounts/${diagnosticsStorageAccountName}"
			},
			"diagnosticsStorageAccountType": {
			"value": "Standard_LRS"
			},
			"addressPrefix": {
			"value": "10.17.3.0/24"
			},
			"subnetName": {
			"value": "default"
			},
			"subnetPrefix": {
			"value": "10.17.3.0/24"
			},
			"publicIpAddressName": {
			"value": "${virtualMachineName}-ip"
			},
			"publicIpAddressType": {
			"value": "Dynamic"
			}
}
"@;

        $st = Set-Content -Path $paramFile -Value $paramContent -Force;

        $newStorageName = Get-ResourceName;
        $containerName = Get-ResourceName;
        New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $newStorageName -Location $location -Type Standard_GRS;
        $keysResult = Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -Name $newStorageName;
        $context = New-AzureStorageContext -StorageAccountName $newStorageName -StorageAccountKey $keysResult.Keys[0].Value;
        New-AzureStorageContainer -Name $containerName -Context $context;
        $container = Get-AzureStorageContainer -Name $containerName -Context $context;

        AzureRm.Resources\New-AzureRmResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile "$templateFile" -TemplateParameterFile $paramFile

        if($vpnGatewayName)
        {
            $vpnVnetName = Get-ResourceName;
            $vpnIpName = Get-ResourceName;
            $vpnCfg = Get-ResourceName;

            $subnet = New-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet -AddressPrefix 10.0.1.0/24;
            $vnet = New-AzureRmVirtualNetwork -Name $vpnVnetName -ResourceGroupName $rgName `
                    -AddressPrefix 10.0.0.0/8 -Location $location -Subnet $subnet;
            $publicIp = New-AzureRMPublicIpAddress -Name $vpnIpName -ResourceGroupName $rgName -Location $location `
            -AllocationMethod Dynamic;

            $ipConfig = New-AzureRmVirtualNetworkGatewayIpConfig -Name $vpnCfg -SubnetId $vnet.Subnets[0].Id `
                        -PublicIpAddressId $publicIp.Id;

            $vpn = New-AzureRmVirtualNetworkGateway -ResourceGroupName $rgname -Name $vpnGatewayName -Location $location `
            -IpConfigurations $ipConfig -VpnType RouteBased;
            $envContents.vpnGatewayId = $vpn.Id;
        }

        $vm = Get-AzureRmVM -ResourceGroupName $rgName;
        $envContents.virtualMachineId = $vm.Id;
        Set-AzureRmVMExtension -ResourceGroupName "$rgName" -Location "$location" -VMName $vm.Name -Name "MyNetworkWatcherAgent" -Type "NetworkWatcherAgentWindows" -TypeHandlerVersion "1.4" -Publisher "Microsoft.Azure.NetworkWatcher" 

        $envContents.targetResourceGroupName = $rgName;
        $nic = Get-AzureRmNetworkInterface -ResourceGroupName $rgName;
        $envContents.networkInterfaceId = $nic.Id;
        $envContents.LocalIpAddress = $nic.IpConfigurations[0].PrivateIpAddress;
        $envContents.networkSecurityGroupId = (Get-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName).Id;
        $envContents.storageId = (Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $newStorageName).Id
        $envContents.storagePath = $container.CloudBlobContainer.StorageUri.PrimaryUri.AbsoluteUri; #"https://${storageAccountName}.blob.core.windows.net/${containerName}"

        return $envContents;
}

<#
.SYNOPSIS
Test GetTopology NetworkWatcher API.
#>
function Test-GetTopology
{
    # Setup
    $rname = Get-ResourceName;
    $virtualMachineName = Get-ResourceName;
    $storageAccountName = Get-ResourceName;
    $routeTableName = Get-ResourceName;
    $virtualNetworkName = Get-ResourceName;
    $networkInterfaceName = Get-ResourceName;
    $networkSecurityGroupName = Get-ResourceName;
    $rgName = Get-ResourceGroupName;
    $location = "westcentralus";
    $publicIpAddressName = Get-ResourceName;

    try
    {
        New-AzureRmResourceGroup -Name $rgname -Location $location;
        $env = Get-TestResourcesDeployment -virtualMachineName $virtualMachineName `
                                    -storageAccountName $storageAccountName `
                                    -routeTableName $routeTableName `
                                    -virtualNetworkName $virtualNetworkName `
                                    -networkInterfaceName $networkInterfaceName `
                                    -networkSecurityGroupName $networkSecurityGroupName `
                                    -storageAccountType $storageAccountType `
                                    -rgName $rgName `
                                    -location $location `
                                    -publicIpAddressName $publicIpAddressName;
        $NetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Location $location -Name $rname;


        $vTopology = Get-AzureRMNetworkWatcherTopology -ResourceGroupName $rgname -Name $rname -TargetResourceGroupName $env.TargetResourceGroupName;
        Assert-NotNull $vTopology;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}


<#
.SYNOPSIS
Test GetSecurityGroupView NetworkWatcher API.
#>
function Test-GetVMSecurityRule
{
    # Setup
    $rname = Get-ResourceName;
    $virtualMachineName = Get-ResourceName;
    $storageAccountName = Get-ResourceName;
    $routeTableName = Get-ResourceName;
    $virtualNetworkName = Get-ResourceName;
    $networkInterfaceName = Get-ResourceName;
    $networkSecurityGroupName = Get-ResourceName;
    $rgName = Get-ResourceGroupName;
    $location = "westcentralus";
    $publicIpAddressName = Get-ResourceName;

    try
    {
        New-AzureRmResourceGroup -Name $rgname -Location $location;
        $env = Get-TestResourcesDeployment -virtualMachineName $virtualMachineName `
                                    -storageAccountName $storageAccountName `
                                    -routeTableName $routeTableName `
                                    -virtualNetworkName $virtualNetworkName `
                                    -networkInterfaceName $networkInterfaceName `
                                    -networkSecurityGroupName $networkSecurityGroupName `
                                    -storageAccountType $storageAccountType `
                                    -rgName $rgName `
                                    -location $location `
                                    -publicIpAddressName $publicIpAddressName;
        $NetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Location $location -Name $rname;


        $vVMSecurityRules = Get-AzureRmNetworkWatcherSecurityGroupView -ResourceGroupName $rgname -Name $rname -TargetVirtualMachineId $env.virtualMachineId;
        Assert-NotNull $vVMSecurityRules;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

<#
.SYNOPSIS
Test GetNextHop NetworkWatcher API.
#>
function Test-GetNextHop
{
    # Setup
    $rname = Get-ResourceName;
    $virtualMachineName = Get-ResourceName;
    $storageAccountName = Get-ResourceName;
    $routeTableName = Get-ResourceName;
    $virtualNetworkName = Get-ResourceName;
    $networkInterfaceName = Get-ResourceName;
    $networkSecurityGroupName = Get-ResourceName;
    $rgName = Get-ResourceGroupName;
    $location = "westcentralus";
    $publicIpAddressName = Get-ResourceName;

    try
    {
        New-AzureRmResourceGroup -Name $rgname -Location $location;
        $env = Get-TestResourcesDeployment -virtualMachineName $virtualMachineName `
                                    -storageAccountName $storageAccountName `
                                    -routeTableName $routeTableName `
                                    -virtualNetworkName $virtualNetworkName `
                                    -networkInterfaceName $networkInterfaceName `
                                    -networkSecurityGroupName $networkSecurityGroupName `
                                    -storageAccountType $storageAccountType `
                                    -rgName $rgName `
                                    -location $location `
                                    -publicIpAddressName $publicIpAddressName;
        $NetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Location $location -Name $rname;


        $vNextHop = Get-AzureRMNetworkWatcherNextHop -ResourceGroupName $rgname -Name $rname -TargetVirtualMachineId $env.virtualMachineId -SourceIPAddress 10.0.0.4 -DestinationIPAddress 192.168.10.11 -TargetNetworkInterfaceId $env.networkInterfaceId;
        Assert-NotNull $vNextHop;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

<#
.SYNOPSIS
Test VerifyIPFlow NetworkWatcher API.
#>
function Test-VerifyIPFlow
{
    # Setup
    $rname = Get-ResourceName;
    $virtualMachineName = Get-ResourceName;
    $storageAccountName = Get-ResourceName;
    $routeTableName = Get-ResourceName;
    $virtualNetworkName = Get-ResourceName;
    $networkInterfaceName = Get-ResourceName;
    $networkSecurityGroupName = Get-ResourceName;
    $rgName = Get-ResourceGroupName;
    $location = "westcentralus";
    $publicIpAddressName = Get-ResourceName;

    try
    {
        New-AzureRmResourceGroup -Name $rgname -Location $location;
        $env = Get-TestResourcesDeployment -virtualMachineName $virtualMachineName `
                                    -storageAccountName $storageAccountName `
                                    -routeTableName $routeTableName `
                                    -virtualNetworkName $virtualNetworkName `
                                    -networkInterfaceName $networkInterfaceName `
                                    -networkSecurityGroupName $networkSecurityGroupName `
                                    -storageAccountType $storageAccountType `
                                    -rgName $rgName `
                                    -location $location `
                                    -publicIpAddressName $publicIpAddressName;
        $NetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Location $location -Name $rname;


        $vIPFlow = Test-AzureRMNetworkWatcherIPFlow -ResourceGroupName $rgname -Name $rname -TargetVirtualMachineId $env.virtualMachineId -Direction Inbound -Protocol TCP -LocalPort 80 -RemotePort 80 -LocalIPAddress $env.localIPAddress -RemoteIPAddress 10.0.0.13 -TargetNetworkInterfaceId $env.networkInterfaceId;
        Assert-NotNull $vIPFlow;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

<#
.SYNOPSIS
Test PacketCapture API.
#>
function Test-PacketCapture
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    $nwName = Get-ResourceName
    $location = "westcentralus"
    $resourceTypeParent = "Microsoft.Network/networkWatchers"
    $nwLocation = Get-ProviderLocation $resourceTypeParent
    $nwRgName = Get-ResourceGroupName
    $securityGroupName = Get-ResourceName
    $templateFile = "..\..\TestData\Deployment.json"
    $pcName1 = Get-ResourceName
    $pcName2 = Get-ResourceName
    
    try 
    {
        # Create Resource group
        New-AzureRmResourceGroup -Name $resourceGroupName -Location "$location"

        # Deploy resources
        Get-TestResourcesDeployment -rgn "$resourceGroupName"
        
        # Create Resource group for Network Watcher
        New-AzureRmResourceGroup -Name $nwRgName -Location "$location"
        
        # Create Network Watcher
        $nw = New-AzureRmNetworkWatcher -Name $nwName -ResourceGroupName $nwRgName -Location $location

        #Get Vm
        $vm = Get-AzureRmVM -ResourceGroupName $resourceGroupName
        
        #Install networkWatcherAgent on Vm
        Set-AzureRmVMExtension -ResourceGroupName "$resourceGroupName" -Location "$location" -VMName $vm.Name -Name "MyNetworkWatcherAgent" -Type "NetworkWatcherAgentWindows" -TypeHandlerVersion "1.4" -Publisher "Microsoft.Azure.NetworkWatcher" 

        #Create filters for packet capture
        $f1 = New-AzureRmPacketCaptureFilterConfig -Protocol Tcp -RemoteIPAddress 127.0.0.1-127.0.0.255 -LocalPort 80 -RemotePort 80-120
        $f2 = New-AzureRmPacketCaptureFilterConfig -LocalIPAddress 127.0.0.1;127.0.0.5

        #Create packet capture
        New-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw -PacketCaptureName $pcName1 -TargetVirtualMachineId $vm.Id -LocalFilePath C:\tmp\Capture.cap -Filter $f1, $f2
        New-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw -PacketCaptureName $pcName2 -TargetVirtualMachineId $vm.Id -LocalFilePath C:\tmp\Capture.cap -TimeLimitInSeconds 1
        Start-Sleep -s 2

        #Get packet capture
        $pc1 = Get-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw -PacketCaptureName $pcName1
        $pc2 = Get-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw -PacketCaptureName $pcName2
        $pcList = Get-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw

        #Verification
        Assert-AreEqual $pc1.Name $pcName1
        Assert-AreEqual "Succeeded" $pc1.ProvisioningState
        Assert-AreEqual $pc1.TotalBytesPerSession 1073741824
        Assert-AreEqual $pc1.BytesToCapturePerPacket 0
        Assert-AreEqual $pc1.TimeLimitInSeconds 18000
        Assert-AreEqual $pc1.Filters[0].LocalPort 80
        Assert-AreEqual $pc1.Filters[0].Protocol TCP
        Assert-AreEqual $pc1.Filters[0].RemoteIPAddress 127.0.0.1-127.0.0.255
        Assert-AreEqual $pc1.Filters[1].LocalIPAddress 127.0.0.1;127.0.0.5
        Assert-AreEqual $pc1.StorageLocation.FilePath C:\tmp\Capture.cap
        Assert-AreEqual $pcList.Count 2

        #Stop packet capture
        Stop-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw -PacketCaptureName $pcName1

        #Get packet capture
        $pc1 = Get-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw -PacketCaptureName $pcName1

        #Remove packet capture
        Remove-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw -PacketCaptureName $pcName1

        #List packet captures
        $pcList = Get-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw
        Assert-AreEqual $pcList.Count 1

        #Remove packet capture
        Remove-AzureRmNetworkWatcherPacketCapture -NetworkWatcher $nw -PacketCaptureName $pcName2

    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $resourceGroupName
        Clean-ResourceGroup $nwRgName
    }
}

<#
.SYNOPSIS
Test Troubleshoot API.
#>
function Test-GetTroubleshooting
{
    # Setup
    $rname = Get-ResourceName;
    $virtualMachineName = Get-ResourceName;
    $storageAccountName = Get-ResourceName;
    $routeTableName = Get-ResourceName;
    $virtualNetworkName = Get-ResourceName;
    $networkInterfaceName = Get-ResourceName;
    $networkSecurityGroupName = Get-ResourceName;
    $rgName = Get-ResourceGroupName;
    $location = "westcentralus";
    $publicIpAddressName = Get-ResourceName;
    $vpnGatewayName = Get-ResourceName;

    try
    {
        New-AzureRmResourceGroup -Name $rgname -Location $location;
        $env = Get-TestResourcesDeployment -virtualMachineName $virtualMachineName `
                                    -storageAccountName $storageAccountName `
                                    -routeTableName $routeTableName `
                                    -virtualNetworkName $virtualNetworkName `
                                    -networkInterfaceName $networkInterfaceName `
                                    -networkSecurityGroupName $networkSecurityGroupName `
                                    -storageAccountType $storageAccountType `
                                    -rgName $rgName `
                                    -location $location `
                                    -publicIpAddressName $publicIpAddressName `
                                    -vpnGatewayName $vpnGatewayName;
        $NetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Location $location -Name $rname;


        $vResourceTroubleshooting = Start-AzureRMNetworkWatcherResourceTroubleshooting -ResourceGroupName $rgname -Name $rname -TargetResourceId $env.vpnGatewayId -StorageId $env.storageId -StoragePath $env.storagePath;
        Assert-NotNull $vResourceTroubleshooting;
        $vTroubleshootingResult = Get-AzureRMNetworkWatcherTroubleshootingResult -ResourceGroupName $rgname -Name $rname -TargetResourceId $env.vpnGatewayId;
        Assert-NotNull $vTroubleshootingResult;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}



<#
.SYNOPSIS
Test Flow log API.
#>
function Test-SetFlowLogConfiguration
{
    # Setup
    $rname = Get-ResourceName;
    $virtualMachineName = Get-ResourceName;
    $storageAccountName = Get-ResourceName;
    $routeTableName = Get-ResourceName;
    $virtualNetworkName = Get-ResourceName;
    $networkInterfaceName = Get-ResourceName;
    $networkSecurityGroupName = Get-ResourceName;
    $rgName = Get-ResourceGroupName;
    $location = "westcentralus";
    $publicIpAddressName = Get-ResourceName;

    try
    {
        New-AzureRmResourceGroup -Name $rgname -Location $location;
        $env = Get-TestResourcesDeployment -virtualMachineName $virtualMachineName `
                                    -storageAccountName $storageAccountName `
                                    -routeTableName $routeTableName `
                                    -virtualNetworkName $virtualNetworkName `
                                    -networkInterfaceName $networkInterfaceName `
                                    -networkSecurityGroupName $networkSecurityGroupName `
                                    -storageAccountType $storageAccountType `
                                    -rgName $rgName `
                                    -location $location `
                                    -publicIpAddressName $publicIpAddressName;
        $NetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Location $location -Name $rname;


        $vSetFlowLogConfiguration = Set-AzureRmNetworkWatcherConfigFlowLog -ResourceGroupName $rgname -Name $rname -TargetResourceId $env.networkSecurityGroupId -EnableFlowLog $true -StorageAccountId $env.storageId -EnableRetention $true -RetentionInDays 123;
        Assert-NotNull $vSetFlowLogConfiguration;
        $vFlowLogStatus = Get-AzureRMNetworkWatcherFlowLogStatus -ResourceGroupName $rgname -Name $rname -TargetResourceId $env.networkSecurityGroupId;
        Assert-NotNull $vFlowLogStatus;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}

<#
.SYNOPSIS
Test ConnectivityCheck NetworkWatcher API.
#>
function Test-CheckConnectivity
{
    # Setup
    $rname = Get-ResourceName;
    $virtualMachineName = Get-ResourceName;
    $storageAccountName = Get-ResourceName;
    $routeTableName = Get-ResourceName;
    $virtualNetworkName = Get-ResourceName;
    $networkInterfaceName = Get-ResourceName;
    $networkSecurityGroupName = Get-ResourceName;
    $rgName = Get-ResourceGroupName;
    $location = "westcentralus";
    $publicIpAddressName = Get-ResourceName;

    try
    {
        New-AzureRmResourceGroup -Name $rgname -Location $location;
        $env = Get-TestResourcesDeployment -virtualMachineName $virtualMachineName `
                                    -storageAccountName $storageAccountName `
                                    -routeTableName $routeTableName `
                                    -virtualNetworkName $virtualNetworkName `
                                    -networkInterfaceName $networkInterfaceName `
                                    -networkSecurityGroupName $networkSecurityGroupName `
                                    -storageAccountType $storageAccountType `
                                    -rgName $rgName `
                                    -location $location `
                                    -publicIpAddressName $publicIpAddressName;
        $NetworkWatcher = New-AzureRMNetworkWatcher -ResourceGroupName $rgname -Location $location -Name $rname;


        $vCheckConnectivity = Test-AzureRmNetworkWatcherConnectivity -ResourceGroupName $rgname -Name $rname -SourceId $env.virtualMachineId -DestinationAddress bing.com -DestinationPort 80;
        Assert-NotNull $vCheckConnectivity;
    }
    finally
    {
        # Cleanup
        Clean-ResourceGroup $rgname
    }
}




