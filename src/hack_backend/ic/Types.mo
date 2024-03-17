import Time "mo:base/Time";
import Result "mo:base/Result";
import Bool "mo:base/Bool";
import Text "mo:base/Text";
import Principal "mo:base/Principal";


module {

    public type Result<Ok, Err> = Result.Result<Ok, Err>;


    //
    // Proposals
    //
    public type ProposalT = {
        id : Nat; 
        title : Text;
        description: Text;
        created : Time.Time;
        executed : ?Time.Time; 
        voteScore : Int; // A score based on the votes
        status : ProposalStatus; 
        isTempCheck : Bool;
    };


    public type ProposalStatus = {
        #Open;
        #Accepted;
        #Rejected;
    };

    public type MemberT = {
        id : Principal;
        walletAddr : Text;
        weiAmount: Nat;
    };

    //
    // Community
    //
    public type CommunityT = {
        id : Nat;
        name : Text;
        smartContractAddr : Text;
    };


    // //
    // // Wallet
    // //
    // public type EthWallet = EthWallet.Address;
    // public type SignedPrincipal = EthWallet.SignedPrincipal;

    // public module Address {
    //     public type Address = Text;
    //     public let hash = Text.hash;
    //     public let equal = Text.equal;
    // };

    // public module EthWallet {
    //     public type Address = Address.Address;
    //     public type SignedPrincipal = Text;
    // };

};
