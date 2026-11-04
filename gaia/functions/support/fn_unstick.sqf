/* ----------------------------------------------------------------------------
Function: GAIA_fnc_unstick

Description:
	Unstick action for vehicle groups without passengers (tanks, armed cars,
	AA), called by GAIA_fnc_analyzeForces when the leader has not moved 6 m
	for GAIA_STUCK_CYCLES (4) cycles while it still has waypoints.
	Skipped (returns false) when:
		- the CBA setting MCC_GAIA_UNSTICK is off,
		- HBQ Advanced Driving AI is active (["HBQ"] call GAIA_fnc_compat): it has
		  its own unstuck / route recovery,
		- anybody of the group is on foot, the group rides a borrowed vehicle
		  (GAIA_isRide) or carries passengers (cargo role): GAIA_fnc_vehicleTick
		  handles those (dismount / re-mount / re-path),
		- air, ships, static weapons, the group is in COMBAT, its order is not a
		  moving one (DoAttack, DoPatrol, DoClear), its current waypoint is a
		  waiting one (HOLD, GUARD, ...), it is at its waypoint, or it can't move.
	Escalation per order (counter reset when the group gets a new order):
		0. flipped and local and no player within 300 m: put it back on its wheels
		1st: re-set the current waypoint (driver plans a new route)
		2nd: back up 40 m (waypoint inserted before the current one)
		3rd: drop the order (GAIA gives a new one next cycle)

Parameters:
	0: GROUP

Returns:
	BOOL - true when an unstick action was taken
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]]];

if (isNull _group) exitWith {false};
if !(missionNamespace getVariable ["MCC_GAIA_UNSTICK", true]) exitWith {false};
if (["HBQ"] call GAIA_fnc_compat) exitWith {false};

private _leader = leader _group;
if (!alive _leader || {behaviour _leader == "COMBAT"}) exitWith {false};
if !((_group getVariable ["GAIA_Order", ""]) in ["DoAttack", "DoPatrol", "DoClear"]) exitWith {false};

//Vehicle crews only (GAIA_fnc_vehicleTick handles groups with men on foot, passengers or rides)
private _units = (units _group) select {alive _x};
if (_units isEqualTo []) exitWith {false};
if ((_units findIf {vehicle _x == _x}) > -1) exitWith {false};
if (_group getVariable ["GAIA_isRide", false]) exitWith {false};
if ((_units findIf {(toLowerANSI ((assignedVehicleRole _x) param [0, ""])) == "cargo"}) > -1) exitWith {false};
private _vehs = [];
{_vehs pushBackUnique (vehicle _x)} forEach _units;
if ((_vehs findIf {(_x isKindOf "Air") || {_x isKindOf "Ship"} || {_x isKindOf "StaticWeapon"}}) > -1) exitWith {false};

//Waypoint checks
private _wpIdx = currentWaypoint _group;
if (_wpIdx >= count (waypoints _group)) exitWith {false};
private _wp = [_group, _wpIdx];
if ((waypointType _wp) in ["HOLD", "GUARD", "SENTRY", "DISMISS", "LOITER", "SUPPORT"]) exitWith {false};
private _wpPos = waypointPosition _wp;
if ((_leader distance2D _wpPos) < 50) exitWith {false};

private _veh = vehicle _leader;
if (!canMove _veh) exitWith {false};

//Escalation counter, per order
private _tries = _group getVariable ["GAIA_unstickTries", 0];
if ((_group getVariable ["GAIA_unstickOrder", -1]) != (_group getVariable ["GAIA_OrderTime", 0])) then {
	_tries = 0;
	_group setVariable ["GAIA_unstickOrder", _group getVariable ["GAIA_OrderTime", 0]];
};

private _action = "";
switch (true) do {
	case (
		local _veh
		&& {((vectorUp _veh) select 2) < 0.3}
		&& {((missionNamespace getVariable ["GAIA_PLAYER_LIST", []]) findIf {(_x distance2D _veh) < 300}) < 0}
	): {
		_veh setVectorUp (surfaceNormal (getPosATL _veh));
		_veh setPosATL ((getPosATL _veh) vectorAdd [0, 0, 0.5]);
		_action = "unflip";
	};
	case (_tries == 0): {
		_wp setWaypointPosition [_wpPos, 0];
		_tries = 1;
		_action = "re-path";
	};
	case (_tries == 1): {
		private _back = _veh getPos [40, (getDir _veh) + 180];
		if (!(surfaceIsWater _back) && {[_back] call GAIA_fnc_isValidPos}) then {
			private _new = _group addWaypoint [_back, 0, _wpIdx];
			_new setWaypointType "MOVE";
			_new setWaypointCompletionRadius 10;
			_group setCurrentWaypoint _new;
			_action = "back up";
		} else {
			_wp setWaypointPosition [_wpPos, 0];
			_action = "re-path";
		};
		_tries = 2;
	};
	default {
		[_group] call GAIA_fnc_removeWaypoints;
		_tries = 0;
		_action = "new order";
	};
};
_group setVariable ["GAIA_unstickTries", _tries];

if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
	diag_log format ["GAIA unstick: %1 (%2, %3) stuck at %4 -> %5", _group, _group getVariable ["GAIA_class", ""], typeOf _veh, getPosATL _leader, _action];
};

true
