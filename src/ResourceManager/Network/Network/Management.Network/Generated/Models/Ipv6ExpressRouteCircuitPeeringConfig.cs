// <auto-generated>
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Microsoft.Azure.Management.Network.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Contains IPv6 peering config.
    /// </summary>
    public partial class Ipv6ExpressRouteCircuitPeeringConfig
    {
        /// <summary>
        /// Initializes a new instance of the
        /// Ipv6ExpressRouteCircuitPeeringConfig class.
        /// </summary>
        public Ipv6ExpressRouteCircuitPeeringConfig()
        {
            CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// Ipv6ExpressRouteCircuitPeeringConfig class.
        /// </summary>
        /// <param name="primaryPeerAddressPrefix">The primary address
        /// prefix.</param>
        /// <param name="secondaryPeerAddressPrefix">The secondary address
        /// prefix.</param>
        /// <param name="microsoftPeeringConfig">The Microsoft peering
        /// configuration.</param>
        /// <param name="routeFilter">The reference of the RouteFilter
        /// resource.</param>
        /// <param name="state">The state of peering. Possible values are:
        /// 'Disabled' and 'Enabled'. Possible values include: 'Disabled',
        /// 'Enabled'</param>
        public Ipv6ExpressRouteCircuitPeeringConfig(string primaryPeerAddressPrefix = default(string), string secondaryPeerAddressPrefix = default(string), ExpressRouteCircuitPeeringConfig microsoftPeeringConfig = default(ExpressRouteCircuitPeeringConfig), RouteFilter routeFilter = default(RouteFilter), string state = default(string))
        {
            PrimaryPeerAddressPrefix = primaryPeerAddressPrefix;
            SecondaryPeerAddressPrefix = secondaryPeerAddressPrefix;
            MicrosoftPeeringConfig = microsoftPeeringConfig;
            RouteFilter = routeFilter;
            State = state;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the primary address prefix.
        /// </summary>
        [JsonProperty(PropertyName = "primaryPeerAddressPrefix")]
        public string PrimaryPeerAddressPrefix { get; set; }

        /// <summary>
        /// Gets or sets the secondary address prefix.
        /// </summary>
        [JsonProperty(PropertyName = "secondaryPeerAddressPrefix")]
        public string SecondaryPeerAddressPrefix { get; set; }

        /// <summary>
        /// Gets or sets the Microsoft peering configuration.
        /// </summary>
        [JsonProperty(PropertyName = "microsoftPeeringConfig")]
        public ExpressRouteCircuitPeeringConfig MicrosoftPeeringConfig { get; set; }

        /// <summary>
        /// Gets or sets the reference of the RouteFilter resource.
        /// </summary>
        [JsonProperty(PropertyName = "routeFilter")]
        public RouteFilter RouteFilter { get; set; }

        /// <summary>
        /// Gets or sets the state of peering. Possible values are: 'Disabled'
        /// and 'Enabled'. Possible values include: 'Disabled', 'Enabled'
        /// </summary>
        [JsonProperty(PropertyName = "state")]
        public string State { get; set; }

    }
}
