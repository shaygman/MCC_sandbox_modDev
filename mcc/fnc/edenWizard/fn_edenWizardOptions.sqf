/*=================================================== MCC_fnc_edenWizardOptions ===================================================
	Reads the "MCC 5 Mission Wizard" scenario attributes (Cfg3DEN >> Mission >> MCC5_MW, get3DENMissionAttribute) and
	resolves every "Random" choice, the same way the old Mission Wizard dialog did (mcc\missionWizard\scripts\
	missionWizardInit.sqf), so the generated mission is fixed and can be inspected in the editor.
	Editor only.

	Params: none
	Returns: HASHMAP - keys:
		areaMode, areaRadius, players, difficulty, sizeMul, maxUnits (NUMBER)
		enemyFaction, playerFaction, civFaction (STRING)
		objectives (ARRAY of objective type strings, "Random" already resolved, "None" removed)
		isCQB, isCiv, vehicles, armor, stealth, ied, sb, ac, roadblocks, animals (BOOL)
		reinforcement (0 none, 1 aerial, 2 motorized), artillery (0 none, 1 mortars, 2 self propelled)
		weather (0-4), intro (0-2), precise, generalMarkers, briefing, endMission (BOOL), playerStart (0-1)
	Example: private _opts = [] call MCC_fnc_edenWizardOptions;
*/
#define MW_TYPES ["Secure HVT","Kill HVT","Destroy Vehicle","Destroy AA","Destroy Artillery","Destroy Weapon Cache","Destroy Fuel Depot","Destroy Radar/Radio","Acquire Intel","Download Intel","Capture Area","Disarm IED"]

private _fnc_get = {
	params ["_prop", "_default"];
	private _v = "MCC5_MW" get3DENMissionAttribute _prop;
	if (isNil "_v") exitWith {_default};
	if (_default isEqualType 0 && {_v isEqualType ""}) then {_v = parseNumber _v};
	if (_default isEqualType true && {_v isEqualType 0}) then {_v = _v > 0};
	if !(_v isEqualType _default) exitWith {_default};
	_v
};

//0 - No, 1 - Yes, 2 - Random
private _fnc_tri = {
	params ["_prop", "_default"];
	private _v = round ([_prop, _default] call _fnc_get);
	[false, true, selectRandom [true, false]] select (_v max 0 min 2)
};

private _opts = createHashMap;

_opts set ["areaMode",		round ((["MCC5MW_areaMode", 0] call _fnc_get) max 0 min 2)];
_opts set ["areaRadius",	(["MCC5MW_areaRadius", 0] call _fnc_get) max 0 min 10000];
_opts set ["players",		round ((["MCC5MW_players", 10] call _fnc_get) max 1 min 150)];
_opts set ["difficulty",	(["MCC5MW_difficulty", 4] call _fnc_get) max 1 min 10];
_opts set ["sizeMul",		(["MCC5MW_missionSize", 1] call _fnc_get) max 0.25 min 4];
_opts set ["maxUnits",		round ((["MCC5MW_maxUnits", 200] call _fnc_get) max 10 min 1000)];

private _fnc_faction = {
	params ["_prop", "_default"];
	private _f = [_prop, _default] call _fnc_get;
	if (_f == "" || {!isClass (configFile >> "CfgFactionClasses" >> _f)}) then {
		if (_f != "") then {diag_log format ["MCC Mission Wizard: faction '%1' (%2) not found, using %3", _f, _prop, _default]};
		_f = _default;
	};
	_f
};
_opts set ["enemyFaction",	["MCC5MW_enemyFaction", "OPF_F"] call _fnc_faction];
_opts set ["playerFaction",	["MCC5MW_playerFaction", "BLU_F"] call _fnc_faction];
_opts set ["civFaction",	["MCC5MW_civFaction", "CIV_F"] call _fnc_faction];

//------------------------------------------------ Objectives ------------------------------------------------
private _count = round ((["MCC5MW_objectivesCount", 3] call _fnc_get) max 1 min 8);
private _slots = [];
for "_i" from 1 to _count do {
	_slots pushBack ([format ["MCC5MW_objective%1", _i], "Random"] call _fnc_get);
};

//Fixed types first, then the random slots take a type that is not used yet in this mission
private _objectives = [];
private _used = [];
{
	if (_x in MW_TYPES) then {_used pushBackUnique _x};
} forEach _slots;
{
	private _type = _x;
	if (_type == "Random") then {
		private _free = MW_TYPES - _used;
		if (_free isEqualTo []) then {_free = MW_TYPES};
		_type = selectRandom _free;
		_used pushBackUnique _type;
	};
	if (_type in MW_TYPES) then {_objectives pushBack _type};
} forEach _slots;
_opts set ["objectives", _objectives];

//------------------------------------------------ Forces ------------------------------------------------
//CQB: same table as the old dialog
private _isCQB = false;
private _isCiv = false;
switch (round (["MCC5MW_cqb", 3] call _fnc_get)) do {
	case 1: {_isCQB = true; _isCiv = false};
	case 2: {_isCQB = true; _isCiv = true};
	case 3: {_isCQB = selectRandom [true, false]; _isCiv = selectRandom [true, false]};
	default {_isCQB = false; _isCiv = false};
};
_opts set ["isCQB", _isCQB];
_opts set ["isCiv", _isCiv];

_opts set ["vehicles",		["MCC5MW_vehicles", 2] call _fnc_tri];
_opts set ["armor",			["MCC5MW_armor", 2] call _fnc_tri];
_opts set ["stealth",		["MCC5MW_stealth", 2] call _fnc_tri];
_opts set ["ied",			["MCC5MW_ied", 2] call _fnc_tri];
_opts set ["sb",			["MCC5MW_suicideBombers", 2] call _fnc_tri];
_opts set ["ac",			["MCC5MW_armedCivilians", 2] call _fnc_tri];
_opts set ["roadblocks",	["MCC5MW_roadblocks", 2] call _fnc_tri];
_opts set ["animals",		["MCC5MW_animals", 2] call _fnc_tri];

//0 no, 1 aerial, 2 motorized, 3 random
private _reinf = round ((["MCC5MW_reinforcement", 3] call _fnc_get) max 0 min 3);
if (_reinf == 3) then {_reinf = selectRandom [0, 1, 2]};
_opts set ["reinforcement", _reinf];

//0 no, 1 mortars, 2 self propelled, 3 random
private _arty = round ((["MCC5MW_artillery", 3] call _fnc_get) max 0 min 3);
if (_arty == 3) then {_arty = selectRandom [0, 1, 2]};
_opts set ["artillery", _arty];

//------------------------------------------------ Mission ------------------------------------------------
_opts set ["weather",		round ((["MCC5MW_weather", 0] call _fnc_get) max 0 min 4)];
_opts set ["intro",			round ((["MCC5MW_intro", 0] call _fnc_get) max 0 min 2)];
_opts set ["precise",		["MCC5MW_preciseMarkers", true] call _fnc_get];
_opts set ["generalMarkers",["MCC5MW_generalMarkers", false] call _fnc_get];
_opts set ["briefing",		["MCC5MW_briefing", true] call _fnc_get];
_opts set ["playerStart",	round ((["MCC5MW_playerStart", 0] call _fnc_get) max 0 min 1)];
_opts set ["endMission",	["MCC5MW_endMission", false] call _fnc_get];

_opts
