//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

/// @author Emmanuel
/// @title Product Identification System
/// @dev all functions are still under development
contract ProductIndentification {
    /// @notice productAdded event will be fired when any product is added
    event ProductAdded();

    /// @notice a product object, all products will have these properties
    /// @param sender is address of the manufacturing companies
    /// @param name is the name of the product
    /// @param code a hash of the product id
    /// @param id is a unique id of the product
    /// @param date
    struct Product {
        address sender;
        string name;
        string code;
        uint256 id;
        uint256 date;
        bool isAdded;
    }

    /// @notice keeping tracks of companies and their products
    /// @dev this mapping can be advanced with address => Product[]
    mapping(address => bytes32[]) private productStore;

    /// @notice keeps track manufacturers and their public addresses
    mapping(string => address) private manufacturers;

    /// @notice onlyManufacturer requires manufacturer to be registered
    /// @param _manufacturer is the name of the manufacturer
    /// @param _manufacturerAddress is the address of manufacturer
    modifier onlyManufacturer(
        string memory _manufacturer,
        address _manufacturerAddress
    ) {
        require(
            manufacturers[_manufacturer] == _manufacturerAddress,
            "manufacturer not found"
        );
        _;
    }

    /// @notice companies will add products with this method
    /// @param _manufacturer is the name of the manufacturer
    /// @param _code is a unique string found on the product
    /// @param id is a unique nonce added to the product submission form
    /// @param _manufacturerAddress address of the manufacturer
    /// @dev function still under development
    function addProduct(
        uint256 id,
        uint256 date,
        address _manufacturerAddress,
        string memory _code,
        string memory _manufacturer
    ) public onlyManufacturer(_manufacturer, _manufacturerAddress) {
        uint256 arrayLength = productStore[_manufacturerAddress].length;
        bytes32 _productHash = _computeHash(_code);

        // checkif product already exist on chain
        for (uint256 i = 0; i < arrayLength; i++) {
            if (_productHash == productStore[_manufacturerAddress][i]) {
                revert("product already added");
                // else product is not yet added
            } else {
                productStore[_manufacturerAddress].push(_productHash);
                emit ProductAdded();
            }
        }
    }

    /// @notice computeHash produces the hash of the id of the product
    /// @param _productCode is the code of the product to be hashed
    /// @dev can be optimised to save gas
    /// @return _productHash the hash of the code of the product
    function _computeHash(string memory _productCode)
        internal
        pure
        returns (bytes32)
    {
        bytes32 _productHash = keccak256(abi.encodePacked(_productCode));
        return _productHash;
    }

    /// @notice check if product with @param _productCode exist under an address
    /// @param _productCode is the product code of the product
    /// @param _manufacturerAddress is the address of the manufacturer
    /// @return isFound is either true or false based on the search result
    function searchProduct(
        string memory _productCode,
        address _manufacturerAddress
    ) public view returns (bool) {
        uint256 arrayLength = productStore[_manufacturerAddress].length;
        bytes32 _productHash = _computeHash(_productCode);

        for (uint256 i = 0; i < arrayLength; i++) {
            if (productStore[_manufacturerAddress][i] == _productHash) {
                return true;
            }
        }

        return false;
    }

    /// @notice register manufacturers by under their names
    /// @param _manufacturer is the the name of the manufacturer
    /// @param _manufacturerAddress is the address of the manufacturer
    function registerManufacturer(
        string memory _manufacturer,
        address _manufacturerAddress
    ) public {
        manufacturers[_manufacturer] = _manufacturerAddress;
    }
}
