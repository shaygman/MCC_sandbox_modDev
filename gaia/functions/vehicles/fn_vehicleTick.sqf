/*
	GAIA_fnc_vehicleTick
	Per-group vehicle logic, called by the GAIA scheduler for every registered group. Throttles itself
	to once every 5 seconds per group and exits fast for groups it does not handle.
	What it does:
		1. Long trip on foot  -> look for an empty friendly vehicle (GAIA_fnc_findRide).
		2. Close to objective  -> whole group gets out, leader included (GAIA_fnc_dismount).
		3. After a fight       -> if the objective is still far, get back in the same vehicle (GAIA_fnc_remount).
		4. Vehicle not 100 m closer to the objective in 90 s -> re-path; after 3 tries, continue on foot.
		5. Vehicle lost        -> forget it (a new ride may be found later).
	Params:
		0: GROUP
	Settings (missionNamespace, CBA "MCC GAIA" category):
		MCC_GAIA_vehiclesEnabled (true), MCC_GAIA_rideDistance (1500 m), MCC_GAIA_dismountDistance (400 m),
		MCC_GAIA_rideSearchRadius (300 m)
*/
params [["_group", grpNull, [grpNull]]];

if (isNull _group) exitWith {};
if (time < (_group getVariable ["GAIA_vehNext", 0])) exitWith {};
_group setVariable ["GAIA_vehNext", time + 5];

if !(missionNamespace getVariable ["MCC_GAIA_vehiclesEnabled", true]) exitWith {};

private _leader = leader _group;
if (!alive _leader || {!local _leader}) exitWith {};
if ((units _group) findIf {isPlayer _x} > -1) exitWith {};

private _intend = _group getVariable ["GAIA_ZONE_INTEND", []];
if (_intend isEqualTo [] || {(_intend param [1, ""]) == "FORTIFY"}) exitWith {};
if (_group getVariable ["Garrisoning", false]) exitWith {};
// GAIA's own transport system (a transporter group carrying another group) handles these
if ((_group getVariable ["GAIA_Order", ""]) == "DoTransport") exitWith {};

private _class = _group getVariable ["GAIA_class", ""];
if (_class in ["Helicopter", "Autonomous", "Ship", "Artillery", "Mortar"]) exitWith {};

private _objective = [_group] call GAIA_fnc_groupObjective;
if (_objective isEqualTo []) exitWith {};
private _dist = _leader distance2D _objective;

private _rideDist = missionNamespace getVariable ["MCC_GAIA_rideDistance", 1500];
private _dismountDist = missionNamespace getVariable ["MCC_GAIA_dismountDistance", 400];
private _remountDist = (_dismountDist * 2) max 800;

// Calm = not in combat and no known enemy within 500 m, counted over ticks
private _inCombat = (behaviour _leader == "COMBAT") || {count (_leader targets [true, 500]) > 0};
private _calm = if (_inCombat) then {0} else {(_group getVariable ["GAIA_calmTicks", 0]) + 1};
_group setVariable ["GAIA_calmTicks", _calm];

private _veh = [_group] call GAIA_fnc_groupVehicle;

// 5. Vehicle lost
if (!isNull _veh && {!alive _veh || {!canMove _veh}}) then {
	_veh setVariable ["GAIA_claimedBy", grpNull, true];
	_group setVariable ["GAIA_groupVehicle", objNull];
	_group setVariable ["GAIA_isRide", false];
	_group leaveVehicle _veh;
	_veh = objNull;
};

private _onFoot = (units _group) select {alive _x && {vehicle _x == _x}};
private _mounted = !isNull _veh && {vehicle _leader == _veh};

// 1. Long trip on foot: find a ride
if (isNull _veh) exitWith {
	if (
		!_inCombat
		&& {_dist > _rideDist}
		&& {count _onFoot == count ((units _group) select {alive _x})}
		&& {time > (_group getVariable ["GAIA_noRideUntil", 0])}
	) then {
		[_group, _objective] call GAIA_fnc_findRide;
	};
};

// 2. Close to the objective: everybody out, leader included
if (_mounted && {_dist < _dismountDist} && {!(_group getVariable ["GAIA_dismounted", false])}) exitWith {
	[_group, _veh] call GAIA_fnc_dismount;
	_group setVariable ["GAIA_stuck", nil];
};

// 3. Fight is over and the objective is still far: back in the vehicle
if (count _onFoot > 0 && {_calm >= 3} && {_dist > _remountDist} && {time > (_group getVariable ["GAIA_noRideUntil", 0])}) exitWith {
	if !([_group, _veh] call GAIA_fnc_remount) then {
		// Vehicle can't take everyone any more: let it go, walk or find another ride later
		_veh setVariable ["GAIA_claimedBy", grpNull, true];
		_group setVariable ["GAIA_groupVehicle", objNull];
		_group setVariable ["GAIA_isRide", false];
		_group leaveVehicle _veh;
	};
};

// 4. Driving but not getting closer (stuck, or wandering around the map): re-path, after 3 tries continue on foot
if (_mounted && {!_inCombat}) then {
	private _stuck = _group getVariable ["GAIA_stuck", [time, _dist, 0]];
	_stuck params ["_since", "_lastDist", "_tries"];
	if (_dist < _lastDist - 100) then {
		_group setVariable ["GAIA_stuck", [time, _dist, 0]];
	} else {
		if (time - _since > 90) then {
			if (_tries >= 3) then {
				[_group, _veh] call GAIA_fnc_dismount;
				_group setVariable ["GAIA_noRideUntil", time + 300];
				_group setVariable ["GAIA_stuck", nil];
			} else {
				// Re-setting the waypoint position makes the driver plan a new route
				private _wp = [_group, currentWaypoint _group];
				private _wpPos = waypointPosition _wp;
				if ([_wpPos] call GAIA_fnc_isValidPos) then {_wp setWaypointPosition [_wpPos, 0]} else {_group move _objective};
				_group setVariable ["GAIA_stuck", [time, _dist, _tries + 1]];
			};
		};
	};
} else {
	if (_mounted) then {_group setVariable ["GAIA_stuck", [time, _dist, 0]]};
};
