pragma solidity ^0.4.24;
 
import "./ZombieFactory.sol";
 
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}
 
contract ZombieFeeding is ZombieFactory {
   
    KittyInterface kittyContract;
   
    modifier ownerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }
   
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }
   
    function _feedAndMultiply(uint _zombieId, uint _targetDna, string _species)
        internal 
        ownerOf(_zombieId) 
    {
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
    }
   
   
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        _feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
     
}