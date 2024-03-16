import Types "types";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";

module {

    type Result<A, B> = Types.Result<A, B>;
    type CommunityT = Types.Community;

    public class Community(communities: Map.Map<Nat, CommunityT>) {

        public func createCommunity(smartContractAddr: Text, name: Text) : Result<CommunityT, Text> {

            var newID : Nat = 0;
            switch(Map.peek<Nat, CommunityT>(communities)) {
                case(null) {  };
                case(? (k,_)) { newID := k+1 };
            };

            let newCommunity : CommunityT = {
                id = newID;
                name;
                smartContractAddr;
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
       
    };
};