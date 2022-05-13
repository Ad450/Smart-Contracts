//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;


/// @author Emmanuel
/// @title Multisig
/// @dev all contract functions are still under development
contract MultisigWallet{
    // owners of contract
    address[] public owners;

    // required number of owners to validate/ approve a transaction
    uint public required; 
    
    // keep track of owners
    mapping (address => bool) isOwner;

    // keep track of transactions 
    mapping (uint => Transaction) transactionExist;

    // keep track of approvals addresses
    mapping (uint => address) public approvalAddress;

    // an array of transactions
    Transaction[] private transactions;

    // events 
    event Approved(uint txId, address owner);
    event Revoked(uint txId);
    event Executed(uint txId);
    event TransactionCreated(uint txId);


    // init owners at deployment
    constructor (address[] memory _owners, uint _required) payable {
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
        address payable to;
        uint amount;
        bool executed;
    }


    // create transaction
    function createTransaction(address payable _to, uint _txId, uint _amount) public {
        require(isOwner[msg.sender], "not authorised");
        emit TransactionCreated(_txId);

        transactionExist[_txId] = Transaction(_txId, false, 0, _to, _amount, false);
        transactions.push(Transaction(_txId, false, 0, _to, _amount, false));
    }

    // approve transaction 
    function approveAndExecute (uint _txId) public {
        require(isOwner[msg.sender], "not authorised");
        require (approvalAddress[_txId] != msg.sender, "already approved");

        approvalAddress[_txId] = msg.sender;
        transactionExist[_txId].approvals ++;
        emit Approved(_txId, msg.sender);

        require( transactionExist[_txId].approvals >= required, "waiting other approvals");

        _execute(_txId);

    }

    // execute transaction
    function _execute (uint txId) private {
        Transaction storage _transaction = transactionExist[txId];

        require(!_transaction.executed, "transaction already executed");
        require (_transaction.approvals >= required, "transaction not approved");

        _transaction.executed = true;

      (bool success, ) =  _transaction.to.call{value: _transaction.amount}("");
      require(success, "transaction failed");

      emit Executed(_txId);
    }
}
