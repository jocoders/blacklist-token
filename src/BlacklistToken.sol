// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/// @title Blacklist Token Contract
/// @author Evgenii Kireev
/// @notice This contract manages a token that can blacklist addresses from transferring or receiving tokens.
/// @dev This contract extends ERC20 and Ownable2Step from OpenZeppelin
contract BlacklistToken is ERC20, Ownable2Step {
    uint256 public constant INITIAL_SUPPLY = 100_000_000 * 1e18;

    mapping(address => bool) public blacklist;

    /// @notice Initializes the contract with initial supply and sets the deployer as the initial owner
    /// @dev The constructor sets the initial supply and calls ERC20 and Ownable constructors
    constructor() ERC20("BlacklistToken", "BLT") Ownable(msg.sender) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /// @notice Checks if the addresses involved in a transaction are not blacklisted.
    /// @param from The address sending the tokens.
    /// @param to The address receiving the tokens.
    modifier notBlacklisted(address from, address to) {
        require(!blacklist[from], "Address 'from' is blacklisted");
        require(!blacklist[to], "Address 'to' is blacklisted");
        _;
    }

    /// @notice Adds an address to the blacklist.
    /// @dev Only the owner can call this function.
    /// @param account The address to blacklist.
    function addToBlacklist(address account) external onlyOwner {
        require(account != address(0), "Invalid address");
        blacklist[account] = true;
    }

    /// @notice Removes an address from the blacklist.
    /// @dev Only the owner can call this function.
    /// @param account The address to remove from the blacklist.
    function removeFromBlacklist(address account) external onlyOwner {
        require(account != address(0), "Invalid address");
        blacklist[account] = false;
    }

    /// @notice Transfers tokens to a specified address, checking if the sender and receiver are not blacklisted.
    /// @param to The recipient of the tokens.
    /// @param value The amount of tokens to send.
    /// @return A boolean value indicating whether the operation was successful.
    function transfer(address to, uint256 value) public override notBlacklisted(msg.sender, to) returns (bool) {
        return super.transfer(to, value);
    }

    /// @notice Transfers tokens from one address to another, checking if the sender, from, and to addresses are not blacklisted.
    /// @param from The address which you want to send tokens from.
    /// @param to The address which you want to transfer to.
    /// @param value The amount of tokens to be transferred.
    /// @return A boolean value indicating whether the operation was successful.
    function transferFrom(address from, address to, uint256 value)
        public
        override
        notBlacklisted(from, to)
        returns (bool)
    {
        return super.transferFrom(from, to, value);
    }

    /// @notice Approves another address to spend tokens on behalf of msg.sender, checking if the owner and spender are not blacklisted.
    /// @param spender The address which will spend the funds.
    /// @param value The amount of tokens to be spent.
    /// @return A boolean value indicating whether the operation was successful.
    function approve(address spender, uint256 value)
        public
        override
        notBlacklisted(msg.sender, spender)
        returns (bool)
    {
        return super.approve(spender, value);
    }
}
