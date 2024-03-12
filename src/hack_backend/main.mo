import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor {

        type Result<A, B> = Result.Result<A, B>;
        public type HttpHeader = { value : Text; name : Text };
        public type RejectionCode = {
                #NoError;
                #CanisterError;
                #SysTransient;
                #DestinationInvalid;
                #Unknown;
                #SysFatal;
                #CanisterReject;
        };
        public type JsonRpcError = { code : Int64; message : Text };
        
        public type ProviderError = {
                #TooFewCycles : { expected : Nat; received : Nat };
                #MissingRequiredProvider;
                #ProviderNotFound;
                #NoPermission;
        };

        public type ValidationError = {
                #CredentialPathNotAllowed;
                #HostNotAllowed : Text;
                #CredentialHeaderNotAllowed;
                #UrlParseError : Text;
                #Custom : Text;
                #InvalidHex : Text;
        };

        public type HttpOutcallError = {
                #IcError : { code : RejectionCode; message : Text };
                #InvalidHttpJsonRpcResponse : {
                status : Nat16;
                body : Text;
                parsingError : ?Text;
                };
        };

        public type RpcError = {
                #JsonRpcError : JsonRpcError;
                #ProviderError : ProviderError;
                #ValidationError : ValidationError;
                #HttpOutcallError : HttpOutcallError;
        };

        public type RequestResult = { #Ok : Text; #Err : RpcError };


        public type RpcApi = { url : Text; headers : ?[HttpHeader] };

        public type EthSepoliaService = { #Alchemy; #BlockPi; #PublicNode; #Ankr };

        public type EthMainnetService = {
                #Alchemy;
                #BlockPi;
                #Cloudflare;
                #PublicNode;
                #Ankr;
        };

        public type RpcService = {
                #EthSepolia : EthSepoliaService;
                #Custom : RpcApi;
                #EthMainnet : EthMainnetService;
                #Chain : Nat64;
                #Provider : Nat64;
        };

        stable let evmRPC = actor("7hfb6-caaaa-aaaar-qadga-cai") : actor {
                request : shared (RpcService, Text, Nat64) -> async RequestResult;
        };

        public shared ({caller}) func  testRPC() : async Result<Text, Text> {

                let apiKey : Text = "https://eth-sepolia.g.alchemy.com/v2/NRlM5XIU21Q7N-NKOILlZoS6LFrXb_ss";
                let number : Nat64 = 1000;

                let flag : Text = "--wallet $(dfx identity get-wallet) --with-cycles";
                let cycles : Nat64 = 1000000000;

                let request : HttpHeader = {value = "request"; name = "POST"};
                let url : HttpHeader = {value = "url"; name = apiKey};
                let header : HttpHeader = {value = "header"; name = "accept: application/json"};
                let header2 : HttpHeader = {value = "header"; name = "content-type: application/json"};
                let data : HttpHeader = {value = "--data"; name = "{\"id\":1,\"jsonrpc\":\"2.0\",\"params\":[\"0x0d7322ca364B01A7b6749BC50786D9b3f9340B04\",\"latest\"],\"method\":\"eth_getBalance\"}"};

                let headersArray : [HttpHeader] = [request, url, header, header2, data];
                // let headersArray : [HttpHeader] = [data];


                let customRPCapi : RpcApi = {
                        url = apiKey;
                        headers = ?headersArray;
                };

                let rpcService : RpcService = #Custom(customRPCapi);

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
        
        public query func greet(name : Text) : async Text {
          return "Hello, " # name # "!";
        };

        public shared query (msg) func whoami() : async Principal {
              return msg.caller;
          };

 


}
