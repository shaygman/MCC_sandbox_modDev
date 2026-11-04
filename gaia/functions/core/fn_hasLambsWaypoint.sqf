/* ----------------------------------------------------------------------------
Function: GAIA_fnc_hasLambsWaypoint

Description:
	Checks whether a group is running a LAMBS Danger task waypoint
	(waypointType "SCRIPTED" with a waypointScript containing "lambs_wp"),
	from its current waypoint onwards. GAIA leaves such groups alone (they are
	treated like FORTIFY groups: no new orders, no order cancelling).

Parameters:
	0: GROUP

Returns:
	BOOL

Example:
	if ([_group] call GAIA_fnc_hasLambsWaypoint) exitWith {};
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]]];

if (isNull _group) exitWith {false};

private _wps = waypoints _group;
private _current = currentWaypoint _group;
private _found = false;

for "_i" from _current to ((count _wps) - 1) do {
	private _wp = _wps select _i;
	if (
		(toUpper (waypointType _wp)) isEqualTo "SCRIPTED"
		&& {"lambs_wp" in (toLower (waypointScript _wp))}
	) exitWith {_found = true};
};

_found
