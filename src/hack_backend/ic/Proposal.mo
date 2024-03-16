import Types "types";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";
import Buffer "mo:base/Buffer";
import Bool "mo:base/Bool";
import Time "mo:base/Time";


module {

    type Result<A, B> = Types.Result<A, B>;
    type ProposalT = Types.ProposalT;

    public class Proposal(proposalsMap: Map.Map<Nat, Buffer.Buffer<ProposalT>>){

        public func createProposal(cmtID: Nat, title: Text, description: Text, isTempCheck: Bool) : Result<ProposalT, Text> {
            
            var list = Buffer.Buffer<ProposalT>(3);
            var newProposalId = cmtID * 10000;


            switch(Map.get<Nat, Buffer.Buffer<ProposalT>>(proposalsMap, nhash, cmtID)) {
                case(null) { 
                    // does nothing because is going to create a new list
                };
                case(? proposalsList) { 

                    //if cmtID = 5
                    //and listSize = 10
                    //newProposalID = 50_011 
                    //this creates a range of 99999 proposals per community

                    let listSize = proposalsList.size();
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

            list.add(newProposal);
            Map.set<Nat, Buffer.Buffer<ProposalT>>(proposalsMap, nhash, cmtID, list);

            return #ok(newProposal);
            
        }
    };


};
