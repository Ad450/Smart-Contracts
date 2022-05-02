//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
/// @title NAT TOKEN OWNERBLE
/// @author Emmanuel
/// @notice an interface that guides the the NAT token
/// @dev A token standard based on the ERC20 standards

import "./nat_token.sol";

contract NatTokenOwnerble is NatToken {
    address public _owner;

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner(address caller){
        require(caller == _owner, "not authorise to perform operation");
        _;
    }

    /// @notice to transfer ownership of contract to another address
    /// @param _newOwner is the address to take over ownership
    function transferOwnership(address _newOwner) public {
        require(msg.sender == _owner, "only owners can call this method");
        require(_newOwner != address(0), "address doesnot exist");
        _owner = _newOwner;
    }
}
