pragma solidity ^0.4.24;
 
import "./ZombieFeeding.sol";
 
contract ZombieBattle is ZombieFeeding {
   
    uint randNonce = 0;
    uint public attackVictoryProbability = 70;
   
    mapping(uint => uint) public ZombieIdToWin;
    mapping(uint => uint) public ZombieIdToLoss;
   
    function randMod(uint _mod) internal returns(uint) {
        randNonce++;
        return uint(keccak256(now, msg.sender, randNonce)) % _mod;
    }
   
    function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
       
        uint rand = randMod(100);
       
        if (rand <= attackVictoryProbability) {
            ZombieIdToWin[_zombieId]++;
            ZombieIdToLoss[_targetId]++;
            _feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            ZombieIdToLoss[_zombieId]++;
            ZombieIdToWin[_targetId]++;
        }
       
    }
   
}