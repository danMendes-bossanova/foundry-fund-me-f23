// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/Mockv3Aggregator.sol";

//2. Keep track of contract address across different chains
//Sepolia ETH/USD
// Mainnet ETH/USD

contract HelperConfig is Script {
    // if we are on a local anvil, we deploy mocks
    // Otherwise, grab the existing address from the live nwetwork
    NetworkConfig public activNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    // 1. Deploy mocks we are on local anvil chain
    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activNetworkConfig = getMainnetEthConfig();
        } else {
            activNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address

        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
        //v,r,f address
        //gas price
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethereumConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethereumConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activNetworkConfig.priceFeed != address(0)) {
            return activNetworkConfig;
        }
        MockV3Aggregator mockPriceFeed;
        //price feed address

        //1.Deploy the mocks
        //2. Return the mock address
        vm.startBroadcast();
        //mockPriceFeed = new MockV3Aggregator(18, 2000 * 10 ** 18);
        mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
