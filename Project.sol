// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Inheritance {
    address owner;
    Heir[] heirs;

    constructor(){
        owner = msg.sender;
    }

    //1. put fund in smart contract
    function addFunds() payable public {
    }

    //2. view balance
    function viewFunds() public view returns(uint){
        return address(this).balance;
    }

    //3. add structure heir
    struct Heir {
        address payable walletAddress;
        string name;
    }

    //3.2 add heir
    function addHeir(address payable walletAddress, string memory name) public {
        require(msg.sender == owner, "Only the owner can call this function");
        bool heirExists = false;

        if(heirs.length >= 1){
            for(uint i = 0; i < heirs.length; i++) {
                if(heirs[i].walletAddress == walletAddress) {
                    heirExists = true;
                }
            }
        }
        if(!heirExists) {
            heirs.push(Heir(walletAddress, name));
        }
    }

    //4. remove heir
    function removeHeir(address payable walletAddress) public {
        require(msg.sender == owner, "Only the owner can call this function");
        if(heirs.length > 0) {
            for(uint i = 0; i < heirs.length; i++) {
                if(heirs[i].walletAddress == walletAddress) {
                    for(uint j = i; j < heirs.length - 1; j++) {
                        heirs[j] = heirs[j + 1];
                    }
                    heirs.pop();
                    break;
                }
            }
        }
    }

    //5. view heirs
    function viewHeirs() public view returns (Heir[] memory) {
        return heirs;
    }

    //6. distribute inheritance
    function distributeInheritance() public {
        require(address(this).balance > 0, "Insufficient balance in the contract");
        if(heirs.length >= 1) {
            uint amount = address(this).balance / heirs.length;
            for(uint i = 0; i < heirs.length; i++) {
                transfer(heirs[i].walletAddress, amount);
            }
        }
    }

    // transfer money
    function transfer(address payable walletAddress, uint amount) internal {
        walletAddress.transfer(amount);
    }
}
