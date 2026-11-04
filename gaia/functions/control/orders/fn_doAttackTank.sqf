/* ----------------------------------------------------------------------------
Function: GAIA_fnc_doAttackTank

Description:
	Attack order for tank groups (GAIA_fnc_doAttack). Tanks first take an
	overwatch position with line of sight on the target, 300-700 m out on their
	side (GAIA_fnc_findOverwatch, flat ground), engage from there and then
	push in with a SAD waypoint. Without a usable overwatch position, or when
	already within 700 m: MOVE + SAD on the target as before.

Parameters:
	0: GROUP
	1: ARRAY - target position

Returns:
	NUMBER - number of waypoints left
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]], ["_TargetPos", [], [[]]]];

[_group] call GAIA_fnc_removeWaypoints;

private _leader = leader _group;

if ((_leader distance2D _TargetPos) > 700) then {
	private _overwatch = [_TargetPos, getPosATL _leader, 300, 700, true] call GAIA_fnc_findOverwatch;
	if (_overwatch isNotEqualTo []) then {
		[_group, _overwatch, "MOVE"] call GAIA_fnc_addAttackWaypoint;
	} else {
		[_group, _TargetPos, "MOVE"] call GAIA_fnc_addAttackWaypoint;
	};
};

[_group, _TargetPos, "SAD"] call GAIA_fnc_addAttackWaypoint;

((count (waypoints _group)) - currentWaypoint _group)
