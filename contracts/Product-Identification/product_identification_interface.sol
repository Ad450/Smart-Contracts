//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract ProductIndentification {
    struct Product {
        address sender;
        string name;
        string code;
        uint256 id;
        uint256 date;
    }

    mapping(address => Product) private companyProducts;
}
