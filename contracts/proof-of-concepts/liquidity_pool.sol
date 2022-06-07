//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "../ERC20/token_interface.sol";

contract DExchange {
    // amount of token0 in pool
    uint256 reserve0;
    // amount of token1 in pool
    uint256 reserve1;
ß
    // accummulate percentage deposit (lp - liquidity provider)
    mapping(address => uint256) lpAccumulator0;
    mapping(address => uint256) lpAccumulator1;

    // emit liquidityAdded
    event LiquidityAdded(uint256 _amount0, uint256 _amount1);

    // reentrancy locker
    bool private locked;

    // reentrancy guard
    modifier reentrancyGuard() {
        require(!locked, "function locked");
        locked = true;
        _;
        locked = false;
    }

    // functionality still immature, security and gas optimization will be done later
    // will change function to conform to the constant product of uniswap
    function addLiqudity(
        address _token0,
        address _token1,
        uint256 _amount0,
        uint256 _amount1
    ) public reentrancyGuard {
        reserve0 += IERC20(_token0).balanceOf(address(this)) + _amount0;
        reserve1 += IERC20(_token1).balanceOf(address(this)) + _amount1;

        IERC20(_token0).transfer(address(this), _amount0);
        IERC20(_token1).transfer(address(this), _amount1);

        // accumulating percentage of provider 
        uint256 _percentageDeposit0 = (_amount0 / reserve0) * 100;
        uint256 _percentageDeposit1 = (_amount1 / reserve1) * 100;
        lpAccumulator0[msg.sender] += _percentageDeposit0; // will be used to calculate lp fee of provider
        lpAccumulator1[msg.sender] += _percentageDeposit1;
    }
}
