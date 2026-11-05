/*=================================================== MCC_fnc_edenWizardObjective ===================================================
	Editor-time Mission Wizard: builds one objective as Eden entities (Eden mirror of MCC_fnc_MWObjectiveHVT / Destroy /
	Intel / Clear / Disable): the objective object or unit, its guards, an MCC zone with GAIA patrols around it and the
	task (MCC_fnc_edenWizardTask). Uses the generation context MCC5MW_ctx.

	Params:
		0: STRING - objective type ("Secure HVT", "Kill HVT", "Destroy Vehicle", "Destroy AA", "Destroy Artillery",
		            "Destroy Weapon Cache", "Destroy Fuel Depot", "Destroy Radar/Radio", "Acquire Intel",
		            "Download Intel", "Capture Area", "Disarm IED")
		1: NUMBER - objective number (1-8)
		2: ARRAY  - objective position (ATL)
		3: ARRAY  - building found for the objective: [building, [positions]] or [] (open ground)
	Returns: ARRAY - [title, position] of the objective, [] when it failed
	Example: ["Kill HVT", 1, _pos, _building] call MCC_fnc_edenWizardObjective;
*/
params [
	["_type", "", [""]],
	["_index", 1, [0]],
	["_pos", [0, 0, 0], [[]]],
	["_building", [], [[]]]
];

private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
private _opts = _ctx get "opts";
private _enemy = _ctx get "enemy";
private _player = _ctx get "player";
private _civ = _ctx get "civ";
private _total = _ctx get "total";
private _zoneRadius = _ctx get "objZoneRadius";
private _isCQB = (_opts get "isCQB") && {_building isNotEqualTo []};
private _taskId = format ["mcc5mw_%1_obj%2", _ctx get "token", _index];
private _enemyMen = _enemy get "men";

_pos = [_pos select 0, _pos select 1, 0];

//--------------------------------------------------------------------- helpers ---------------------------------------------------------------------
//Objects from an objectMapper style array [[class, [x,y,z], dir], ...] around a position (same rotation as MCC_fnc_objectMapper)
private _fnc_mapper = {
	params ["_center", "_azi", "_objs"];
	{
		_x params ["_class", "_rel", "_d"];
		private _rx = ((_rel select 0) * cos _azi) + ((_rel select 1) * sin _azi);
		private _ry = (-(_rel select 0) * sin _azi) + ((_rel select 1) * cos _azi);
		private _p = [(_center select 0) + _rx, (_center select 1) + _ry, 0];
		["Object", _class, _p, [["rotation", [0, 0, _azi + _d]]], true] call MCC_fnc_edenWizardCreate;
	} forEach _objs;
};

//Camp / outpost from the Mission Wizard composition settings (CfgGroups >> Empty), returns the position used
private _fnc_camp = {
	params ["_near", "_military"];
	private _sites = if (_military) then {
		["MCC_MWSITESmilitary", "", [["Military","Outposts","OutpostA"],["Military","Outposts","OutpostB"],["Military","Outposts","OutpostC"],["Military","Outposts","OutpostD"],["Military","Outposts","OutpostE"],["Military","Outposts","OutpostF"]], ""] call MCC_fnc_edenWizardSetting
	} else {
		["MCC_MWSITES", "", [["Guerrilla","Camps","CampA"],["Guerrilla","Camps","CampB"],["Guerrilla","Camps","CampC"],["Guerrilla","Camps","CampD"],["Guerrilla","Camps","CampE"],["Guerrilla","Camps","CampF"]], ""] call MCC_fnc_edenWizardSetting
	};
	private _cfgs = (_sites select {_x isEqualType [] && {count _x == 3}}) apply {configFile >> "CfgGroups" >> "Empty" >> (_x select 0) >> (_x select 1) >> (_x select 2)};
	_cfgs = _cfgs select {isClass _x};
	private _flat = ["flat", _near, 80, 14] call MCC_fnc_edenWizardFindPos;
	if (_flat isEqualTo [] || {_cfgs isEqualTo []}) exitWith {_near};
	private _entities = create3DENComposition [selectRandom _cfgs, _flat];
	if (isNil "_entities") then {_entities = []};
	private _layer = _ctx getOrDefault ["curLayer", -1];
	{
		if (_layer >= 0) then {_x set3DENLayer _layer};
		(_ctx get "entities") pushBack _x;
	} forEach _entities;
	_flat
};

