/*
	MCC_fnc_remoteAllowed
	Call at the top of a function that can be reached through remoteExec and does something powerful.
	In Normal mode it always returns true. In Strict mode:
		- calls that did not come over the network, or came from the server, are allowed
		- on the server, a call from a client is allowed only if MCC_fnc_isAuthorizedOwner says so
		- on clients, a call that came straight from another client is refused. If _broadcast is set,
		  the server re-sends approved calls to the other machines, so broadcasts still arrive.
	Params:
		0: STRING - this function's name, e.g. "MCC_fnc_setVehicleInit"
		1: ANY    - the function's _this, re-sent unchanged when broadcasting
		2: BOOL   - (optional) the function is normally sent to everyone (target 0). Default false
		3: BOOL   - (optional) re-send with JIP. Default false
	Returns: BOOL - false means exit without doing anything
	Example:
		if !(["MCC_fnc_setVehicleInit", _this, true, true] call MCC_fnc_remoteAllowed) exitWith {};
*/
params [["_fnc", "", [""]], ["_args", []], ["_broadcast", false, [false]], ["_jip", false, [false]]];

if (([] call MCC_fnc_networkSecurity) isEqualTo 0) exitWith {true};
if (!isRemoteExecuted) exitWith {true};

private _sender = remoteExecutedOwner;
if (_sender == 2 || {_sender == clientOwner}) exitWith {true};

if (isServer) exitWith {
	private _ok = [_sender] call MCC_fnc_isAuthorizedOwner;
	if (!_ok) exitWith {
		diag_log format ["MCC network security: refused %1 from owner %2", _fnc, _sender];
		false
	};
	if (_broadcast) then {
		// Clients refuse the copy they got straight from the sender, so send them a server copy.
		private _targets = (allUsers apply {(getUserInfo _x) param [1, -1]}) - [_sender, 2, clientOwner, -1];
		if (count _targets > 0) then {_args remoteExec [_fnc, _targets]};
		if (_jip) then {_args remoteExec [_fnc, -2, true]};
	};
	true
};

false
