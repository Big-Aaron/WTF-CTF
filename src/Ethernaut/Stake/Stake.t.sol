// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/Test.sol";
import "./StakeFactory.sol";
import "openzeppelin-contracts-08/token/ERC20/ERC20.sol";

contract StakeTest is Test {
    StakeFactory factory;
    Stake stakeInstance;

    function setUp() public {
        factory = new StakeFactory();
        stakeInstance = Stake(factory.createInstance(address(this)));
    }

    function testStake() public {
        new Deal{value: 0.0011 ether + 1}(stakeInstance);

        ERC20 WETH = ERC20(stakeInstance.WETH());
        WETH.approve(address(stakeInstance), type(uint256).max);
        uint256 amount = 0.0011 ether;
        stakeInstance.StakeWETH(amount);
        stakeInstance.Unstake(amount);

        assertTrue(factory.validateInstance(payable(address(stakeInstance)), address(this)));
    }

    receive() external payable {}
}

contract Deal {
    constructor(Stake stake) payable {
        stake.StakeETH{value: msg.value}();
    }
}
