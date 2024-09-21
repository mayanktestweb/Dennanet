// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IProfile.sol";
import "./Utils.sol";
import "./ServiceTokens.sol";


contract ServiceProviderProfile is IProfile {

    event WorkingSlotCreated(uint256 indexed stotId, uint256 startTime, uint256 endTime);

    struct Spend {
        bytes32 spendHash;
        bool settled;
    }

    struct Earning {
        bytes32 earningHash;
        bool settled;
    }

    struct WorkingSlot {
        uint256 startTime;
        uint256 endTime;
    }

    address profileManager;
    address owner;

    uint256 addedBalance = 0;

    uint32 totalEarnings = 0;
    uint32 totalSpends = 0;

    mapping (uint256 => Spend) spends;
    mapping (uint256 => Earning) earnings;

    uint256 public slotsCreated;
    mapping (uint256 => WorkingSlot) public slots;


    constructor(address _profileManager) {
        profileManager = _profileManager;
    }


    function updateProfileOwner(address _newAddress) external {
        require(msg.sender == profileManager, "Not Profile Manager!");
        owner = _newAddress;
        emit OwnerUpdated(_newAddress);
    }

    function addWorkingSlot(uint256 _startTime, uint256 _endTime) public {
        require(_startTime < _endTime, "Start time must be before end time");
        ServiceTokens serviceTokens = ServiceTokens(msg.sender);
        require(serviceTokens.serviceProvider() == address(this));
        uint256 slotId = slotsCreated;
        slotsCreated++;
        slots[slotId] = WorkingSlot(_startTime, _endTime);
        emit WorkingSlotCreated(slotId, _startTime, _endTime);
    }

    function getSlotById(uint256 _slotId) public view returns (WorkingSlot memory)  {
        return slots[_slotId];
    }
}