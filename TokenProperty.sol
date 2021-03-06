pragma solidity ^0.5.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";

contract CourtHouse is ERC721Full, Ownable {

    constructor() ERC721Full("Philadelphia Residential Properties", "PHI") public {}

    using Counters for Counters.Counter;

    Counters.Counter property_ids;// property_ids is the number identifier of a property

    address courthouse_clerk = msg.sender;//only gonverment officials able to tokenize 
    address payable buyer;// this variable stores buyer wallet address interested in purchasing property.
    uint purchasePrice;// this variable stores the purchase price of the property posted by the seller
    uint unlock_time; //add variable for startdate to be used after deployment instead of contract starting at deployment.
    uint public deposited;//
    uint total;//
    //all bools default to false;
    bool ended; // defaults to false, the sale has not ended.
    bool paid; // the total purchase has not been paid.
    bool deposit_paid;// deposit has not been paid.
  
    //a structure for a property record
    struct Property {
        address payable currentOwner;
        string locationAddress;
        uint sq_ft;
        string propertyType;
        uint last_Price;
    }

    mapping(uint => Property) public properties;// the list of properties mapped by 
    
    event PreviousPrice(uint property_id, string report_uri);
    
    //function for tokenizing property and transfering token to current owner (current owner is part of the )
    function tokenizeProperty(address payable _currentowner, string memory _locationAddress, uint _sq_ft, string memory _propertyType, uint _last_Price, string memory uri) public onlyOwner {
        property_ids.increment();
        uint property_id = property_ids.current();
        require(!_exists(property_id), "Property already Tokenized!");
        _mint(courthouse_clerk, property_id);
        _setTokenURI(property_id, uri);
        properties[property_id] =  Property(_currentowner, _locationAddress, _sq_ft, _propertyType, _last_Price);
    }
    
    //function for creating transaction 
    function createTX(address payable owner, address payable _buyer, uint _purchasePrice, uint property_id) public {
        properties[property_id].currentOwner = owner;
        buyer = _buyer;
        purchasePrice = _purchasePrice;
    }
    // check if funds for purchase price are available in buyer's wallet; use
    function proofOfFunds() public view returns(uint){
        return buyer.balance;//fix this function to show actual balance
    }//return true or false bool; 
    
    function depositPaid() internal {
        deposit_paid = true;}
    
    function totallyPaid() internal {
        paid = true;}
        
    
    function earnestMoney(uint deposit_expiration, uint deposit_basis_points, uint start_date) public payable {
        require(!deposit_paid, 'paid already');
        require(msg.sender ==  buyer, 'pending sale');
        require(unlock_time == start_date || unlock_time < start_date.add(deposit_expiration));
        require(msg.value == purchasePrice.mul(deposit_basis_points).div(10000), 'deposit must be exactly 3 percent');
        deposited = msg.value;
        
        depositPaid();
        //require only one deposit into contract.
    }
    
    
    function salePrice(uint _closing_date) public payable {
        require(!paid, 'paid already');
        require(msg.sender ==  buyer, 'pending sale');
        require(unlock_time == now.add(_closing_date));
        require(msg.value == purchasePrice.sub(deposited), 'incomplete total');
        total = msg.value.add(deposited);//use transfer
        
        totallyPaid();
    }
    //purchase price and terms(all cash!)
    //create start_date and closing_date function to clean up the code
    
    function withdraw(uint _closing_date, uint property_id) public {
        require(msg.sender == properties[property_id].currentOwner, 'you are not the owner');
        require(unlock_time == now.add(_closing_date), 'its not time yet');
        //might put this unlock_time in constructor.
        properties[property_id].currentOwner.transfer(deposited);
        ended = true;//make the sale final, check functionality
    }
    
    function lastPrice(uint property_id, string memory report_uri) public returns(uint) {
        require(!ended, "Sale is not final");
        properties[property_id].last_Price = purchasePrice;
        properties[property_id].currentOwner = buyer;
        emit PreviousPrice(property_id, report_uri);
        return properties[property_id].last_Price;
     }
}