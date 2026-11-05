/*=================================================== MCC_fnc_edenWizardPopulate ===================================================
	Editor-time Mission Wizard: fills the main mission zone (Eden mirror of MCC_fnc_populateObjective): infantry patrols,
	CQB garrisons and civilians, light vehicles, armor, artillery, static weapons, roadblocks, IEDs, suicide bombers,
	armed civilians, animals and the motorized QRF. Every part is wrapped on its own, a failing part is logged and the
	rest still runs. Uses the generation context MCC5MW_ctx.

	Params:
		0: HASHMAP - main zone (MCC_fnc_edenWizardZone)
	Returns: nothing
	Example: [_mainZone] call MCC_fnc_edenWizardPopulate;
*/
params [["_zone", createHashMap, [createHashMap]]];

private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
private _opts = _ctx get "opts";
private _enemy = _ctx get "enemy";
private _player = _ctx get "player";
private _civ = _ctx get "civ";
private _total = _ctx get "total";
(_ctx get "area") params ["_center", "_a", "_b", "_dir", "_rect"];
private _radius = (_a + _b) / 2;
private _isCQB = _opts get "isCQB";
private _enemyMen = _enemy get "men";
private _layers = _ctx get "layers";

//Run one part, log when it fails (an SQF error inside a part returns nil instead of true)
private _fnc_part = {
	params ["_name", "_code"];
	private _ok = call _code;
	if (isNil "_ok") then {
		diag_log format ["MCC Mission Wizard: part '%1' failed", _name];
		(_ctx get "failed") pushBack _name;
	};
};

private _fnc_infSource = {
	params [["_size", 4]];
	private _cfgs = _enemy get "grpInf";
	if (_cfgs isNotEqualTo []) exitWith {selectRandom _cfgs};
	private _men = [];
	for "_i" from 1 to _size do {if (_enemyMen isNotEqualTo []) then {_men pushBack selectRandom _enemyMen}};
	_men
};

//Vehicles on roads inside the area, else on open ground
private _fnc_vehPos = {
	private _roads = ["roads", _center, _radius] call MCC_fnc_edenWizardFindPos;
	if (_roads isNotEqualTo []) exitWith {
		private _road = selectRandom _roads;
		[getPosATL _road, ["roadDir", _road] call MCC_fnc_edenWizardFindPos]
	};
	private _p = ["inArea", 0.8] call MCC_fnc_edenWizardFindPos;
	if (_p isEqualTo []) exitWith {[]};
	private _flat = ["flat", _p, 100, 8] call MCC_fnc_edenWizardFindPos;
	if (_flat isEqualTo []) exitWith {[]};
	[_flat, random 360]
};

_ctx set ["curLayer", _layers getOrDefault ["forces", _ctx get "layer"]];

//------------------------------------------------------------ Infantry patrols ------------------------------------------------------------
["infantry", {
	private _budget = _total * ([0.2, 0.1] select _isCQB);
	private _start = _ctx get "units";
	for "_i" from 1 to 10 do {
		if ((_ctx get "units") - _start >= _budget) exitWith {};
		private _p = ["inArea", 0.9] call MCC_fnc_edenWizardFindPos;
		if (_p isEqualTo []) exitWith {};
		private _res = [[] call _fnc_infSource, _p, _zone, selectRandom ["MOVE", "MOVE", "MOVE", "NOFOLLOW"]] call MCC_fnc_edenWizardSpawnGroup;
		if (isNull (_res select 0)) exitWith {};
	};
	true
}] call _fnc_part;

//------------------------------------------------------------ CQB garrison ------------------------------------------------------------
if (_isCQB) then {
	["garrison", {
		[_center, _radius * 0.8, (round (_total * 0.15)) max 4 min 24, _enemyMen, _zone, "FORTIFY"] call MCC_fnc_edenWizardGarrison;
		true
	}] call _fnc_part;
};

//------------------------------------------------------------ Light vehicles ------------------------------------------------------------
if (_opts get "vehicles") then {
	["vehicles", {
		private _count = (round (_total * 0.6 / 4)) max 1 min 6;
		for "_i" from 1 to _count do {
			private _vp = [] call _fnc_vehPos;
			if (_vp isEqualTo []) exitWith {};
			_vp params ["_p", "_d"];
			private _source = switch (true) do {
				case ((_enemy get "grpMot") isNotEqualTo [] && {random 1 > 0.4}): {selectRandom (_enemy get "grpMot")};
				case ((_enemy get "carsArmed") isNotEqualTo []): {selectRandom (_enemy get "carsArmed")};
				case ((_enemy get "grpMot") isNotEqualTo []): {selectRandom (_enemy get "grpMot")};
				default {""};
			};
			if (_source isEqualTo "") exitWith {};
			private _res = [_source, _p, _zone, "MOVE", _d] call MCC_fnc_edenWizardSpawnGroup;
			if (isNull (_res select 0)) exitWith {};
		};
		true
	}] call _fnc_part;
};

