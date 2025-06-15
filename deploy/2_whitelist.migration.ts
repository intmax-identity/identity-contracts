import { WhitelistManager__factory } from "@ethers-v6";
import { Deployer, Reporter } from "@solarity/hardhat-migrate";

export = async (deployer: Deployer) => {
  const whitelistManager = await deployer.deploy(WhitelistManager__factory);

  Reporter.reportContracts(["WhitelistManager", await whitelistManager.getAddress()]);
};
