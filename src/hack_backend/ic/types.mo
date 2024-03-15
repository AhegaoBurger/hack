import Time "mo:base/Time";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
module {

    public type Result<Ok, Err> = Result.Result<Ok, Err>;
    public type HashMap<Ok, Err> = HashMap.HashMap<Ok, Err>;

    public type Member = {
        adress : Text;
    };

    /////////////////
    // PROPOSALS //
    ///////////////
    public type ProposalId = Nat64;
    public type ProposalContent = {
        #ChangeManifesto : Text; // Change the manifesto to the provided text
        #AddGoal : Text; // Add a new goal with the provided text
    };
    public type ProposalStatus = {
        #Open;
        #Accepted;
        #Rejected;
    };


    public type Proposal = {
        id : Nat64; // The id of the proposal
        content : ProposalContent; // The content of the proposal 
        creator : Principal; // The member who created the proposal
        created : Time.Time; // The time the proposal was created
        executed : ?Time.Time; // The time the proposal was executed or null if not executed
        voteScore : Int; // A score based on the votes
        status : ProposalStatus; // The current status of the proposal
    };
};