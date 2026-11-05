/*=================================================== MCC_fnc_edenWizardBuild ===================================================
	Editor-time Mission Wizard: builds the whole mission from the prepared context MCC5MW_ctx (see
	MCC_fnc_edenWizardGenerate, which runs this inside collect3DENHistory so one Ctrl+Z removes everything).
	Order: optional clear of the old wizard layers, layers, operation marker, main MCC zone, objectives, main zone forces,
	operation task, briefing, intro, weather, GAIA support settings, player start, end trigger.
	Each objective and each part runs on its own; a failure is logged and the rest is still built.

	Params: none (MCC5MW_ctx)
	Returns: BOOL - true when at least the area and one objective or group were built
	Example: [] call MCC_fnc_edenWizardBuild;
*/
private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
if (count _ctx == 0) exitWith {false};

private _opts = _ctx get "opts";
private _enemy = _ctx get "enemy";
private _player = _ctx get "player";
(_ctx get "area") params ["_center", "_a", "_b", "_dir", "_rect", "_areaLabel"];
private _radius = (_a + _b) / 2;
private _token = _ctx get "token";

if (_ctx getOrDefault ["clearFirst", false]) then {
	[false] call MCC_fnc_edenWizardClear;
};

//------------------------------------------------------------ Layers ------------------------------------------------------------
private _rootName = "MCC Mission Wizard";
private _existing = ((all3DENEntities) param [6, []]) select {
	_x isEqualType 0 && {(((_x get3DENAttribute "name") param [0, ""]) find _rootName) == 0}
};
if (_existing isNotEqualTo []) then {_rootName = format ["%1 %2", _rootName, (count _existing) + 1]};

private _root = -1 add3DENLayer _rootName;
if (_root < 0) exitWith {
	diag_log "MCC Mission Wizard: could not create the layer";
	false
};
uiNamespace setVariable ["MCC5MW_lastLayer", _root];
_ctx set ["layer", _root];
_ctx set ["curLayer", _root];
private _layers = createHashMapFromArray [
	["area", _root add3DENLayer "Area and zones"],
	["objectives", _root add3DENLayer "Objectives"],
	["forces", _root add3DENLayer "Enemy forces"],
	["civ", _root add3DENLayer "Civilians, IEDs and animals"],
	["tasks", _root add3DENLayer "Tasks, triggers and briefing"]
];
_ctx set ["layers", _layers];
_ctx set ["layerTasks", _layers get "tasks"];

//------------------------------------------------------------ Operation name / area ------------------------------------------------------------
private _name1 = selectRandom ["Desert","Oversized","Roguish","Smouldering","Cold","Flaring","Furious","Silver","Vengeance","Yellow","Red","Blue","White","Gold","Dark","Broken","Morbid","Flying","Living","Swift","Evil","Fallen","Solitary","Alpha","Bravo","Charlie","Delta","Echo","Foxtrot"];
private _name2 = selectRandom ["Storm","Lightning","Rain","Thunder","Tornado","Hurricane","Flood","Dragonfly","Ocelot","Cobra","Fiend","Father","Horse","Thorn","Urgency","Snake","Serpent","Famine","Cage","Contempt","Priest","Stranger","Dagger","One","Two","Three","Zero","Arrow"];
private _opName = format ["%1 %2", _name1, _name2];
private _opTitle = if (_opts get "stealth") then {format ["Black Ops: %1", toUpperANSI _opName]} else {format ["Operation %1", toUpperANSI _opName]};
_ctx set ["opName", _opName];

//Nearest named location for the briefing
private _locName = "";
private _loc = nearestLocations [_center, ["NameCityCapital", "NameCity", "NameVillage", "NameLocal", "Hill"], _radius * 1.5];
if (_loc isNotEqualTo []) then {_locName = text (_loc select 0)};

_ctx set ["curLayer", _layers get "area"];
["Marker", "", _center, [
	["markerName", ["mkOperation"] call MCC_fnc_edenWizardName],
	["markerType", [1, 0] select _rect],
	["brush", "Border"],
	["baseColor", "ColorRed"],
	["size2", [_a, _b]],
	["rotation", _dir],
	["text", _opTitle]
]] call MCC_fnc_edenWizardCreate;

private _mainZone = [_center, _a, _b, _dir, _rect, format ["MW main zone: %1", _opTitle]] call MCC_fnc_edenWizardZone;
if (count _mainZone == 0) exitWith {
	diag_log "MCC Mission Wizard: could not create the main zone";
	false
};
_ctx set ["mainZone", _mainZone];

