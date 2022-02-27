/* eslint-disable prettier/prettier */
import { expect } from "chai";

/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat";
import { NatToken } from "../typechain/NatToken";

describe("NatToken", function () {
  let natToken: NatToken;
  beforeEach(async () => {
    const NatToken = await ethers.getContractFactory("NatToken");
    natToken = await NatToken.deploy();
    (await natToken).deployed();
  });

  it("Should deploy contract", async function () {
    console.log(`the address of natToken is ${natToken.address}`);
  });

  it("should return `NAT` as symbol of token", async () => {
    // act
    const result = await natToken.symbol();

    // assert
    expect(result).equal("NAT");
  });

  it("should return `Nat Token` as name of token", async () => {
    // act
    const result = await natToken.name();

    // assert
    expect(result).equals("Nat token");
  });

  it("should return 18 as decimal", async () => {
    // act
    const result = await natToken.decimals();

    // assert
    expect(result).equals(18);
  });

  it("should return totalSupply ", async () => {
    // act
    const result = await natToken.totalSupply();

    // assert
    expect(result).equals(ethers.utils.);
  });
});
