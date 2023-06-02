// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Purchase {
  uint public value;
  address payable public seller;
  address payable public buyer;

  enum State { Created, Locked, Release, Inactive }
  // The state variable has a default value of the first member, `State.created`
  State public state;

  modifier condition(bool condition_) {
    require(condition_);
    _;
  }  

}
