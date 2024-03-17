import Map "mo:map/Map";
import Principal "mo:base/Principal";
import Bool "mo:base/Bool";
import Result "mo:base/Result";
import Types "Types";
import { phash } "mo:map/Map";


module {

    type MemberT = Types.MemberT;
    type Result<A, B> = Types.Result<A, B>;

    public class MemberState(members: Map.Map<Principal, MemberT>) {

        public func login(memberID: Principal, walletAddress: Text, weiAmount: Nat) : Result<MemberT, Text> {

            switch(Map.get<Principal, MemberT>(members, phash, memberID)) {
                case(null) { 
                    
                    //if user never logged in
                    //TO DO should call the checkWallet to check if another user already has that account
                    //Vulnerability: if a user never logged in, another user can log in with an account that is from the first user

                };
                case(? member) { 
                    if (member.walletAddr != walletAddress) {
                        return #err("User already logged in with another wallet address")
                    };
                };
            }; 

            let newMember : MemberT = {
                id = memberID;
                walletAddr = walletAddress;
                weiAmount = weiAmount;
            };

            Map.set<Principal, MemberT>(members, phash, memberID, newMember);
            return #ok(newMember);
        };

        private func checkWallet(memberID: Principal, walletAddress: Text) : Bool {
            //TO DO
            //check if this wallet already is from a user and if that user is the member;
            return false;
        };

        public func getMember(memberID: Principal) : Result<MemberT, Text> {
            switch(Map.get<Principal, MemberT>(members, phash, memberID)) {
                case(null) { #err("User not found") };
                case(? member) { return #ok(member) };
            };
        }

    };
}