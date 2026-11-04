/*=================================================================MCC_fnc_curatorConvoy============================================================================
	Zeus module "Convoy - Spawn": spawns an MCC convoy (up to 5 vehicles, optional HVT in the middle vehicle) at the module
	position, facing the chosen heading. Use the "Convoy - Drive To" module (MCC_fnc_curatorConvoyStart) to send it.
	Replaces the old MCC menu Convoy tab (place convoy).
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

private _result = ["Convoy - Spawn (1/2)", [
	["Faction", _factions apply {format ["%1 (%2)", _x select 0, _x select 1]}],
	["Heading", _headings]
]] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _faction = _factions select (_result select 0);
private _factionClass = _faction select 2;
private _sideName = toLower (_faction select 1);
private _heading = (_result select 1) * 45;

private _vehicles = [_factionClass, ["Car","Tank"]] call MCC_fnc_curatorFactionClasses;
if (_vehicles isEqualTo []) exitWith {
	[objNull, "This faction has no vehicles"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

private _vehicleNames = _vehicles apply {_x select 0};
private _hvts = missionNamespace getVariable ["MCC_convoyHVT", [["None","0"]]];
private _hvtCars = missionNamespace getVariable ["MCC_convoyHVTcar", [["Default",""]]];

waitUntil {isNull (findDisplay 1031982)};

private _resultCars = ["Convoy - Spawn (2/2)", [
	["Vehicle 1 (lead)", _vehicleNames],
	["Vehicle 2", ["None"] + _vehicleNames],
	["Vehicle 3", ["None"] + _vehicleNames],
	["Vehicle 4", ["None"] + _vehicleNames],
	["Vehicle 5", ["None"] + _vehicleNames],
	["HVT", _hvts apply {_x select 0}],
	["HVT vehicle", _hvtCars apply {_x select 0}]
], "The HVT rides in the middle vehicle. Place a 'Convoy - Drive To' module to send the convoy."] call MCC_fnc_initDynamicDialog;

if (_resultCars isEqualTo []) exitWith {deleteVehicle _module};

private _classes = [(_vehicles select (_resultCars select 0)) select 1];
for "_i" from 1 to 4 do {
	private _index = _resultCars select _i;
	if (_index > 0) then {_classes pushBack ((_vehicles select (_index - 1)) select 1)};
};

private _vip = (_hvts select (_resultCars select 5)) select 1;
private _vipCar = (_hvtCars select (_resultCars select 6)) select 1;
private _headingPos = _pos getPos [100, _heading];

[_classes, [_pos select 0, _pos select 1, 0], _headingPos, _sideName, _vip, _vipCar] remoteExec ["MCC_fnc_curatorConvoyServer", 2];
[objNull, format ["Convoy of %1 vehicles placed", count _classes]] call BIS_fnc_showCuratorFeedbackMessage;

deleteVehicle _module;
