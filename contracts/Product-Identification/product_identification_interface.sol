//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

/// @author Emmanuel
/// @title Product Identification System
/// @dev all functions are still under development
contract ProductIndentification {
    /// @notice a product object, all products will have these properties
    /// @param `sender` is address of the manufacturing companies
    /// @param `name` is the name of the product
    /// @param `code` a hash of the product id
    /// @param `id` is a unique id of the product
    struct Product {
        address sender;
        string name;
        string code;
        uint256 id;
        uint256 date;
    }

    /// @notice keeping tracks of companies and their products
    /// @dev this mapping can be advanced with address => Product[]
    mapping(address => Product) private companyProducts;

    /// @notice companies will add products with this method
    /// @param _product is the product to be added
    /// @dev function still under development
    function addProduct(Product memory _product) public {}
}
