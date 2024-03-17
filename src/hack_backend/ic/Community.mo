import Types "Types";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";

module {

    type Result<A, B> = Types.Result<A, B>;
    type CommunityT = Types.CommunityT;
    type ProposalT = Types.ProposalT;
    type MemberT = Types.MemberT;

    public class Community(communities: Map.Map<Nat, CommunityT>) {

        public func createCommunity(admin: Principal, smartContractAddr: Text, name: Text) : Result<CommunityT, Text> {

            var newID : Nat = 0;
            switch(Map.peek<Nat, CommunityT>(communities)) {
                case(null) {  };
                case(? (k,_)) { newID := k+1 };
            };

            let newCommunity : CommunityT = {
                id = newID;
                name;
                smartContractAddr;
                admin;
                members = [];
            };

            //if all the conditions are met (not implemented)
            Map.set<Nat, CommunityT>(communities, nhash, newID,  newCommunity);

            //maybe change to return the community
            return #ok(newCommunity);
        };

        public func getCommunity(id: Nat) : Result<CommunityT, Text> {
            switch(Map.get<Nat, CommunityT>(communities, nhash, id)) {
                    case(null) { return #err("Community not found"); };
                    case(? community) { return #ok(community)};
            }; 
        };

        public func getAllCommunities() : [CommunityT] {
            return Iter.toArray(Map.vals<Nat, CommunityT>(communities));
        };

        public func joinCommunity(cmtID: Nat, member: MemberT) : Result<CommunityT, Text> {
            
            switch(getCommunity(cmtID)) {
                case(#err(msg)) { return #err(msg) };
                case(#ok(cmt)) {

                    switch(Array.find<MemberT>(cmt.members, func _member = _member.id == member.id)) {
                        case(null) { 

                            let buffer : Buffer.Buffer<MemberT> = Buffer.fromArray(cmt.members);
                            buffer.add(member);
                            let newMembersList : [MemberT] = Buffer.toArray(buffer); 

                            let updatedCommunity : CommunityT = {
                                id = cmt.id;
                                name = cmt.name;
                                smartContractAddr = cmt.smartContractAddr;
                                admin = cmt.admin;
                                members = newMembersList;
                            };

                            Map.set<Nat, CommunityT>(communities, nhash, cmt.id,  updatedCommunity);
                            return #ok(updatedCommunity);
                        };
                        case(? member) { return #err("Member already exists")};
                    };

                };
            };

        }
      
    };
};