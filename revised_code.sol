//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Importing Ownable from OpenZeppelin for ownership management
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SendMeATip is Ownable {
    // Event emitted when a new tip is received
    event NewTip(address indexed tipper, string name);

    // Struct to store tip information
    struct Tip {
        address tipper;
        string name;
        uint256 value;
    }

    // Array to store all tips, made private for better encapsulation
    Tip[] private tips;

    // Constructor calls Ownable constructor with msg.sender as the initial owner
    constructor() Ownable(msg.sender) {}

    /**
     * @dev Fetches all stored Tips
     * @return An array of all Tips
     */
    function getTips() public view returns (Tip[] memory) {
        return tips;
    }

    /**
     * @dev Allows a user to give a tip to the contract owner in ETH
     * @param _name Name of the tipper
     */
    function giveTip(string memory _name) public payable {
        // Ensure the tip amount is greater than zero
        require(msg.value > 0, "Cannot tip for free!");
        // Add the new tip to the tips array
        tips.push(Tip(msg.sender, _name, msg.value));
        // Emit event for the new tip
        emit NewTip(msg.sender, _name);
    }

    /**
     * @dev Allows the owner to withdraw all tips from the contract
     * Uses the more secure 'call' method instead of 'send'
     * Implements the 'checks-effects-interactions' pattern
     */
    function withdrawTips() public onlyOwner {
        // Get the current balance of the contract
        uint256 amount = address(this).balance;
        // Transfer the entire balance to the owner
        (bool success, ) = owner().call{value: amount}("");
        // Check if the transfer was successful
        require(success, "Transfer failed.");
    }
}
