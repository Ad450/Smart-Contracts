// SPDX-License-Identifier: Unilicense
pragma solidity ^0.8.4;
import "../ERC20/token_interface.sol";
import "./libraries/safeMath.sol";

contract Vault{
    using SafeMath for uint;
    using SafeMath for uint8;

    address[] private _vaultMasters;
    uint private _requiredVaultMasters;

    mapping(address => uint256) private _allowance;
    mapping(address => bool) private isVaultMaster;
    mapping(uint => mapping(address => bool)) private hasAuthorisedTransaction;
    

    // Transactions
    struct Transaction{
        address _to;
        address _from;
        address _by;
        address _tokenAddress;
        uint _amount;
        uint8 _id;
        uint8 _approvals;   

    }

    constructor (address[] memory vaultMasters, uint requiredVaultMasters) payable {
        require(vaultMasters.length > 0 , "provide a valid array");
        require(_requiredVaultMasters > 0, "invalid required number");
        require(vaultMasters.length == requiredVaultMasters, "invalid vault master array");

        (address[] storage _masters, uint _required) = _getVaultMasters();

        for(uint i = 0; i < vaultMasters.length; i++){
            _masters.push(vaultMasters[i]);
            isVaultMaster[vaultMasters[i]] = true;
        }
        _required = requiredVaultMasters;
    }


    // save gas (gas optimization)
    function _getVaultMasters() private view returns (address[] storage _masters, uint _required){
        _masters = _vaultMasters;
        _required = _requiredVaultMasters;

        return (_masters, _required);
    }


    // _lock is false
    uint8 private _lock = 0;

    modifier locked {
        // check if _lock is false or contract is not locked
        require(_lock == 0, "contract locked");
        // lock contract and execute
        _lock = 1;
        _;
        // unlock contract after execution
        _lock = 0;
    }

    function depositTokens (uint256 _amount, address  _tokenAddress) external locked{
        require(_tokenAddress != address(0), "invalid address");
        IERC20 token = IERC20(_tokenAddress);
       
        require(_amount > 0, "amount can not be 0 or less");
        require(token.balanceOf(msg.sender) > _amount, "insufficient balance");

        _allowance[msg.sender].add(_amount);

        token.transferFrom(msg.sender, payable(address(this)), _amount);
        
    }

    function _withdrawTokens (uint256 _amount, address _tokenAddress) private locked{
        require(_tokenAddress != address(0), "invalid address");
        IERC20 token = IERC20(_tokenAddress);

        require (_allowance[msg.sender] >= _amount, "insufficient balance");
        
        _allowance[msg.sender].sub(_amount);

        token.transferFrom(address(this), msg.sender, _amount);
    }

    function executeWithdrawal(Transaction memory _transaction) external locked {
        if(_validateWithdrawal(_transaction)){
            _withdrawTokens(_transaction._amount, _transaction._tokenAddress);
        }

    }

    function _validateWithdrawal(Transaction memory _transaction) private view returns (bool validated){
        if(_transaction._approvals >= _requiredVaultMasters){
            return true;
        }
        return false;
    }

    function approveWithdrawal(Transaction memory _transaction) external {
        require(isVaultMaster[msg.sender], "not authorised");
        require(!hasAuthorisedTransaction[_transaction._id][msg.sender], "already approved");
        _transaction._approvals.add(1);
        hasAuthorisedTransaction[_transaction._id][msg.sender] = true;
    }

    receive() external payable {
        require(msg.sender != address(0), "invalid caller");
        require(msg.value > 0, "invalid amount");
    }
}