//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "../ERC20/token_interface.sol";
import "./dexchange_ERC20.sol";

contract DExchange is DexchangeERC20 {
    // amount of token0 in pool
    uint256 private reserve0;
    // amount of token1 in pool
    uint256 private reserve1;

    // burn address
    address payable private constant BURN =
        payable(0x000000000000000000000000000000000000dEaD);

    // accummulate percentage deposit (lp - liquidity provider)
    mapping(address => uint256) private lpAccumulator0;
    mapping(address => uint256) private lpAccumulator1;

    // accumulate incentives

    mapping(address => uint256) incentives;

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

    // functionality immature
    function _mintDexchangeToken(uint256 _amount) private {
        mint(_amount);
    }

    // will be used when pool provider decides to take out tokens
    function burn(uint256 _amount) private {
        BURN.transfer(_amount);
    }

    function _calcLPIncentive(address _lpAddress)
        private
        returns (uint256 incentive)
    {}
}