//HVT / hostage class: Mission Wizard HVT setting for the side, else an officer, else a soldier of the faction
private _fnc_hvtClass = {
	params ["_factionData"];
	private _list = ["MCC_MWHVT", "MWHVT", ["B_officer_F","O_officer_F","I_officer_F","C_Nikos"]] call MCC_fnc_edenWizardSetting;
	_list = _list select {getNumber (configFile >> "CfgVehicles" >> _x >> "side") == (_factionData get "sideNum")};
	if (_list isEqualTo []) then {_list = _factionData get "officers"};
	if (_list isEqualTo []) then {_list = _factionData get "men"};
	if (_list isEqualTo []) exitWith {""};
	selectRandom _list
};

//A spot for a small object/unit: a building position or the position itself
private _fnc_spot = {
	if (_building isNotEqualTo []) then {
		private _free = (_building select 1) select {private _p = _x; ((_ctx get "usedBuildingPos") findIf {(_x distance _p) < 1.5}) < 0};
		if (_free isEqualTo []) exitWith {_pos};
		private _p = selectRandom _free;
		(_ctx get "usedBuildingPos") pushBack _p;
		_p
	} else {_pos}
};

private _nestBig = [
	["Land_Mound01_8m_F",[6.44922,3.31543,0],66.057],["Land_Mound01_8m_F",[6.02734,-4.37598,0],120.305],
	["Land_Mound01_8m_F",[0.277344,7.45605,0],0.521262],["Land_Mound01_8m_F",[-6.4834,3.86426,0],304.131],
	["Land_Razorwire_F",[8.23438,3.67578,0],68.1704],["Land_Razorwire_F",[-7.5918,5.68555,0],317.346],
	["Land_Razorwire_F",[-0.763672,9.59375,0],0.851241],["Land_Razorwire_F",[9.32617,-4.35352,0],114.796]
];
private _nestSmall = [
	["Land_Pallet_MilBoxes_F",[1.7334,-1.05176,0],35.4607],["Land_PaperBox_open_empty_F",[-1.28809,1.57129,0],35.4607],
	["Land_BagFence_Long_F",[2.41992,1.31055,0],211.563],["Land_BagFence_Long_F",[0.172852,2.80566,0],216.675],
	["Land_Pallet_MilBoxes_F",[-2.91602,2.03613,0],35.4607],["Land_BagFence_Long_F",[4.23926,-0.692383,0],243.512],
	["Land_BagFence_Long_F",[3.65234,-2.73926,0],325.109],["Land_Razorwire_F",[-2.41797,4.95605,0],11.7958],
	["Land_BagFence_Long_F",[-2.39258,3.91113,0],188.154],["Land_Razorwire_F",[4.01953,1.74609,0],64.5719],
	["Land_BagFence_Long_F",[-4.10449,2.54199,0],106.055]
];
private _hangar = [
	["Land_TentHangar_V1_F",[1.05078,-1.05859,0],126.962],["Land_HBarrier_3_F",[-6.7627,7.95703,0],345.872],
	["Land_HBarrier_3_F",[-10.3105,3.9873,0],83.1959],["Land_HBarrier_5_F",[-3.98145,9.03125,0],317.747],
	["Land_HBarrier_5_F",[-11.7637,-3.2832,0],288.944],["Land_HBarrierWall6_F",[6.27148,-11.2832,0],139.899],
	["Land_HBarrierWall_corner_F",[13.8047,-2.25,0],48.408],["Land_HBarrierTower_F",[11.9297,-7.59766,0],310.581],
	["Land_Razorwire_F",[6.19824,-14.8174,0],320.967],["Land_Razorwire_F",[17.2617,-4.8623,0],276.346]
];

private _title = "";
private _description = "";
private _taskType = "default";
private _objVar = "";
private _successCond = "";
private _failCond = "";
private _areaSuccess = [];
private _guards = 0;

