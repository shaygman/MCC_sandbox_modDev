/*=================================================== MCC_fnc_edenWizardGenerate ===================================================
	Eden menu MCC 5 > Generate Mission / Regenerate Mission. Editor-time Mission Wizard: builds a whole Mission Wizard
	mission (MCC zones, objectives, tasks, enemy groups under GAIA, IEDs, roadblocks, civilians, briefing, weather) as
	Eden entities in an "MCC Mission Wizard" layer, so the mission maker sees and edits everything before playing.
	Options: MCC 5 > Mission Wizard... (scenario attributes MCC5_MW, MCC_fnc_edenWizardOptions).
	Area: the one selected trigger or area marker, else the point the camera looks at, or a random location of the map.
	The whole generation is one undo step (collect3DENHistory). Editor only.

	Params:
		0: BOOL - (optional) clear the previous wizard layers first (Regenerate), default false
	Returns: BOOL - true when the mission was generated
	Example: [] call MCC_fnc_edenWizardGenerate;
*/
params [["_clearFirst", false, [false]]];

if (!is3DEN) exitWith {false};
if (missionNamespace getVariable ["MCC5MW_busy", false]) exitWith {false};

private _fnc_error = {
	params ["_text"];
	diag_log format ["MCC Mission Wizard: %1", _text];
	[format ["MCC Mission Wizard: %1", _text], 1, 6] call BIS_fnc_3DENNotification;
	false
};

private _opts = [] call MCC_fnc_edenWizardOptions;
if (isNil "_opts" || {!(_opts isEqualType createHashMap)}) exitWith {["could not read the options"] call _fnc_error};

private _isCQB = _opts get "isCQB";
private _players = _opts get "players";
private _sizeMul = _opts get "sizeMul";
private _objCount = count (_opts get "objectives");
if (_objCount == 0) exitWith {["every objective slot is None - set at least one objective in MCC 5 > Mission Wizard..."] call _fnc_error};

//------------------------------------------------------------ Numbers (old wizard) ------------------------------------------------------------
private _difficulty = _opts get "difficulty";
private _total = if ((_players * _difficulty) > 10) then {_players * _difficulty} else {20};
_total = round (_total * _sizeMul);
private _maxUnits = _opts get "maxUnits";
//Rough spawn estimate (same ratios as MCC_fnc_MWinitMission) to stay under the unit cap
private _spawnFactor = (0.2 * _objCount) + 0.35
	+ ([0, 0.75] select (_opts get "vehicles"))
	+ ([0, 0.4] select (_opts get "armor"))
	+ ([0, 0.2] select ((_opts get "artillery") > 0));
if (_total * _spawnFactor > _maxUnits) then {_total = floor (_maxUnits / _spawnFactor)};
_total = _total max 5;

private _minDist = [200, 100] select _isCQB;
private _maxDist = ((_minDist * 1.5) + (10 * _players)) * (sqrt ((_objCount / 3) max 1)) * (sqrt (_sizeMul max 1));
private _autoRadius = (_maxDist * 2) min 3000;

//------------------------------------------------------------ Area ------------------------------------------------------------
private _area = [];
private _areaMode = _opts get "areaMode";
private _radiusOpt = _opts get "areaRadius";
private _radius = [_autoRadius, _radiusOpt] select (_radiusOpt > 0);

if (_areaMode == 0) then {
	private _trigger = (get3DENSelected "trigger") param [0, objNull];
	private _marker = (get3DENSelected "marker") param [0, ""];
	switch (true) do {
		case (!isNull _trigger): {
			private _size = (_trigger get3DENAttribute "size3") param [0, []];
			private _rot = (_trigger get3DENAttribute "rotation") param [0, 0];
			if (_rot isEqualType []) then {_rot = _rot param [2, 0]};
			private _isRect = (_trigger get3DENAttribute "IsRectangle") param [0, false];
			private _sa = _size param [0, 0];
			private _sb = _size param [1, 0];
			if (_sa < 20 || {_sb < 20}) then {_sa = _radius; _sb = _radius};
			_area = [getPosATL _trigger, _sa, _sb, _rot, _isRect, "selected trigger"];
		};
		case (_marker != ""): {
			private _shape = markerShape _marker;
			private _size = markerSize _marker;
			if (_shape in ["RECTANGLE", "ELLIPSE"] && {(_size select 0) >= 20} && {(_size select 1) >= 20}) then {
				_area = [markerPos _marker, _size select 0, _size select 1, markerDir _marker, _shape == "RECTANGLE", "selected marker"];
			} else {
				_area = [markerPos _marker, _radius, _radius, 0, false, "selected marker"];
			};
		};
	};
};

if (_area isEqualTo [] && {_areaMode < 2}) then {
	_area = [screenToWorld [0.5, 0.5], _radius, _radius, 0, false, "camera view"];
};