//------------------------------------------------------------ Armor ------------------------------------------------------------
if (_opts get "armor") then {
	["armor", {
		private _count = (round (_total * 0.4 / 4)) max 1 min 4;
		for "_i" from 1 to _count do {
			private _vp = [] call _fnc_vehPos;
			if (_vp isEqualTo []) exitWith {};
			_vp params ["_p", "_d"];
			private _source = switch (true) do {
				case ((_enemy get "grpMech") isNotEqualTo [] && {random 1 > 0.4}): {selectRandom (_enemy get "grpMech")};
				case ((_enemy get "armor") isNotEqualTo []): {selectRandom (_enemy get "armor")};
				case ((_enemy get "grpMech") isNotEqualTo []): {selectRandom (_enemy get "grpMech")};
				default {""};
			};
			if (_source isEqualTo "") exitWith {};
			private _res = [_source, _p, _zone, "MOVE", _d] call MCC_fnc_edenWizardSpawnGroup;
			if (isNull (_res select 0)) exitWith {};
		};
		true
	}] call _fnc_part;
};

//------------------------------------------------------------ Artillery ------------------------------------------------------------
private _artillery = _opts get "artillery";
if (_artillery > 0) then {
	["artillery", {
		private _classes = if (_artillery == 1) then {_enemy get "mortars"} else {_enemy get "artySP"};
		//Fall back to the other kind, then to the Mission Wizard artillery setting for the enemy side
		if (_classes isEqualTo []) then {_classes = if (_artillery == 1) then {_enemy get "artySP"} else {_enemy get "mortars"}};
		if (_classes isEqualTo []) then {
			_classes = (["MCC_MWArtillery", "MWArtillery", ["B_MBT_01_arty_F","B_MBT_01_mlrs_F","O_MBT_02_arty_F","O_Mortar_01_F","I_Mortar_01_F"]] call MCC_fnc_edenWizardSetting)
				select {getNumber (configFile >> "CfgVehicles" >> _x >> "side") == (_enemy get "sideNum")};
		};
		if (_classes isEqualTo []) exitWith {true};
		private _count = [1 + floor random 2, 1] select (_artillery == 2);
		private _base = ["inArea", 0.5] call MCC_fnc_edenWizardFindPos;
		if (_base isEqualTo []) exitWith {true};
		_base = ["flat", _base, 150, 10] call MCC_fnc_edenWizardFindPos;
		if (_base isEqualTo []) exitWith {true};
		for "_i" from 1 to _count do {
			private _p = if (_i == 1) then {_base} else {_base getPos [8 * _i, random 360]};
			[selectRandom _classes, _p, _zone, "NOFOLLOW", random 360] call MCC_fnc_edenWizardSpawnGroup;
		};
		_ctx set ["hasArtillery", true];
		true
	}] call _fnc_part;
};

//------------------------------------------------------------ Static weapons (70%, old wizard) ------------------------------------------------------------
if (random 1 > 0.3 && {(_enemy get "staticMG") isNotEqualTo []}) then {
	["statics", {
		for "_i" from 1 to (1 + floor random 3) do {
			private _p = ["inArea", 0.7] call MCC_fnc_edenWizardFindPos;
			if (_p isEqualTo []) exitWith {};
			private _flat = ["flat", _p, 60, 3] call MCC_fnc_edenWizardFindPos;
			if (_flat isEqualTo []) exitWith {};
			[selectRandom (_enemy get "staticMG"), _flat, _zone, "FORTIFY", _center getDir _flat] call MCC_fnc_edenWizardSpawnGroup;
		};
		true
	}] call _fnc_part;
};

