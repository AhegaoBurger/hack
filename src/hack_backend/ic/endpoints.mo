import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Debug "mo:base/Debug";
import System "lib/System";


module {

    public shared ({caller}) func  getBalanceTokens() : async Result<Text, Text> {
        return #err("to implement");
    };

    public shared ({caller}) func  getBalanceNFT() : async Result<Text, Text> {
        return #err("to implement");
    };


}