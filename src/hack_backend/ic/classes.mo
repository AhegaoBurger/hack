import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Types "types";

class Proposal(){

    type Member = Types.Member;
    type Result<Ok, Err> = Types.Result<Ok, Err>;
    type HashMap<K, V> = Types.HashMap<K, V>;
    type Proposal = Types.Proposal;
    type ProposalContent = Types.ProposalContent;
    type ProposalId = Types.ProposalId;


    var nextProposalId : Nat64 = 0;
    let proposals = HashMap.HashMap<ProposalId, Proposal>(0, Nat64.equal, Nat64.toNat32);

    
    let members = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);


    public shared ({ caller }) func createProposal(content : ProposalContent) : async Result<ProposalId, Text> {
        switch (members.get(caller)) {
            case (null) {
                return #err("The caller is not a member - cannot create a proposal");
            };
            case (?member) {
                // Create the proposal and burn the tokens
                let proposal : Proposal = {
                    id = nextProposalId;
                    content;
                    creator = caller;
                    created = Time.now();
                    executed = null;
                    votes = [];
                    voteScore = 0;
                    status = #Open;
                };
                proposals.put(nextProposalId, proposal);
                nextProposalId += 1;
                return #ok(nextProposalId - 1);
            };
        };
    };

    public query func getProposal(proposalId : ProposalId) : async ?Proposal {
        return proposals.get(proposalId);
    };

    public query func getAllProposals() : async [Proposal] {
        return Iter.toArray(proposals.vals());
    };

};
