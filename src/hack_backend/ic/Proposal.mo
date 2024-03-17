import Types "Types";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";
import Bool "mo:base/Bool";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Vector "mo:vector";


module {

    type Result<A, B> = Types.Result<A, B>;
    type ProposalT = Types.ProposalT;

    public class Proposal(proposalsMap: Map.Map<Nat, Vector.Vector<ProposalT>>){

        public func createProposal(cmtID: Nat, title: Text, description: Text, isTempCheck: Bool) : Result<ProposalT, Text> {
            
            var list = Vector.new<ProposalT>();
            var newProposalId = cmtID * 10000;

            switch(Map.get<Nat, Vector.Vector<ProposalT>>(proposalsMap, nhash, cmtID)) {
                case(null) { 
                    // does nothing because is going to create a new list
                };
                case(? proposalsList) { 

                    //if cmtID = 5
                    //and listSize = 10
                    //newProposalID = 50_011 
                    //this creates a range of 99999 proposals per community

                    let listSize = Vector.size(proposalsList);
                    newProposalId += listSize;

                };
            };

            let newProposal : ProposalT = {
                id = newProposalId;
                title;
                description;
                created = Time.now();
                executed = null; 
                voteScore = 0; // A score based on the votes
                status = #Open; 
                isTempCheck = isTempCheck;
            };


            Vector.add(list, newProposal);
            Map.set<Nat, Vector.Vector<ProposalT>>(proposalsMap, nhash, cmtID, list);

            return #ok(newProposal);
            
        };

        public func getAllProposalsByCmt(cmtID: Nat) : Result<[ProposalT], Text> {

            switch(Map.get<Nat, Vector.Vector<ProposalT>>(proposalsMap, nhash, cmtID)) {
                    case(null) { 
                        return #err("Community not found");
                    };
                    case(? proposalsList) { 
                        return #ok(Vector.toArray(proposalsList));
                    };
            }

        };
    };
};
