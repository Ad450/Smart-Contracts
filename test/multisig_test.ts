/* eslint-disable prettier/prettier */
import { expect } from "chai";

/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat";
import { deployContract, MockProvider } from "ethereum-waffle";
import { BigNumber, Contract } from "ethers";
import multisigJson from "../artifacts/contracts/multisig/multisig.sol/MultisigWallet.json";
import { beforeEach } from "mocha";

describe("Multisig Contract", async () => {
    let multisig : Contract;
    let wallet;
    let owners: Array<string>;

    
    
    beforeEach(async ()=>{
        wallet = await new MockProvider().getWallets();
        owners = [wallet[0].address, wallet[1].address , wallet[2].address,];
        multisig = await deployContract(wallet[0], multisigJson, [  owners ,3]);
       
    })

    it("should deploy contract", async ()=>{
       console.log(multisig.address);      
    });
});