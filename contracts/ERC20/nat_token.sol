//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
/// @title NAT TOKEN
/// @author Emmanuel
/// @notice an interface that guides the the NAT token
/// @dev A token standard based on the ERC20 standards

import "./token_interface.sol";

contract NatToken is IERC20 {
    constructor() {
        _owner = msg.sender;
        supply = 100 * 10**18;
        balances[msg.sender] = supply;
    }

    string private constant NAME = "Nat token";
    string private constant SYMBOL = "NAT";
    uint256 private supply;
    uint8 private constant DECIMALS = 18;

    address internal _owner;

    mapping(address => uint256) public balances;

    /*
  @notice name is the a short description of the token
  @returns returns a string name
   */
    function name() public pure override returns (string memory) {
        return NAME;
    }

    /*
  @notice symbol is a ticker (a three or letter word) that represents the token
  @returns returns the symbol of the token
   */
    function symbol() public pure override returns (string memory) {
        return SYMBOL;
    }

    /*  
  @notice decimals gives the smallest unit of the token
  @returns returns a number representing the number behind the decimal point
   */
    function decimals() public pure override returns (uint8) {
        return DECIMALS;
    }

    /*
  @notice supply is the the total amount of tokens in circulation or in the network
  @returns returns the number of tokens
   */
    function totalSupply() public view override returns (uint256) {
        return supply;
    }

    /*
  @notice balanceOf gives the amount of tokens of a particular address in the network
  @params _owner is the address we want its balance
  @returns returns the balance of the address
   */
    function balanceOf(address  _caller)
        public
        view
        override
        returns (uint256)
    {
        require(_caller != address(0), "invalid address");
        return balances[_caller];
    }

    /*
  @notice transfer simply transfers some amount of tokens from an address to the other
  @params _to is the recipient address
  @params _value is the amount of tokens to be sent to the recipient
  @returns returns a boolean if transfer is successful
   */
    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool)
    {
        require(_to != address(0), "invalid address");
        return transferFrom(msg.sender, _to, _value);
    }

    /*
  @notice transferFrom transfers tokens from _from to the recipient _to
  @notice this is basically a third party sending money from _from to _to
  @params _from is the address we are transfering tokens from its account
  @params _to is the recipient address
  @params _value is the amount of tokens to be transfered from _from
  @returns returns a boolean if operation is successful
   */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool) {
        require(_from != address(0), "invalid address");
        require(balances[_from] >= _value, "insufficient balance");
        require(_to != address(0), "address not found");

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        //_to.transfer(_value);

        emit Transfer({_from: msg.sender, _to: _to, _value: _value});

        return true;
    }

    /*
  @notice approve will allow _spender to spend some tokens in another address's account
  @params _spender is the address requesting to spend the tokens
  @params _value is the amount of tokens requested 
   */
    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool)
    {
        return true;
    }

    /*
  @notice allowance basically tells who (_spender) can spend some tokens from _owner's account
  @params _owner is the the bearer of the account
  @params _spender is the address requesting to spend some tokens from _owner
   */
    function allowance(address owner, address _spender)
        public
        view
        override
        returns (uint256)
    {
        // will not allow any address to spend on behalf of another address
        return 0;
    }

    /*
  @notice adding new tokens 
   */
    function mint(uint256 _value) private {
        require(msg.sender == _owner, "not authorized");
        supply += _value;
    }

    /*
  @notice seize tokens of an address for any misconduct such as fraud
   */
    function confiscate(address _bearer) public {
        require(msg.sender == _owner, "not authorized");
        supply -= balances[_bearer];
        balances[_bearer] = 0;
    }
}
