//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

/// @author Emmanuel
/// @title Product Identification System
/// @dev use openZeppelin safe math library to prevent overflow
contract ProductIdentification {
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

    /// @notice keeps tracks of companies and their products
    /// @dev this mapping can be advanced with address => Product[]
    mapping(address => bytes32[]) private productStore;

    /// @notice keeps track of product hash of added products
    mapping(address => mapping(string => mapping(string => bytes32))) hashFactory;

    /// @notice keeps track of manufacturers and their public addresses
    mapping(string => address) private manufacturers;

    /// @notice keeps to tracks of added product
    mapping(address => mapping(string => bool)) private addedProducts;

    /// @notice all manufacturer addresses are tracked here
    mapping(address => bool) private isManufacturer;

    /// @notice ensures only manufacturers can add product
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
    /// @param _manufacturerAddress address of the manufacturer
    /// @dev function still under development
    function addProduct(
        address _manufacturerAddress,
        string memory _code,
        string memory _manufacturer
    ) public onlyManufacturer(_manufacturer, _manufacturerAddress) {
        bytes32 _productHash = _computeHash(_code);

        // checkif product already exist on chain
        require(
            !addedProducts[_manufacturerAddress][_code],
            " product already added"
        );
        productStore[_manufacturerAddress].push(_productHash);
        addedProducts[_manufacturerAddress][_code] = true;

        hashFactory[_manufacturerAddress][_manufacturer][_code] = _productHash;

        emit ProductAdded();
    }

    /// @notice produces the hash of the id of the product
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
        require(
            addedProducts[_manufacturerAddress][_productCode],
            " product not added"
        );

        return true;
    }

    /// @notice register manufacturers under their names
    /// @param _manufacturer is the name of the manufacturer
    /// @param _manufacturerAddress is the address of the manufacturer
    function registerManufacturer(
        string memory _manufacturer,
        address _manufacturerAddress
    ) public {
        manufacturers[_manufacturer] = _manufacturerAddress;
    }

    /// @notice get all manufacturers registered with us
    /// @param _manufacturer is the address of the manufacturer
    /// @dev check if @param _manufacturer is not empty
    function getManufacturers(address _manufacturer)
        public
        view
        returns (address)
    {
        require(isManufacturer[_manufacturer], " address not a manufacturer");
        return _manufacturer;
    }

    /// @notice get all products belonging to a manufacturer
    /// @param _manufacturerAddress address of manufacturer
    /// @param _manufacturer name of manufacturer
    /// @param _productCode code of product
    /// @dev can replace with `searchProduct`
    function getProduct(
        address _manufacturerAddress,
        string memory _productCode,
        string memory _manufacturer
    ) public view returns (bytes32) {
        require(
            addedProducts[_manufacturerAddress][_productCode],
            " product not added"
        );

        bytes32 _productHash = hashFactory[_manufacturerAddress][_manufacturer][
            _productCode
        ];
        return _productHash;
    }
}
