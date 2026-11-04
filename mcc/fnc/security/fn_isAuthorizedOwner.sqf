/*
	MCC_fnc_isAuthorizedOwner
	Checks whether the machine with the given owner id may use MCC.
	Params:
		0: NUMBER - owner id, usually remoteExecutedOwner
	Returns: BOOL
	On the server the answer is worked out directly. On clients it uses the list the server sends
	through MCC_fnc_setAuthorizedOwners (see MCC_fnc_securityInit). Owner ids come from the engine
	and cannot be faked by a client.
	Server rules:
		- With an MCC Access Rights module: players whose UID is listed in the module, or whose unit
		  is synced to it, plus logged-in admins if the module allows admins. These lists live in
		  localNamespace, which clients cannot overwrite.
		- Without the module: MCC_allowedPlayers (default ["all"] = everyone) and logged-in admins.
	The client-settable "MCC_allowed" unit variable is NOT trusted here.
*/
params [["_owner", -1, [0]]];

if (_owner == 2) exitWith {true};
if (!isServer) exitWith {_owner in (localNamespace getVariable ["MCC_authorizedOwners", []])};
if (_owner in [0, clientOwner]) exitWith {true};

private _info = [];
{
	private _i = getUserInfo _x;
	if ((_i param [1, -1]) == _owner) exitWith {_info = _i};
} forEach allUsers;
if (_info isEqualTo []) exitWith {false};

private _uid = _info param [2, ""];
private _unit = _info param [10, objNull];
private _hasModule = !isNil {localNamespace getVariable "MCC_accessNames"};

private _allowed = if (_hasModule) then {localNamespace getVariable ["MCC_accessNames", []]} else {missionNamespace getVariable ["MCC_allowedPlayers", ["all"]]};
private _allowAdmin = if (_hasModule) then {localNamespace getVariable ["MCC_accessAdmin", true]} else {missionNamespace getVariable ["MCC_allowAdmin", true]};

if ("all" in _allowed) exitWith {true};
if (_allowAdmin && {(admin _owner) > 0}) exitWith {true};
if (_uid != "" && {_uid in _allowed}) exitWith {true};
!isNull _unit && {_unit in (localNamespace getVariable ["MCC_accessUnits", []])}
