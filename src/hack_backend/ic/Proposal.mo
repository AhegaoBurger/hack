import Types "Types";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";
import Bool "mo:base/Bool";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Vector "mo:vector";


module {

    type Result<A, B> = Types.Result<A, B>;
    type ProposalT = Types.ProposalT;
    type MemberT = Types.MemberT;
    type Vote = Types.Vote;
    type VoteType = Types.VoteType;
    type ProposalStatus = Types.ProposalStatus;
    type CommunityT = Types.CommunityT;


    public class Proposal(proposalsMap: Map.Map<Nat, Vector.Vector<ProposalT>>){

        public func createProposal(cmtID: Nat, title: Text, description: Text, isTempCheck: Bool) : Result<ProposalT, Text> {
            

            //burn member tokens

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
                votes = [];
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
            };
        };

        private func getProposalById(cmtID: Nat, proposalId: Nat) : Result<ProposalT, Text> {
            switch(getAllProposalsByCmt(cmtID)) {
                case(#ok(proposals)) { 

                    switch(Array.find<ProposalT>(proposals, func proposal = proposal.id == proposalId)) {
                        case(? p) { return #ok(p) };
                        case(null) { return #err("Proposal not found") };
                    };

                };
                case(#err(msg)) { return #err(msg) };
            };
        };

        public func voteProposalByCmt(cmt: CommunityT, proposalId: Nat, member: MemberT, voteValue: Bool) : Result<ProposalT, Text> {
        
            switch(getProposalById(cmt.id, proposalId)) {
                case(#err(msg)) { return #err(msg)};
                case(#ok(proposal)) { 

                    let voteType = switch(voteValue) {
                        case(true) { #Yes };
                        case(false) { #No };
                    };

                    let multiplier = switch(voteType) {
                        case(#Yes) { 1 };
                        case(#No) { -1 };
                    };

                    let vote : Vote = {
                        member = member.id;
                        vote = voteType;
                        votingPower = member.weiAmount * multiplier;
                    };

                    
                    let newVoteScore = proposal.voteScore + vote.votingPower;

                    let buffer : Buffer.Buffer<Vote> = Buffer.fromArray(proposal.votes);
                    buffer.add(vote);
                    let newVotesList : [Vote] = Buffer.toArray(buffer); 


                    //check if it needs to be executed and if is a temperature check

                    //if is executed sends something to the smart contract to make it execute

                    let executeBound : Int = 10 ** 16; //less then what the user has
                    var newStatus : ProposalStatus = #Open;
                    
                    if (newVoteScore >= executeBound) {
                        newStatus := #Accepted;

                        if (not proposal.isTempCheck) {
                            //execute
                        };
                    } else if (newVoteScore <= (executeBound*-1)) {
                        newStatus := #Rejected;
                    };

                    let newProposal : ProposalT = {
                        id = proposal.id; 
                        title = proposal.title;
                        description = proposal.description;
                        created = proposal.created;
                        executed = proposal.executed; 
                        voteScore = newVoteScore;
                        votes = newVotesList;
                        status = proposal.status; 
                        isTempCheck = proposal.isTempCheck;
                    };

                    
                    switch(Map.get<Nat, Vector.Vector<ProposalT>>(proposalsMap, nhash, cmt.id)) {
                        case(null) { return #err("Vector does not exist") };
                        case(? vector) { 
                            Vector.add(vector, newProposal);
                            Map.set<Nat, Vector.Vector<ProposalT>>(proposalsMap, nhash, cmt.id, vector);
                        };
                    };
                    
                    return #ok(newProposal);
                };
            };
        };

    };
};
