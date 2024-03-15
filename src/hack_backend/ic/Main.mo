import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import EvmRpc "../lib/Evm_rpc";

actor {

    type Result<A, B> = Result.Result<A, B>;

    stable let evmRPC = actor("xhcuo-6yaaa-aaaar-qacqq-cai") : actor {
            request : shared (EvmRpc.RpcService, Text, Nat64) -> async EvmRpc.RequestResult;
    };

  
    public query func greet(name : Text) : async Text {
        return "Hello, " # name # "!";
    };

    public shared query (msg) func whoami() : async Principal {
        return msg.caller;
    };

  
    public shared ({caller}) func getBalanceTokens() : async Result<Text, Text> {
        let apiKey : Text = "https://eth-sepolia.g.alchemy.com/v2/NRlM5XIU21Q7N-NKOILlZoS6LFrXb_ss";

        let flag : Text = "--wallet $(dfx identity get-wallet) --with-cycles";
        let cycles : Nat64 = 1000000000;

        let request : EvmRpc.HttpHeader = {value = "request"; name = "POST"};
        let url : EvmRpc.HttpHeader = {value = "url"; name = apiKey};
        let header : EvmRpc.HttpHeader = {value = "header"; name = "accept: application/json"};
        let header2 : EvmRpc.HttpHeader = {value = "header"; name = "content-type: application/json"};
        let data : EvmRpc.HttpHeader = {value = "--data"; name = "{\"id\":1,\"jsonrpc\":\"2.0\",\"params\":[\"0x0d7322ca364B01A7b6749BC50786D9b3f9340B04\",\"latest\"],\"method\":\"eth_getBalance\"}"};

        let headersArray : [EvmRpc.HttpHeader] = [request, url, header, header2, data];
        // let headersArray : [HttpHeader] = [data];


        let customRPCapi : EvmRpc.RpcApi = {
                url = apiKey;
                headers = ?headersArray;
        };

        let rpcService : EvmRpc.RpcService = #Custom(customRPCapi);

        switch(await evmRPC.request(rpcService, flag, cycles)) {
                
                case(#Err(error)) { 

                        switch(error) {
                                case(#JsonRpcError(msg)) { return #err(msg.message) };
                                case(#ProviderError(msg)) { 
                                        switch(msg) {
                                                case(#TooFewCycles(fewCyclesError)) { return #err("caller: " # Principal.toText(caller) #" expected: " # Nat.toText(fewCyclesError.expected) # " received: " # Nat.toText(fewCyclesError.received))  };
                                                case(#MissingRequiredProvider(_)) {  };
                                                case(#ProviderNotFound(_)) { };
                                                case(#NoPermission(_)) { };
                                        };
                                };
                                case(#ValidationError(msg)) { };
                                case(#HttpOutcallError(msg)) { };
                        };

                        return #err("ERROOO");
                };
                case(#Ok(msg)) {  
                        return #ok(msg);
                };
        }; 
    };

    public shared ({caller}) func  getBalanceNFT() : async Result<Text, Text> {
        return #err("to implement");
    };

 


}
