pragma solidity ^0.4.24;

contract dccAuction {
    
    struct voter {
        address voterAddress;
        uint tokenBought;
		mapping (bytes32 => uint) myVotes;
    }
    
    mapping (address => voter) public voters;
    mapping (bytes32 => uint) public hVote;
    
    bytes32[] public candidateNames;
    
    uint public tokenPrice;
    
    constructor(uint _tokenPrice) public
    {
        tokenPrice = _tokenPrice;
        
        candidateNames.push("iphone7");
        candidateNames.push("iphone8");
        candidateNames.push("iphoneX");
        candidateNames.push("galaxyS9");
        candidateNames.push("galaxyNote9");
        candidateNames.push("LGG7");
    }
    
    function buy() payable public returns (int) 
    {
        uint tokensToBuy = msg.value / tokenPrice;
        voters[msg.sender].voterAddress = msg.sender;
        voters[msg.sender].tokenBought += tokensToBuy;
    }
    
    function getHeighestVotesReceivedFor() view public returns (uint, uint, uint, uint, uint, uint)
    {
        return (hVote["iphone7"],
        hVote["iphone8"],
        hVote["iphoneX"],
        hVote["galaxyS9"],
        hVote["galaxyNote9"],
        hVote["LGG7"]);
    }

	function getMyVotes() view public returns (uint, uint, uint, uint, uint, uint)
	{
        return (voters[msg.sender].myVotes["iphone7"],
        voters[msg.sender].myVotes["iphone8"],
        voters[msg.sender].myVotes["iphoneX"],
        voters[msg.sender].myVotes["galaxyS9"],
        voters[msg.sender].myVotes["galaxyNote9"],
        voters[msg.sender].myVotes["LGG7"]);
	}
    
    function vote(bytes32 candidateName, uint tokenCountForVote) public
    {
        uint index = getCandidateIndex(candidateName);
        require(index != uint(-1));
        
        require(tokenCountForVote <= voters[msg.sender].tokenBought);
        		
		if(voters[msg.sender].myVotes[candidateName] == 0)
		    voters[msg.sender].myVotes[candidateName] = tokenCountForVote;
		else
		    voters[msg.sender].myVotes[candidateName] += tokenCountForVote;
		    
		if(hVote[candidateName] < voters[msg.sender].myVotes[candidateName])
			hVote[candidateName] = voters[msg.sender].myVotes[candidateName];

        voters[msg.sender].tokenBought -= tokenCountForVote;
    }
    
    function getCandidateIndex(bytes32 candidate) view public returns (uint)
    {
        for(uint i=0; i < candidateNames.length; i++)
        {
            if(candidateNames[i] == candidate)
            {
                return i;
            }
        }
        
        return uint(-1); 
    }
    
    function getCandidatesInfo() view public returns (bytes32[])
    {
        return candidateNames;
    }
    
    function getTokenPrice() view public returns(uint)
    {
        return tokenPrice;
    }
    
    function getTokenBought() view public returns(uint)
    {
        return voters[msg.sender].tokenBought;
    }
}