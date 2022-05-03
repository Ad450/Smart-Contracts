/* eslint-disable prettier/prettier */
import { expect } from "chai";

/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat";
import { deployContract, MockProvider } from "ethereum-waffle";
import { Contract } from "ethers";
import productContractJson from "../artifacts/contracts/Product-Identification/product_identification.sol/ProductIdentification.json";

describe("product identication contract test", () => {
  let contractInstance: Contract;
  let wallet;
  let testAddress1: any;
  const testManufacturer: String = "Geocem";
  const productCode: String = "123456";

  beforeEach(async () => {
    wallet = await new MockProvider().getWallets();
    contractInstance = await deployContract(wallet[0], productContractJson);
    testAddress1 = wallet[1].address;
  });

  it("should deploy contract ", async () => {
    console.log(contractInstance.address);
  });

  it("should register a manufacturer", async () => {
    // ARRANGE
    await contractInstance.registerManufacturer(testManufacturer, testAddress1);

    // ACT
    const result = await contractInstance.getManufacturers(testManufacturer);

    // ASSERT
    expect(result).equals(testAddress1);
  });

  it("add products to a manufacturers array", async () => {
    // ARRANGE
    await contractInstance.registerManufacturer(testManufacturer, testAddress1);

    // ACT
    await contractInstance.addProduct(
      1,
      2,
      testAddress1,
      productCode,
      testManufacturer
    );

    const result = await contractInstance.searchProduct(
      productCode,
      testAddress1
    );
    // ASSERT
    expect(result).equals(true);
  });
});

// uint256 id,
// uint256 date,
// address _manufacturerAddress,
// string memory _code,
// string memory _manufacturer
