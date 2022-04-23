//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
/// @title NAT TOKEN OWNERBLE
/// @author Emmanuel
/// @notice an interface that guides the the NAT token
/// @dev A token standard based on the ERC20 standards

import "./nat_token.sol";

contract NatTokenOwnerble is NatToken {
    address private override _owner;

    address public newOwner;

    constructor() public {
        _owner = msg.sender;
    }

    //@notice to transfer ownership of contract to another address
    //@params _newOwner is the address to take over ownership
    function transferOwnership(address _newOwner) public {
        require(msg.sender == _owner);
        require(newOwner != address(0));
        _owner = newOwner;
    }
}
