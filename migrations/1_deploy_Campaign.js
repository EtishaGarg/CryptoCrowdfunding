var CampaignFactory = artifacts.require("CampaignFactory");

module.exports = function(deployer, network, accounts) {
	const owner = accounts[0];
  deployer.deploy(CampaignFactory,20,owner);
};