private _when = selectRandom ["This morning", "Last night", "Yesterday", "A few days ago", "Last week"];
private _intel = selectRandom ["From gathered intel", "According to satellite photos", "According to intel from a local informant", "According to info from High Command"];
private _where = selectRandom ["in this location", "in this area", "somewhere in this area", "close to this location", "around here"];

//--------------------------------------------------------------------- objective ---------------------------------------------------------------------
switch (true) do {

	case (_type == "Secure HVT"): {
		//Hostage: a player faction soldier or a civilian (50/50 like the old wizard)
		private _hostageData = if (random 1 > 0.5 && {(_player get "men") isNotEqualTo []}) then {_player} else {_civ};
		private _class = [_hostageData] call _fnc_hvtClass;
		if (_class == "") exitWith {};
		if (!_isCQB) then {_pos = [_pos, false] call _fnc_camp};
		private _spot = [] call _fnc_spot;
		if (_spot isEqualTo _pos) then {_spot = _pos getPos [3, random 360]};
		_objVar = ["hostage"] call MCC_fnc_edenWizardName;
		private _unit = ["Object", _class, _spot, [
			["Name", _objVar],
			["rotation", [0, 0, random 360]],
			["Init", "this setCaptive true; if (isServer) then {this spawn MCC_fnc_s_create_hostage};"]
		]] call MCC_fnc_edenWizardCreate;
		if (isNull _unit) exitWith {_objVar = ""};
		_unit set3DENAttribute ["position", _spot];
		private _name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
		_title = format ["Rescue the %1", _name];
		_description = format ["Rescue the %2.<br/><br/>%1 a %2 was captured by enemy forces operating in the area.<br/>%3 we believe that he is held captive %4.<br/>Find him, untie him and bring him home (more than 300 m from the place he is held).", _when, _name, _intel, _where];
		_taskType = "help";
		_successCond = format ["alive %1 && {%1 getVariable ['MCC_neutralize', false]} && {(%1 distance2D %2) > 300}", _objVar, [_spot select 0, _spot select 1]];
		_failCond = format ["!alive %1", _objVar];
		_guards = 3;
	};

	case (_type == "Kill HVT"): {
		private _class = [_enemy] call _fnc_hvtClass;
		if (_class == "") exitWith {};
		private _walking = false;
		if (!_isCQB) then {
			_pos = [_pos, false] call _fnc_camp;
			_walking = random 1 < 0.5;
		};
		private _spot = [] call _fnc_spot;
		_objVar = ["hvt"] call MCC_fnc_edenWizardName;
		private _init = if (_walking) then {
			"if (local this) then {[group this, getPos this, 100] call BIS_fnc_taskPatrol};"
		} else {
			"if (local this) then {doStop this};"
		};
		private _unit = ["Object", _class, _spot, [
			["Name", _objVar],
			["rotation", [0, 0, random 360]],
			["rank", "MAJOR"],
			["Init", _init]
		]] call MCC_fnc_edenWizardCreate;
		if (isNull _unit) exitWith {_objVar = ""};
		_unit set3DENAttribute ["position", _spot];
		//Bodyguards in the HVT's group (old wizard: 0-4)
		private _group = group _unit;
		for "_i" from 1 to (1 + floor random 4) do {
			if (_enemyMen isEqualTo []) exitWith {};
			private _gPos = if (_isCQB) then {[] call _fnc_spot} else {_spot getPos [3 + random 6, random 360]};
			private _guard = ["Object", selectRandom _enemyMen, _gPos, [["Init", "if (local this) then {doStop this};"]], false, _group] call MCC_fnc_edenWizardCreate;
			if (!isNull _guard && {_isCQB}) then {_guard set3DENAttribute ["position", _gPos]};
		};
		private _name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
		_title = format ["Kill or capture the %1", _name];
		_description = format ["Kill or capture the enemy %2.<br/><br/>%3, HQ believe that since %1 the %2 has been hiding %4.<br/>He is a most wanted HVT and should be considered armed and dangerous.<br/>Capture him if possible, if not kill him. Either way, do not let him escape.", toLowerANSI _when, _name, _intel, _where];
		_taskType = "kill";
		_successCond = format ["!alive %1 || {captive %1} || {%1 getVariable ['ace_captives_isHandcuffed', false]} || {%1 getVariable ['MCC_disarmed', false]}", _objVar];
		_guards = 2;
	};

	case ((_type find "Destroy") == 0): {
		private _kind = switch (_type) do {
			case "Destroy Vehicle": {selectRandom ["tanks", "air"]};
			case "Destroy AA": {"aa"};
			case "Destroy Artillery": {"artillery"};
			case "Destroy Weapon Cache": {"cache"};
			case "Destroy Fuel Depot": {"fuel"};
			default {selectRandom ["radar", "radio"]};
		};
		private _list = switch (_kind) do {
			case "tanks": {["MCC_MWTanks", "MWTanks", ["B_MBT_01_cannon_F","O_MBT_02_cannon_F"]] call MCC_fnc_edenWizardSetting};
			case "air": {["MCC_MWAir", "", ["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_UAV_02_F","O_UAV_02_CAS_F","B_Heli_Attack_01_F","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]] call MCC_fnc_edenWizardSetting};
			case "aa": {["MCC_MWAA", "MWAA", ["B_APC_Tracked_01_AA_F","O_APC_Tracked_02_AA_F","I_APC_Wheeled_03_cannon_F"]] call MCC_fnc_edenWizardSetting};
			case "artillery": {["MCC_MWArtillery", "MWArtillery", ["B_MBT_01_arty_F","B_MBT_01_mlrs_F","O_MBT_02_arty_F","O_Mortar_01_F","I_Mortar_01_F"]] call MCC_fnc_edenWizardSetting};
			case "cache": {["MCC_MWcache", "", ["Box_East_AmmoVeh_F","Land_Pallet_MilBoxes_F"]] call MCC_fnc_edenWizardSetting};
			case "fuel": {["MCC_MWFuelTanks", "", ["Land_dp_smallTank_F","Land_ReservoirTank_V1_F","Land_dp_bigTank_F"]] call MCC_fnc_edenWizardSetting};
			case "radar": {["MCC_MWradar", "", ["Land_Radar_Small_F","B_Radar_System_01_F","O_Radar_System_02_F"]] call MCC_fnc_edenWizardSetting};
			default {["MCC_MWRadio", "", ["Land_TTowerBig_2_F"]] call MCC_fnc_edenWizardSetting};
		};
		//The enemy's own vehicles first, then anything in the list (old wizard)
		private _sideList = _list select {getNumber (configFile >> "CfgVehicles" >> _x >> "side") == (_enemy get "sideNum")};
		if (_sideList isNotEqualTo []) then {_list = _sideList};
		if (_list isEqualTo []) exitWith {};
		private _class = selectRandom _list;

		private _size = [14, 20] select (_kind in ["air", "radio", "radar", "fuel"]);
		private _flat = ["flat", _pos, 150, _size] call MCC_fnc_edenWizardFindPos;
		if (_flat isNotEqualTo []) then {_pos = _flat};
		private _dir = random 360;
		switch (true) do {
			case (_kind in ["tanks", "aa", "artillery"]): {[_pos, _dir, _nestBig] call _fnc_mapper};
			case (_kind == "cache"): {[_pos, _dir, _nestSmall] call _fnc_mapper};
			case (_kind == "air"): {[_pos, _dir, _hangar] call _fnc_mapper};
		};

		_objVar = ["target"] call MCC_fnc_edenWizardName;
		private _isVehicle = _class isKindOf "AllVehicles";
		private _crewed = _kind in ["aa", "artillery"];
		private _attrs = [["Name", _objVar], ["rotation", [0, 0, _dir]]];
		if (_isVehicle && {!(_class isKindOf "StaticWeapon")}) then {_attrs pushBack ["lock", 2]};
		private _object = ["Object", _class, _pos, _attrs, !_crewed] call MCC_fnc_edenWizardCreate;
		if (isNull _object) exitWith {_objVar = ""};

		private _name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
		switch (_kind) do {
			case "tanks";
			case "air": {
				_title = format ["Destroy the prototype %1", _name];
				_description = format ["Destroy the prototype %2.<br/><br/>%1 HQ received intel suggesting that the enemy has obtained a prototype %2.<br/>This is a game-changer and we must eliminate it by any means necessary.<br/>%3 the vehicle is hidden %4.", _when, _name, _intel, _where];
			};
			case "aa": {
				_title = format ["Destroy the %1", _name];
				_description = format ["Destroy the %2.<br/><br/>%1 one of our planes got shot down.<br/>HQ believes that a %2 is behind it.<br/>This threat must be eliminated.<br/>%3 the AA is operating %4. Find and destroy it, soldier.", _when, _name, _intel, _where];
			};
			case "artillery": {
				_title = format ["Destroy the %1", _name];
				_description = format ["Destroy the %2.<br/><br/>%1 enemy artillery began pounding our troops. This threat must be eliminated.<br/>%3 the %2 is operating %4.<br/>Find and destroy it ASAP.", _when, _name, _intel, _where];
			};
			case "cache": {
				_title = "Destroy the enemy weapons cache";
				_description = format ["Destroy the enemy weapons cache.<br/><br/>%1, we believe that the enemy is hiding a weapons cache %2.<br/>Destroying it will severely damage the enemy war effort.<br/>Find and destroy it ASAP.", _intel, _where];
			};
			case "fuel": {
				_title = "Destroy the enemy fuel depot";
				_description = format ["Destroy the enemy fuel depot.<br/><br/>%1, we believe that the enemy have a fuel depot %2.<br/>Destroying it will severely damage the enemy war effort.<br/>Find and destroy it ASAP.", _intel, _where];
			};
			case "radar": {
				_title = "Destroy the enemy radar";
				_description = format ["Destroy the enemy radar.<br/><br/>%1 the enemy have a radar installation %2. They are using it to pinpoint the location of our troops.<br/>By destroying it we can regain the element of surprise.<br/>Find and destroy it ASAP.", _intel, _where];
			};
			default {
				_title = "Destroy the enemy radio tower";
				_description = format ["Destroy the enemy radio tower.<br/><br/>%1 the enemy have a radio tower %2. They are using it to coordinate their attacks.<br/>Destroying it will severely damage the enemy war effort.<br/>Find and destroy it ASAP.", _intel, _where];
			};
		};
		_taskType = "destroy";
		_successCond = format ["!alive %1", _objVar];
		_guards = 4;
	};

	case (_type in ["Acquire Intel", "Download Intel"]): {
		private _download = _type == "Download Intel";
		//Open ground: a camp; a building close by is used for the item (old wizard)
		if (!_isCQB) then {
			_pos = [_pos, false] call _fnc_camp;
			if (_building isNotEqualTo [] && {((_building select 0) distance2D _pos) > 50}) then {_building = []};
		};
		private _spot = [] call _fnc_spot;
		if (_spot isEqualTo _pos) then {
			private _flat = ["flat", _pos, 30, 3] call MCC_fnc_edenWizardFindPos;
			if (_flat isNotEqualTo []) then {_spot = _flat};
		};
		_objVar = ["intel"] call MCC_fnc_edenWizardName;
		private _class = "";
		private _itemPos = _spot;
		if (_download) then {
			_class = "Land_DataTerminal_01_F";
		} else {
			_class = selectRandom (["MCC_MWIntelObjects", "", ["Land_File2_F","Land_FilePhotos_F","Land_Laptop_unfolded_F","Land_SatellitePhone_F","Land_Suitcase_F"]] call MCC_fnc_edenWizardSetting);
			//On a small table like the old wizard
			private _table = ["Object", "Land_WoodenTable_small_F", _spot, [["enableSimulation", false], ["rotation", [0, 0, random 360]]], true] call MCC_fnc_edenWizardCreate;
			if (!isNull _table) then {
				_table set3DENAttribute ["position", _spot];
				_itemPos = _table modelToWorld [0, 0, 0.43];
			};
		};
		if (isNil "_class" || {_class == ""}) exitWith {_objVar = ""};
		private _init = if (_download) then {
			"this setVariable ['MCC_intelItem', true]; this call MCC_fnc_pickItem;"
		} else {
			"this call MCC_fnc_pickItem;"
		};
		private _object = ["Object", _class, _itemPos, [["Name", _objVar], ["Init", _init], ["enableSimulation", false]], true] call MCC_fnc_edenWizardCreate;
		if (isNull _object) exitWith {_objVar = ""};
		_object set3DENAttribute ["position", _itemPos];

		private _name = getText (configFile >> "CfgVehicles" >> _class >> "displayName");
		if (_download) then {
			_title = format ["Hack and download intel from the %1", _name];
			_description = format ["Download Intel.<br/><br/>HQ believe that we have an opportunity to acquire top notch information about enemy forces operating in the area.<br/>%1 the target data is in a %2, located %3.<br/>Hack it and download the information.", _intel, _name, _where];
			_taskType = "download";
			_successCond = format ["%1 getVariable ['MCC_intelItemDone', false]", _objVar];
			_failCond = format ["!alive %1", _objVar];
		} else {
			_title = format ["Acquire the %1", _name];
			_description = format ["Acquire Intel.<br/><br/>HQ believe that we have an opportunity to acquire top notch information about enemy forces operating in the area.<br/>%1 the target data is in a %2, located %3.<br/>Retrieve the information and bring it back for analysis.", _intel, _name, _where];
			_taskType = "search";
			_successCond = format ["isNull %1", _objVar];
			_failCond = format ["!isNull %1 && {!alive %1}", _objVar];
		};
		_guards = 4;
	};

	case (_type == "Capture Area"): {
		private _range = 100;
		if (_isCQB) then {
			_pos = getPosATL (_building select 0);
			_range = 50;
		} else {
			_pos = [_pos, true] call _fnc_camp;
		};
		_title = "Clear the area";
		_description = format ["Capture Area.<br/><br/>%1 enemy forces established a foothold %2.<br/>We can not allow this to continue!<br/>Go there and kick them out!", _when, _where];
		_taskType = "attack";
		_areaSuccess = [_ctx get "enemyActivation", _range];
		_guards = (round (_total * 0.1)) max 4 min 12;
	};

	case (_type == "Disarm IED"): {
		private _class = "Land_Device_disassembled_F";
		private _spot = _pos;
		if (_isCQB) then {
			_class = "Land_PressureWasher_01_F";
			_spot = [] call _fnc_spot;
			private _table = ["Object", "Land_WoodenTable_small_F", _spot, [["enableSimulation", false]], true] call MCC_fnc_edenWizardCreate;
			if (!isNull _table) then {
				_table set3DENAttribute ["position", _spot];
				_spot = _table modelToWorld [0, 0, 0.43];
			};
		} else {
			private _flat = ["flat", _pos, 150, 14] call MCC_fnc_edenWizardFindPos;
			if (_flat isNotEqualTo []) then {_pos = _flat; _spot = _flat};
			[_pos, random 360, _nestBig] call _fnc_mapper;
		};
		_objVar = ["ied"] call MCC_fnc_edenWizardName;
		private _device = ["Object", _class, _spot, [["Name", _objVar], ["rotation", [0, 0, random 360]]], true] call MCC_fnc_edenWizardCreate;
		if (isNull _device) exitWith {_objVar = ""};
		_device set3DENAttribute ["position", _spot];
		//MCC IED module: big, deadly, mini-game disarm, only the mission maker can detonate it (old wizard: trigger type 4)
		private _module = ["Logic", "MCC_Module_createIED", _spot getPos [4, 0], [
			["side", _player get "sideNum"],
			["size", "large"],
			["effect", 0],
			["disarmTime", 60],
			["Jammable", 0],
			["ActivationType", 4],
			["Distance", 10]
		]] call MCC_fnc_edenWizardCreate;
		if (!isNull _module) then {add3DENConnection ["Sync", [_device], _module]};

		_title = "Disarm the IED";
		_description = format ["Disable IED.<br/><br/>%1 enemy forces managed to put their hands on a massive Improvised Explosive Device (IED) %2.<br/>We must disable it before they will be able to use it against the civilian population.<br/>Tread carefully, find the IED and disarm it.", _intel, _where];
		_taskType = "mine";
		_successCond = format ["alive %1 && {!(%1 getVariable ['armed', true])} && {!(%1 getVariable ['iedTrigered', false])}", _objVar];
		_failCond = format ["isNull %1 || {!alive %1}", _objVar];
		_guards = 3;
	};
};

if (_title == "") exitWith {
	diag_log format ["MCC Mission Wizard: objective %1 '%2' could not be built at %3", _index, _type, _pos];
	[]
};

//--------------------------------------------------------------------- zone, guards, patrols ---------------------------------------------------------------------
private _zone = [_pos, _zoneRadius, _zoneRadius, 0, false, format ["MW objective %1: %2", _index, _title]] call MCC_fnc_edenWizardZone;

//Guards in the buildings around the objective (FORTIFY)
private _placed = [_pos, [30, 60] select (!_isCQB), _guards, _enemyMen, _zone, "FORTIFY"] call MCC_fnc_edenWizardGarrison;

//No buildings: a defending group next to the objective instead
if (_placed < 2 && {_guards > 0}) then {
	private _cfgs = _enemy get "grpInf";
	private _source = if (_cfgs isNotEqualTo []) then {selectRandom _cfgs} else {
		private _men = [];
		for "_i" from 1 to (_guards max 2) do {if (_enemyMen isNotEqualTo []) then {_men pushBack selectRandom _enemyMen}};
		_men
	};
	private _gPos = ["flat", _pos getPos [15, random 360], 40, 3] call MCC_fnc_edenWizardFindPos;
	if (_gPos isEqualTo []) then {_gPos = _pos getPos [15, random 360]};
	[_source, _gPos, _zone, "FORTIFY"] call MCC_fnc_edenWizardSpawnGroup;
};

//Infantry patrols in the objective zone (old wizard: 20% of the enemy force per objective)
private _budget = _total * 0.2;
private _start = _ctx getOrDefault ["units", 0];
for "_i" from 1 to 6 do {
	if ((_ctx getOrDefault ["units", 0]) - _start >= _budget) exitWith {};
	private _cfgs = _enemy get "grpInf";
	private _source = if (_cfgs isNotEqualTo []) then {selectRandom _cfgs} else {
		private _men = [];
		for "_j" from 1 to 4 do {if (_enemyMen isNotEqualTo []) then {_men pushBack selectRandom _enemyMen}};
		_men
	};
	private _p = _pos getPos [_zoneRadius * (0.3 + random 0.5), random 360];
	if (surfaceIsWater _p) then {_p = _pos};
	private _res = [_source, _p, _zone, selectRandom ["NOFOLLOW", "MOVE"]] call MCC_fnc_edenWizardSpawnGroup;
	if (isNull (_res select 0)) exitWith {};
};

//CQB: more units in the buildings; civilians
if (_opts get "isCQB") then {
	[_pos, _zoneRadius * 0.5, (round (_total * 0.1)) max 2 min 8, _enemyMen, _zone, "FORTIFY"] call MCC_fnc_edenWizardGarrison;
};
if (_opts get "isCiv") then {
	[_pos, _zoneRadius * 0.5, (round (_total * 0.1)) max 2 min 8, _civ get "men", createHashMap, "", true] call MCC_fnc_edenWizardGarrison;
};

//General markers: the objective zone
if (_opts get "generalMarkers") then {
	["Marker", "", _pos, [
		["markerName", ["mkObjZone"] call MCC_fnc_edenWizardName],
		["markerType", 1],
		["brush", "FDiagonal"],
		["baseColor", "ColorOPFOR"],
		["size2", [_zoneRadius, _zoneRadius]],
		["alpha", 0.5]
	]] call MCC_fnc_edenWizardCreate;
};

//--------------------------------------------------------------------- task ---------------------------------------------------------------------
private _layerTasks = _ctx getOrDefault ["layerTasks", -1];
private _layerBefore = _ctx get "curLayer";
if (_layerTasks >= 0) then {_ctx set ["curLayer", _layerTasks]};
[_taskId, _title, _description, _pos, _objVar, _taskType, _successCond, _failCond, _areaSuccess] call MCC_fnc_edenWizardTask;
_ctx set ["curLayer", _layerBefore];

[_title, _pos]
