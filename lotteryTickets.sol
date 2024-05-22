// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > .01 ether, "Minimum ETH not met");
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players)));
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        address winner = players[index];
        payable(winner).transfer(address(this).balance);
        delete players; // Reset the players array
    }

    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
