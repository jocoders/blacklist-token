// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Ownable } from '@openzeppelin/access/Ownable.sol';
import { ERC20 } from '@openzeppelin/token/ERC20/ERC20.sol';

/// @title Blacklist Token Contract
/// @notice This contract manages a token that can blacklist addresses from transferring or receiving tokens.
/// @dev This contract extends OpenZeppelin's ERC20 and Ownable contracts.
contract BlacklistToken is ERC20, Ownable {
  mapping(address => bool) public blacklist;

  /// @notice Initializes the contract with token name and symbol, and sets the owner to the deployer.
  /// @param name The name of the token.
  /// @param symbol The symbol of the token.
  constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender) {}

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
    require(account != address(0), 'Invalid address');
    blacklist[account] = true;
  }

  /// @notice Removes an address from the blacklist.
  /// @dev Only the owner can call this function.
  /// @param account The address to remove from the blacklist.
  function removeFromBlacklist(address account) external onlyOwner {
    require(account != address(0), 'Invalid address');
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
  function transferFrom(
    address from,
    address to,
    uint256 value
  ) public override notBlacklisted(from, to) returns (bool) {
    return super.transferFrom(from, to, value);
  }

  /// @notice Approves another address to spend tokens on behalf of msg.sender, checking if the owner and spender are not blacklisted.
  /// @param spender The address which will spend the funds.
  /// @param value The amount of tokens to be spent.
  /// @return A boolean value indicating whether the operation was successful.
  function approve(address spender, uint256 value) public override notBlacklisted(msg.sender, spender) returns (bool) {
    return super.approve(spender, value);
  }
}
