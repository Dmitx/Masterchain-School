pragma solidity ^0.4.24;
 
contract Ownable {
   
    address owner;
   
    constructor() public {
        owner = msg.sender;
    }
   
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
   
    function transferOwnership(address _newOwner) public onlyOwner{
        owner = _newOwner;
    }
   
}
 
contract BusinessCard is Ownable {
   
    mapping (uint256 => string) public data;
   
    function setData(uint256 _key, string _value) public onlyOwner {
        data[_key] = _value;
    }
}