if (_areaMode == 2) then {
	private _half = worldSize / 2;
	private _types = if (_isCQB) then {["NameCityCapital", "NameCity", "NameVillage"]} else {["NameCityCapital", "NameCity", "NameVillage", "NameLocal", "Hill"]};
	private _locations = (nearestLocations [[_half, _half], _types, worldSize]) select {!surfaceIsWater (locationPosition _x)};
	if (_locations isNotEqualTo []) then {
		private _loc = selectRandom _locations;
		_area = [locationPosition _loc, _radius, _radius, 0, false, text _loc];
	} else {
		for "_i" from 1 to 50 do {
			private _p = [random worldSize, random worldSize, 0];
			if !(surfaceIsWater _p) exitWith {_area = [_p, _radius, _radius, 0, false, "random spot"]};
		};
	};
};

if (_area isEqualTo []) exitWith {["no mission area found"] call _fnc_error};
private _center = _area select 0;
_area set [0, [_center select 0, _center select 1, 0]];
if (surfaceIsWater (_area select 0)) exitWith {["the center of the mission area is in the water - move the camera or select a trigger on land"] call _fnc_error};

//------------------------------------------------------------ Factions ------------------------------------------------------------
private _enemy = [_opts get "enemyFaction"] call MCC_fnc_edenWizardFactionData;
private _player = [_opts get "playerFaction"] call MCC_fnc_edenWizardFactionData;
private _civ = [_opts get "civFaction"] call MCC_fnc_edenWizardFactionData;
if ((_enemy get "men") isEqualTo [] && {(_enemy get "grpInf") isEqualTo []}) exitWith {
	[format ["enemy faction %1 has no soldiers", _opts get "enemyFaction"]] call _fnc_error
};
if ((_enemy get "side") isEqualTo (_player get "side")) exitWith {
	[format ["the enemy faction (%1) and the player faction (%2) are on the same side", _opts get "enemyFaction", _opts get "playerFaction"]] call _fnc_error
};

private _sideCodes = ["east", "west", "resistance", "civilian"];
private _activation = ["EAST", "WEST", "GUER", "CIV"];

//------------------------------------------------------------ Context ------------------------------------------------------------
private _objZoneRadius = (_maxDist * 0.5) max 100 min 400;
_objZoneRadius = _objZoneRadius min (((_area select 1) + (_area select 2)) / 2 * 0.6) max 75;

MCC5MW_ctx = createHashMapFromArray [
	["opts", _opts],
	["area", _area],
	["enemy", _enemy],
	["player", _player],
	["civ", _civ],
	["total", _total],
	["maxUnits", _maxUnits],
	["objZoneRadius", _objZoneRadius],
	["token", floor random 100000],
	["counter", 0],
	["units", 0],
	["groups", 0],
	["entities", []],
	["usedPos", []],
	["usedBuildingPos", []],
	["taskIds", []],
	["failed", []],
	["parentTask", ""],
	["playerSideCode", _sideCodes select (_player get "sideNum")],
	["enemyActivation", _activation select (_enemy get "sideNum")],
	["stealthInit", _opts get "stealth"],
	["clearFirst", _clearFirst],
	["capped", false],
	["layer", -1],
	["curLayer", -1]
];

diag_log format ["MCC Mission Wizard: generating - area %1, enemy %2 (%3 units), player %4, objectives %5, cqb %6",
	_area, _opts get "enemyFaction", _total, _opts get "playerFaction", _opts get "objectives", _isCQB];

//------------------------------------------------------------ Build (one undo step) ------------------------------------------------------------
MCC5MW_busy = true;
MCC5MW_result = false;
private _time = diag_tickTime;
collect3DENHistory {
	MCC5MW_result = [] call MCC_fnc_edenWizardBuild;
};
private _result = missionNamespace getVariable ["MCC5MW_result", false];
if (isNil "_result" || {!(_result isEqualType true)}) then {_result = false};
MCC5MW_busy = false;

private _ctx = MCC5MW_ctx;
MCC5MW_ctx = nil;
MCC5MW_result = nil;

//------------------------------------------------------------ Summary ------------------------------------------------------------
private _results = _ctx getOrDefault ["results", []];
private _failed = _ctx getOrDefault ["failed", []];
private _summary = format ["MCC Mission Wizard: %1 - %2 objective(s), %3 groups, %4 AI units, %5 entities (%6 s). Layer '%7'.",
	_ctx getOrDefault ["opName", ""], count _results, _ctx get "groups", _ctx get "units", count (_ctx get "entities"),
	(round ((diag_tickTime - _time) * 10)) / 10, "MCC Mission Wizard"];
if (_ctx get "capped") then {_summary = _summary + format [" Unit cap (%1) reached.", _maxUnits]};
if (_failed isNotEqualTo []) then {_summary = _summary + format [" Skipped: %1.", _failed joinString ", "]};
diag_log _summary;

if (!_result) exitWith {["generation failed - see the RPT log"] call _fnc_error};

[_summary, [0, 1] select (_failed isNotEqualTo []), 10] call BIS_fnc_3DENNotification;

//Look at the area
private _camPos = AGLToASL (_area select 0);
move3DENCamera [_camPos vectorAdd [0, 0, ((_area select 1) max (_area select 2)) * 0.5], true];

true
