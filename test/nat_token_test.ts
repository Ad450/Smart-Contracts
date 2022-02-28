/* eslint-disable prettier/prettier */
import { assert, expect } from "chai";

/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat";
import { NatToken } from "../typechain/NatToken";
import * as BigNumber from "bignumber.js";

describe("NatToken", () => {
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
    // arrange
    const supply = new BigNumber.BigNumber(100 * 10 ** 18);

    // act
    const result = await natToken.totalSupply();
    const parsedResult = new BigNumber.BigNumber(result.toString());

    // assert
    assert(parsedResult.minus(supply).toString, "0");
  });

  it("should revert when address is a zero address", async () => {
    // assert
    try {
      await natToken.balanceOf("0");
    } catch (error) {
      expect(error).toString().includes("invalid address");
    }

    // expect(await natToken.balanceOf("0x"))
    //   .throws(new Error())
    //   .includes("invalid address");
  });

  it("should return a number between 0 and 100, 0 inclusive", async () => {
    // arrange
    const testAddress: string = "0xbda5747bfd65f08deb54cb465eb87d40e51b197e";

    const supply = new BigNumber.BigNumber(100 * 10 ** 18);
    const parsedSupply = new BigNumber.BigNumber(supply.toString());

    const result = await natToken.balanceOf(testAddress);
    const parsedResult = new BigNumber.BigNumber(result.toString());

    // assert
    expect(result._isBigNumber);
    expect(!result.isNegative);
    expect(parsedSupply <= parsedResult);
  });
});
