// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.19;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract JtestToken is ERC20 {
    address payable public owner;

    constructor(uint256 initialSupply) ERC20("JtestToken", "JTT") {
        owner = payable(msg.sender);
        _mint(msg.sender, initialSupply);
    }
}
