/*
	MCC_fnc_remoteAllowed
	Call at the top of a function that can be reached through remoteExec and does something powerful.
	Normal mode: always true. Strict mode (multiplayer only): a call that came over the network is
	allowed only if the sender is the server, this machine, or a player allowed to use MCC.
	Params:
		0: STRING - this function's name, used in the log
	Returns: BOOL - false means exit without doing anything
	Example:
		if !(["MCC_fnc_setVehicleInit"] call MCC_fnc_remoteAllowed) exitWith {};
*/
params [["_fnc", "", [""]]];

if (([] call MCC_fnc_networkSecurity) isEqualTo 0) exitWith {true};
if (!isRemoteExecuted) exitWith {true};

private _sender = remoteExecutedOwner;
if (_sender == clientOwner || {[_sender] call MCC_fnc_isAuthorizedOwner}) exitWith {true};

diag_log format ["MCC network security: refused %1 from owner %2", _fnc, _sender];
false