//------------------------------------------------------------ Operation (parent) task ------------------------------------------------------------
private _objectives = _opts get "objectives";
private _sideCode = _ctx get "playerSideCode";
if (count _objectives > 1) then {
	private _parentId = format ["mcc5mw_%1_op", _token];
	_ctx set ["curLayer", _layers get "tasks"];
	private _init = format [
		"if (isServer) then {0 = [] spawn {[%1, %2, [%3, %4, ''], objNull, 'ASSIGNED', 10, true, 'attack', false] call BIS_fnc_taskCreate;};};",
		_sideCode, str _parentId, str format ["%1<br/><br/>Complete all the objectives of the operation.", _opTitle], str _opTitle
	];
	["Logic", "Logic", _center getPos [8, 180], [["Name", ["opTask"] call MCC_fnc_edenWizardName], ["Init", _init]]] call MCC_fnc_edenWizardCreate;
	_ctx set ["parentTask", _parentId];
};

//------------------------------------------------------------ Objectives ------------------------------------------------------------
private _isCQB = _opts get "isCQB";
private _minDist = ([200, 100] select _isCQB) min (_radius * 0.5);
private _buildings = ["buildings", _center, _radius * 0.8, 4] call MCC_fnc_edenWizardFindPos;
_buildings = _buildings select {(getPosATL (_x select 0)) inArea [_center, _a * 0.8, _b * 0.8, _dir, _rect]};
private _results = [];

{
	private _type = _x;
	private _index = _forEachIndex + 1;
	_ctx set ["curLayer", _layers get "objectives"];

	//Building objectives prefer buildings; CQB puts every objective in or next to a building
	private _wantsBuilding = _isCQB || {_type in ["Secure HVT", "Kill HVT", "Acquire Intel", "Download Intel"] && {random 1 > 0.4}};
	private _used = _ctx get "usedPos";
	private _anchor = [];
	private _building = [];
	if (_wantsBuilding && {_buildings isNotEqualTo []}) then {
		private _free = _buildings select {private _b = _x select 0; (_used findIf {(_x distance2D _b) < _minDist}) < 0};
		if (_free isNotEqualTo []) then {
			_building = selectRandom _free;
			_anchor = getPosATL (_building select 0);
		};
	};
	if (_anchor isEqualTo []) then {
		_anchor = ["inArea", 0.75, _minDist] call MCC_fnc_edenWizardFindPos;
		if (_anchor isEqualTo []) then {_anchor = ["inArea", 0.75, _minDist * 0.5] call MCC_fnc_edenWizardFindPos};
		//A building close to the spot (intel / HVT may still use it)
		if (_anchor isNotEqualTo []) then {
			private _near = ["buildings", _anchor, 60, 4] call MCC_fnc_edenWizardFindPos;
			if (_near isNotEqualTo []) then {_building = _near select 0};
		};
	};

	if (_anchor isEqualTo []) then {
		diag_log format ["MCC Mission Wizard: no position for objective %1 (%2)", _index, _type];
		(_ctx get "failed") pushBack format ["objective %1 (%2): no position", _index, _type];
	} else {
		_used pushBack _anchor;
		private _res = [_type, _index, _anchor, _building] call MCC_fnc_edenWizardObjective;
		if (isNil "_res" || {!(_res isEqualType [])} || {_res isEqualTo []}) then {
			(_ctx get "failed") pushBack format ["objective %1 (%2)", _index, _type];
		} else {
			_results pushBack _res;
		};
	};
} forEach _objectives;
_ctx set ["results", _results];

//------------------------------------------------------------ Main zone forces ------------------------------------------------------------
[_mainZone] call MCC_fnc_edenWizardPopulate;

