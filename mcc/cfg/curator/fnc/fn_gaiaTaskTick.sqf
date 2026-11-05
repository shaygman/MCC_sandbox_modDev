/*
	MCC_fnc_gaiaTaskTick  (server)
	For a group with GAIA_followTasks: picks the nearest unfinished task of the group's side that has a destination,
	makes sure an MCC zone covers it (creating one if needed) and points GAIA at that zone. When the task is done,
	the next call moves the group on to the next task. With no tasks left, the group patrols its last zone (or the nearest one).
	Params:
		0: GROUP
*/
params [["_group", grpNull, [grpNull]]];
if (!isServer || {isNull _group}) exitWith {};
private _leader = leader _group;
if (!alive _leader || {isPlayer _leader}) exitWith {};

private _current = _group getVariable ["GAIA_followTask", ""];
private _tasks = ([_leader] call BIS_fnc_tasksUnit) select {
	!([_x] call BIS_fnc_taskCompleted) && {([_x] call BIS_fnc_taskDestination) isNotEqualTo [0,0,0]}
};
// No open tasks: patrol. Keep the current zone, or take the nearest one (or make one around the group).
if (_tasks isEqualTo []) exitWith {
	if ((_group getVariable ["GAIA_ZONE_INTEND", []]) isEqualTo []) then {
		private _zone = [getPosATL _leader] call MCC_fnc_gaiaNearestZone;
		if (_zone < 1) then {
			_zone = [] call MCC_fnc_MWnextZoneNumber;
			[_zone, getPosATL _leader, [300, 300]] call MCC_fnc_MWUpdateZone;
		};
		_group setVariable ["GAIA_ZONE_INTEND", [str _zone, "MOVE"], true];
		[_group] call GAIA_fnc_registerGroup;
	};
	_group setVariable ["GAIA_followTask", "", true];
};

// Keep the current task while it's open, else the nearest open one
private _task = if (_current in _tasks) then {_current} else {
	private _withDist = _tasks apply {
		private _d = [_x] call BIS_fnc_taskDestination;
		if (_d isEqualType objNull) then {_d = getPosATL _d};
		[_leader distance2D _d, _x]
	};
	_withDist sort true;
	(_withDist select 0) select 1
};
if (_task == _current && {(_group getVariable ["GAIA_ZONE_INTEND", []]) isNotEqualTo []}) exitWith {};

private _dest = [_task] call BIS_fnc_taskDestination;
if (_dest isEqualType objNull) then {_dest = getPosATL _dest};

private _zone = [_dest, 400] call MCC_fnc_gaiaNearestZone;
if (_zone < 1) then {
	_zone = [] call MCC_fnc_MWnextZoneNumber;
	[_zone, _dest, [200, 200]] call MCC_fnc_MWUpdateZone;
};

_group setVariable ["GAIA_followTask", _task, true];
_group setVariable ["GAIA_ZONE_INTEND", [str _zone, "MOVE"], true];
[_group] call GAIA_fnc_removeWaypoints;
[_group] call GAIA_fnc_registerGroup;

if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
	diag_log format ["GAIA tasks: %1 -> task %2, zone %3 at %4", _group, _task, _zone, _dest];
};
