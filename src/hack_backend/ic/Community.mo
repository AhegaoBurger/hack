import Types "types";



module {

    type Result<A, B> = Types.Result<A, B>;
    type CommunityT = Types.Community;

    public class Community() {

        public func createCommunity(id: Nat, smartContractAddr: Text, name: Text) : async CommunityT {

            let newCommunity : CommunityT = {
                id;
                name;
                smartContractAddr;
            };

            //maybe change to return the community
            return newCommunity;
        };
       
    };
};