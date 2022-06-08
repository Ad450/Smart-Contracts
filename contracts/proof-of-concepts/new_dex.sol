//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "../ERC20/nat_token.sol";

contract NewDex {
    // using 0 address as token0 and token1 address
    address private constant tokenAddress =
        0x000000000000000000000000000000000000dEaD;

    // token0 interface
    NatToken token0 = NatToken(tokenAddress);
    NatToken token1 = NatToken(tokenAddress);

    // reserve - amount of both tokens held in NewDex
    uint256 private reserve0;
    uint256 private reserve1;

    // track amount of each tokens owned by LPs
    mapping(address => uint256) pool0Ownership;
    mapping(address => uint256) pool1Ownership;

    // reentrancy locker
    bool private locked;

    modifier reentrancyGuard() {
        require(!locked, "reentrancy occured");
        locked = true;
        _;
        locked = false;
    }

    // function to optimise gas
    function _getReserve() private view returns (uint256, uint256) {
        uint256 _reserve0 = reserve0;
        uint256 _reserve1 = reserve1;
        return (_reserve0, _reserve1);
    }

    function addLiquidity(uint256 _amount0, uint256 _amount1)
        public
        reentrancyGuard
    {
        require(_amount1 > 0, "amount cant be 0 or less");
        require(_amount0 > 0, "amount cant be 0 or less");

        (uint256 _reserve0, uint256 _reserve1) = _getReserve();
        _reserve0 = token0.balanceOf(address(this)) + _amount0;
        _reserve1 = token1.balanceOf(address(this)) + _amount1;

        token0.transfer(address(this), _amount0);
        token1.transfer(address(this), _amount1);

        // updating state after transfer, possible reentrancy

        uint256 _percentOwned0 = (_amount0 / _reserve0);
        uint256 _percentOwned1 = (_amount1 / _reserve1);
        pool0Ownership[msg.sender] += _percentOwned0;
        pool1Ownership[msg.sender] += _percentOwned1;
    }
}
