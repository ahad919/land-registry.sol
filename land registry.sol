// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract RegistrationLand
{
    struct registrationLand
    {
        string Area;
        string City;
        string State;
        uint LandPrice;
        uint PropertyPID;
        address Owner;
    } 

    struct BuyerDetail
    {
        string Name;
        uint Age;
        string City;
        string CNIC;
        string Email;
    }

    struct SellerDetail
    {
        string Name;
        uint Age;
        string City;
        string CNIC;
        string Email;
    }

    struct LandInspectorDetail
    {
        address ID;
        string Name;
        uint Age;
        string Designation;
    }

    //mappings

    mapping(uint => registrationLand) public MappingOfLandDetails;
    mapping(address => BuyerDetail) public MappingOfBuyerDetails;
    mapping(address => SellerDetail) public MappingOfSellerDetails;
    mapping(address => LandInspectorDetail) public MappingOfLandInspectorDetails;
    mapping(address => bool) public BuyerIsVerify;
    mapping(address => bool) public SellerIsVerify;
    mapping(uint => bool) public LandIsVerify;

    address public LandInspectorAddress;

    constructor() payable
    {
        LandInspectorAddress = msg.sender;
    }

    modifier LandInspectorOnly()
    {
        require(msg.sender == LandInspectorAddress,"you are not land inspector");
        _;        
    }

    // function of register seller

    function SellerRegister(address , string memory NAME, uint AGE, string memory CITY, string memory CNIC, string memory Email) public
    {
        MappingOfSellerDetails[msg.sender] = SellerDetail( NAME, AGE, CITY, CNIC, Email);

        require(SellerIsVerify[msg.sender] == true,"please verify seller");
    }

    //function of verify seller

    function SellerVerify(address add) LandInspectorOnly() public
    {
        SellerIsVerify[add] = true;
    }

    //function of reject seller

    function SellerReject(address add ) LandInspectorOnly() public
    {
        SellerIsVerify[add] = false;
    }

    //function of register buyer

    function BuyerRegister(address addr, string memory NAME, uint AGE, string memory CITY, string memory CNIC, string memory Email) public
    {
        MappingOfBuyerDetails[addr] = BuyerDetail( NAME, AGE, CITY, CNIC, Email);

        require(BuyerIsVerify[msg.sender] == true,"please verify buyer");
    }

    //function of verify buyer

    function BuyerVerify(address addr) LandInspectorOnly() public
    {
        BuyerIsVerify[addr] = true;
    }

    //function of reject buyer

    function BuyerReject(address addr) LandInspectorOnly() public
    {
        BuyerIsVerify[addr] = false;
    }

    //function of land registration

    function LandRegister(uint _LandID, string memory Area, string memory City, string memory State, uint LandPrice, uint PropertyPID, address) public
    {
        MappingOfLandDetails[_LandID] = registrationLand( Area, City, State, LandPrice, PropertyPID, msg.sender);

        require(LandIsVerify[_LandID] == true,"please verify Land");
    }

    //function of land verify

    function LandVerify(uint _LandID) LandInspectorOnly() public
    {
        LandIsVerify[_LandID] = true;
    }

    //function of reject land

    function LandReject(uint _LandID) LandInspectorOnly() public
    {
        LandIsVerify[_LandID] = false;
    }

    // seller update

    function UpdateSeller(address addr, string memory Name_, uint Age_, string memory City_, string memory CNIC_, string memory Email_) public
    {
        MappingOfSellerDetails[addr].Name=Name_;
        MappingOfSellerDetails[addr].Age=Age_;
        MappingOfSellerDetails[addr].City=City_;
        MappingOfSellerDetails[addr].CNIC=CNIC_;
        MappingOfSellerDetails[addr].Email=Email_;
    }

    // buyer update

    function UpdateBuyer(address addr, string memory Name_, uint Age_, string memory City_, string memory CNIC_, string memory Email_) public
    {
        MappingOfBuyerDetails[addr].Name=Name_;
        MappingOfBuyerDetails[addr].Age=Age_;
        MappingOfBuyerDetails[addr].City=City_;
        MappingOfBuyerDetails[addr].CNIC=CNIC_;
        MappingOfBuyerDetails[addr].Email=Email_;
    }

    // get land details by landID

    function GetLandDetails(uint ID) public view returns (string memory, string memory, string memory, uint, uint)
    {
        return  
            ( MappingOfLandDetails[ID].Area,
            MappingOfLandDetails[ID].City,
            MappingOfLandDetails[ID].State,
            MappingOfLandDetails[ID].LandPrice,
            MappingOfLandDetails[ID].PropertyPID );
    }

    // check owner by landID

    function GetLandOwner(uint _LandID) public view returns(address)
    {
        return MappingOfLandDetails[_LandID].Owner;
    } 

    // get city by landID

    function GetLandCity(uint ID) public view returns (string memory)
    {
        return(MappingOfLandDetails[ID].City);
    }

    // get land price by landID

    function GetLandPrice(uint ID) public view returns (uint)
    {
        return(MappingOfLandDetails[ID].LandPrice);
    }

    // get area by landID

    function GetLandArea(uint ID) public view returns (string memory)
    {
        return(MappingOfLandDetails[ID].Area);
    }

    // function of register land inspector 

        function LandinspectorRegister(address ID, string memory NAME, uint AGE, string memory Designation) public
    {
        MappingOfLandInspectorDetails[msg.sender] = LandInspectorDetail(ID, NAME, AGE, Designation);
    }

    // buy land

    function BuyLand(uint _LandID) public payable
    {
        require(BuyerIsVerify[msg.sender] == true,"please verify buyer");
        require(LandIsVerify[_LandID] == true,"please verify land");
        payable(MappingOfLandDetails[_LandID].Owner).transfer(msg.value);
        require(msg.value >= 3 ether, "please pay me ether");
        MappingOfLandDetails[_LandID].Owner = msg.sender;
    }

    //transfer land

    function LandOwnerShipTransfer(uint _LandID, address newOwner) public
    {
        MappingOfLandDetails[_LandID].Owner = newOwner;
    }
}
