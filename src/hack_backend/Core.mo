import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Debug "mo:base/Debug";
import System "lib/System";


module {
    // sys : System.System, _state : State.Stable.State, history : History.History
    public class Core(installer : Principal, ) {
  
        public func login(caller : Principal) : Types.Resp.Login {
            // let log = logger.Begin(caller, #login);
            // log.okWith(state.login(caller));
            Debug.print("AAAAAAA");
        };

    }
}