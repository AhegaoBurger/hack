import EvmRpc "../../lib/Evm_rpc";
import Types "../Types";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";

module {

    type RpcError = EvmRpc.RpcError;
    type Result<A, B> = Types.Result<A, B>;

    public func handleError(error: RpcError) : Text {
        
        switch(error) {
                case(#JsonRpcError(msg)) { return "JsonRpcError: " # msg.message };
                case(#ProviderError(msg)) { 
                    switch(msg) {
                            case(#TooFewCycles(fewCyclesError)) { return "expected: " # Nat.toText(fewCyclesError.expected) # " received: " # Nat.toText(fewCyclesError.received) };
                            case(#MissingRequiredProvider(errorMessage)) { return "MissingRequiredProvider" };
                            case(#ProviderNotFound(errorMessage)) {return "ProviderNotFound" };
                            case(#NoPermission(errorMessage)) {return "NoPermission" };
                    };
                };
                case(#ValidationError(msg)) { return "ValidationError"};
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
                            return "Code: " # errorCode # " message: " # icError.message;
                        };
                        case(#InvalidHttpJsonRpcResponse(invalidHttpError)) {
                            return "Status: " # Nat16.toText(invalidHttpError.status) # " body: " # invalidHttpError.body;
                        };
                    };
                };
        };

    }

}