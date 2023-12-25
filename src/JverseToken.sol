// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.19;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
error FundMe__NotOwner();

contract JverseToken is ERC20 {
    address private immutable i_owner;

    constructor() ERC20("JverseToken", "JVT23") {
        i_owner = payable(msg.sender);
        mint(i_owner, 70000000 * (10 ** decimals()));
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function mint(address account, uint256 amount) public onlyOwner {
        mint(account, amount);
    }
}
