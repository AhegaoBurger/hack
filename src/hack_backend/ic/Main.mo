import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import EvmRpc "../lib/Evm_rpc";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat8 "mo:base/Nat8";
import Proposal "Proposal";
import Map "mo:map/Map";
import Types "Types";
import Community "Community";
import Vector "mo:vector";
import HandleError "utilities/HandleError";
import MemberState "MemberState";
import JsonConverter "utilities/JsonConverter";
import Hex "utilities/Hex";
import Binary "utilities/Binary";
import { nhash } "mo:map/Map";



actor {

    Cycles.add(30_000_000_000_000);

    //
    // TYPES
    //
    type Result<A, B> = Types.Result<A, B>;
    type ProposalT = Types.ProposalT;
    type CommunityT = Types.CommunityT;
    type MemberT = Types.MemberT;
    type RequestResult = EvmRpc.RequestResult;
    //
    // Canisters
    //
    stable let evmRPC = actor("xhcuo-6yaaa-aaaar-qacqq-cai") : actor {
            request : shared (EvmRpc.RpcService, Text, Nat64) -> async EvmRpc.RequestResult;
    };

    //
    // State Variables
    //
    stable let communities = Map.new<Nat, CommunityT>(); //stable map
    stable let proposalsByCommunity = Map.new<Nat, Vector.Vector<ProposalT>>(); //stable map
    stable let members = Map.new<Principal, MemberT>();

    //
    // Class Objects
    //
    let cmtObj = Community.Community(communities);
    let proposalsObj = Proposal.Proposal(proposalsByCommunity);
    let membersObj = MemberState.MemberState(members);


    //
    // EVM RPC variables
    //
    let networkLink = "https://eth-mainnet.g.alchemy.com/v2/";
    let apiKey = "NRlM5XIU21Q7N-NKOILlZoS6LFrXb_ss/";
    let url = networkLink # apiKey;

    let maxbytes : Nat64 = 1000;

    //
    // Member
    //
    public shared ({caller}) func login(icID: Text, walletAddress: Text) : async Result<Text, Text> {
        
        //a malicious user cannot says that is another user
        //but is still able to use walletAddress from another user
        if (caller != Principal.fromText(icID)) {
            return #err("Caller is not the same has the IC provided");
        };

        //this call is called to verify the amount of tokens of the wallet address
        //but the walletAddress is not being validated
        switch(await getBalance(walletAddress)) {
            case(#ok(responseJSON)) { 
                
                //get the tokens amount
                switch(JsonConverter.toGetBalanceResponse(responseJSON)) {
                    case(#err(msg)) { return #err(msg) };
                    case(#ok(responseJson)) { 
                        Debug.print(responseJson.result);

                        //not working
                        // switch(Hex.decode(responseJson.result)) {
                        //     case(#ok(array)) {
                        //         Debug.print(Nat64.toText(Binary.BigEndian.toNat64(array)));
                        //     };
                        //     case(#err(_)) { Debug.print("error converting to binary")};
                        // };
                    };
                };

                //TO DO convert hex to decimal
                
                let weiAmount = 10 ** 15 + 7 ** 13; //harcoded for now - in wei
                Debug.print(Nat.toText(weiAmount));
                
                switch(membersObj.login(caller, walletAddress, weiAmount)) {
                    case(#ok(member)) { return #ok("User " # Principal.toText(member.id) # " logged in") };
                    case(#err(errorMsg)) { return #err(errorMsg) };
                };

            };
            case(#err(errorMsg)) { 
                return #err(errorMsg);
            };
        }; 

    };

    //text because it might be called by the frontend
    public shared func getMember(memberID: Text) : async Result<MemberT, Text> {
        return membersObj.getMember(Principal.fromText(memberID));
    };

    //
    // Community
    //

    /*
    - creates a Community
    - should check if the caller is the owner of the contract (not done)
    - should check if already exists a community with that contract (not done)
    */
    public shared ({caller}) func createCommunity(smartContractAddr: Text, name: Text) : async Result<CommunityT, Text> {

        switch(cmtObj.createCommunity(caller, smartContractAddr, name)) {
            case(#ok(cmt)) { 
                let list = Vector.new<ProposalT>();
                Map.set<Nat, Vector.Vector<ProposalT>>(proposalsByCommunity, nhash, cmt.id, list);
                return #ok(cmt)
            };
            case(#err(error)) { return #err(error) };
        }; 
    };

    public shared query func getCommunity(id: Nat) : async Result<CommunityT, Text> {
        switch(cmtObj.getCommunity(id)) {
            case(#ok(cmt)) { return #ok(cmt) };
            case(#err(error)) { return #err(error) };
        };
    };

    public shared query func getAllCommunities() : async [CommunityT] {
        return cmtObj.getAllCommunities();
    };

    public shared ({ caller }) func joinCommunity(cmtID: Nat) : async Result<CommunityT, Text> {
    
        switch(membersObj.getMember(caller)) {
            case(#err(msg)) { return #err(msg) };
            case(#ok(member)) {
                cmtObj.joinCommunity(cmtID, member);
            };
        };

    };
    
    //
    // Proposals
    //
    public shared func createProposal(cmtID: Nat, title: Text, description: Text) : async Result<ProposalT, Text> {

        switch(cmtObj.getCommunity(cmtID)) {
            case(#err(msg)) { return #err(msg) };
            case(#ok(cmt)) {
                switch(proposalsObj.createProposal(cmt.id, title, description, false)) {
                    case(#ok(proposal)) { return #ok(proposal) };
                    case(#err(error)) { return #err(error) };
                }; 
            };
        };
        
    };

    public shared query func getAllProposalsByCmt(cmtID: Nat) : async Result<[ProposalT], Text> {
        switch(proposalsObj.getAllProposalsByCmt(cmtID: Nat)) {
            case(#err(msg)) { return #err(msg) };
            case(#ok(list)) { return #ok(list) };
        };
    };

    public shared ({caller}) func voteProposalByCmt(cmtID: Nat, proposalID: Nat, vote: Bool) : async Result<ProposalT, Text> {

        
        switch(await getCommunity(cmtID)) {
            case(#ok(cmt)) { 

                switch(membersObj.getMember(caller)) {
                    case(#err(msg)) { return #err(msg) };
                    case(#ok(member)) {
                        return proposalsObj.voteProposalByCmt(cmt, proposalID, member, vote);
                    };
                };


            };
            case(#err(msg)) { return #err(msg)};
        };

    };

  
    //
    // Ethereum integration
    //
    public shared func getBalance(walletAddress: Text) : async Result<Text, Text> {
        // 0x0d7322ca364B01A7b6749BC50786D9b3f9340B04
        let payload : Text = "{\"id\":1,\"jsonrpc\":\"2.0\",\"params\":[\"" # walletAddress # "\",\"latest\"],\"method\":\"eth_getBalance\"}";

        let customRPCapi : EvmRpc.RpcApi = {
                url = url;
                headers = null;
        };

        let rpcService : EvmRpc.RpcService = #Custom(customRPCapi);

        Cycles.add(30_000_000_000_000);

        let res : RequestResult = await evmRPC.request(rpcService, payload, maxbytes);
        switch(res) {
                case(#Err(error)) { 
                        return(#err(HandleError.handleError(error)));
                };
                case(#Ok(msg)) { 
                    return #ok(msg);
                };
        }; 
    };

    public query func greet(name : Text) : async Text {
        return "Hello, " # name # "!";
    };

    public shared query (msg) func whoami() : async Principal {
        return msg.caller;
    };

}
