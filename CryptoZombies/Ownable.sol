contract Ownable {
   
    address public owner;
   
    event OwnershipTransferred(
        address indexed preOwner,
        address indexed newOwner
    );
   
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