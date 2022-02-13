// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract CampaignFactory {
    Campaign[] public deployedContracts;

    function createCampaign(uint minimum) public {
        Campaign newCampaign = new Campaign(minimum, msg.sender);
        deployedContracts.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns(Campaign[] memory){
        return deployedContracts;
    }
}

contract Campaign {
    struct Request{
        string description;
        uint value;
        address payable recipient;
        bool complete;
        mapping (address => bool) approvals;
        uint approvalCount;
    }


    address public manager;
    uint public minimumContribution;
    mapping (address=>bool) public approvers;
    uint numRequests;
    mapping (uint => Request) public requests;
    // Request[] public requests;
    uint public approversCount;

    modifier onlyManager{
        require(msg.sender == manager, "You are not the manager");
        _;
    }

    constructor(uint minimum, address creator){
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable{
        require(msg.value > minimumContribution, "You should pay greater than minimumContribution amount");
        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string memory description, uint value, address payable recipient) public onlyManager{
        Request storage newRequest = requests[numRequests++];
        newRequest.description = description;
        newRequest.value = value;
        newRequest.recipient = recipient;
        newRequest.complete = false;
        newRequest.approvalCount = 0;
    }

    function approveRequest(uint requestNumber) public{
        require(approvers[msg.sender]==true, "You are not an approver");
        require(requests[requestNumber].approvals[msg.sender]==false, "You have already voted");
        requests[requestNumber].approvals[msg.sender] = true;
        requests[requestNumber].approvalCount++;
    }

    function finaliseRequest(uint requestNumber)public onlyManager{
        Request storage request = requests[requestNumber];
        require(request.complete == false, "Request already completed");
        require(request.approvalCount > (approversCount/2), "Not enough approvers");
        require(request.value <= address(this).balance, "Not enough funds");
        request.complete = true;
        request.recipient.transfer(request.value);
    }
}
