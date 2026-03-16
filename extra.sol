// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract ChallengeCommunalArray {
    // challenge: 
    // make an "admin" role, and a "member" role
    // admins can add members, but members cannot add other members or admins. 
    // admins have all the permissions of members
    // members can call some function to append a number to an array
    // anyone can access the array
    // admins can promote members
    
    mapping(address => bool) public members;
    mapping(address => bool) public admins; 
    uint256[] public communalArray;

    constructor(){
        admins[msg.sender] = true;
    }

    event MembershipUpdated(address, string);
    
    modifier canAdd(){
        require(members[msg.sender] || admins[msg.sender], "Not enough permissions");
        _;
    }

    modifier onlyAdmin(){
        require(admins[msg.sender], "Only admin can call this function");
        _;
    }

    function addMember(address _newMember) external onlyAdmin {
        require(!admins[_newMember], "User is already admin");
        members[_newMember] = true;
        emit MembershipUpdated(_newMember, "Member added.");
    }

    function promote(address _member) external onlyAdmin {
        require(members[_member], "Must be an existing member");
        admins[_member] = true;
        members[_member] = false;
        emit MembershipUpdated(_member, "Member promoted.");
    }

    function kick(address _member) external onlyAdmin {
        require(members[_member], "Must be an existing member");
        members[_member] = false;
        emit MembershipUpdated(_member, "Member kicked.");
    }
    
    function appendArray(uint256 _number) external canAdd {
        communalArray.push(_number);
        emit MembershipUpdated(msg.sender, "Communal array appended.");
    }

    function getWholeArray() external view returns (uint256[] memory) {
        return communalArray;
    }

}
