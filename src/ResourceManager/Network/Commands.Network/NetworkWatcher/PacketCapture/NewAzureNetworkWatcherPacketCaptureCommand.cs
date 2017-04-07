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
using CNM = Microsoft.Azure.Commands.Network.Models;

namespace Microsoft.Azure.Commands.Network.Automation
{


    [Cmdlet(VerbsCommon.New, "AzureRmNetworkWatcherPacketCapture", DefaultParameterSetName = "InvokeByDynamicParameters", SupportsShouldProcess = true)]
    public partial class NewAzureRmNetworkWatcherPacketCapture : PacketCaptureBaseCmdlet
    {
        [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string ResourceGroupName { get; set; }
        [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string NetworkWatcherName { get; set; }
        [Parameter(
            Mandatory = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string Name { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public string TargetVirtualMachineId { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public int? BytesToCapturePerPacket { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public int? TotalBytesPerSession { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public int? TimeLimitInSeconds { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public string StorageAccountId { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public string StoragePath { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public string LocalFilePath { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipelineByPropertyName = true)]
        public List<PSPacketCaptureFilter> Filter { get; set; }

        [Parameter(
            Mandatory = false,
            HelpMessage = "Do not ask for confirmation if you want to overwrite a resource")]
        public SwitchParameter Force { get; set; }


        public override void Execute()
        {
            base.Execute();


            // StorageLocation
            PSStorageLocation vStorageLocation = null;

            if (this.StorageAccountId != null)
            {
                if (vStorageLocation == null)
                {
                    vStorageLocation = new PSStorageLocation();
                }
                vStorageLocation.StorageId = this.StorageAccountId;
            }

            if (this.StoragePath != null)
            {
                if (vStorageLocation == null)
                {
                    vStorageLocation = new PSStorageLocation();
                }
                vStorageLocation.StoragePath = this.StoragePath;
            }

            if (this.LocalFilePath != null)
            {
                if (vStorageLocation == null)
                {
                    vStorageLocation = new PSStorageLocation();
                }
                vStorageLocation.FilePath = this.LocalFilePath;
            }


            var vPacketCapture = new PSPacketCapture
            {
                Target = this.TargetVirtualMachineId,
                BytesToCapturePerPacket = this.BytesToCapturePerPacket,
                TotalBytesPerSession = this.TotalBytesPerSession,
                TimeLimitInSeconds = this.TimeLimitInSeconds,
                Filters = this.Filter,
                StorageLocation = vStorageLocation,
            };

            var vPacketCaptureModel = Mapper.Map<MNM.PacketCapture>(vPacketCapture);
            this.PacketCaptures.Create(this.ResourceGroupName, this.NetworkWatcherName, this.Name, vPacketCaptureModel);
            var vPacketCaptureResult = this.PacketCaptures.Get(this.ResourceGroupName, this.NetworkWatcherName, this.Name);
            WriteObject(vPacketCaptureResult);

        }
    }
}
