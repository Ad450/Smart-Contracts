//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

/// @author Emmanuel
/// @title Multisig
/// @dev all contract functions are still under development
contract MultisigWallet {
    /// @notice owners of contract
    address[] public owners;

    /// @notice the number of owners required to execute approve a transaction
    uint256 public required;

    /// @notice keeps track of owners of contract
    mapping(address => bool) isOwner;

    /// @notice keeps track of all transactions
    mapping(uint256 => Transaction) transactionExist;

    /// @notice keeps track of addresses that approve a transaction
    mapping(uint256 => mapping(uint256 => address)) public approvalAddress;

    /// @notice stores all transactions
    Transaction[] private transactions;

    /// @notice all events emitted by contract
    event Approved(uint256 txId, address owner);
    event Revoked(uint256 txId);
    event Executed(uint256 txId);
    event TransactionCreated(uint256 txId);

    /// @notice set owners of contract and give a required number for approval and execution
    /// @param _owners is an array of owners of contract
    /// @param _required is the required number of owners needed to approve and execute a transaction
    constructor(address[] memory _owners, uint256 _required) payable {
        require(_owners.length > 0, "invalid owner array");
        require(required > 0, "invalid required value");

        for (uint256 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);

            isOwner[_owners[i]] = true;
        }

        required = _required;
    }

    /// @notice represent a transaction object
    /// @param txId is the unique id of the transaction
    /// @param isApproved checks whether transaction is approved or otherwise
    /// @param approvals is the number of owners that have approved the transaction
    /// @param to is the address receiving the @param amount
    /// @param amount is the amount of ether sent
    /// @param executed checks whether transaction has been executed or otherwise
    struct Transaction {
        uint256 txId;
        bool isApproved;
        uint256 approvals;
        address payable to;
        uint256 amount;
        bool executed;
    }

    /// @notice owner initiates a transaction with createTransaction
    /// @param _to is address of the receiver
    /// @param _txId is the unique id of the transaction
    /// @param _amount the amount of ether to be sent to @param _to

    function createTransaction(
        address payable _to,
        uint256 _txId,
        uint256 _amount
    ) public {
        require(isOwner[msg.sender], "not authorised");

        transactionExist[_txId] = Transaction(
            _txId,
            false,
            0,
            _to,
            _amount,
            false
        );
        transactions.push(Transaction(_txId, false, 0, _to, _amount, false));

        emit TransactionCreated(_txId);
    }

    /// @notice owner(s) approve transaction to be executed
    /// @param _txId is the unique id of the transaction
    function approveAndExecute(uint256 _txId) public {
        require(isOwner[msg.sender], "not authorised");
        bytes32 senderHash = keccak256(abi.encodePacked(msg.sender));
        require(
            approvalAddress[uint256(senderHash)][_txId] != msg.sender,
            "already approved"
        );

        approvalAddress[uint256(senderHash)][_txId] = msg.sender;
        transactionExist[_txId].approvals++;
        emit Approved(_txId, msg.sender);

        require(
            transactionExist[_txId].approvals >= required,
            "waiting other approvals"
        );

        _execute(_txId);
    }

    /// @notice does the sending of ether to receiver
    /// @param txId is the unique id of the transaction
    function _execute(uint256 txId) private {
        Transaction storage _transaction = transactionExist[txId];

        require(!_transaction.executed, "transaction already executed");
        require(_transaction.approvals >= required, "transaction not approved");

        _transaction.executed = true;

        (bool success, ) = _transaction.to.call{value: _transaction.amount}("");
        require(success, "transaction failed");

        emit Executed(txId);
    }

    /// @notice receives ether coming from owners and or other addresses
    receive() external payable {}
}
