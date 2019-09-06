pragma solidity ^0.4.24;

contract Bet{
    address owner;
    string public choice1;
    uint public amt1;
    string public choice2;
    uint public amt2;
    string public winner;
    uint public winningAmt;
    uint public transferAmt;
    
    
    constructor() public// to initialize the smart contract deployer
    {
        owner=msg.sender;
    }
    
    function  setChoice(string  _choice1,string  _choice2) public// to get choice 
    {
        choice1=_choice1;
        choice2=_choice2;
        
    }
    
    struct bidders{
        
        address name;
        uint amt;
        string choice;
    }
    
    
    mapping(address=>uint) public store1;//to store adress and thier corresponding value
    mapping(address=>string) public store2;//to store address and its corresponding choice
    
    bidders [] public bid;
    
    ///enter choice1 or choice 2
    function bidCrypto(string _choice) payable public //function to bit crypto and input choice
    {
        require(msg.value>0);
        
        if(store1[msg.sender]==0)
        {
        bid.push(bidders({
            name : msg.sender,
            amt:msg.value,
            choice:_choice
        }));
        store1[msg.sender]=msg.value;//stores the crypto send
        store2[msg.sender]=_choice;//stores the choice
        }
        else
        {
            store1[msg.sender]+=msg.value;
            
        }
        if(keccak256(abi.encodePacked(_choice))==keccak256(abi.encodePacked(choice1))) //to store the amount bid on each choice
        {amt1+=msg.value;}
        else
        {amt2+=msg.value;}
        
       // uint totalAmt=amt1+amt2;
        

    }
    
    function setWinner(string _winner) public {// it is set by the owner 
        require(msg.sender==owner);
        winner=_winner;
        if(keccak256(abi.encodePacked(winner))==keccak256(abi.encodePacked(choice1))) winningAmt=amt1;
        else winningAmt=amt2;
        
    }
    
    function knowResult() public payable{//when the user clicks to see result, if his choice matches with the winner,appropriate amount of 
                                        //crypto is send to his/her account. The reward amount depends on amount bid by him as well as 
                                        //how fast he or she ehcekcs the result.
        
        if(keccak256(abi.encodePacked(winner))==keccak256(abi.encodePacked(store2[msg.sender])))
        {
            transferAmt=(uint)(winningAmt-store1[msg.sender]);
            winningAmt=(uint)(winningAmt-store1[msg.sender]);
            msg.sender.transfer(store1[msg.sender]+transferAmt);
            transferAmt=0;
            store1[msg.sender]=0;
            
        }
        else store1[msg.sender]=0;
        
    }
        
    function resetAll() public//it is used to reset the values for a fresh bid
    {
        require(msg.sender==owner);
        choice1="";
        choice2="";
        amt1=0;
        amt2=0;
        transferAmt=0;
        
        
    }
        
    } 
    
   
    
    
    
    
    
    
