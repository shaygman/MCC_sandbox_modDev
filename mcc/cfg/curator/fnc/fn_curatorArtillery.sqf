/*=================================================================MCC_fnc_curatorArtillery=========================================================================
	Zeus module "Artillery Fire Mission": fires MCC artillery (HE, smoke, flares, cluster, mines, DPICM, laser guided...)
	at the module position, or adds the shells to a side's artillery console. Replaces the old MCC menu Artillery tab.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _pos = getPosATL _module;
private _types = missionNamespace getVariable ["MCC_artilleryTypeArray", []];
private _spreads = missionNamespace getVariable ["MCC_artillerySpreadArray", []];

if (_types isEqualTo [] || {_spreads isEqualTo []}) exitWith {
	[objNull, "MCC artillery types are not defined"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

private _rounds = [1,2,3,4,5,6,8,10,12,16,20,30,40,50];
private _delays = [0,20,40,60,80,100,120,140,160,180];

private _result = ["Artillery Fire Mission", [
	["Shell type", _types apply {_x select 0}],
	["Spread", _spreads apply {_x select 0}],
	["Rounds", _rounds apply {str _x}],
	["Delay", ["None","20 sec","40 sec","1 min","80 sec","100 sec","2 min","140 sec","160 sec","3 min"]],
	["Action", ["Fire now at this position", "Add shells to a side's artillery console"]],
	["Console side (Add only)", ["West", "East", "Resistance"]]
]] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _type = _types select (_result select 0);
private _shellName = _type select 0;
private _shellType = _type select 1;
private _simulate = _type select 2;
private _spread = (_spreads select (_result select 1)) select 1;
private _nShell = _rounds select (_result select 2);
private _delay = _delays select (_result select 3);

if ((_result select 4) == 0) then {
	//Fire mission (same call as the old Artillery tab map click)
	[[_pos select 0, _pos select 1, 0], _shellType, _spread, _nShell, _simulate, _delay] remoteExec ["MCC_fnc_artillery", 2];
	[objNull, format ["%1 x%2 inbound", _shellName, _nShell]] call BIS_fnc_showCuratorFeedbackMessage;
} else {
	//Add to the artillery console (same as the old "Add" button)
	private _sideName = ["WEST", "EAST", "GUER"] select (_result select 5);
	private _artiTypes = missionNamespace getVariable ["HW_arti_types", []];
	if !([_shellName, _shellType] in _artiTypes) then {
		_artiTypes pushBack [_shellName, _shellType];
		HW_arti_types = _artiTypes;
		publicVariable "HW_arti_types";
	};

	HW_arti_number_shells_per_hour = (missionNamespace getVariable ["HW_arti_number_shells_per_hour", 0]) + _nShell;
	publicVariable "HW_arti_number_shells_per_hour";

	if (!isNil "MCC_server") then {
		MCC_server setVariable [format ["Arti_%1_shellsleft", _sideName], HW_arti_number_shells_per_hour, true];
	};

	["MCCNotifications", [format ["%2 %1 shells added", _nShell, _shellName], format ["%1data\ammo_icon.paa", missionNamespace getVariable ["MCC_path", ""]], ""]] remoteExec ["BIS_fnc_showNotification", 0];
};

deleteVehicle _module;
