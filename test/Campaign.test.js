const assert = require('assert');
const Web3 = require('web3');
const web3 = new Web3('HTTP://127.0.0.1:7545'); 
const compiledFactory = require('../build/contracts/CampaignFactory.json');
const compiledCampaign = require('../build/contracts/Campaign.json');
const abiFactory = compiledFactory.abi;
const abiCampaign = compiledCampaign.abi;
const contract_address = '0x7680B4449c702028Ff06B75839027677486Be835';

let accounts;
let factory;
let campaignAddress;
let campaign;

beforeEach(async () => {
    accounts = await web3.eth.getAccounts();
    factory = await new web3.eth.Contract(abiFactory,contract_address);
    await factory.methods.createCampaign('100').send({from : accounts[0]});
    //campaign = await factory.methods.getDeployedCampaigns().call();

    [campaignAddress]= await factory.methods.getDeployedCampaigns().call();
    //campaign = factory.methods.deployedContracts(0).call();
    campaign = await new web3.eth.Contract(abiCampaign,campaignAddress);
    
});

describe('Campaigns', () => {

    it('checks the manager', async() =>{
        let manager = await campaign.methods.manager().call()
        console.log(manager)
        assert.equal(manager,accounts[0])
    });

    // it('allows people to contribute money and mark as contributor', async () => {
    //     await campaign.methods.contribute().send({
    //         value: '200',
    //         from : accounts[1]
    //     });
    //     const isContributor = await campaign.methods.approvers(accounts[1]).call();
    //     assert.equal(isContributor);
    // });
});