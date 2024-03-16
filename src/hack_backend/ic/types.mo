import Time "mo:base/Time";
import Result "mo:base/Result";
import Bool "mo:base/Bool";

module {

    public type Result<Ok, Err> = Result.Result<Ok, Err>;

    public type ProposalT = {
        id : Nat; 
        title : Text;
        description: Text;
        created : Time.Time;
        executed : ?Time.Time; 
        voteScore : Int; // A score based on the votes
        status : ProposalStatus; 
        isTempCheck : Bool;
        // content : ProposalContent; // The content of the proposal 
        // creator : Principal; // The member who created the proposal
    };

    public type CommunityT = {
        id : Nat;
        name : Text;
        smartContractAddr : Text;
    };

    public type ProposalStatus = {
        #Open;
        #Accepted;
        #Rejected;
    };

    // public type Member = {
    //     adress : Text;
    // };

    /////////////////
    // PROPOSALS //
    ///////////////
    // public type ProposalId = Nat64;
    // public type ProposalContent = {
    //     #ChangeManifesto : Text; // Change the manifesto to the provided text
    //     #AddGoal : Text; // Add a new goal with the provided text
    // };
    


    
};