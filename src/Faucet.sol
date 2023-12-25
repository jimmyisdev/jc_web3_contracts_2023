// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions
// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.19;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Faucet {
    address payable owner;
    IERC20 public token;
    uint256 public lockTime = 5 minutes;
    uint256 public withdrawalAmount = 50 * (10 ** 18);

    event Withdrawal(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    mapping(address => uint256) nextAccessTime;

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function requestTokens() public {
        require(
            msg.sender != address(0),
            "Request must not originate from a zero account"
        );
        require(
            token.balanceOf(address(this)) >= withdrawalAmount,
            "Insufficient balance in faucet for withdrawal request"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient time elapsed since last withdrawal - try again later."
        );

        nextAccessTime[msg.sender] = block.timestamp + lockTime;

        token.transfer(msg.sender, withdrawalAmount);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf((address(this)));
    }

    function setWithdrawalAmount(uint256 amount) public onlyOwner {
        withdrawalAmount = amount * (10 ** 18);
    }

    function setLockTime(uint256 amount) public onlyOwner {
        lockTime = amount * 1 minutes;
    }

    function withdraw() external onlyOwner {
        emit Withdrawal(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}
