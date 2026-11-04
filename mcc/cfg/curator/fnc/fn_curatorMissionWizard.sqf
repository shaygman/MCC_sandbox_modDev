/*=================================================================MCC_fnc_curatorMissionWizard=====================================================================
	Zeus module "Mission Wizard": asks the Mission Wizard options and generates a mission on the server
	(MCC_fnc_MWinitMission) around the module position or anywhere on the map. Replaces the old MCC Mission Wizard dialog.
	The number of objectives above 3 and the mission size come from the CBA settings MCC_MWmaxObjectives / MCC_MWmissionSize.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

if (missionNamespace getVariable ["MCC_MWisGenerating", false]) exitWith {
	[objNull, "MCC is generating a mission, try again later"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

private _pos = getPosATL _module;
private _factions = missionNamespace getVariable ["U_FACTIONS", []];
private _civFactions = missionNamespace getVariable ["U_FACTIONSCIV", []];
private _objTypes = missionNamespace getVariable ["MCC_MWMissionType", ["None","Random"]];

if (_factions isEqualTo []) exitWith {
	[objNull, "MCC factions are not ready yet"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};
if (_civFactions isEqualTo []) then {_civFactions = [["Civilians","CIV","CIV_F"]]};

private _factionNames = _factions apply {format ["%1 (%2)", _x select 0, _x select 1]};
private _radii = [500,1000,2000,3000,5000];
private _players = [5,10,15,20,30,40,60,80];
private _ynr = ["Random","Yes","No"];
private _obj1Types = ["Random"] + (_objTypes - ["Random","None"]);

private _result = ["Mission Wizard", [
	["Area", ["Around this position","Anywhere on the map"]],
	["Search radius (m)", _radii apply {str _x}],
	["Enemy faction", _factionNames],
	["Players' faction", [format ["My faction (%1)", faction player]] + _factionNames],
	["Civilians faction", _civFactions apply {_x select 0}],
	["Players", _players apply {str _x}],
	["Difficulty", ["Easy","Medium","Hard"]],
	["Objective 1", _obj1Types],
	["Objective 2", _objTypes],
	["Objective 3", _objTypes],
	["Terrain", ["Open terrain","CQB","CQB with civilians","Random"]],
	["Stealth", _ynr],
	["IEDs", _ynr],
	["Suicide bombers", _ynr],
	["Armed civilians", _ynr],
	["Roadblocks", _ynr],
	["Vehicles", _ynr],
	["Armor", _ynr],
	["Animals", _ynr],
	["Reinforcements", ["No","Aerial","Motorized","Random"]],
	["Artillery", ["No","Mortars","Self propelled","Random"]],
	["Weather", ["Don't change","Random","Sandstorm","Blizzard","Snow"]],
	["Intro", ["Cinematic","Intro only","None"]],
	["Precise objective markers", false],
	["Debug markers", false]
], "Objectives beyond 3 and the mission size are set in CBA settings (MCC Mission Wizard)."] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};
deleteVehicle _module;

private _fnc_ynr = {
	params ["_index"];
	[selectRandom [true,false], true, false] select _index
};

private _wholeMap = (_result select 0) == 1;
private _radius = _radii select (_result select 1);

//Sides and factions
private _enemyFaction = (_factions select (_result select 2)) select 2;
private _enemySide = (getNumber (configFile >> "CfgFactionClasses" >> _enemyFaction >> "side")) call BIS_fnc_sideType;

private _sidePlayer = side group player;
private _factionPlayer = faction player;
if ((_result select 3) > 0) then {
	_factionPlayer = (_factions select ((_result select 3) - 1)) select 2;
	_sidePlayer = (getNumber (configFile >> "CfgFactionClasses" >> _factionPlayer >> "side")) call BIS_fnc_sideType;
};
private _civFaction = (_civFactions select (_result select 4)) select 2;

//Size
private _playersNumber = _players select (_result select 5);
private _difficulty = ((_result select 6) + 1) * 2;
private _totalEnemyUnits = if ((_playersNumber * _difficulty) > 10) then {_playersNumber * _difficulty} else {20};

//Objectives
private _objectivesList = [_obj1Types select (_result select 7), _objTypes select (_result select 8), _objTypes select (_result select 9)];

//Defines
private _isCQB = false;
private _isCiv = false;
switch (_result select 10) do {
	case 1: {_isCQB = true};
	case 2: {_isCQB = true; _isCiv = true};
	case 3: {_isCQB = selectRandom [true,false]; _isCiv = selectRandom [true,false]};
};
private _stealth = [_result select 11] call _fnc_ynr;
private _isIED = [_result select 12] call _fnc_ynr;
private _isSB = [_result select 13] call _fnc_ynr;
private _isAS = [_result select 14] call _fnc_ynr;
private _isRoadblocks = [_result select 15] call _fnc_ynr;
private _vehicles = [_result select 16] call _fnc_ynr;
private _armor = [_result select 17] call _fnc_ynr;
private _animals = [_result select 18] call _fnc_ynr;
private _reinforcement = _result select 19;
private _artillery = _result select 20;
private _weatherChange = _result select 21;
private _playMusic = _result select 22;
private _preciseMarkers = _result select 23;
private _markers = _result select 24;

private _minObjectivesDistance = if (_isCQB) then {100} else {200};
private _maxObjectivesDistance = (_minObjectivesDistance * 1.5) + (10 * _playersNumber);

//Build the faction's unit arrays and send them to the server (same as the old wizard)
[objNull, "Mission Wizard: preparing the faction"] call BIS_fnc_showCuratorFeedbackMessage;
[_enemyFaction, _enemySide] call MCC_fnc_MWCreateUnitsArray;

//User custom groups of that faction
MCC_customGroupsSaveMW = [];
{
	if (_enemyFaction == (_x select 0)) then {
		MCC_customGroupsSaveMW pushBack [_x select 3, _x select 4, _x select 2];
	};
} forEach (missionNamespace getVariable ["MCC_customGroupsSave", []]);
publicVariableServer "MCC_customGroupsSaveMW";

//The "zone" the wizard searches in is the module position
mcc_zone_markposition = [_pos select 0, _pos select 1, 0];
mcc_zone_marker_X = _radius;
mcc_zone_marker_Y = _radius;
publicVariableServer "mcc_zone_markposition";
publicVariableServer "mcc_zone_marker_X";
publicVariableServer "mcc_zone_marker_Y";

diag_log format ["MCC Zeus Mission Wizard: enemy %1 (%2), total enemy %3, objectives %4, whole map %5", _enemyFaction, _enemySide, _totalEnemyUnits, _objectivesList, _wholeMap];

[
	[_wholeMap, _totalEnemyUnits, _minObjectivesDistance, _maxObjectivesDistance, _weatherChange, _preciseMarkers, _playMusic, _markers],
	[_enemySide, _enemyFaction, _sidePlayer, _factionPlayer, _civFaction],
	_objectivesList,
	[_isCQB, _isCiv, _armor, _vehicles, _stealth, _isIED, _isAS, _isSB, _isRoadblocks, _animals],
	[_reinforcement, _artillery]
] remoteExec ["MCC_fnc_MWinitMission", 2];

[objNull, "Mission Wizard: building the mission on the server"] call BIS_fnc_showCuratorFeedbackMessage;
