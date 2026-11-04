/* ----------------------------------------------------------------------------
Function: GAIA_fnc_doAttackMotorizeInfantry

Description:
	Attack order for motorized and mechanized infantry (GAIA_fnc_doAttack).
	Instead of driving the whole group onto the target, the vehicles drive to a
	staging point on the approach, inside the dismount distance
	(MCC_GAIA_dismountDistance x 0.8): a road segment close to it when there is
	one, else open, fairly flat ground (GAIA_fnc_safePos). There the infantry
	gets out (GAIA_fnc_vehicleTick dismounts passengers and leader, the crew
	stays to support) and the group assaults the target with a SAD waypoint.
	With smart vehicle use off (MCC_GAIA_vehiclesEnabled) the staging waypoint
	is an UNLOAD waypoint instead. Close to the target: SAD only.

Parameters:
	0: GROUP
	1: ARRAY - target position

Returns:
	NUMBER - number of waypoints left
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]], ["_TargetPos", [], [[]]]];

[_group] call GAIA_fnc_removeWaypoints;

private _leader			= leader _group;
private _dismountDist	= missionNamespace getVariable ["MCC_GAIA_dismountDistance", 400];
private _stageDist		= (_dismountDist * 0.8) max 100;

if ((_leader distance2D _TargetPos) > (_dismountDist + 100)) then {
	private _target2D	= [_TargetPos select 0, _TargetPos select 1, 0];
	private _stage		= _target2D getPos [_stageDist, _target2D getDir _leader];

	//A road close to the staging point (but not further from the target than the dismount distance)
	private _roads = (_stage nearRoads 120) select {
		((getPosATL _x) distance2D _target2D) < (_dismountDist * 0.95)
		&& {((getPosATL _x) distance2D _target2D) > 100}
	};
	if (_roads isNotEqualTo []) then {
		_roads = [_roads, [_stage], {_input0 distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
		_stage = getPosATL (_roads select 0);
	} else {
		private _p = [_stage, 0, 60, 6, 0, 0.3, 0, _stage] call GAIA_fnc_safePos;
		if ((_p distance2D _target2D) < (_dismountDist * 0.95)) then {_stage = _p};
	};

	if (!(surfaceIsWater _stage) && {[_stage] call GAIA_fnc_isValidPos}) then {
		private _type = ["UNLOAD", "MOVE"] select (missionNamespace getVariable ["MCC_GAIA_vehiclesEnabled", true]);
		[_group, _stage, _type] call GAIA_fnc_addAttackWaypoint;
	};
};

[_group, _TargetPos, "SAD"] call GAIA_fnc_addAttackWaypoint;

((count (waypoints _group)) - currentWaypoint _group)
