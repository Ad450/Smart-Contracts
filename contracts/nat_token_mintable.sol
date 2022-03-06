//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
/// @title NAT TOKEN MINTABLE
/// @author Emmanuel
/// @notice an interface that guides the the NAT token
/// @dev A token standard based on the ERC20 standards

import "./nat_token.sol";

contract NatTokenMintable is NatToken{
     /*
  @notice creates new token and adds to supply in circulation 
  @param _value is the amount of tokens to be added
  @param _supply is the total supply in circulation
   */
  function mint (uint _value, uint supply) public {
      require (msg.sender == owner, "not authorized");
      supply += _value;
  }
}