// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    function buyTokens() public payable {
        require(
            yourToken.balanceOf(address(this)) >= (msg.value * tokensPerEth),
            "ERC20: transfer amount exceeds balance"
        );
        uint256 amountOfETH = msg.value;
        uint256 amountOfTokens = amountOfETH * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, amountOfETH, amountOfTokens);
    }

    function withdraw() public payable onlyOwner {
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to withdraw from vendor");
    }

    // ToDo: create a payable buyTokens() function:
    event SellToken(
        address seller,
        uint256 amountOfTokens,
        uint256 amountOfETH
    );

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function sellTokens(uint256 amount) public payable {
        // ToDo: create a sellTokens() function:
        yourToken.approve(address(this), amount);
        yourToken.transferFrom(msg.sender, address(this), amount);
        uint256 amountOfEth = amount / tokensPerEth;
        (bool sent, ) = msg.sender.call{value: amountOfEth}("");

        require(sent, "Failed to send ether  to  seller");
        emit SellToken(msg.sender, amount, amountOfEth);
    }
}
