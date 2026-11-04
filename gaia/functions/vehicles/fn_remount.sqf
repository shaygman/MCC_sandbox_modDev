/*
	GAIA_fnc_remount
	Puts the group back into its vehicle after a fight or when its next objective is far away,
	instead of walking there.
	Params:
		0: GROUP
		1: OBJECT - the vehicle
	Returns: BOOL - true if the order was given
*/
params [["_group", grpNull, [grpNull]], ["_veh", objNull, [objNull]]];

if (!alive _veh || {!canMove _veh} || {fuel _veh < 0.05}) exitWith {false};

private _leader = leader _group;
private _foot = (units _group) select {alive _x && {vehicle _x == _x}};
if (count _foot == 0) exitWith {false};
if ((_veh emptyPositions "") < count _foot) exitWith {false};

_veh setVariable ["GAIA_claimedBy", _group, true];
_group addVehicle _veh;
_foot allowGetIn true;

if (isNull driver _veh) then {
	private _driver = (_foot - [_leader]) param [0, _leader];
	_driver assignAsDriver _veh;
	_foot = _foot - [_driver];
	[_driver] orderGetIn true;
};
{_x assignAsCargo _veh} forEach _foot;
_foot orderGetIn true;

_group setVariable ["GAIA_dismounted", false];

if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
	diag_log format ["GAIA vehicles: %1 re-mounts %2", _group, typeOf _veh];
};
true
