/*
	GAIA_fnc_groupObjective
	Where the group is really going: its last waypoint, or the stored GAIA order position.
	Params:
		0: GROUP
	Returns: ARRAY - position, or [] if unknown
*/
params [["_group", grpNull, [grpNull]]];

private _wps = waypoints _group;
private _pos = [];
if (count _wps > 0 && {currentWaypoint _group < count _wps}) then {
	_pos = waypointPosition (_wps select (count _wps - 1));
};
if !([_pos] call GAIA_fnc_isValidPos) then {
	_pos = _group getVariable ["GAIA_OrderPosition", []];
};
if !([_pos] call GAIA_fnc_isValidPos) then {_pos = []};
_pos
