// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InheritanceDistributingSystem {

    address public owner;
    uint256 public poolBalance;
    mapping(address => bool) public heirs;  // รายชื่อทายาท
    address[] public heirsList;  // ใช้เพื่อเก็บรายชื่อทายาท
    bool public isAlive;  // สถานะว่าผู้ถือสัญญายังมีชีวิตหรือไม่

    constructor() {
        owner = msg.sender;  // ผู้ที่ deploy สัญญาจะเป็นผู้ถือสัญญา
        isAlive = true;  // ตั้งค่าเริ่มต้นว่าผู้ถือสัญญายังมีชีวิตอยู่
    }

    // ใส่เงินเข้าไปใน pool
    function putMoneyIntoPool() public payable {
        require(msg.sender == owner, "Only owner can add funds to the pool");
        poolBalance += msg.value;
    }

    // ดูยอดเงินใน pool
    function viewPoolBalance() public view returns (uint256) {
        return poolBalance;
    }

    // เพิ่มทายาท
    function addPerson(address _heir) public {
        require(msg.sender == owner, "Only owner can add heirs");
        require(!heirs[_heir], "This heir is already added");
        heirs[_heir] = true;
        heirsList.push(_heir);
    }

    // ลบทายาท
    function removePerson(address _heir) public {
        require(msg.sender == owner, "Only owner can remove heirs");
        require(heirs[_heir], "This heir is not in the list");
        heirs[_heir] = false;

        // เอาทายาทออกจาก list
        for (uint i = 0; i < heirsList.length; i++) {
            if (heirsList[i] == _heir) {
                heirsList[i] = heirsList[heirsList.length - 1];
                heirsList.pop();
                break;
            }
        }
    }

    // ดูรายชื่อทายาท
    function viewHeirs() public view returns (address[] memory) {
        return heirsList;
    }

    // แจกจ่ายมรดกให้กับทายาท
    function distributeInheritance() public {
        require(msg.sender == owner || !isAlive, "Only owner or if the owner is deceased can distribute inheritance");
        require(heirsList.length > 0, "No heirs added");
        require(poolBalance > 0, "No funds in the pool");

        uint256 share = poolBalance / heirsList.length;
        for (uint i = 0; i < heirsList.length; i++) {
            address payable heir = payable(heirsList[i]);
            heir.transfer(share);
        }

        poolBalance = 0;  // รีเซ็ตยอดเงินใน pool หลังการแจกจ่าย
    }

    // ฟังก์ชันบอกสถานะผู้ถือสัญญาว่ายังมีชีวิตอยู่
    function keepAlive() public {
        require(msg.sender == owner, "Only owner can update alive status");
        isAlive = true;
    }

    // ฟังก์ชันบอกว่าสถานะเจ้าของสัญญาไม่อยู่แล้ว
    function markDeceased() public {
        require(msg.sender == owner, "Only owner can declare as deceased");
        isAlive = false;
    }
}
