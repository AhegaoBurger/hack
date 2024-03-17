import serdeJson "mo:serde/JSON";
import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Types "../Types";

module {

    type GetBalanceResponse = Types.GetBalanceResponse;
    type Result<A, B> = Types.Result<A, B>;

    type User = {
        name: Text;
        id: Nat;
    };

    public func toGetBalanceResponse(json: Text) : Result<GetBalanceResponse, Text> {
        Debug.print(json);
        let jsonText = "{\"id\": 1, \"jsonrpc\": \"2.0\", \"result\": \"0x3cd28c9e8e000\"}";
        // Serde.JSON.fromText(jsonText, null)
        switch(serdeJson.fromText(jsonText, null)) {   
            case(#ok(blob)) { 

                let responseObj : ?GetBalanceResponse = from_candid(blob);
                switch(responseObj) {
                        case(? response) { return #ok(response); };
                        case(null) {return #err("Error converting candid to GetBalanceResponse")  };
                    };
                };
                
            case(#err(_)) { return #err("Error converting text to blob") };
        };
    };
};