pragma solidity >=0.4.0 <0.6.0;

contract Voting {
  
  // �ĺ��� ���
  bytes32[] public candidateList;
  // �ĺ��� ��ܰ� ��ǥ �� ������ ����
  mapping (bytes32 => uint8) public votesReceived;

  // �ĺ��� ��� �Լ�
  // �����ڰ� �Լ��� ����Ѵ�.
  constructor(bytes32[] memory candidateNames) public {
    candidateList = candidateNames;
  }
  
  // ��ǥ ��� �Լ�
  function voteForCandidate(bytes32 candidate) public {
    // �������� �ĺ��� �Է��� �˻� 
    require(validCandidate(candidate));
    // �ĺ��� ������ ��ǥ ���� 1 �ø���.
    votesReceived[candidate] += 1;
  }
  
  // �ĺ��� ��ǥ �� ���� �Լ� 
  function totalVotesFor(bytes32 candidate) view public returns(uint8) {
    // �������� �ĺ��� �Է��� �˻� 
    require(validCandidate(candidate));
    // ��ǥ �� ��ȯ
    return votesReceived[candidate];
  }
  
  // �ĺ��� ���� �˻� �Լ�
  // �������� �ĺ���(���� �̸�) ������ ��ܰ� �����Ѵ�.
  function validCandidate(bytes32 candidate) view public returns (bool) {
    for(uint i=0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return true;
      }
    }
    return false;
  }
  
}