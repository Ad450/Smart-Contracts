//SPDX-License-Identifier: Unilicense
pragma solidity ^0.8.4;

library SafeMath {
    // update functions to check integer overflow and underflow

    // safe multiplication
    function mul(uint256 a, uint256 b) public pure returns (uint256 result) {
        result = (a * b);
        require((result / a) == b, "incorrect multiplication");

        return result;
    }

    // safe addition
    function add(uint256 a, uint256 b) public pure returns (uint256 result) {
        result = (a + b);
        require(result >= (a + b), "incorrect addition");

        return result;
    }

    // safe division
    function div(uint256 a, uint256 b) public pure returns (uint256 result) {
        // where a is always the numerator
        require(b > 0, "indeterminate");
        result = (a / b);
        require((result * b) == a, "incorrect division");

        return result;
    }

    // safe subtraction
    function sub(uint256 a, uint256 b) public pure returns (uint256 result) {
        require(a > b, "negative result ");
        result = (a - b);
        require(result < a, "incorrect subtraction");

        return result;
    }
}
