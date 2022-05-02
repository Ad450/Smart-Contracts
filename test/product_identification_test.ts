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
  beforeEach(async () => {
    wallet = await new MockProvider().getWallets();
    contractInstance = await deployContract(wallet[0], productContractJson);
  });

  it("should deploy contract ", async () => {
    console.log(contractInstance.address);
  });
});