//------------------------------------------------------------ Weather / time ------------------------------------------------------------
private _weather = _opts get "weather";
if (_weather > 0) then {
	private _date = ("Intel" get3DENMissionAttribute "IntelDate");
	if (isNil "_date" || {!(_date isEqualType [])} || {count _date < 3}) then {_date = [2035, 6, 24]};
	private _month = 1 + floor random 12;
	private _hour = if (_opts get "stealth") then {
		[floor random 4, 21 + floor random 3] select (random 1 > 0.5)
	} else {
		5 + floor random 15
	};
	private _hourValue = _hour + ((floor random 4) * 0.25);
	//IntelTime: hours, or seconds when the current value is clearly in seconds
	private _curTime = "Intel" get3DENMissionAttribute "IntelTime";
	if (!isNil "_curTime" && {_curTime isEqualType 0} && {_curTime > 24}) then {_hourValue = _hourValue * 3600};

	private _attrs = [
		["Intel", "IntelDate", [_date select 0, _month, 1 + floor random 28]],
		["Intel", "IntelTime", _hourValue]
	];
	//Wetter in winter, like the old wizard
	private _monthFactor = [1,1,0.8,0.8,0.6,0.4,0.2,0.2,0.4,0.6,0.8,1] select (_month - 1);
	switch (_weather) do {
		case 1: {
			private _overcast = (random (_monthFactor / 2)) + _monthFactor / 2;
			_attrs pushBack ["Intel", "IntelWeatherStart", _overcast];
			_attrs pushBack ["Intel", "IntelFogStart", if (_overcast > 0.6) then {((random (_monthFactor / 2)) + _monthFactor / 2) / 5} else {0}];
			if (_overcast > 0.6) then {
				_attrs pushBack ["Intel", "IntelRainIsForced", true];
				_attrs pushBack ["Intel", "IntelRainStart", (random (_monthFactor / 2)) + _monthFactor / 2];
			};
		};
		default {
			//Sandstorm / blizzard / snow: bad weather plus the MCC effect at mission start
			_attrs pushBack ["Intel", "IntelWeatherStart", [0.4, 0.9, 0.7] select (_weather - 2)];
			_attrs pushBack ["Intel", "IntelFogStart", [0.3, 0.2, 0.15] select (_weather - 2)];
			_attrs pushBack ["Intel", "IntelRainIsForced", true];
			_attrs pushBack ["Intel", "IntelRainStart", 0];
			private _effect = ["sandstorm", "storm", "snow"] select (_weather - 2);
			_ctx set ["curLayer", _layers get "tasks"];
			["Logic", "Logic", _center getPos [12, 180], [
				["Name", ["weatherFx"] call MCC_fnc_edenWizardName],
				["Init", format ["if (isServer) then {0 = [] spawn {sleep 5; [%1, false] remoteExec ['MCC_fnc_ppEffects', 0, true];};};", str _effect]]
			]] call MCC_fnc_edenWizardCreate;
		};
	};
	set3DENMissionAttributes _attrs;
};

//------------------------------------------------------------ GAIA support (reinforcements / artillery) ------------------------------------------------------------
private _reinf = _opts get "reinforcement";
private _arty = _opts get "artillery";
if (_reinf > 0 || {_arty > 0}) then {
	private _attrs = [["MCC5", "MCC_GAIA_SUPPORT_ENABLED", 1]];
	if (_reinf > 0) then {_attrs pushBack ["MCC5", "MCC_GAIA_SUPPORT_REINF", 1]};
	if (_arty > 0) then {_attrs pushBack ["MCC5", "MCC_GAIA_SUPPORT_ARTY", 1]};
	set3DENMissionAttributes _attrs;
};

//------------------------------------------------------------ Briefing ------------------------------------------------------------
private _factionName = _enemy get "name";
private _text = format ["%1%2.", _opTitle, ["", format [" - %1", _locName]] select (_locName != "")];
_text = _text + format ["<br/><br/>%1 %2.", _factionName, selectRandom ["presence in the area has been increased", "have established a foothold in the area", "forces are active in the area"]];
if (_isCQB) then {_text = _text + " " + selectRandom ["They have taken up defensive positions inside buildings.", "They are using civilian buildings to fortify themselves."]};
if (_opts get "vehicles") then {_text = _text + format ["<br/>You may also encounter %1 technicals or soft vehicles.", _factionName]};
if (_opts get "armor") then {_text = _text + format ["<br/>Be aware that there may be %1 armored vehicles or even MBTs operating in the area.", _factionName]};
if (_arty > 0) then {_text = _text + format ["<br/>%1 may also have artillery operating in the area.", _factionName]};
if ((_ctx getOrDefault ["roadblocks", 0]) > 0) then {_text = _text + format ["<br/>%1 forces have established hasty checkpoints on some of the roads leading in and out of the area.", _factionName]};
if ((_opts get "ied") || {_opts get "sb"}) then {_text = _text + format ["<br/>Keep an eye out for anything that might look suspicious, as we believe that %1 may employ IEDs, or even suicide attacks.", _factionName]};
if (_opts get "ac") then {_text = _text + format ["<br/>The local civilians support %1, so be on the look out for any strange behavior. But keep civilian casualties to a minimum.", _factionName]};
if (_reinf > 0 || {_opts get "stealth"}) then {
	_text = _text + format ["<br/><br/>The enemy have %1QRF forces nearby. Expect enemy reinforcements should they become aware of your presence.", ["", "aerial ", "motorized "] select _reinf];
};
_text = _text + "<br/><br/>Objectives:";
{
	_x params ["_title", "_pos"];
	_text = _text + format ["<br/>%1. %2 (grid %3)", _forEachIndex + 1, _title, mapGridPosition _pos];
} forEach _results;
_text = _text + "<br/><br/>Go over your objectives, gear up and get ready. Mission is a go!";

