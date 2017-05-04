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
using Microsoft.Azure.Management.Network.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;

namespace Microsoft.Azure.Commands.Network.Automation
{
    [Cmdlet("Add", "AzureRmNetworkSecurityRuleConfig", SupportsShouldProcess = true)]
    [OutputType(typeof(NetworkSecurityGroup))]
    public class AddAzureRmNetworkSecurityRuleCommand : NetworkBaseCmdlet
    {
        [Parameter(
            Mandatory = true,
            Position = 0,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public PSNetworkSecurityGroup NetworkSecurityGroup { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 2,
            ValueFromPipelineByPropertyName = true)]
        public string Description { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 3,
            ValueFromPipelineByPropertyName = true)]
        public string Protocol { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 4,
            ValueFromPipelineByPropertyName = true)]
        public string SourcePortRange { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 5,
            ValueFromPipelineByPropertyName = true)]
        public string DestinationPortRange { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 6,
            ValueFromPipelineByPropertyName = true)]
        public string SourceAddressPrefix { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 7,
            ValueFromPipelineByPropertyName = true)]
        public string DestinationAddressPrefix { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 8,
            ValueFromPipelineByPropertyName = true)]
        public string Access { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 9,
            ValueFromPipelineByPropertyName = true)]
        public int? Priority { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 10,
            ValueFromPipelineByPropertyName = true)]
        public string Direction { get; set; }

        [Parameter(
            Mandatory = false,
            Position = 1,
            ValueFromPipelineByPropertyName = true)]
        public string Name { get; set; }

        public override void Execute()
        {

            // SecurityRules
            if (this.NetworkSecurityGroup.SecurityRules == null)
            {
                this.NetworkSecurityGroup.SecurityRules = new List<PSSecurityRule>();
            }

            var vSecurityRules = new PSSecurityRule();

            vSecurityRules.Description = this.Description;
            vSecurityRules.Protocol = this.Protocol;
            vSecurityRules.SourcePortRange = this.SourcePortRange;
            vSecurityRules.DestinationPortRange = this.DestinationPortRange;
            vSecurityRules.SourceAddressPrefix = this.SourceAddressPrefix;
            vSecurityRules.DestinationAddressPrefix = this.DestinationAddressPrefix;
            vSecurityRules.Access = this.Access;
            vSecurityRules.Priority = this.Priority.Value;
            vSecurityRules.Direction = this.Direction;
            vSecurityRules.Name = this.Name;
            this.NetworkSecurityGroup.SecurityRules.Add(vSecurityRules);
            WriteObject(this.NetworkSecurityGroup);
        }
    }
}

