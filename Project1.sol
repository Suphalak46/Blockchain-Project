// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InheritanceDistributingSystem {
    address public owner;
    uint256 public poolBalance;
    bool public alive;

    struct Heir {
        address heirAddress;
        uint256 share;
        bool exists;
    }

    mapping(address => Heir) public heirs;
    address[] public heirAddresses;

    constructor() {
        owner = msg.sender; // เจ้าของสัญญาคือผู้ Deploy
        alive = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier isAlive() {
        require(alive == true, "The owner is not alive");
        _;
    }

    modifier isDeceased() {
        require(alive == false, "The owner is still alive");
        _;
    }

    // ฟังก์ชันเพิ่มเงินเข้ากองมรดก
    function addFunds() public payable onlyOwner {
        poolBalance += msg.value;
    }

    // ฟังก์ชันเพิ่มทายาท
    function addHeir(address _heirAddress, uint256 _share) public onlyOwner {
        require(_share > 0 && _share <= 100, "Share must be between 1 and 100");
        require(heirAddresses.length < 2, "Can only add 2 heirs");
        require(!heirs[_heirAddress].exists, "Heir already exists");

        Heir memory newHeir = Heir({
            heirAddress: _heirAddress,
            share: _share,
            exists: true
        });

        heirs[_heirAddress] = newHeir;
        heirAddresses.push(_heirAddress);
    }

    // ฟังก์ชันประกาศเจ้าของเสียชีวิต
    function declareDeceased() public onlyOwner {
        alive = false;
    }

    // ฟังก์ชันยืนยันการมีชีวิตอยู่
    function keepAlive() public onlyOwner {
        alive = true;
    }

    // ฟังก์ชันแจกจ่ายมรดก
    function distributeInheritance() public isDeceased {
        require(poolBalance > 0, "No funds in the pool");
        require(heirAddresses.length == 2, "Exactly 2 heirs are required");

        for (uint256 i = 0; i < heirAddresses.length; i++) {
            address heirAddr = heirAddresses[i];
            uint256 share = heirs[heirAddr].share;
            uint256 amount = (poolBalance * share) / 100;
            payable(heirAddr).transfer(amount);
        }

        poolBalance = 0; // รีเซ็ตกองมรดกหลังการแจก
    }

    // ฟังก์ชันดูเจ้าของ
    function getOwner() public view returns (address) {
        return owner; // คืนค่าที่อยู่ของเจ้าของ
    }
}
