//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Pool is Ownable{
    uint256 public userBalance;

    function deposit() public onlyOwner{

    }

    function depositUser() public payable{
        userBalance += msg.value;
    }

    function rescureStuck() public onlyOwner{
        uint256 amount = address(this).balance;
        require(amount > 0, "Not enough ether");
        payable(owner()).transfer(amount);
    }

    function withdraw() public{
        
    }

    function getMessageHash(address _to, uint _amount, string memory _message, uint _nonce) public pure returns (bytes32){
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32){
        return keccak256(abi.encodePacked(_messageHash));
    }

    function verify(address _signer, address _to, uint _amount, string memory _message, uint _nonce, bytes memory signature) public pure returns (bool){
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }
    
    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v){
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))

            s := mload(add(sig, 64))

            v := byte(0, mload(add(sig, 96)))
        }
    }
}