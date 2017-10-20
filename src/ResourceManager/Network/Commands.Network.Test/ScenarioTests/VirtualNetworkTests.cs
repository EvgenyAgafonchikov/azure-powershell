// ----------------------------------------------------------------------------------
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

using Microsoft.Azure.ServiceManagemenet.Common.Models;
using Microsoft.WindowsAzure.Commands.ScenarioTest;
using Xunit;
using Xunit.Abstractions;

namespace Commands.Network.Test.ScenarioTests
{
    public class VirtualNetworkTests : Microsoft.WindowsAzure.Commands.Test.Utilities.Common.RMTestBase
    {
        public VirtualNetworkTests(ITestOutputHelper output)
        {
            XunitTracingInterceptor.AddToContext(new XunitTracingInterceptor(output));
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestVirtualNetworkCRUDMinimalParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-VirtualNetworkCRUDMinimalParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestVirtualNetworkCRUDAllParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-VirtualNetworkCRUDAllParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestSubnetCRUDMinimalParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-SubnetCRUDMinimalParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestSubnetCRUDAllParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-SubnetCRUDAllParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestVirtualNetworkUsage()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-VirtualNetworkUsage");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestVirtualNetworkSubnetServiceEndpoint()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-VirtualNetworkSubnetServiceEndpoint");
        }
    }
}
