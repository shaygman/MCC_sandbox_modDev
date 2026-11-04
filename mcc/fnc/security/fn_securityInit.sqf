/*
	MCC_fnc_securityInit  (postInit, server only)
	Keeps the clients' list of authorized owners up to date for Strict network security, so clients can check
	who is allowed to send them MCC commands.
*/
if (!isServer || {!isMultiplayer}) exitWith {};

MCC_fnc_securityRefresh = {
	private _owners = [];
	{
		private _owner = (getUserInfo _x) param [1, -1];
		if (_owner > 0 && {[_owner] call MCC_fnc_isAuthorizedOwner}) then {_owners pushBackUnique _owner};
	} forEach allUsers;
	_owners sort true;
	if !(_owners isEqualTo (localNamespace getVariable ["MCC_authorizedOwnersLast", []])) then {
		localNamespace setVariable ["MCC_authorizedOwnersLast", _owners];
		// Sent with remoteExec, not publicVariable, so clients can check it came from the server.
		[_owners] remoteExec ["MCC_fnc_setAuthorizedOwners", -2, "MCC_authorizedOwnersJIP"];
	};
};

addMissionEventHandler ["PlayerConnected", {[] spawn {sleep 1; call MCC_fnc_securityRefresh}}];
addMissionEventHandler ["PlayerDisconnected", {call MCC_fnc_securityRefresh}];

// Admin logins and MCC access-rights changes have no event, so also refresh every 10 seconds.
[] spawn {
	while {true} do {
		call MCC_fnc_securityRefresh;
		sleep 10;
	};
};
