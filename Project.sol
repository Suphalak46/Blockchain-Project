// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Inheritance {
    address owner;
    Heir[] heirs;

    constructor() {
        owner = msg.sender;
    }

    //1. put fund in smart contract ใส่กองทุนในสัญญาอัจฉริยะ
    function addFunds() payable public {
    }

    //2. view balance ดูยอดเงิน
    function viewFunds() public view returns(uint) {
        return address(this).balance;
    }

    //3. add structure heir เพิ่มทายาทโครงสร้าง
    struct Heir {
        address payable walletAddress;
        string name;
        uint percentage; // เปอร์เซ็นต์ของมรดกที่จะได้รับ
    }

    //3.2 add heir เพิ่มทายาท
    function addHeir(address payable walletAddress, string memory name, uint percentage) public {
        require(msg.sender == owner, "Only the owner can call this function");
        require(percentage > 0 && percentage <= 100, "Invalid percentage");
        require(totalPercentage() + percentage <= 100, "Total percentage exceeds 100");

        bool heirExists = false;

        for(uint i = 0; i < heirs.length; i++) {
            if(heirs[i].walletAddress == walletAddress) {
                heirExists = true;
                break;
            }
        }

        if(!heirExists) {
            heirs.push(Heir(walletAddress, name, percentage));
        }
    }

    //4. remove heir ลบทายาท
    function removeHeir(address payable walletAddress) public {
        require(msg.sender == owner, "Only the owner can call this function");

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

    //5. view heirs ดูทายาท
    function viewHeirs() public view returns (Heir[] memory) {
        return heirs;
    }

    // ฟังก์ชันคำนวณเปอร์เซ็นต์รวมของทายาท
    function totalPercentage() internal view returns (uint) {
        uint total = 0;
        for (uint i = 0; i < heirs.length; i++) {
            total += heirs[i].percentage;
        }
        return total;
    }

    //6. distribute inheritance แจกจ่ายมรดก
    function distributeInheritance() public {
        require(address(this).balance > 0, "Insufficient balance in the contract");
        require(totalPercentage() == 100, "Total percentage must equal 100");

        for (uint i = 0; i < heirs.length; i++) {
            uint amount = (address(this).balance * heirs[i].percentage) / 100;
            transfer(heirs[i].walletAddress, amount);
        }
    }

    // transfer money โอนเงิน
    function transfer(address payable walletAddress, uint amount) internal {
        walletAddress.transfer(amount);
    }
}