//------------------------------------------------------------ Roadblocks ------------------------------------------------------------
if (_opts get "roadblocks") then {
	["roadblocks", {
		//c_roadBlock composition (mcc\general_scripts\docobject\c_roadBlock.sqf)
		private _objs = [
			["RoadCone_L_F",[0.8125,-3.30859],161.93],["RoadCone_L_F",[3.15625,-1.48828],161.922],["RoadCone_L_F",[5.60742,0.232422],162.084],
			["Land_CncBarrierMedium4_F",[2.90625,-5.56641],177.178],["Land_BagBunker_Small_F",[7.99414,-7.19141],174.142],
			["Land_PortableLight_double_F",[11.3477,-5.43164],148.348],["Land_CncBarrierMedium4_F",[-6.76953,10.9277],177.402],
			["Land_BagBunker_Small_F",[-12.3594,6.16992],178.119],["RoadCone_L_F",[-3.53906,13.4199],165.012],
			["RoadCone_L_F",[-6.52148,16.8164],168.788],["Land_PortableLight_double_F",[-16.1738,8.23438],200.025],
			["RoadCone_L_F",[-8.77539,19.9121],168.806]
		];
		private _placedBlocks = 0;
		{
			if (_placedBlocks >= 3) exitWith {};
			private _road = _x;
			private _rPos = getPosATL _road;
			if (random 1 > 0.5 && {(nearestTerrainObjects [_rPos, ["HOUSE", "BUILDING"], 30, false, true]) isEqualTo []}) then {
				private _azi = ["roadDir", _road] call MCC_fnc_edenWizardFindPos;
				{
					_x params ["_class", "_rel", "_d"];
					private _rx = ((_rel select 0) * cos _azi) + ((_rel select 1) * sin _azi);
					private _ry = (-(_rel select 0) * sin _azi) + ((_rel select 1) * cos _azi);
					["Object", _class, [(_rPos select 0) + _rx, (_rPos select 1) + _ry, 0], [["rotation", [0, 0, _azi + _d]]], true] call MCC_fnc_edenWizardCreate;
				} forEach _objs;
				//Guards: 3 men next to the road, and a static weapon when the faction has one
				private _men = [];
				for "_i" from 1 to 3 do {if (_enemyMen isNotEqualTo []) then {_men pushBack selectRandom _enemyMen}};
				private _gPos = ["onRoadSide", _road, 5] call MCC_fnc_edenWizardFindPos;
				[_men, _gPos, _zone, "FORTIFY", _azi] call MCC_fnc_edenWizardSpawnGroup;
				if ((_enemy get "staticMG") isNotEqualTo []) then {
					private _sPos = ["onRoadSide", _road, 9] call MCC_fnc_edenWizardFindPos;
					[selectRandom (_enemy get "staticMG"), _sPos, _zone, "FORTIFY", _rPos getDir (_rPos getPos [100, _azi + 180])] call MCC_fnc_edenWizardSpawnGroup;
				};
				if (_opts get "generalMarkers") then {
					["Marker", "mil_warning", _rPos, [["markerName", ["mkRoadblock"] call MCC_fnc_edenWizardName], ["text", "Checkpoint"], ["baseColor", "ColorOPFOR"]]] call MCC_fnc_edenWizardCreate;
				};
				_placedBlocks = _placedBlocks + 1;
			};
		} forEach ((["roadsEntering", _center, _radius * 0.7] call MCC_fnc_edenWizardFindPos) call BIS_fnc_arrayShuffle);
		_ctx set ["roadblocks", _placedBlocks];
		true
	}] call _fnc_part;
};

//------------------------------------------------------------ Civilians, IEDs, suicide bombers, armed civilians ------------------------------------------------------------
_ctx set ["curLayer", _layers getOrDefault ["civ", _ctx get "layer"]];
private _playerSideNum = _player get "sideNum";
private _civMen = _civ get "men";

if (_opts get "isCiv") then {
	["civilians", {
		[_center, _radius * 0.8, (round (_total * 0.15)) max 4 min 20, _civMen, createHashMap, "", true] call MCC_fnc_edenWizardGarrison;
		true
	}] call _fnc_part;
};

if (_opts get "ied") then {
	["ieds", {
		private _props = ["Land_GarbageBags_F", "Land_GarbagePallet_F", "Land_JunkPile_F", "Land_Tyres_F", "Land_Sacks_heap_F", "Land_GarbageHeap_01_F", "Land_CanisterPlastic_F"];
		_props = _props select {isClass (configFile >> "CfgVehicles" >> _x)};
		private _wrecks = (_civ get "cars") select {!("kart" in toLowerANSI _x)};
		private _max = (round (_total / 10)) max 2 min 8;
		private _placed = 0;
		{
			if (_placed >= _max) exitWith {};
			if (random 1 > 0.3) then {
				private _road = _x;
				//30% a parked civilian car, else junk on the roadside (old wizard)
				private _useCar = random 1 < 0.3 && {_wrecks isNotEqualTo []};
				private _class = if (_useCar) then {selectRandom _wrecks} else {selectRandom _props};
				if (isNil "_class") exitWith {};
				private _p = ["onRoadSide", _road, [2, 3] select _useCar] call MCC_fnc_edenWizardFindPos;
				private _iedName = ["iedObj"] call MCC_fnc_edenWizardName;
				private _obj = ["Object", _class, _p, [["Name", _iedName], ["rotation", [0, 0, ["roadDir", _road] call MCC_fnc_edenWizardFindPos]]], true] call MCC_fnc_edenWizardCreate;
				if (isNull _obj) exitWith {};
				private _module = ["Logic", "MCC_Module_createIED", _p getPos [3, 0], [
					["side", _playerSideNum],
					["size", selectRandom ["small", "medium", "large"]],
					["effect", 0],
					["disarmTime", 30],
					["Jammable", 1],
					["ActivationType", selectRandom [0, 0, 1, 3]],
					["Distance", selectRandom [10, 20]]
				]] call MCC_fnc_edenWizardCreate;
				if (!isNull _module) then {add3DENConnection ["Sync", [_obj], _module]};
				_placed = _placed + 1;
			};
		} forEach ((["roads", _center, _radius * 0.9] call MCC_fnc_edenWizardFindPos) call BIS_fnc_arrayShuffle);
		_ctx set ["ieds", _placed];
		true
	}] call _fnc_part;
};

