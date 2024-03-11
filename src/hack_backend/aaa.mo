import System "lib/System";

import Core "Core";

shared ({ caller = installer }) actor class Main() {

  let sys = System.IC();

  let core = Core.Core(installer, sys, _state_v0, _history_v0);

   /// Login and fetch user details. Creates an account if none exists for the caller principal.
  public shared ({ caller }) func login() : async Types.Resp.Login {
    core.login(caller);
  };
}