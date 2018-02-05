pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        // msg is always available
        // everywhere in the contract.
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        // sha3, block and now are global.
        return uint(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        address winnerAddress = players[index];
        winnerAddress.transfer(this.balance);

        // Reset the pool.
        players = new address[](0);
    }

    function returnEntries() public restricted {
        // Return money to everyone.
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

}
