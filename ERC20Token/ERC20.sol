pragma solidity ^0.4.24;
 
contract TokenInterface {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
   
    function totalSupply() constant returns(uint256 totalSupply);
    function balanceOf(address _owner) constant returns(uint256 balance);
    function transfer(address _to, uint256 _value) returns(bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns(bool success);
    function approve(address _spender, uint256 _value) returns(bool success);
    function allowance(address _owner, address _spender) constant returns(uint256 remaining);
   
    string public constant name = "Token Name";
    string public constant symbol = "Tkn";
    uint8 public constant decimals = 18;
}
 
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
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }
 
  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }
 
  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}
 
 
contract Token is Ownable {
   
    string public constant name = "Token Name";
   
    string public constant symbol = "TKN";
   
    uint8 public constant decimals = 18;
   
    uint256 public totalSupply = 0;
   
    mapping (address => uint256) balances;
   
    mapping (address => mapping (address => uint256)) allowed;
   
    function balanceOf(address _owner) public view  returns (uint256 balance) {
        return balances[_owner];
    }
   
    function transfer(address _to, uint256 _value) public returns(bool success) {
        require(balanceOf(msg.sender) >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
   
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        require(_value <= allowed[_from][msg.sender]);
        require(balanceOf(_from) >= _value);
       
        balances[_from] -= _value;
        balances[_to] += _value;
       
        allowed[_from][msg.sender] -= _value;
       
        emit Transfer(_from, _to, _value);
        return true;
    }
   
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
   
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
   
    function _mint(address _to, uint256 _amount) internal canMint returns (bool) {
        totalSupply += _amount;
        balances[_to] += _amount;
        emit Mint(_to, _amount);
        return true;
    }
   
    function _withdrawal() onlyOwner private {
        owner.transfer(address(this).balance);
    }
   
    function finishBuy() onlyOwner public {
        mintingFinish = true;
        _withdrawal();
        _mint(owner, 10 ether);
    }
   
    function buyTokens(address _beneficiary) payable public {
        uint256 value = msg.value;
        _mint(_beneficiary, value);
    }
   
    function() external payable {
        buyTokens(msg.sender);
    }
   
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
   
    event Mint(address indexed _to, uint256 _value);
   
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
   
    bool public mintingFinish = false;
   
    modifier canMint() {
        require(!mintingFinish);
        _;
    }
   
}
 
contract TokenFactory {
   
    mapping (uint256 => address) public tokens;
   
    uint256 public tokensCount = 0;
   
    function createToken() {
        address newToken = new Token();
        Token(newToken).transferOwnership(msg.sender);
        tokens[tokensCount] = newToken;
        tokensCount++;
       
    }
     
}