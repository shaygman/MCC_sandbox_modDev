/*=================================================================MCC_fnc_curatorCASConsole========================================================================
	Zeus module "CAS for Commander Console": gives a side's commander console a CAS / AC-130 / UAV call (plane + CAS type),
	like the old MCC menu CAS tab "Add" button. To fire CAS right away use the "CAS - MCC" module.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _casTypes = missionNamespace getVariable ["MCC_CASBombs", []];
private _planes = (missionNamespace getVariable ["MCC_vehicles_airplanes", []]) + (missionNamespace getVariable ["MCC_vehicles_helicopters", []]);
if (_planes isEqualTo []) then {
	_planes = (["", ["Plane","Helicopter"]] call MCC_fnc_curatorFactionClasses) apply {[_x select 1, _x select 0]};
};

if (_casTypes isEqualTo [] || {_planes isEqualTo []}) exitWith {
	[objNull, "No CAS types or aircraft found"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

private _sides = ["WEST","EAST","GUER"];

private _result = ["CAS for Commander Console", [
	["Side", ["West","East","Independent"]],
	["Aircraft", _planes apply {_x select 1}],
	["CAS", _casTypes]
], "AC-130 needs an armed VTOL/gunship, UAV a drone."] call MCC_fnc_initDynamicDialog;

deleteVehicle _module;
if (_result isEqualTo []) exitWith {};

private _sideName = _sides select (_result select 0);
private _plane = (_planes select (_result select 1)) select 0;
private _cas = _casTypes select (_result select 2);

private _arrayName = format ["MCC_CASConsoleArray%1", _sideName];
private _array = missionNamespace getVariable [_arrayName, []];
_array pushBack [[_cas], [_plane]];
missionNamespace setVariable [_arrayName, _array];
publicVariable _arrayName;

["MCCNotifications", [format ["%1 CAS available", _cas], format ["%1data\ammo_icon.paa", missionNamespace getVariable ["MCC_path", ""]], ""]] remoteExec ["BIS_fnc_showNotification", [west, east, resistance] select (_result select 0)];
[objNull, format ["%1 added to the %2 commander console", _cas, _sideName]] call BIS_fnc_showCuratorFeedbackMessage;
