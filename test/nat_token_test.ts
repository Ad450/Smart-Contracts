/* eslint-disable prettier/prettier */
import { expect } from "chai";

/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat";
import { deployContract, MockProvider } from "ethereum-waffle";
import contractJson from "../artifacts/contracts/nat_token.sol/NatToken.json";
import { Contract } from "ethers";

// describe("NatToken", () => {
//   const testAddress: string = "0xbda5747bfd65f08deb54cb465eb87d40e51b197e";
//   // const trialAccount = ethers.Wallet.createRandom();

//   let natToken: NatToken;
//   beforeEach(async () => {
//     const NatToken = await ethers.getContractFactory("NatToken");
//     natToken = await NatToken.deploy();
//     (await natToken).deployed();
//   });

//   describe("deploy contract", () => {
//     it("Should deploy contract", async function () {
//       console.log(`the address of natToken is ${natToken.address}`);
//     });
//   });

//   describe("optional functions", () => {
//     it("should return `NAT` as symbol of token", async () => {
//       // act
//       const result = await natToken.symbol();

//       // assert
//       expect(result).equal("NAT");
//     });

//     it("should return `Nat Token` as name of token", async () => {
//       // act
//       const result = await natToken.name();

//       // assert
//       expect(result).equals("Nat token");
//     });

//     it("should return 18 as decimal", async () => {
//       // act
//       const result = await natToken.decimals();

//       // assert
//       expect(result).equals(18);
//     });

//     it("should return totalSupply ", async () => {
//       // arrange
//       const supply = new BigNumber.BigNumber(100 * 10 ** 18);

//       // act
//       const result = await natToken.totalSupply();
//       const parsedResult = new BigNumber.BigNumber(result.toString());

//       // assert
//       assert(parsedResult.minus(supply).toString, "0");
//     });
//   });

//   describe("balanceOf", () => {
//     it("should revert when address is a zero address", async () => {
//       // assert
//       try {
//         await natToken.balanceOf("0");
//       } catch (error) {
//         expect(error).toString().includes("invalid address");
//       }

//       // expect(await natToken.balanceOf("0x"))
//       //   .throws(new Error())
//       //   .includes("invalid address");
//     });

//     it("should return a number between 0 and 100, 0 inclusive", async () => {
//       // arrange

//       const supply = new BigNumber.BigNumber((100 * 10 ** 18).toString());
//       const result = await natToken.balanceOf(testAddress);
//       const parsedResult = new BigNumber.BigNumber(result.toString());

//       // assert
//       expect(result._isBigNumber);
//       expect(!result.isNegative);
//       expect(supply <= parsedResult);
//     });
//   });

//   describe("transferFrom", () => {
//     it("should revert when address _from is a zero address", async () => {
//       // assert
//       try {
//         await natToken.transferFrom("0", testAddress, 100);
//       } catch (error) {
//         expect(error).toString().includes("invalid address");
//       }

//       // expect(await natToken.balanceOf("0x"))
//       //   .throws(new Error())   ethers.utils.formatEther(await natToken.balanceOf(wallets[0].address))
//         await natToken.transferFrom(testAddress, "0", 100);
//       } catch (error) {
//         expect(error).toString().includes("address not found");
//       }
//     });

//     it("should revert when balance of _from is insufficient", async () => {
//       const wallets = new MockProvider().getWallets();
//       const trialContract = await deployContract(wallets[0], contractJson);

//       const result = await trialContract.balanceOf(wallets[0].address);

//       console.log(ethers.utils.formatEther(result));
//     });
//   });
// });

describe("Nat Token", () => {
  let natToken: Contract;
  const wallets = new MockProvider().getWallets();
  beforeEach(async () => {
    natToken = await deployContract(wallets[0], contractJson);
  });

  it("should return a balance of 100NAT for deployer", async () => {
    // assert
    expect(
      ethers.utils.formatEther(await natToken.balanceOf(wallets[0].address))
    ).equals("100.0");
    // console.log(ethers.utils.formatEther(result));
  });

  it("should revert when balance of is called with address not found or address 0", async () => {
    // assert
    await expect(natToken.balanceOf("0")).to.be.reverted;
  });

  it("should transfer 50 NAT to wallet[1].address", async () => {
    // arrange
    // eslint-disable-next-line node/no-unsupported-features/es-builtins
    const amount: BigInt = BigInt(50 * 10 ** 18);

    // act
    await natToken.transfer(wallets[1].address, amount);

    expect(
      ethers.utils.formatEther(await natToken.balanceOf(wallets[1].address))
    ).equals("50.0");
    expect(
      ethers.utils.formatEther(await natToken.balanceOf(wallets[0].address))
    ).equals("50.0");
  });

  it("should revert when transfer _from account has insufficient balance", async () => {
    // arrange
    // eslint-disable-next-line node/no-unsupported-features/es-builtins
    const amount: BigInt = BigInt(80 * 10 ** 18);

    // transfering 80NAT to wallets[1].address
    // balance of msg.sender , in this case wallets[0].address has 80NAT
    await natToken.transfer(wallets[1].address, amount);

    // assert
    // calling transfer with amount 80NAT should throw or revert with insufficient balance
    await expect(natToken.transfer(wallets[1].address, amount)).to.be.reverted;
  });
});
