// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Microsoft.Azure.Commands.ServiceBus.Models
{
    using Newtonsoft.Json;
    using Microsoft.Azure.Management.ServiceBus.Models;
    using System.Linq;
    using System.Collections.Generic;

    /// <summary>
    /// Description of NetWorkRuleSet - IpRules resource.
    /// </summary>
    public class PSNWRuleSetIpRulesAttributes
    {
        /// <summary>
        /// Initializes a new instance of the NWRuleSetIpRules class.
        /// </summary>
        public PSNWRuleSetIpRulesAttributes()
        {

        }

        public static IList<PSNWRuleSetIpRulesAttributes> PSNWRuleSetIpRulesAttributesCollection(IList<NWRuleSetIpRules> nwiprulescol)
        {
            List<PSNWRuleSetIpRulesAttributes> nwiprulesAttributescol = new List<PSNWRuleSetIpRulesAttributes>();

            foreach (NWRuleSetIpRules nwiprules in nwiprulescol)
            {
                nwiprulesAttributescol.Add(new PSNWRuleSetIpRulesAttributes(nwiprules));
            }

            return nwiprulesAttributescol;
        }

        /// <summary>
        /// Initializes a new instance of the NWRuleSetIpRules class.
        /// </summary>
        /// <param name="ipMask">IP Mask</param>
        /// <param name="action">The IP Filter Action. Possible values include:
        /// 'Allow'</param>
        public PSNWRuleSetIpRulesAttributes(NWRuleSetIpRules nwiprules)
        {
            IpMask = nwiprules.IpMask;
            Action = nwiprules.Action;
        }

        /// <summary>
        /// Gets or sets IP Mask
        /// </summary>
        public string IpMask { get; set; }

        /// <summary>
        /// Gets or sets the IP Filter Action. Possible values include: 'Allow'
        /// </summary>        
        public string Action { get; set; }

    }
}
