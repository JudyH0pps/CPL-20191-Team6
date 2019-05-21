pragma solidity >=0.4.0 <0.6.0;

contract Voting {

 // We use the struct datatype to store the voter information.
 struct voter {
  address voterAddress; // ��ǥ���� �ּ�, �ּ� �ڷ���
  uint tokensBought;  // ��ǥ�ڰ� ���� ��ū�� ����
  uint[] tokensUsedPerCandidate; // �ĺ����� ��ǥ�� ���� ��ū��
  /* We have an array of candidates initialized below.
   Every time this voter votes with her tokens, the value at that
   index is incremented. Example, if candidateList array declared
   below has ["Rama", "Nick", "Jose"] and this
   voter votes 10 tokens to Nick, the tokensUsedPerCandidate[1]
   will be incremented by 10.
   */
 }// �� ��ǥ�ڰ� �̷��� ����ü�� ������ �ȴ�.

 /* mapping is equivalent to an associate array or hash
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer which used to store the vote count
  */

 mapping (address => voter) public voterInfo;// ��ǥ�� ������ �ּҿ� ���� ��ȸ�� �� �ִ�.
 //��ǥ�� ���� ����ü�� �ּҰ� Ű�� �Ǿ� ��ǥ�ڰ� ���� �Ǵ� ����ü�� ����

 /* Solidity doesn't let you return an array of strings yet. We will use an array of bytes32
  instead to store the list of candidates
  */

 mapping (bytes32 => uint) public votesReceived;// ���� ��ǥ���� ���

 bytes32[] public candidateList; // �ĺ��� ����Ʈ

 uint public totalTokens; // Total no. of tokens available for this election �� ��ū ��
 uint public balanceTokens; // Total no. of tokens still available for purchase ���� ������ ��ū ��
 uint public tokenPrice; // Price per token  ��ū�� ����

 /* When the contract is deployed on the blockchain, we will initialize
  the total number of tokens for sale, cost per token and all the candidates
  */
 constructor(uint tokens, uint pricePerToken, bytes32[] memory candidateNames) public {
  candidateList = candidateNames; 
  totalTokens = tokens;//
  balanceTokens = tokens;
  tokenPrice = pricePerToken;
 }// ������, ��ū ���� ����, ���� �����Ͽ� �ϳ��� �ȸ��� �ʾ����Ƿ� �� ��ū��, ���Ű����� ��ū���� ������ token����

  //1. Users should be able to purchase tokens ��ū�� ������ �� �־�� �Ѵ�.
  //2. Users should be able to vote for candidates with tokens ��ū���� �ĺ��ڿ��� ��ǥ�� �� �־���Ѵ�.
  //3. Anyone should be able to lookup voter info ��ǥ�� ������ Ȯ���� �� �־�� �Ѵ�.
  function buy() payable public {//���� ����� �������� payable�� ����ؾ� �Ѵ�.
    uint tokensToBuy = msg.value / tokenPrice;// msg value�� ����ϸ� �̴��� �󸶳� ���´��� Ȯ�� (wei����)
    require(tokensToBuy <= balanceTokens);//����� ��ū�� ���� ���� �ȼ� �ִ� ��ū�� �纸�ٴ� �۾ƾ��Ѵ�.
    voterInfo[msg.sender].voterAddress = msg.sender;//msg.sender�� ��� ������ buy�Լ��� ȣ���޴��� �˷���  
    voterInfo[msg.sender].tokensBought += tokensToBuy;// ��ū�� �������� ������ ����ü�� ������ ��ū�� ���� �÷��� �Ѥ�
    balanceTokens -= tokensToBuy; // ���Ű����� ��ū�� �� ��ŭ�� ��ū��ŭ ������
  }
    function voteForCandidate(bytes32 candidate, uint tokens) public {
    // Check to make sure user has enough tokens to vote ��ǥ�� ���� ��ū�� ����� �����ϴ��� Ȯ��
    // Increment vote count for candidate ��ǥ�� Ƚ���� ����
    // Update the voter struct tokensUsedPerCandidate for this voter  ����ü�� ���� ������Ʈ
     //  ��ǥ�� �ĺ��� Ư�� �� �ƴ϶� ��� ��ū�� �� �ĺ��ڿ��� ��ǥ�� ������
    uint availableTokens = voterInfo[msg.sender].tokensBought - totalTokensUsed(voterInfo[msg.sender].tokensUsedPerCandidate);
   // ����ڰ� ������ ��ū���� ��ǥ�� ����� �� ��ū ���� �� ��
    require(tokens <= availableTokens, "You don't have enough tokens");// ��ū�� ������� ������ �ܰ�
    votesReceived[candidate] += tokens;
     
    if(voterInfo[msg.sender].tokensUsedPerCandidate.length == 0) {//�ʱ�ȭ
      for(uint i=0; i<candidateList.length; i++) {
        voterInfo[msg.sender].tokensUsedPerCandidate.push(0);
      }
    }
     
    uint index = indexOfCandidate(candidate);
    voterInfo[msg.sender].tokensUsedPerCandidate[index] += tokens;//�ش� �ĺ�����  
  }
   
  function indexOfCandidate(bytes32 candidate) view public returns(uint) {
    for(uint i=0; i<candidateList.length; i++) {
      if (candidateList[i] == candidate) {//�ĺ��� ����� �����鼭 �ش�Ǵ� ���� ������ �� index�� ��ȯ
        return i;
      }
    }
    return uint(-1);
  }

  function totalTokensUsed(uint[] memory _tokensUsedPerCandidate) private pure returns (uint) {//���ο����� ȣ���ϰ� �б� �����̹Ƿ� private view
    uint totalUsedTokens = 0;
    for(uint i=0; i<_tokensUsedPerCandidate.length; i++) {
      totalUsedTokens += _tokensUsedPerCandidate[i];// ��ǥ �� Ƚ�� üũ
    }
    return totalUsedTokens;
  } 
  function voterDetails(address user) view public returns (uint, uint[] memory) {//�ĺ��� ���� ��ȯ,��ǥ�� �ּҿ� ���� ������ ��ŭ�� ��ǥ�� ���� ����
    return (voterInfo[user].tokensBought, voterInfo[user].tokensUsedPerCandidate);
  }
   
  function tokensSold() public view returns (uint) {
    return totalTokens - balanceTokens; //��ū �󸶳� �ȾҴ°�
  }
   
  function allCandidates() public view returns (bytes32[] memory) {
    return candidateList;//�ĺ��� ����Ʈ ���
  }
   
  function totalVotesFor(bytes32 candidate) public view returns (uint) {
    return votesReceived[candidate];//�� �ĺ��� ���� ��ǥ�� ��ü ǥ��
  }
}
