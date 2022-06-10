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
    mapping(address => uint256) private poolOwnership0;
    mapping(address => uint256) private poolOwnership1;

    // reentrancy locker
    bool private locked = false;

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

        _calculateOwnership(_amount0, _amount1);
        
    }

    // tokens owned by LPs 
    function _calculateOwnership(uint256 _amount0, uint256 _amount1)
        private
        view
    {
        (uint256 _reserve0, uint256 _reserve1) = _getReserve();

        uint256 _percentOwned0 = (_amount0 / _reserve0);
        uint256 _percentOwned1 = (_amount1 / _reserve1);
        poolOwnership0[msg.sender].add(_percentOwned0);
        poolOwnership1[msg.sender].add(_percentOwned1);
    }

    // LP withdraws tokens from pool
    function withdrawLiquidity(uint256 _amount0, uint256 _amount1)
        public
        reentrancyGuard
    {
        require(_amount0 > 0, "amount cant be 0 or less");
        require(_amount1 > 0, "amount cant be 0 or less");
        (uint256 _reserve0, uint256 _reserve1) = _getReserve();

        // amount of tokens owned by LP
        uint256 _amountOwnedByLP0 = _reserve0.mul(poolOwnership0[msg.sender]);
        uint256 _amountOwnedByLP1 = _reserve1.mul(poolOwnership1[msg.sender]);

        // amount to transfer to owner
        uint256 _newAmountOwned0 = _amountOwnedByLP0.sub(_amount0);
        uint256 _newAmountOwned1 = _amountOwnedByLP1.sub(_amount1);

        // update pool ownership
        poolOwnership0[msg.sender] = (_newAmountOwned0).div(_reserve0);
        poolOwnership1[msg.sender] = (_newAmountOwned1).div(_reserve1);

        // transfer tokens back to owner , will add incentives when swap is added
        token0.transferFrom(address(this), msg.sender, _amount0);
        token1.transferFrom(address(this), msg.sender, _amount1);
    }


    
    function _amountToGiveTrader(uint256 _amount, bool _is0, bool _is1) private view returns (uint256 _trade){
         (uint256 _reserve0, uint256 _reserve1) = _getReserve();
         uint256 _constantProduct = _reserve0.mul(_reserve1);

         if(_is0){
             uint256 _newReserve1 = _constantProduct.div(_reserve0.add(_amount));
             _trade = _reserve1.sub(_newReserve1);
         } 
         if(_is1){
             uint256 _newReserve0 = _constantProduct.div(_reserve1.add(_amount));
             _trade = _reserve1.sub(_newReserve0);
         }

        return _trade;
    }


    function swap(uint256 _amount, bool _is0, bool _is1) public reentrancyGuard {
         require(_amount > 0, "amount must not be 0 or less");
        (uint256 _reserve0, uint256 _reserve1) = _getReserve();

        if(_is0){
            _reserve0.add(_amount);
            _calculatePrice(_amount, 0, true, false);
            (uint256 _trade ) =_amountToGiveTrader(_amount, true, false);

            token1.transfer(msg.sender, _trade);
        }
        if(_is1){
            _reserve1.add(_amount);
            _calculatePrice(0, _amount, true, false);
            (uint256 _trade ) =_amountToGiveTrader(_amount, false, true);

            token0.transfer(msg.sender, _trade);
        }
    }

    function _calculatePrice(uint256 _amount0, uint256 _amount1, bool _isSwap, bool _isWithdrawal) private view returns (uint256 _price0,uint256 _price1){

        (uint256 _reserve0, uint256 _reserve1) = _getReserve();

        if(_isSwap){
            uint256 _constantProduct = _reserve0.mul(_reserve1);
            uint256 _newReserve1;
            uint256 _newReserve0;

            if (_amount0 > _amount1) {
                _price0 = _reserve0.div(_reserve0.add(_amount0));

                _newReserve1 = _constantProduct.div(_reserve0.add(_amount0));
                _price1 = _reserve1.div(_newReserve1);
            } else {
                
                _newReserve0 = _constantProduct.div(_reserve1.add(_amount1));
                _price1 = _reserve1.div(_reserve1.add(_amount1));

                _price0 = _reserve0.div(_newReserve0);
            }
     }

      if(_isWithdrawal){
            uint256 _amountAfterWithdrawal0 = _reserve0.sub(_amount0);
            uint256 _amountAfterWithdrawal1 = _reserve1.sub(_amount1);

            _price0 = _reserve0.div(_amountAfterWithdrawal0);
            _price1 = _reserve1.div(_amountAfterWithdrawal1);
      }

      return (_price0, _price1);

    }
}