_ctx set ["curLayer", _layers get "tasks"];
if (_opts get "briefing") then {
	private _init = format [
		"if (hasInterface) then {0 = [] spawn {waitUntil {sleep 0.5; !isNull player}; if (side group player == %1) then {player createDiaryRecord ['Diary', [%2, %3]];};};};",
		_sideCode, str _opTitle, str _text
	];
	["Logic", "Logic", _center getPos [8, 0], [["Name", ["briefing"] call MCC_fnc_edenWizardName], ["Init", _init]]] call MCC_fnc_edenWizardCreate;
};

//------------------------------------------------------------ Intro ------------------------------------------------------------
private _intro = _opts get "intro";
if (_intro < 2) then {
	private _music = ["", format ["playMusic %1;", str selectRandom ["LeadTrack01_F","LeadTrack02_F","LeadTrack03_F","LeadTrack04a_F","LeadTrack05_F","LeadTrack06_F","AmbientTrack03_F","BackgroundTrack03_F","BackgroundTrack01_F","LeadTrack01_F_EPA","LeadTrack02_F_EPA","EventTrack01_F_EPA","EventTrack03_F_EPA"]]] select (_intro == 0);
	private _init = format [
		"if (hasInterface) then {0 = [] spawn {waitUntil {sleep 0.5; !isNull player && {time > 3}}; if (side group player == %1) then {%2 [%3, %4, %5] spawn BIS_fnc_infoText;};};};",
		_sideCode, _music, str _opTitle, str ([_locName, worldName] select (_locName == "")), str format ["%1 objective(s)", count _results]
	];
	["Logic", "Logic", _center getPos [8, 90], [["Name", ["intro"] call MCC_fnc_edenWizardName], ["Init", _init]]] call MCC_fnc_edenWizardCreate;
};

//------------------------------------------------------------ Player start ------------------------------------------------------------
if ((_opts get "playerStart") == 1) then {
	private _start = [];
	for "_i" from 1 to 30 do {
		private _try = _center getPos [_radius * (1.6 + random 0.6), random 360];
		private _flat = ["flat", _try, 150, 10] call MCC_fnc_edenWizardFindPos;
		if (_flat isNotEqualTo [] && {!(_flat inArea [_center, _a * 1.3, _b * 1.3, _dir, _rect])}) exitWith {_start = _flat};
	};
	if (_start isEqualTo []) then {
		(_ctx get "failed") pushBack "player start: no flat land found outside the area";
	} else {
		private _respawn = ["respawn_east", "respawn_west", "respawn_guerrila", "respawn_civilian"] select (_player get "sideNum");
		["Marker", "respawn_inf", _start, [
			["markerName", format ["%1_%2", _respawn, ["start"] call MCC_fnc_edenWizardName]],
			["text", "MW Start"]
		]] call MCC_fnc_edenWizardCreate;
		_ctx set ["startPos", _start];
	};
};

//------------------------------------------------------------ End of operation ------------------------------------------------------------
private _taskIds = _ctx get "taskIds";
if (_taskIds isNotEqualTo []) then {
	private _parent = _ctx getOrDefault ["parentTask", ""];
	private _onAct = "if (isServer) then {" + (["", format ["[%1, 'SUCCEEDED'] call BIS_fnc_taskSetState; ", str _parent]] select (_parent != "")) + "'cp_mission_accomplished_1' remoteExec ['playSound', 0];};";
	private _attrs = [
		["name", ["endTrg"] call MCC_fnc_edenWizardName],
		["text", format ["%1: all objectives done", _opTitle]],
		["size3", [0, 0, -1]],
		["ActivationBy", "NONE"],
		["condition", format ["time > 10 && {(%1 findIf {!(_x call BIS_fnc_taskCompleted)}) < 0}", str _taskIds]],
		["onActivation", _onAct]
	];
	if (_opts get "endMission") then {_attrs pushBack ["TriggerType", "END1"]};
	["Trigger", "EmptyDetector", _center getPos [12, 0], _attrs] call MCC_fnc_edenWizardCreate;
};

_ctx set ["curLayer", _root];
(_results isNotEqualTo []) || {(_ctx getOrDefault ["groups", 0]) > 0}