//Civilian with an MCC module synced (suicide bomber: IED module, armed civilian: Armed Civilian module)
private _fnc_civWithModule = {
	params ["_count", "_moduleClass", "_attrs", "_tag"];
	private _placed = 0;
	for "_i" from 1 to _count do {
		if ((_ctx get "units") >= (_ctx get "maxUnits")) exitWith {_ctx set ["capped", true]};
		private _p = ["inArea", 0.4] call MCC_fnc_edenWizardFindPos;
		if (_p isEqualTo [] || {_civMen isEqualTo []}) exitWith {};
		private _unit = ["Object", selectRandom _civMen, _p, [["Name", [_tag] call MCC_fnc_edenWizardName], ["rotation", [0, 0, random 360]]]] call MCC_fnc_edenWizardCreate;
		if (!isNull _unit) then {
			private _module = ["Logic", _moduleClass, _p getPos [3, 0], _attrs] call MCC_fnc_edenWizardCreate;
			if (!isNull _module) then {add3DENConnection ["Sync", [_unit], _module]};
			_placed = _placed + 1;
		};
	};
	_placed
};

if (_opts get "sb") then {
	["suicideBombers", {
		//Old wizard: for 0..total/30, 50% each
		private _count = 0;
		for "_i" from 0 to floor (_total / 30) do {if (random 1 > 0.5) then {_count = _count + 1}};
		[_count max 1, "MCC_Module_createIED", [["side", _playerSideNum], ["size", "large"], ["effect", 0]], "bomber"] call _fnc_civWithModule;
		true
	}] call _fnc_part;
};

if (_opts get "ac") then {
	["armedCivilians", {
		private _count = 0;
		for "_i" from 0 to floor (_total / 15) do {if (random 1 > 0.5) then {_count = _count + 1}};
		[_count max 1, "MCC_Module_createArmedCivilian", [["side", _playerSideNum], ["patrol", 1]], "armedCiv"] call _fnc_civWithModule;
		true
	}] call _fnc_part;
};

//------------------------------------------------------------ Animals ------------------------------------------------------------
if (_opts get "animals") then {
	["animals", {
		private _modules = ["ModuleAnimalsGoats_F", "ModuleAnimalsPoultry_F", "ModuleAnimalsSheep_F"] select {isClass (configFile >> "CfgVehicles" >> _x)};
		if (_modules isEqualTo []) exitWith {true};
		{
			_x params ["_p"];
			if (!surfaceIsWater _p && {_p inArea [_center, _a, _b, _dir, _rect]}) then {
				["Logic", selectRandom _modules, [_p select 0, _p select 1, 0]] call MCC_fnc_edenWizardCreate;
			};
		} forEach (selectBestPlaces [_center, _radius * 0.8, "(2 * houses) * (meadow)", 30, 3 + floor random 3]);
		true
	}] call _fnc_part;
};

//------------------------------------------------------------ Motorized QRF (reinforcements) ------------------------------------------------------------
_ctx set ["curLayer", _layers getOrDefault ["forces", _ctx get "layer"]];
if ((_opts get "reinforcement") == 2) then {
	["qrf", {
		private _source = switch (true) do {
			case ((_enemy get "grpMot") isNotEqualTo []): {selectRandom (_enemy get "grpMot")};
			case ((_enemy get "carsArmed") isNotEqualTo []): {selectRandom (_enemy get "carsArmed")};
			default {""};
		};
		if (_source isEqualTo "") exitWith {true};
		//On a road 1.2-1.6 x the radius away from the center
		private _p = [];
		private _d = random 360;
		for "_i" from 1 to 12 do {
			private _try = _center getPos [_radius * (1.2 + random 0.4), random 360];
			private _road = [_try, 300] call BIS_fnc_nearestRoad;
			if (!isNull _road && {!((getPosATL _road) inArea [_center, _a, _b, _dir, _rect])}) exitWith {
				_p = getPosATL _road;
				_d = (getPosATL _road) getDir _center;
			};
		};
		if (_p isEqualTo []) exitWith {true};
		[_source, _p, _zone, "MOVE", _d] call MCC_fnc_edenWizardSpawnGroup;
		true
	}] call _fnc_part;
};
