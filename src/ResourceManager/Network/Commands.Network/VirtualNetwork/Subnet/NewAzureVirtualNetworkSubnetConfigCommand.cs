﻿// 
// Copyright (c) Microsoft and contributors.  All rights reserved.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 
// See the License for the specific language governing permissions and
// limitations under the License.
// 

// Warning: This code was generated by a tool.
// 
// Changes to this file may cause incorrect behavior and will be lost if the
// code is regenerated.

using Microsoft.Azure.Commands.Network.Models;
using Microsoft.Azure.Management.Network;
using Microsoft.Azure.Management.Network.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using AutoMapper;
using MNM = Microsoft.Azure.Management.Network.Models;
using NMN = Microsoft.Azure.Commands.Network.Models;

namespace Microsoft.Azure.Commands.Network.Automation
{


    [Cmdlet(VerbsCommon.New, "AzureRmVirtualNetworkSubnetConfig", DefaultParameterSetName = "InvokeByDynamicParameters", SupportsShouldProcess = true)]
    public partial class NewAzureRmVirtualNetworkSubnetConfig : NetworkBaseCmdlet
    {
        [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string Name { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public string AddressPrefix { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 1,
            ParameterSetName = "SetByResourceId",
            ValueFromPipelineByPropertyName = true)]
        public string NetworkSecurityGroupId { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 1,
            ParameterSetName = "SetByResource",
            ValueFromPipelineByPropertyName = true)]
        public PSNetworkSecurityGroup NetworkSecurityGroup { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 1,
            ParameterSetName = "SetByResourceId",
            ValueFromPipelineByPropertyName = true)]
        public string RouteTableId { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 1,
            ParameterSetName = "SetByResource",
            ValueFromPipelineByPropertyName = true)]
        public PSRouteTable RouteTable { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "Do not ask for confirmation if you want to overwrite a resource")]
        public SwitchParameter Force { get; set; }


        public override void Execute()
        {
            base.Execute();
            //            var present = this.IsRouteTablePresent(this.ResourceGroupName, this.Name);


            // NetworkSecurityGroup
            PSNetworkSecurityGroup vNetworkSecurityGroup = null;

            // RouteTable
            PSRouteTable vRouteTable = null;


            if (string.Equals(ParameterSetName, Microsoft.Azure.Commands.Network.Properties.Resources.SetByResource))
            {
                if (this.NetworkSecurityGroup != null)
                {
                    this.NetworkSecurityGroupId = this.NetworkSecurityGroup.Id;
                }
                if (this.RouteTable != null)
                {
                    this.RouteTableId = this.RouteTable.Id;
                }
            }

            if (this.NetworkSecurityGroupId != null)
            {
                if (vNetworkSecurityGroup == null)
                {
                    vNetworkSecurityGroup = new PSNetworkSecurityGroup();
                }
                vNetworkSecurityGroup.Id = this.NetworkSecurityGroupId;
            }

            if (this.RouteTableId != null)
            {
                if (vRouteTable == null)
                {
                    vRouteTable = new PSRouteTable();
                }
                vRouteTable.Id = this.RouteTableId;
            }


            var vSubnet = new PSSubnet
            {
                AddressPrefix = this.AddressPrefix,
                NetworkSecurityGroup = vNetworkSecurityGroup,
                RouteTable = vRouteTable,
            };
            vSubnet.Name = this.Name;
            WriteObject(vSubnet);

        }
    }
}
