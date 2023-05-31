// SPDX-Liscense-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract SimpleAuction {
  // Parameters of the auction. Times are either absolute unix timestamps (seconds since 1970-01-01)
  // or time periods in seconds.
  address payable public beneficiary;
  uint public auctionEndTime;


  // Current state of the auction.
  address public highestBidder;
  uint public highestBid;

  // Allowed withdrawls of previous bids
  mapping (address => uint) pendingReturns;

  // Set to true at the end, disallows any change.
  // By default initialzed to `false`.
  bool ended;

  // Events that will be emitted on changes.
  event HighestBidIncreased(address bidder, uint amount);
  event AuctionEnded(address winner, uint amount);

  // Errors that describe failures.

  // The triple-slash comments are so-called natspec comments
  // They will be shown when the user is aksed to confirm a
  // transaction or when an error is displayed.

  /// The auction has already ended.
  error AuctionAlreadyEnded();
  /// There is already a higher or equal bid.
  error BidNotHighEnough(uint highestBid);
  /// The auction has not ended yet.
  error AuctionNotYetEnded();
  /// The function auctionEnd has already been called.
  error AuctionEndAlreadyCalled();

  /// Create a simple auction with `biddingTime`
  /// seconds bidding time on behalf of the 
  /// beneficiary address `beneficiartAddress`
  constructor(uint biddingTime, address payable beneficiaryAddress) {
    beneficiary = beneficiaryAddress;
    auctionEndTime = block.timestamp + biddingTime;
  }

  /// Bid on the auction with the value sent together with this transaction
  /// The value will only be refunded if the auction is not won.
  function bid() external payable {
    // No arguments are required as all the info is already part of the transaction.
    // The keyword payable is required for the function to be able to recieved Ether.

    // Revert the call if bidding period is over
    if (block.timestamp > auctionEndTime) {
      revert AuctionAlreadyEnded();
    }
    // If bid is not higher, send the ether back. revert statement will revert
    //  all changes in this function execution including it having received the Ether.
    if (msg.value <= highestBid) {
      revert BidNotHighEnough(highestBid);
    }

    if (highestBid != 0) {
      // Sending back the Ether by simply using highestBidder.send(highestBid) is a security risk
      // because it could execute an untrusted contract.
      // It is alwways safer to let the recipients withdraw their Ether themselves.
      pendingReturns[highestBidder] += highestBid;
    }
    highestBidder = msg.sender;
    highestBid = msg.value;
  }
}