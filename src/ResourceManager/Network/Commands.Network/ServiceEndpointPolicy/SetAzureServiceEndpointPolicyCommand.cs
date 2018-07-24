﻿// ----------------------------------------------------------------------------------
//
// Copyright Microsoft Corporation
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------

namespace Microsoft.Azure.Commands.Network.VirtualNetwork.ServiceEndpointPolicies
{
    using Microsoft.Azure.Commands.Network.Models;
    using System;
    using System.Management.Automation;
    using MNM = Microsoft.Azure.Management.Network.Models;

    [Cmdlet(VerbsCommon.Set, "AzureRmPublicIpAddress"), OutputType(typeof(PSPublicIpAddress))]
    class SetAzureServiceEndpointPolicyCommand : ServiceEndpointPolicyBaseCmdlet
    {
        [Parameter(
            Mandatory = true,
            ValueFromPipeline = true,
            HelpMessage = "The PublicIpAddress")]
        public PSServiceEndpointPolicy ServiceEndpointPolicy { get; set; }

        public override void Execute()
        {
            base.Execute();
            if (!this.IsServiceEndpointPolicyPresent(this.ServiceEndpointPolicy.ResourceGroupName, this.ServiceEndpointPolicy.Name))
            {
                throw new ArgumentException(Microsoft.Azure.Commands.Network.Properties.Resources.ResourceNotFound);
            }

            // Map to the sdk object
            var serviceEndpointPolicyModel = NetworkResourceManagerProfile.Mapper.Map<MNM.ServiceEndpointPolicy>(this.ServiceEndpointPolicy);

            this.ServiceEndpointPolicyClient.CreateOrUpdateWithHttpMessagesAsync(this.ServiceEndpointPolicy.ResourceGroupName, this.ServiceEndpointPolicy.Name, serviceEndpointPolicyModel);

            var getServiceEndpointPolicy = this.GetServiceEndpointPolicy(this.ServiceEndpointPolicy.ResourceGroupName, this.ServiceEndpointPolicy.Name);

            WriteObject(getServiceEndpointPolicy);
        }
    }
}
