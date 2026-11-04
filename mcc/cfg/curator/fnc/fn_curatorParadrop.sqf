/*=================================================================MCC_fnc_curatorParadrop==========================================================================
	Zeus module "Paradrop Units": flies a group (the unit the module was placed on) or all players of a side to the module
	position and drops them by parachute, drop pods or HALO (MCC_fnc_realParadrop). Replaces the old MCC menu
	Unit Management "Parachute" / "H.A.L.O" buttons.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _pos = getPosATL _module;
private _mouseOver = missionNamespace getVariable ["MCC_curatorMouseOver", []];
private _target = if (count _mouseOver > 1) then {_mouseOver select 1} else {objNull};
private _targetGroup = switch (true) do {
	case (_target isEqualType grpNull): {_target};
	case (_target isEqualType objNull && {!isNull _target}): {group effectiveCommander _target};
	default {grpNull};
};

private _headings = ["North","North-East","East","South-East","South","South-West","West","North-West"];

private _result = ["Paradrop Units", [
	["Who", ["Group the module was placed on","All players","All West players","All East players","All Independent players"]],
	["Method", ["Parachute","Drop pods","H.A.L.O"]],
	["Coming from", _headings]
], "Place the module on a unit to drop its group."] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _who = _result select 0;
private _players = allPlayers - (entities "HeadlessClient_F");
private _units = switch (_who) do {
	case 0: {if (isNull _targetGroup) then {[]} else {units _targetGroup}};
	case 1: {_players};
	case 2: {_players select {side group _x == west}};
	case 3: {_players select {side group _x == east}};
	default {_players select {side group _x == resistance}};
};
_units = _units select {alive _x && {!(_x isKindOf "Logic")}};

if (_units isEqualTo []) exitWith {
	[objNull, "No units to drop (place the module on a unit for 'Group')"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

private _dropPos = [_pos select 0, _pos select 1, 0];
private _dirFrom = (_result select 2) * 45;
private _spawn = _dropPos getPos [2000, _dirFrom];
private _away = _dropPos getPos [2000, _dirFrom + 180];

//MCC_fnc_realParadrop: 0 = units list, method 0 parachute / 1 drop pods / 2 HALO
[_dropPos, _units, 0, _result select 1, _spawn, _away] remoteExec ["MCC_fnc_realParadrop", 2];
[objNull, format ["Paradropping %1 units", count _units]] call BIS_fnc_showCuratorFeedbackMessage;

deleteVehicle _module;
