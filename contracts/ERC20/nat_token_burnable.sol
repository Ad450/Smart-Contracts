//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/// @title NAT TOKEN BURNABLE 
/// @author Emmanuel
/// @notice an interface that guides the the NAT token
/// @dev A token standard based on the ERC20 standards

import "./nat_token.sol";

contract NatTokenBurnable is NatToken{
    address private constant BURN = 0x000000000000000000000000000000000000dEaD;
    
     /*  
  @notice burn destroys some _amount of tokens in circulation
  @notice we transfer _amount of tokens to the eater address (0x0...)
  @notice this locks the tokens forever because this address has no private key and it is not owned
  @param _amount is the amount of tokens to be destroyed

   */

    function burn(uint _amount) public {
        transfer(BURN, _amount);
    }
}