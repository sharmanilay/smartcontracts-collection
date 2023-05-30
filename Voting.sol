// SPDX-License-Identifier: MIT 
pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
  // This declares a new complex type which will be used for variables later, it represents a single voter.
  struct Voter {
    uint weight;
    bool voted;
    address delegate;
    uint vote;
  }

  struct Proposal {
    bytes32 name;
    uint voteCount;
  }

  address public chairperson;

  // This declates a state variable that stores a `Voter struct for each possible address.
  mapping(address => Voter) public voters;

  // A dynamically-sized array of `Proposal` structs.
  Proposal[] public proposals;

  // Create a new ballot to choose one of `proposalNames`

}