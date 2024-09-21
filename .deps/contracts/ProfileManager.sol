// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IProfile.sol";

contract ProfileManager {
    

    address emailVerifier;


    struct ProfileDetails {
        address profileAddress;
        bytes32 verificationHash;
    }

    mapping (bytes32 => ProfileDetails) profiles;

    constructor(address _emailVerifier) {
        emailVerifier = _emailVerifier;
    }


    function updateEmailVerifier(address _newEmailVerifier) external {
        require(msg.sender == emailVerifier);
        emailVerifier = _newEmailVerifier;
    }   


    function setEmailHash(string memory _email, bytes32 _hash) public {
        require(msg.sender == emailVerifier, "Not Email Verifier!");
        bytes32 _emailId = keccak256(abi.encode(_email));
        ProfileDetails storage profileDetails = profiles[_emailId];
        profileDetails.verificationHash = _hash;
    } 

    function updateOwner(string memory _email, string memory _msgByEmail) public {
        bytes32 emailId = keccak256(abi.encode(_email));
        ProfileDetails storage profileDetails = profiles[emailId];
        
        require(getEmailHash(_email, _msgByEmail) == profileDetails.verificationHash, "Invalid Request!");
        IProfile(profileDetails.profileAddress).updateProfileOwner(msg.sender);
    }

    function getEmailHash(string memory _email, string memory _msg) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_email, _msg));
    }
}