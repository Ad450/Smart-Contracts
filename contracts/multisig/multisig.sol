//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;


/// @author Emmanuel
/// @title Multisig
/// @dev all contract functions are still under development
contract Multisig{
    // owners of contract
    address[] public owners;

    // required number of owners to validate/ approve a transaction
    uint public required; 
    
    // keep track of owners
    mapping (address => bool) isOwner;

    // an array of transactions
    Transaction[] private transactions;

    // events 
    event Approved(uint txId);
    event Revoked(uint txId);
    event Executed(uint txId);
    event TransactionCreated(uint txId);


    // init owners at deployment
    constructor (address[] memory _owners, uint _required){
        require(_owners.length > 0, "invalid owner array");
        require(required > 0, "invalid required value");

        for(uint i = 0; i < _owners.length; i++){
            owners.push(_owners[i]);

            isOwner[_owners[i]] = true;
        }

        required = _required;
    }    

    // transaction struct

    struct Transaction{
        uint txId;
        bool isApproved;
        uint approvals;
        address to;
        uint amount;
    }


    // create transaction
    function createTransaction(address _to, uint _txId, uint _amount) public {
        require(isOwner[msg.sender], "not authorised");
        emit TransactionCreated(_txId);
        transactions.push(Transaction(_txId, false, 1, _to, _amount));
    }
}
