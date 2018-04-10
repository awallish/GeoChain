pragma solidity ^0.4.21;

contract LocationIncentive {  
    
    struct Incentive{
        string name;
        uint256 reward;
        uint256 winningNumber;
        uint256 currentVal;
    }
    
    mapping(string => Incentive) incentives;
    
    //event log_number(uint256 log); // Event
    event log_string(string log); //Event
    //event log_address(address log); //Event
    
    function () public payable { 
        // Fallback Function
    }
    
    function createIncentive(string tL, string name, uint256 r, uint wN) public payable {
        if(!(msg.value < r || r <= 0 || wN <= 0)) {
            incentives[tL] = Incentive(name, r, wN, 0);
            emit log_string("Success!");
        } else {
            emit log_string("Failure");
        }
    }
    
    function checkIn(string location) public {
        if(_null(incentives[location])){
            emit log_string("No incentive at this location!");
        } else {
            emit log_string(incentives[location].name);
            incentives[location].currentVal++;
            if(incentives[location].currentVal == incentives[location].winningNumber) {
                emit log_string("WIN");
                msg.sender.transfer(incentives[location].reward);
                delete incentives[location];
            }
        }
    }
    
    function _null(Incentive a) internal pure returns (bool) {
        if(a.reward == 0 && a.winningNumber == 0 && a.currentVal == 0) {
            return true;
        }
        return false;
    }
}
