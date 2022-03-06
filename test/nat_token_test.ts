/* eslint-disable prettier/prettier */
import { expect } from "chai";

/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat";
import { deployContract, MockProvider } from "ethereum-waffle";
import contractJson from "../artifacts/contracts/nat_token.sol/NatToken.json";
import { Contract } from "ethers";

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

  describe("transfer , ", async () => {
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
      await expect(natToken.transfer(wallets[1].address, amount)).to.be
        .reverted;
    });
  });

  describe("transferFrom", async () => {
    it("should transfer from account 1 to account 2", async () => {
      // arrange
      // eslint-disable-next-line node/no-unsupported-features/es-builtins
      const amount: BigInt = BigInt(80 * 10 ** 18);

      // act
      await natToken.transferFrom(
        wallets[0].address,
        wallets[1].address,
        amount
      );

      // assert

      expect(
        ethers.utils.formatEther(await natToken.balanceOf(wallets[1].address))
      ).equals("80.0");
      expect(
        ethers.utils.formatEther(await natToken.balanceOf(wallets[0].address))
      ).equals("20.0");
    });

    it("should revert when transfer _from account has insufficient balance", async () => {
      // arrange
      // eslint-disable-next-line node/no-unsupported-features/es-builtins
      const amount: BigInt = BigInt(80 * 10 ** 18);

      // transfering 80NAT to wallets[1].address
      // balance of msg.sender , in this case wallets[0].address has 80NAT
      await natToken.transferFrom(
        wallets[0].address,
        wallets[1].address,
        amount
      );

      // assert
      // calling transfer with amount 80NAT should throw or revert with insufficient balance
      await expect(
        natToken.transferFrom(wallets[0].address, wallets[1].address, amount)
      ).to.be.reverted;
    });
  });

  // describe("confiscate", async () => {
  //   // act
  //   await natToken.confiscate(wallets[1].address);

  //   // assert
  //   expect(
  //     ethers.utils.formatEther(await natToken.balanceOf(wallets[1].address))
  //   ).equals("0.0");
  // });
});
