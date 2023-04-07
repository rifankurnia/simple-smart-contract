pragma solidity ^0.5.0;

contract StorageContract {

    //storage variables
    uint public storedInteger = 0;
    address public whoChangedTheStoredInteger;
    address public contractCreator;

    //event declarations
    event storageChanged(uint newStoredInteger, address changedBy, uint previousStoredInteger);
    event multiplicationStored(bool wasTheMultiplicationStored, string reason);

    //contract creation
    constructor(address _contractCreator) public {
        contractCreator = _contractCreator;
    }

    //contract state query function
    function getStoredAddresses() public view returns(address, address) {
        return (contractCreator, whoChangedTheStoredInteger);
    }

    //contract state change function
    function setStoredInteger(uint newStoredInteger) public returns(bool) {
        if (newStoredInteger == storedInteger){
            return false;
        } else {
            uint previousStoredInteger = storedInteger;
            storedInteger = newStoredInteger;
            
            whoChangedTheStoredInteger = msg.sender;
            emit storageChanged(newStoredInteger, whoChangedTheStoredInteger, previousStoredInteger);
            return true;
        }
    }

    //pure function (does not interact with the contract state)
    function letsMultiple(uint numberToMultiple) public pure returns(uint){
        return numberToMultiple * 2;
    }

    //contract state change function
    function setStoredIntegerWithMultiplication(uint newStoredInteger) public payable {
        uint price = 1 wei;
        require(msg.value >= price, "Not enough cryptocurrency received");
        
        uint multipliedInteger = letsMultiple(newStoredInteger);
        bool stored = setStoredInteger(multipliedInteger);
        if (stored){
            emit multiplicationStored(true, "Stored successfully");
        } else {
            emit multiplicationStored(false, "Failed reserved number test");
        }
        
        uint excess = msg.value - price;
        if (excess > 0) {
            msg.sender.transfer(excess);
        }
    }
}
