/* eslint-disable prettier/prettier */
import { expect } from "chai";

/* eslint-disable node/no-missing-import */
import { ethers } from "hardhat";
import { deployContract, MockProvider } from "ethereum-waffle";
import { Contract } from "ethers";
import multisigJson from "../artifacts/contracts/multisig/multisig.sol/MultisigWallet.json";
import { beforeEach } from "mocha";

describe("Multisig Contract", async () => {
    let multisig : Contract;
    let wallet;
    

    beforeEach(async ()=>{
        wallet = await new MockProvider().getWallets();
        let owners : Array<string> = [wallet[0].address, wallet[1].address , wallet[2].address,];
        multisig = await deployContract(wallet[0], multisigJson, [owners, 4]);
    })

    it("should deploy contract", async ()=>{
       console.log(multisig.address);
        
    });
});