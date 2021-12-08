// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    
    address admin = msg.sender;
    Token public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;
    
    event Xfereth(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
    
    mapping (address => uint256) private x_balances;

    constructor () ERC20("zyptoToken", "Zypto") {
        _mint(msg.sender, 10000000000 * (10 ** uint256(decimals())));
    }
	
    function TokenSale(Token _tokenContract, uint256 _tokenPrice) public {
        require(msg.sender == admin);
        tokenContract = _tokenContract;       
        tokenPrice = _tokenPrice;
    }
    
    function TransferToken(uint256 _numberOfTokens) public payable{
        require(msg.value == _numberOfTokens * tokenPrice);
        require(balanceOf(address(this)) >= _numberOfTokens);
        
        x_balances[msg.sender] -= msg.value;
        payable(admin).transfer(msg.value);
        
        _numberOfTokens = _numberOfTokens * 1000000000000000000;
        require(tokenContract.transfer(msg.sender, _numberOfTokens));
        tokensSold += _numberOfTokens;
        
        
        Xfereth(msg.sender,admin, msg.value);
    }
}