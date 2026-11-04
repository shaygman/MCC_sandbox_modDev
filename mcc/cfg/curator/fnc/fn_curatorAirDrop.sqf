/*=================================================================MCC_fnc_curatorAirDrop===========================================================================
	Zeus module "Air Drop": drops supply crates or vehicles at the module position with MCC_fnc_airDrop
	(parachute from a helicopter, slingload, or parachute without an aircraft). Replaces the old MCC menu Air Drop tab.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _pos = getPosATL _module;
private _factions = missionNamespace getVariable ["U_FACTIONS", []];
if (_factions isEqualTo []) exitWith {
	[objNull, "MCC factions are not ready yet"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

private _headings = ["North","North-East","East","South-East","South","South-West","West","North-West"];

private _result = ["Air Drop (1/2)", [
	["Delivery", ["Parachute from helicopter","Slingload (one object)","Parachute (no aircraft)"]],
	["Cargo", ["Supply crates","Vehicles"]],
	["Faction (aircraft side / vehicles)", _factions apply {format ["%1 (%2)", _x select 0, _x select 1]}],
	["Amount", ["1","2","3","4","5","6"]],
	["Approach from", _headings],
	["Action", ["Drop now", "Add to the faction side's commander console"]]
]] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _isParachute = _result select 0;
private _isCrate = (_result select 1) == 0;
private _faction = _factions select (_result select 2);
private _amount = (_result select 3) + 1;
private _dirFrom = (_result select 4) * 45;
private _toConsole = (_result select 5) == 1;

//Build the cargo list
private _classes = [];
if (_isCrate) then {
	{
		if (isClass (configFile >> "CfgVehicles" >> _x)) then {
			_classes pushBack [getText (configFile >> "CfgVehicles" >> _x >> "displayName"), _x];
		};
	} forEach ["MCC_crateAmmo","MCC_crateSupply","MCC_crateFuel","MCC_ammoBox"];
	private _mccCrates = _classes apply {_x select 1};
	_classes append ((["", ["ReammoBox_F"]] call MCC_fnc_curatorFactionClasses) select {!((_x select 1) in _mccCrates)});
} else {
	_classes = [_faction select 2, ["Car","Tank","Ship"]] call MCC_fnc_curatorFactionClasses;
};

if (_classes isEqualTo []) exitWith {
	[objNull, "Nothing to drop for this faction"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

waitUntil {isNull (findDisplay 1031982)};

private _resultClass = ["Air Drop (2/2)", [
	["Object", _classes apply {_x select 0}]
], "Heavy vehicles may be too heavy to slingload."] call MCC_fnc_initDynamicDialog;

if (_resultClass isEqualTo []) exitWith {deleteVehicle _module};

private _class = (_classes select (_resultClass select 0)) select 1;
if (_isParachute == 1) then {_amount = 1};

private _cargo = [];
for "_i" from 1 to _amount do {_cargo pushBack _class};

//Add to the commander console (same entry format as the old "Add" button)
if (_toConsole) exitWith {
	private _arrayName = format ["MCC_ConsoleAirdropArray%1", _faction select 1];
	private _array = missionNamespace getVariable [_arrayName, []];
	_array pushBack [[_cargo], ["I_Heli_Transport_02_F"], _isParachute];
	missionNamespace setVariable [_arrayName, _array];
	publicVariable _arrayName;
	[objNull, format ["Air drop added to the %1 commander console", _faction select 1]] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

private _dropPos = [_pos select 0, _pos select 1, 0];
private _spawn = _dropPos getPos [2000, _dirFrom];
private _away = _dropPos getPos [2000, _dirFrom + 180];

//Side string decides the helicopter class ("west", "east", "guer", "civ")
[_amount, [_cargo], _dropPos, [toLower (_faction select 1)], _spawn, _away, _isParachute] remoteExec ["MCC_fnc_airDrop", 2];
[objNull, "Air drop inbound"] call BIS_fnc_showCuratorFeedbackMessage;

deleteVehicle _module;
