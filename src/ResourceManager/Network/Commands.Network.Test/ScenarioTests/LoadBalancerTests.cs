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
    public class LoadBalancerTests : Microsoft.WindowsAzure.Commands.Test.Utilities.Common.RMTestBase
    {
        public LoadBalancerTests(ITestOutputHelper output)
        {
            XunitTracingInterceptor.AddToContext(new XunitTracingInterceptor(output));
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestLoadBalancerCRUDMinimalParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-LoadBalancerCRUDMinimalParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestLoadBalancerCRUDAllParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-LoadBalancerCRUDAllParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestBackendAddressPoolCRUDMinimalParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-BackendAddressPoolCRUDMinimalParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestFrontendIPConfigurationCRUDMinimalParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-FrontendIPConfigurationCRUDMinimalParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestInboundNatPoolCRUDMinimalParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-InboundNatPoolCRUDMinimalParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestInboundNatRuleCRUDAllParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-InboundNatRuleCRUDAllParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestLoadBalancingRuleCRUDAllParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-LoadBalancingRuleCRUDAllParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestProbeCRUDMinimalParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-ProbeCRUDMinimalParameters");
        }

        [Fact]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestProbeCRUDAllParameters()
        {
            NetworkResourcesController.NewInstance.RunPsTest("Test-ProbeCRUDAllParameters");
        }
        
    }
}
