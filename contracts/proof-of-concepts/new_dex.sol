//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "../ERC20/nat_token.sol";
import "./libraries/safeMath.sol";

contract NewDex {
    using SafeMath for uint256;

    // using 0 address as token0 and token1 address
    address private constant TOKEN_ADDRESS =
        0x000000000000000000000000000000000000dEaD;

    // set initial prices of tokens here
    uint32 private initialPrice0;
    uint32 private _initialPrice1;

    // token0 interface
    NatToken private token0 = NatToken(TOKEN_ADDRESS);
    NatToken private token1 = NatToken(TOKEN_ADDRESS);

    // reserve - amount of both tokens held in NewDex
    uint256 private reserve0;
    uint256 private reserve1;

    // track amount of each tokens owned by LPs
    mapping(address => uint256) private pool0Ownership;
    mapping(address => uint256) private pool1Ownership;

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

        _reserve0 = token0.balanceOf(address(this));
        _reserve1 = token1.balanceOf(address(this));
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

        _calculateOwnership();
    }

    function _calculateOwnership() private {
        (uint256 _reserve0, uint256 _reserve1) = _getReserve();

        uint256 _percentOwned0 = (_amount0 / _reserve0);
        uint256 _percentOwned1 = (_amount1 / _reserve1);
        pool0Ownership[msg.sender].add(_percentOwned0);
        pool1Ownership[msg.sender].add(_percentOwned1);
    }

    // LP withdraws tokens from pool
    function withdrawLiquidity(uint256 _amount0, uint256 _amount1)
        public
        reentrancyGuard
    {
        require(_amount0 && _amount1 > 0, "amount cant be 0 or less");
        (uint256 _reserve0, uint256 _reserve1) = _getReserve();

        // calculating new ownership
        uint256 _withdrawalPercent0 = _amount0.div(_reserve0);
        uint256 _withdrawalPercent1 = _amount1.div(_reserve1);

        // remaining percentage of LP
        require(
            pool0Ownership[msg.sender] >= _withdrawalPercent0,
            "invalid amount 0"
        );
        require(
            pool1Ownership[msg.sender] >= _withdrawalPercent1,
            "invalid amount 1"
        );

        pool0Ownership[msg.sender].sub(_withdrawalPercent0);
        pool1Ownership[msg.sender].sub(_withdrawalPercent1);

        // update pool state
        token0.balanceOf(address(this)).sub(_amount0);
        token1.balanceOf(address(this)).sub(_amount1);

        // calculate amount of tokens to transfer
        uint256 _amountToTransfer0 = _reserve0.mul(pool0Ownership[msg.sender]);
        uint256 _amountToTransfer1 = _reserve1.mul(pool1Ownership[msg.sender]);

        // _calculateNextPrice(_reserve0, _reserve1);

        // transfer tokens
        token0.transferFrom(address(this), msg.sender, _amountToTransfer0);
        token1.transferFrom(address(this), msg.sender, _amountToTransfer1);
    }

    function _calculateNextPrice(uint256 _amount0, uint256 _amount1)
        private
        returns (uint256 _price0, uint256 _price1)
    {
        require(_amount0 != _amount1, "provide amount of token to swap");
        (uint256 _reserve0, uint256 _reserve1) = _getReserve();
        uint256 _constantProduct = _reserve0.mul(_reserve1);

        if (_amount0 > _amount1) {
            _reserve0.add(_amount0);
            uint256 _newReserve0 = _constantProduct.div(_reserve0);
            _price0 = _reserve0.div(_newReserve0);
        }

        _reserve1.add(_amount1);
        uint256 _newReserve1 = _constantProduct.div(_reserve1);
        _price1 = _reserve1.div(_newReserve1);

        return (_price1, price2);
    }
}
