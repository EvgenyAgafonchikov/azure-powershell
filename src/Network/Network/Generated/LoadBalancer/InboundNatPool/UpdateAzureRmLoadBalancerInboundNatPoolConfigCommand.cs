// <auto-generated>
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
// 
// Warning: This code was generated by a tool.
// 
// Changes to this file may cause incorrect behavior and will be lost if the
// code is regenerated.
// 
// For documentation on code generator please visit
//   https://aka.ms/nrp-code-generation
// Please contact wanrpdev@microsoft.com if you need to make changes to this file.
// </auto-generated>

using AutoMapper;
using CNM = Microsoft.Azure.Commands.Network.Models;
using Microsoft.Azure.Commands.Network.Models;
using Microsoft.Azure.Commands.ResourceManager.Common.ArgumentCompleters;
using Microsoft.Azure.Commands.ResourceManager.Common.Tags;
using Microsoft.Azure.Management.Network;
using Microsoft.Azure.Management.Network.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;

namespace Microsoft.Azure.Commands.Network
{
    [Cmdlet(VerbsData.Update, ResourceManager.Common.AzureRMConstants.AzureRMPrefix + "LoadBalancerInboundNatPoolConfig", DefaultParameterSetName = "SetByResourceParent", SupportsShouldProcess = true), OutputType(typeof(PSLoadBalancer))]
    public partial class UpdateAzureRmLoadBalancerInboundNatPoolConfigCommand : NetworkBaseCmdlet
    {
        [Parameter(
            Mandatory = true,
            HelpMessage = "The reference of the load balancer resource.",
            ParameterSetName = "SetByResourceIdParent",
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            Mandatory = true,
            HelpMessage = "The reference of the load balancer resource.",
            ParameterSetName = "SetByResourceParent",
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public PSLoadBalancer LoadBalancer { get; set; }

        [Parameter(
            Mandatory = true,
            HelpMessage = "The reference of the load balancer resource.",
            ParameterSetName = "SetByResourceIdParentName",
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            Mandatory = true,
            HelpMessage = "Resource group name",
            ParameterSetName = "SetByResourceParentName",
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public string ResourceGroupName { get; set; }

        [Parameter(
            Mandatory = true,
            HelpMessage = "The reference of the load balancer resource.",
            ParameterSetName = "SetByResourceIdParentName",
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [Parameter(
            Mandatory = true,
            HelpMessage = "Load Balancer name",
            ParameterSetName = "SetByResourceParentName",
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public string LoadBalancerName { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "Name of the inbound nat pool.")]
        public string Name { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "The transport protocol for the endpoint.",
            ValueFromPipelineByPropertyName = true)]
        [PSArgumentCompleter(
            "Udp",
            "Tcp",
            "All"
        )]
        public string Protocol { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "The first port number in the range of external ports that will be used to provide Inbound Nat to NICs associated with a load balancer. Acceptable values range between 1 and 65534.",
            ValueFromPipelineByPropertyName = true)]
        public int FrontendPortRangeStart { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "The last port number in the range of external ports that will be used to provide Inbound Nat to NICs associated with a load balancer. Acceptable values range between 1 and 65535.",
            ValueFromPipelineByPropertyName = true)]
        public int FrontendPortRangeEnd { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "The port used for internal connections on the endpoint. Acceptable values are between 1 and 65535.",
            ValueFromPipelineByPropertyName = true)]
        public int BackendPort { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "The timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to TCP.",
            ValueFromPipelineByPropertyName = true)]
        public int IdleTimeoutInMinutes { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint.")]
        public SwitchParameter EnableFloatingIP { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.")]
        public SwitchParameter EnableTcpReset { get; set; }

        [Parameter(
            Mandatory = false,
            ParameterSetName = "SetByResourceId",
            HelpMessage = "A reference to frontend IP addresses.",
            ValueFromPipelineByPropertyName = true)]
        public string FrontendIpConfigurationId { get; set; }

        [Parameter(
            Mandatory = false,
            ParameterSetName = "SetByResource",
            HelpMessage = "A reference to frontend IP addresses.",
            ValueFromPipelineByPropertyName = true)]
        public PSFrontendIPConfiguration FrontendIpConfiguration { get; set; }


        public override void Execute()
        {
            if(string.Equals(ParameterSetName, "SetByResourceParentName") ||
               string.Equals(ParameterSetName, "SetByResourceIdParentName"))
            {
                LoadBalancer vLoadBalancer;
                try
                {
                    vLoadBalancer = this.NetworkClient.NetworkManagementClient.LoadBalancers.Get(ResourceGroupName, LoadBalancerName);
                }
                catch (Microsoft.Rest.Azure.CloudException exception)
                {
                    throw exception;
                }
                this.LoadBalancer = NetworkResourceManagerProfile.Mapper.Map<CNM.PSLoadBalancer>(vLoadBalancer);
                this.LoadBalancer.ResourceGroupName = NetworkBaseCmdlet.GetResourceGroup(vLoadBalancer.Id);
                this.LoadBalancer.Tag = TagsConversionHelper.CreateTagHashtable(vLoadBalancer.Tags);
            }

            var vInboundNatPoolsIndex = this.LoadBalancer.InboundNatPools.IndexOf(
                this.LoadBalancer.InboundNatPools.SingleOrDefault(
                    resource => string.Equals(resource.Name, this.Name, System.StringComparison.CurrentCultureIgnoreCase)));
            if (vInboundNatPoolsIndex == -1)
            {
                throw new ArgumentException("InboundNatPools with the specified name does not exist");
            }

            if (string.Equals(ParameterSetName, "SetByResourceParent") ||
                string.Equals(ParameterSetName, "SetByResourceParentName"))
            {
                if (this.FrontendIpConfiguration != null)
                {
                    this.FrontendIpConfigurationId = this.FrontendIpConfiguration.Id;
                }
            }
            var vInboundNatPools = LoadBalancer.InboundNatPools[vInboundNatPoolsIndex];

            if(!string.IsNullOrEmpty(this.Protocol))
            {
                vInboundNatPools.Protocol = this.Protocol;
            }
            if(MyInvocation.BoundParameters.ContainsKey(nameof(this.FrontendPortRangeStart)))
            {
                vInboundNatPools.FrontendPortRangeStart = this.FrontendPortRangeStart;
            }
            if(MyInvocation.BoundParameters.ContainsKey(nameof(this.FrontendPortRangeEnd)))
            {
                vInboundNatPools.FrontendPortRangeEnd = this.FrontendPortRangeEnd;
            }
            if(MyInvocation.BoundParameters.ContainsKey(nameof(this.BackendPort)))
            {
                vInboundNatPools.BackendPort = this.BackendPort;
            }
            if(MyInvocation.BoundParameters.ContainsKey(nameof(this.IdleTimeoutInMinutes)))
            {
                vInboundNatPools.IdleTimeoutInMinutes = this.MyInvocation.BoundParameters.ContainsKey("IdleTimeoutInMinutes") ? this.IdleTimeoutInMinutes : 4;
            }
            if(MyInvocation.BoundParameters.ContainsKey(nameof(this.EnableFloatingIP)))
            {
                vInboundNatPools.EnableFloatingIP = this.EnableFloatingIP;
            }
            if(MyInvocation.BoundParameters.ContainsKey(nameof(this.EnableTcpReset)))
            {
                vInboundNatPools.EnableTcpReset = this.EnableTcpReset;
            }
            if(!string.IsNullOrEmpty(this.Name))
            {
                vInboundNatPools.Name = this.Name;
            }

            if(!string.IsNullOrEmpty(this.FrontendIpConfigurationId))
            {
                // FrontendIPConfiguration
                if (vInboundNatPools.FrontendIPConfiguration == null)
                {
                    vInboundNatPools.FrontendIPConfiguration = new PSResourceId();
                }
                vInboundNatPools.FrontendIPConfiguration.Id = this.FrontendIpConfigurationId;
            }
            WriteObject(this.LoadBalancer, true);
        }
    }
}
