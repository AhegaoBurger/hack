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
        votes: [Vote];
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

    public type VoteType = {
        #Yes;
        #No;
    };

    public type Vote = {
        member: Principal;
        vote: VoteType;
        votingPower: Int;
    };

    //
    // Community
    //
    public type CommunityT = {
        id : Nat;
        name : Text;
        smartContractAddr : Text;
        admin : Principal;
        members: [MemberT];
    };

    //
    // Eth
    //
    public type GetBalanceResponse = {
        id : Nat;
        jsonrpc : Text;
        result: Text
    }


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
