/*=================================================== MCC_fnc_moduleMissionWizard ===================================================
	Eden module "MCC Mission Wizard" (MCC_Module_missionWizard). Generates a Mission Wizard mission on the server at mission
	start with the module's attributes - the Eden replacement of the old MCC menu Mission Wizard tab.

	Mission area (attribute "areaMode"):
		0 - Area: a random spot inside the area of a synced trigger, or the module's own area (default 1500 m)
		1 - Exact: the objectives are spread around the module position
		2 - Whole map

	Params (module framework, server only - isGlobal = 0):
		0: OBJECT - the module logic
		1: ARRAY  - synced units (unused)
		2: BOOL   - activated
	Returns: nothing

	While the mission runs, MCC_MWMissionRuning_<missionId> is true (missionNamespace, public). The module also gets
	"MCC_MWmissionId" (the id used) and "MCC_MWstate" ("waiting", "generating", "running", "failed").
*/
params [
	["_logic", objNull, [objNull]],
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if (!isServer || {isNull _logic} || {!_activated}) exitWith {};
if (_logic getVariable ["MCC_MWstarted", false]) exitWith {};
_logic setVariable ["MCC_MWstarted", true];

[_logic] spawn {
	params ["_logic"];

	_logic setVariable ["MCC_MWstate", "waiting", true];

	//Wait for MCC and the mission start
	waitUntil {sleep 1; missionNamespace getVariable ["MCC_initDone", false]};
	waitUntil {sleep 1; time > 1};
	private _delay = _logic getVariable ["startDelay", 5];
	if !(_delay isEqualType 0) then {_delay = 5};
	if (_delay > 0) then {sleep _delay};

	//------------------------------------------------ Read attributes ------------------------------------------------
	private _fnc_num = {
		params ["_name", "_default"];
		private _v = _logic getVariable [_name, _default];
		if (_v isEqualType "") then {_v = parseNumber _v};
		if !(_v isEqualType 0) then {_v = _default};
		_v
	};
	private _fnc_str = {
		params ["_name", "_default"];
		private _v = _logic getVariable [_name, _default];
		if !(_v isEqualType "") then {_v = _default};
		_v
	};
	//0 - No, 1 - Yes, 2 - Random
	private _fnc_tri = {
		params ["_name", "_default"];
		private _v = [_name, _default] call _fnc_num;
		[false, true, selectRandom [true, false]] select ((round _v) max 0 min 2)
	};

	private _areaMode		= ["areaMode", 0] call _fnc_num;
	private _playersNumber	= (["playersNumber", 10] call _fnc_num) max 1;
	private _difficulty		= (["difficulty", 4] call _fnc_num) max 1;
	private _objCountAttr	= ["objectivesCount", 0] call _fnc_num;
	private _enemyFaction	= ["enemyFaction", "OPF_F"] call _fnc_str;
	private _playerFaction	= ["playerFaction", "BLU_F"] call _fnc_str;
	private _civFaction		= ["civFaction", "CIV_F"] call _fnc_str;
	private _cqbMode		= ["cqb", 3] call _fnc_num;
	private _armor			= ["armor", 2] call _fnc_tri;
	private _vehicles		= ["vehicles", 2] call _fnc_tri;
	private _stealth		= ["stealth", 2] call _fnc_tri;
	private _isIED			= ["ied", 2] call _fnc_tri;
	private _isSB			= ["suicideBombers", 2] call _fnc_tri;
	private _isAS			= ["armedCivilians", 2] call _fnc_tri;
	private _isRoadblocks	= ["roadblocks", 2] call _fnc_tri;
	private _animals		= ["animals", 2] call _fnc_tri;
	private _reinforcement	= (round (["reinforcement", 3] call _fnc_num)) max 0 min 3;
	private _artillery		= (round (["artillery", 3] call _fnc_num)) max 0 min 3;
	private _weatherChange	= (round (["weather", 0] call _fnc_num)) max 0 min 4;
	private _playMusic		= (round (["intro", 0] call _fnc_num)) max 0 min 2;
	private _preciseMarkers	= _logic getVariable ["preciseMarkers", true];
	private _markers		= _logic getVariable ["generalMarkers", false];
	private _missionId		= ["missionId", ""] call _fnc_str;
	if !(_preciseMarkers isEqualType true) then {_preciseMarkers = true};
	if !(_markers isEqualType true) then {_markers = false};

	if (_missionId == "") then {
		_missionId = format ["edenMW_%1", ["MCC_edenMWid", 1] call BIS_fnc_counter];
	};
	_logic setVariable ["MCC_MWmissionId", _missionId, true];

	//CQB - same table as the old dialog
	private _isCQB = false;
	private _isCiv = false;
	switch (round _cqbMode) do {
		case 1: {_isCQB = true; _isCiv = false};
		case 2: {_isCQB = true; _isCiv = true};
		case 3: {_isCQB = selectRandom [true, false]; _isCiv = selectRandom [true, false]};
		default {_isCQB = false; _isCiv = false};
	};

	//------------------------------------------------ Sides / factions ------------------------------------------------
	private _fnc_factionSide = {
		params ["_faction", "_default"];
		private _cfg = configFile >> "CfgFactionClasses" >> _faction;
		if !(isClass _cfg) exitWith {_default};
		switch (getNumber (_cfg >> "side")) do {
			case 0: {east};
			case 1: {west};
			case 2: {resistance};
			case 3: {civilian};
			default {_default};
		}
	};

	if !(isClass (configFile >> "CfgFactionClasses" >> _enemyFaction)) exitWith {
		diag_log format ["MCC Mission Wizard module: enemy faction '%1' not found in CfgFactionClasses", _enemyFaction];
		_logic setVariable ["MCC_MWstate", "failed", true];
	};
	if !(isClass (configFile >> "CfgFactionClasses" >> _civFaction)) then {_civFaction = "CIV_F"};

	private _enemySide	= [_enemyFaction, east] call _fnc_factionSide;
	private _sidePlayer	= [_playerFaction, west] call _fnc_factionSide;
	if (_sidePlayer isEqualTo _enemySide) then {
		diag_log format ["MCC Mission Wizard module: player faction '%1' and enemy faction '%2' are on the same side", _playerFaction, _enemyFaction];
	};

	//------------------------------------------------ Numbers (same as the old dialog) ------------------------------------------------
	private _totalEnemyUnits		= if ((_playersNumber * _difficulty) > 10) then {_playersNumber * _difficulty} else {20};
	private _minObjectivesDistance	= if (_isCQB) then {100} else {200};
	private _maxObjectivesDistance	= (_minObjectivesDistance * 1.5) + (10 * _playersNumber);

	//------------------------------------------------ Objectives ------------------------------------------------
	private _validTypes = missionNamespace getVariable ["MCC_MWMissionType", ["None","Random"]];
	private _objCount = if (_objCountAttr > 0) then {_objCountAttr} else {missionNamespace getVariable ["MCC_MWmaxObjectives", 3]};
	if !(_objCount isEqualType 0) then {_objCount = 3};
	_objCount = (round _objCount) max 1 min 8;

	private _objectivesList = [];
	{
		private _o = [_x, "Random"] call _fnc_str;
		if !(_o in _validTypes) then {_o = "Random"};
		_objectivesList pushBack _o;
	} forEach ["objective1", "objective2", "objective3"];
	while {count _objectivesList < _objCount} do {_objectivesList pushBack "Random"};
	if (count _objectivesList > _objCount) then {_objectivesList resize _objCount};
	if (({_x != "None"} count _objectivesList) == 0) then {_objectivesList set [0, "Random"]};

	//------------------------------------------------ Area ------------------------------------------------
	private _trigger = (synchronizedObjects _logic) findIf {_x isKindOf "EmptyDetector"};
	_trigger = if (_trigger >= 0) then {(synchronizedObjects _logic) select _trigger} else {objNull};

	private _center = getPosATL _logic;
	private _areaX = 750;
	private _areaY = 750;
	if (!isNull _trigger) then {
		_center = getPosATL _trigger;
		private _ta = triggerArea _trigger;
		_areaX = _ta select 0;
		_areaY = _ta select 1;
	} else {
		private _oa = _logic getVariable ["objectArea", []];
		if (_oa isEqualType [] && {count _oa >= 2} && {(_oa select 0) isEqualType 0}) then {
			_areaX = _oa select 0;
			_areaY = _oa select 1;
		};
	};
	_areaX = _areaX max 200;
	_areaY = _areaY max 200;

	//------------------------------------------------ Wait for the generator ------------------------------------------------
	//One Eden MW module at a time (the generator uses shared globals, see MCC_fnc_MWgenLock)
	private _gotTurn = false;
	while {!_gotTurn} do {
		isNil {
			if !(missionNamespace getVariable ["MCC_edenMWbusy", false]) then {
				MCC_edenMWbusy = true;
				_gotTurn = true;
			};
		};
		if (!_gotTurn) then {sleep 2};
	};
	waitUntil {sleep 1; count (missionNamespace getVariable ["MCC_MWgenLock", []]) == 0};

	_logic setVariable ["MCC_MWstate", "generating", true];

	//Unit arrays + group configs of the enemy faction (the client did this in the old dialog)
	private _check = [_enemyFaction, _enemySide] call MCC_fnc_MWCreateUnitsArray;
	waitUntil {!isNil "_check"};
	if (count (missionNamespace getVariable ["MCC_MWunitsArrayMen", []]) == 0) exitWith {
		diag_log format ["MCC Mission Wizard module: faction '%1' has no infantry - mission not generated", _enemyFaction];
		_logic setVariable ["MCC_MWstate", "failed", true];
		MCC_edenMWbusy = false;
	};

	private _wholeMap = true;
	switch (round _areaMode) do {
		case 1: {
			//Exact center: same input as a campaign AO ([position, location name])
			_wholeMap = [[_center select 0, _center select 1, 0], ""];
		};
		case 2: {
			_wholeMap = true;
		};
		default {
			_wholeMap = false;
			mcc_zone_markposition = [_center select 0, _center select 1, 0];
			mcc_zone_marker_X = _areaX;
			mcc_zone_marker_Y = _areaY;
		};
	};

	//Manual MW pads/cuts the objectives to MCC_MWmaxObjectives - use this module's count for this mission only
	private _oldMax = missionNamespace getVariable "MCC_MWmaxObjectives";
	private _overrideMax = (_wholeMap isEqualType true) && {isNil "_oldMax" || {!(_oldMax isEqualTo _objCount)}};
	if (_overrideMax) then {MCC_MWmaxObjectives = _objCount};

	diag_log format ["MCC Mission Wizard module: id '%1' mode %2 center %3 enemy %4/%5 player %6/%7 objectives %8", _missionId, _areaMode, _center, _enemySide, _enemyFaction, _sidePlayer, _playerFaction, _objectivesList];

	private _handle = [
		[_wholeMap, _totalEnemyUnits, _minObjectivesDistance, _maxObjectivesDistance, _weatherChange, _preciseMarkers, _playMusic, _markers],
		[_enemySide, _enemyFaction, _sidePlayer, _playerFaction, _civFaction],
		_objectivesList,
		[_isCQB, _isCiv, _armor, _vehicles, _stealth, _isIED, _isAS, _isSB, _isRoadblocks, _animals],
		[_reinforcement, _artillery],
		_missionId
	] spawn MCC_fnc_MWinitMission;

	//MCC_MWcurrentMissionId is set once the generator owns the lock (after it read MCC_MWmaxObjectives and before it reads the zone)
	private _timeout = diag_tickTime + 600;
	waitUntil {
		sleep 0.5;
		scriptDone _handle
		|| {(missionNamespace getVariable ["MCC_MWcurrentMissionId", ""]) isEqualTo _missionId}
		|| {diag_tickTime > _timeout}
	};

	if (_overrideMax) then {
		if (isNil "_oldMax") then {MCC_MWmaxObjectives = nil} else {MCC_MWmaxObjectives = _oldMax};
	};

	//Let the generator read the zone globals before the next module may change them
	sleep 10;
	MCC_edenMWbusy = false;

	waitUntil {sleep 2; scriptDone _handle};

	//The generator publishes MCC_MWMissionRuning_<id> from a script it spawns at the end; it gives up (no center found etc.) without it
	sleep 5;
	private _running = missionNamespace getVariable [format ["MCC_MWMissionRuning_%1", _missionId], false];
	_logic setVariable ["MCC_MWstate", ["failed", "running"] select _running, true];
	if (!_running) then {
		diag_log format ["MCC Mission Wizard module: mission '%1' was not generated (see the Mission Wizard errors above)", _missionId];
	};
};
