import Map "mo:map/Map";
import { nhash } "mo:map/Map";


actor class Community(_smartContractAddress: Text, _name: Text) {

    stable let smartContractAddress : Text = _smartContractAddress;
    stable let name : Text = _name;

    
    //change to <nat, proposal>
    let map = Map.new<Nat, Nat>();


};