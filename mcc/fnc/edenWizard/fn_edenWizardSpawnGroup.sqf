/*=================================================== MCC_fnc_edenWizardSpawnGroup ===================================================
	Editor-time Mission Wizard: places one AI group as Eden entities in the wizard layer and (optionally) puts it under
	GAIA control in a wizard zone. The source is a CfgGroups group (create3DENComposition), a list of unit classes, or a
	single vehicle class (created with its crew). Respects the unit cap (MCC5MW_ctx "units" / "maxUnits").

	Params:
		0: CONFIG, ARRAY or STRING - CfgGroups group config / array of unit classes / vehicle class
		1: ARRAY   - position (ATL)
		2: HASHMAP - (optional) zone (MCC_fnc_edenWizardZone), empty = no GAIA
		3: STRING  - (optional) GAIA behaviour "MOVE", "NOFOLLOW", "FORTIFY" (default "MOVE")
		4: NUMBER  - (optional) direction (default random)
		5: STRING  - (optional) extra init code for the leader (default "")
	Returns: ARRAY - [GROUP, ARRAY of all created objects (units and vehicles)], [grpNull, []] when nothing was placed
	Example: private _res = [_cfg, _pos, _zone, "NOFOLLOW"] call MCC_fnc_edenWizardSpawnGroup;
*/
params [
	["_source", [], [configNull, [], ""]],
	["_pos", [0, 0, 0], [[]]],
	["_zone", createHashMap, [createHashMap]],
	["_intend", "MOVE", [""]],
	["_dir", -1, [0]],
	["_leaderInit", "", [""]]
];

private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
private _maxUnits = _ctx getOrDefault ["maxUnits", 200];
if (_dir < 0) then {_dir = random 360};

//Estimated size for the unit cap
private _estimate = switch (true) do {
	case (_source isEqualType configNull): {count ("isClass _x" configClasses _source)};
	case (_source isEqualType []): {count _source};
	default {3};
};
if ((_ctx getOrDefault ["units", 0]) + _estimate > _maxUnits) exitWith {
	_ctx set ["capped", true];
	[grpNull, []]
};

private _objects = [];
private _layer = _ctx getOrDefault ["curLayer", -1];

switch (true) do {
	//CfgGroups group: the editor places it like the asset browser does
	case (_source isEqualType configNull): {
		if (!isClass _source) exitWith {};
		private _entities = create3DENComposition [_source, _pos];
		if (isNil "_entities") then {_entities = []};
		_objects = _entities select {_x isEqualType objNull && {!isNull _x}};
		private _crew = [];
		{_crew append (crew _x)} forEach (_objects select {!(_x isKindOf "CAManBase")});
		{_objects pushBackUnique _x} forEach _crew;
		{
			if (_layer >= 0) then {_x set3DENLayer _layer};
			(_ctx getOrDefault ["entities", []]) pushBack _x;
		} forEach _objects;
		_ctx set ["units", (_ctx getOrDefault ["units", 0]) + ({_x isKindOf "CAManBase"} count _objects)];
	};

	//Unit classes: first unit makes the group, the others join it
	case (_source isEqualType []): {
		private _group = grpNull;
		{
			private _p = if (_forEachIndex == 0) then {_pos} else {_pos getPos [2 + (2 * _forEachIndex), _dir + 180 + (([-30, 30] select (_forEachIndex mod 2 == 0)))]};
			private _unit = ["Object", _x, _p, [], false, _group] call MCC_fnc_edenWizardCreate;
			if (!isNull _unit) then {
				_objects pushBack _unit;
				if (isNull _group) then {_group = group _unit};
			};
		} forEach _source;
	};

	//One vehicle with its crew
	default {
		private _veh = ["Object", _source, _pos, [["rotation", [0, 0, _dir]]]] call MCC_fnc_edenWizardCreate;
		if (!isNull _veh) then {
			_objects pushBack _veh;
			{_objects pushBackUnique _x} forEach (crew _veh);
		};
	};
};

private _men = _objects select {_x isKindOf "CAManBase"};
if (_men isEqualTo []) exitWith {
	if (_objects isNotEqualTo []) then {delete3DENEntities _objects};
	[grpNull, []]
};

private _group = group (_men select 0);
if (_layer >= 0) then {_group set3DENLayer _layer};
_ctx set ["groups", (_ctx getOrDefault ["groups", 0]) + 1];

//Stealth: the enemy starts relaxed (GAIA switches them to combat on contact)
if (_ctx getOrDefault ["stealthInit", false]) then {
	_leaderInit = _leaderInit + "if (local this) then {(group this) setBehaviour 'SAFE'; (group this) setSpeedMode 'LIMITED'};";
};
if (_leaderInit != "") then {
	private _leader = leader _group;
	if (isNull _leader) then {_leader = _men select 0};
	_leader set3DENAttribute ["Init", _leaderInit];
};

if (count _zone > 0) then {
	[_group, _zone, _intend] call MCC_fnc_edenWizardAssign;
};

[_group, _objects]
