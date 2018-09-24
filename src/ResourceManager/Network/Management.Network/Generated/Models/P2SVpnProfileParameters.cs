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
    /// Vpn Client Parameters for package generation
    /// </summary>
    public partial class P2SVpnProfileParameters
    {
        /// <summary>
        /// Initializes a new instance of the P2SVpnProfileParameters class.
        /// </summary>
        public P2SVpnProfileParameters()
        {
            CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the P2SVpnProfileParameters class.
        /// </summary>
        /// <param name="authenticationMethod">VPN client Authentication
        /// Method. Possible values are: 'EAPTLS' and 'EAPMSCHAPv2'. Possible
        /// values include: 'EAPTLS', 'EAPMSCHAPv2'</param>
        public P2SVpnProfileParameters(string authenticationMethod = default(string))
        {
            AuthenticationMethod = authenticationMethod;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets VPN client Authentication Method. Possible values are:
        /// 'EAPTLS' and 'EAPMSCHAPv2'. Possible values include: 'EAPTLS',
        /// 'EAPMSCHAPv2'
        /// </summary>
        [JsonProperty(PropertyName = "authenticationMethod")]
        public string AuthenticationMethod { get; set; }

    }
}
