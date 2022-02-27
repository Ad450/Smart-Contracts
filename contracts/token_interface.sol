//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
/// @title IERC20   
/// @author Emmanuel
/// @notice an interface that guides the the NAT token
/// @dev A token standard based on the ERC20 standards

abstract contract IERC20{
  /*
  @notice These are functions from the ERC20 token standard 
   */

    /*
  @notice name is the a short description of the token
  @returns returns a string name
   */
  function name() public view virtual returns (string memory);

    /*
  @notice symbol is a ticker (a three or letter word) that represents the token
  @returns returns the symbol of the token
   */
  function symbol() public view virtual returns (string memory);

    /*  
  @notice decimals gives the smallest unit of the token
  @returns returns a number representing the number behind the decimal point
   */
  function decimals() public view virtual returns (uint8);

    /*
  @notice totalSupply is the the total amount of tokens in circulation or in the network
  @returns returns the number of tokens
   */
  function totalSupply() public view virtual returns (uint256);

    /*
  @notice balanceOf gives the amount of tokens of a particular address in the network
  @params _owner is the address we want its balance
  @returns returns the balance of the address
   */
  function balanceOf(address _owner) public view virtual returns (uint256);

    /*
  @notice transfer simply transfers some amount of tokens from an address to the other
  @params _to is the recipient address
  @params _value is the amount of tokens to be sent to the recipient
  @returns returns a boolean if transfer is successful
   */
  function transfer(address _to, uint256 _value) public virtual returns (bool);

    /*
  @notice transferFrom transfers tokens from _from to the recipient _to
  @notice this is basically a third party sending money from _from to _to
  @params _from is the address we are transfering tokens from its account
  @params _to is the recipient address
  @params _value is the amount of tokens to be transfered from _from
  @returns returns a boolean if operation is successful
   */
  function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool);

    /*
  @notice approve will allow _spender to spend some tokens in another address's account
  @params _spender is the address requesting to spend the tokens
  @params _value is the amount of tokens requested 
   */
  function approve(address _spender, uint256 _value) public virtual returns (bool);

    /*
  @notice allowance basically tells who (_spender) can spend some tokens from _owner's account
  @params _owner is the the bearer of the account
  @params _spender is the address requesting to spend some tokens from _owner
   */
  function allowance(address _owner, address _spender) public view virtual returns (uint256);

  

    /*
  @notice These are Events that will be emmitted in a transfer and transferFrom operations
   */

   event Transfer(address indexed _from, address indexed _to, uint256 _value)
   event Approval(address indexed _owner, address indexed _spender, uint256 _value)

}
