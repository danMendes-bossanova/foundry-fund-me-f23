// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        //Before starBroadcas -> Not a "real" tx
        HelperConfig helperConfig;
        helperConfig = new HelperConfig();
        //if have multiple addres must (addres1,address2...addressn)
        address ethUsPriceFeed = helperConfig.activNetworkConfig();

        //After startBroadcast -> Real tx!
        FundMe fundMe;
        vm.startBroadcast();
        fundMe = new FundMe(ethUsPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
