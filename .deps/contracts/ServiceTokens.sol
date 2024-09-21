// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ServiceProviderProfile.sol";

contract ServiceTokens {
    
    address public serviceProvider;
    uint256 public supply;
    
    mapping(address => uint256) public balances;

    uint startPeriod;
    uint endPeriod;

    constructor(uint256 _supply, uint _startTime, uint _endTime) payable {
        serviceProvider = msg.sender;
        require(canCreateSlot(_startTime, _endTime), "Can not create this slot!");
        supply = _supply;  // 100 service tokens
        balances[serviceProvider] = supply;
    }

    function buyServiceTokens(uint256 _amount, bytes memory _settlementSignature, bytes32 settlementHash) external {
        require(isTokenLive(), "This token is no longer live!");
        require(balances[msg.sender] >= _amount, "Not enough tokens!");  // 100 service tokens = 1 token
        
        balances[msg.sender] -= _amount;  // 100 service tokens = 1 token 
        
        require(canCreateSlot(block.timestamp, block.timestamp), "Can not create this slot!");
    }

    function isTokenLive() public view returns(bool) {
        return block.timestamp < startPeriod;
    }

    function canCreateSlot(uint _startTime, uint _endTime) public view returns (bool) {
        ServiceProviderProfile serviceProviderProfile = ServiceProviderProfile(serviceProvider);
        uint256 totalSlots = serviceProviderProfile.slotsCreated();

        for (uint i = 0; i < totalSlots; i++) 
        {
            ServiceProviderProfile.WorkingSlot memory slot = serviceProviderProfile.getSlotById(i);
        
            if (
                (_startTime <= slot.startTime && _endTime >= slot.startTime) ||
                (_startTime <= slot.endTime && _endTime >= slot.endTime)
            )
                return false;
        }
        return true;
    }
}