// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IProfile {
    
    event OwnerUpdated(address indexed newOwner);

    function updateProfileOwner(address _newOwner) external ;
}