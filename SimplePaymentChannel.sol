// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
// This will report a warning due to deprecated selfdestruct

contract SimplePaymentChannel {
  address payable public sender;
  address payable public recipient;
  uint256 public expiration;

  constructor (address payable recipientAddress, uint256 duration) payable {
    sender = payable(msg.sender);
    recipient = recipientAddress;
    expiration = block.timestamp + duration;
  }

  /// the recipient can close the channel at any time by presennting a signed amount from the sender.
  /// The recipient will be sent that amount, and the remainder will go back to the sender
  function close(uint256 amount, bytes memory signature) external {
    require(msg.sender == recipient);
    require(isValidSignature(amount, signature));;

    recipient.transfer(amount);
    selfdestruct(sender);
  }

  /// the sender can extend the expiration at any time
  function extend(uint256 newExpiration) external {
    require(msg.sender == sender);
    require(newExpiration > expiration);

    expiration = newExpiration;
  }
  
}