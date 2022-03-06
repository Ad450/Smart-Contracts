//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
/// @title NAT TOKEN OWNERBLE
/// @author Emmanuel
/// @notice an interface that guides the the NAT token
/// @dev A token standard based on the ERC20 standards

contract Ownerble {
    address public owner;

    address public newOwner;

    function transferOwnership (address  _newOwner) public {
        require (msg.sender == owner, "you are authorized to perform this operation");
        
    }
}