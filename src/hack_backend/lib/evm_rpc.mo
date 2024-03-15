import Result "mo:base/Result";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {

    public type HttpHeader = { value : Text; name : Text };

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
}