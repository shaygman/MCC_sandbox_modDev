/*
	MCC_fnc_gaiaControlGroups  (server)
	Puts groups under GAIA control (or releases them). Called by the Zeus module "GAIA: Control Group".
	Params:
		0: ARRAY of GROUP
		1: NUMBER - 0 follow the tasks, 1 attack/patrol nearest zone, 2 defend nearest zone, 3 release
		2: BOOL   - (optional) allow GAIA smart vehicle use for these groups, default true
*/
if (!isServer) exitWith {};
if !(["MCC_fnc_gaiaControlGroups"] call MCC_fnc_remoteAllowed) exitWith {};
params [["_groups", [], [[]]], ["_mode", 0, [0]], ["_vehicles", true, [true]]];

{
	private _group = _x;
	if (isNull _group || {isPlayer leader _group}) then {continue};

	if (_mode == 3) then {
		_group setVariable ["GAIA_followTasks", nil, true];
		_group setVariable ["GAIA_ZONE_INTEND", nil, true];
		[_group] call GAIA_fnc_removeWaypoints;
		[_group] call GAIA_fnc_unregisterGroup;
		continue;
	};

	_group setVariable ["GAIA_noVehicles", !_vehicles, true];

	if (_mode == 0) then {
		_group setVariable ["GAIA_followTasks", true, true];
		[_group] call MCC_fnc_gaiaTaskTick;
	} else {
		_group setVariable ["GAIA_followTasks", nil, true];
		private _zone = [getPosATL leader _group] call MCC_fnc_gaiaNearestZone;
		if (_zone < 1) then {
			// No zone yet: make one around the group so GAIA has somewhere to work
			_zone = [] call MCC_fnc_MWnextZoneNumber;
			[_zone, getPosATL leader _group, [300, 300]] call MCC_fnc_MWUpdateZone;
		};
		_group setVariable ["GAIA_ZONE_INTEND", [str _zone, ["MOVE", "FORTIFY"] select (_mode == 2)], true];
		[_group] call GAIA_fnc_removeWaypoints;
	};
	[_group] call GAIA_fnc_registerGroup;
} forEach _groups;

// Start the task follower once
if (isNil "MCC_gaiaTaskLoop") then {
	MCC_gaiaTaskLoop = [] spawn {
		while {true} do {
			sleep 15;
			{
				if (_x getVariable ["GAIA_followTasks", false]) then {[_x] call MCC_fnc_gaiaTaskTick};
			} forEach allGroups;
		};
	};
};
