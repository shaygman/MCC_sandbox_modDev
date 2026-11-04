/*
	MCC_fnc_isAuthorizedOwner  (server only)
	Checks whether the machine with the given owner id may use MCC.
	Params:
		0: NUMBER - owner id, usually remoteExecutedOwner
	Returns: BOOL
	Allowed: the server itself, logged-in admins, and players whose UID is in MCC_allowedPlayers
	(or when MCC_allowedPlayers contains "all").
	The client-settable "MCC_allowed" unit variable is NOT trusted here.
*/
params [["_owner", -1, [0]]];

if (!isServer) exitWith {false};
if (_owner in [0, 2, clientOwner]) exitWith {true};

private _allowed = missionNamespace getVariable ["MCC_allowedPlayers", ["all"]];
if (missionNamespace getVariable ["MCC_allowAdmin", true] && {(admin _owner) > 0}) exitWith {true};

private _unit = (allPlayers select {owner _x == _owner}) param [0, objNull];
if (isNull _unit) exitWith {false};

("all" in _allowed) || {(getPlayerUID _unit) in _allowed}
