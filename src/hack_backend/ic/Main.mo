import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import EvmRpc "../lib/Evm_rpc";
import Cycles "mo:base/ExperimentalCycles";
import Nat16 "mo:base/Nat16";
import Iter "mo:base/Iter";
import Proposal "Proposal";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";
import Types "types";
import Community "Community";


actor {

    let CommunityObj = Community.Community();
    type Proposal = Proposal.Proposal;
    type Result<A, B> = Types.Result<A, B>;
    type CommunityT = Types.Community;

    stable let evmRPC = actor("xhcuo-6yaaa-aaaar-qacqq-cai") : actor {
            request : shared (EvmRpc.RpcService, Text, Nat64) -> async EvmRpc.RequestResult;
    };

    //Main keeps state of all of the communities
    let communities = Map.new<Nat, CommunityT>(); //stable map
    let proposalsByCommunity = Map.new<Nat, Proposal.Proposal>(); //stable map
    stable var nextCommunityID : Nat = 0;


  
    public query func greet(name : Text) : async Text {
        return "Hello, " # name # "!";
    };

    public shared query (msg) func whoami() : async Principal {
        return msg.caller;
    };

    /*
    - creates a Community
    - should check if the caller is the owner of the contract (not done)
    - should check if already exists a community with that contract (not done)
    */
    public shared func createCommunity(smartContractAddr: Text, name: Text) : async Result<Text, ()> {

        Cycles.add(100000000000);
       
        let newCommunity : CommunityT = await CommunityObj.createCommunity(nextCommunityID, smartContractAddr, name);

        //if all the conditions are met
        Map.set<Nat, CommunityT>(communities, nhash, nextCommunityID,  newCommunity);

        nextCommunityID += 1;
        //maybe change to return the community
        return #ok("Created Commmunity " # Nat.toText((nextCommunityID-1)) # " with name: " # name # ", address: " # smartContractAddr);
    };

    public shared query func getCommunity(id: Nat) : async Result<CommunityT, Text> {
        switch(Map.get<Nat, CommunityT>(communities, nhash, id)) {
                case(null) { return #err("Community not found"); };
                case(? community) { return #ok(community)};
        }; 
    };

    public shared query func getAllCommunities() : async [CommunityT] {
        return Iter.toArray(Map.vals<Nat, CommunityT>(communities));
    };

  
    public shared func getBalanceTokens() : async Result<Text, Text> {
        let url : Text = "https://eth-mainnet.g.alchemy.com/v2/NRlM5XIU21Q7N-NKOILlZoS6LFrXb_ss";
        let payload : Text = "{\"id\":1,\"jsonrpc\":\"2.0\",\"params\":[\"0x0d7322ca364B01A7b6749BC50786D9b3f9340B04\",\"latest\"],\"method\":\"eth_getBalance\"}";
        let maxbytes : Nat64 = 2000;

        let customRPCapi : EvmRpc.RpcApi = {
                url = url;
                headers = null;
        };

        let rpcService : EvmRpc.RpcService = #Custom(customRPCapi);

        Cycles.add(30_000_000_000_000);

        switch(await evmRPC.request(rpcService, payload, maxbytes)) {
                
                case(#Err(error)) { 
                        switch(error) {
                                case(#JsonRpcError(msg)) { return #err("JsonRpcError: " # msg.message) };
                                case(#ProviderError(msg)) { 
                                    switch(msg) {
                                            case(#TooFewCycles(fewCyclesError)) { return #err("expected: " # Nat.toText(fewCyclesError.expected) # " received: " # Nat.toText(fewCyclesError.received))  };
                                            case(#MissingRequiredProvider(errorMessage)) { return #err("MissingRequiredProvider") };
                                            case(#ProviderNotFound(errorMessage)) {return #err("ProviderNotFound") };
                                            case(#NoPermission(errorMessage)) {return #err("NoPermission") };
                                    };
                                };
                                case(#ValidationError(msg)) { return #err("ValidationError")};
                                case(#HttpOutcallError(httpError)) { 
                                    switch(httpError) {
                                      case(#IcError(icError)) { 

                                          var errorCode : Text = "";
                                          switch(icError.code) {
                                            case(#NoError(_)) { errorCode := "NoError" };
                                            case(#CanisterError(_)) {errorCode := "CanisterError" };
                                            case(#SysTransient(_)) {errorCode := "SysTransient" };
                                            case(#DestinationInvalid(_)) {errorCode := "DestinationInvalid" };
                                            case(#Unknown(_)) {errorCode := "Unknown" };
                                            case(#SysFatal(_)) {errorCode := "SysFatal" };
                                            case(#CanisterReject(_)) {errorCode := "CanisterReject" };

                                          };
                                          return #err("Code: " # errorCode # " message: " # icError.message);
                                      };
                                      case(#InvalidHttpJsonRpcResponse(invalidHttpError)) {
                                          return #err("Status: " # Nat16.toText(invalidHttpError.status) # " body: " # invalidHttpError.body);
                                      };
                                    };
                                };
                        };

                };
                case(#Ok(msg)) { 
                    return #ok(msg);
                };
        }; 
    };

    // public shared func  getBalanceNFT() : async Result<Text, Text> {
    //     return #err("to implement");
    // };

 


}
