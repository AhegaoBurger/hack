import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import EvmRpc "../lib/Evm_rpc";
import Cycles "mo:base/ExperimentalCycles";
import Nat16 "mo:base/Nat16";

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

  
    public shared func getBalanceTokens() : async Result<Text, Text> {
        let url : Text = "https://eth-mainnet.g.alchemy.com/v2/NRlM5XIU21Q7N-NKOILlZoS6LFrXb_ss";
        let payload : Text = "{\"id\":1,\"jsonrpc\":\"2.0\",\"params\":[\"0x0d7322ca364B01A7b6749BC50786D9b3f9340B04\",\"latest\"],\"method\":\"eth_getBalance\"}";
        let maxbytes : Nat64 = 1000000;

        let customRPCapi : EvmRpc.RpcApi = {
                url = url;
                headers = null;
        };

        let rpcService : EvmRpc.RpcService = #Custom(customRPCapi);

        Cycles.add(30_000_000_000_000);

        switch(await evmRPC.request(rpcService, payload, maxbytes)) {
                
                case(#Err(error)) { 

                        switch(error) {
                                case(#JsonRpcError(msg)) { return #err("AAAAAAA" # msg.message) };
                                case(#ProviderError(msg)) { 
                                    switch(msg) {
                                            case(#TooFewCycles(fewCyclesError)) { return #err("expected: " # Nat.toText(fewCyclesError.expected) # " received: " # Nat.toText(fewCyclesError.received))  };
                                            case(#MissingRequiredProvider(errorMessage)) { return #err("MissingRequiredProvider") };
                                            case(#ProviderNotFound(errorMessage)) {return #err("ProviderNotFound") };
                                            case(#NoPermission(errorMessage)) {return #err("NoPermission") };
                                    };
                                };
                                case(#ValidationError(msg)) { return #err("ValidationError")};
                                case(#HttpOutcallError(httpError)) { 
                                    switch(httpError) {
                                      case(#IcError(icError)) { 

                                          var errorCode : Text = "";
                                          switch(icError.code) {
                                            case(#NoError(_)) { errorCode := "NoError" };
                                            case(#CanisterError(_)) {errorCode := "CanisterError" };
                                            case(#SysTransient(_)) {errorCode := "SysTransient" };
                                            case(#DestinationInvalid(_)) {errorCode := "DestinationInvalid" };
                                            case(#Unknown(_)) {errorCode := "Unknown" };
                                            case(#SysFatal(_)) {errorCode := "SysFatal" };
                                            case(#CanisterReject(_)) {errorCode := "CanisterReject" };

                                          };
                                          return #err("Code: " # errorCode # " message: " # icError.message);
                                      };
                                      case(#InvalidHttpJsonRpcResponse(invalidHttpError)) {
                                          return #err("Status: " # Nat16.toText(invalidHttpError.status) # " body: " # invalidHttpError.body);
                                      };
                                    };
                                };
                        };

                };
                case(#Ok(msg)) {  
                        return #ok(msg);
                };
        }; 
    };

    public shared func  getBalanceNFT() : async Result<Text, Text> {
        return #err("to implement");
    };

 


}
