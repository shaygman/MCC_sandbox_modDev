/*=================================================================MCC_fnc_curatorHostage===========================================================================
	Zeus module "Make Hostage": turns the unit the module was placed on into a tied up hostage that players can untie
	(same as the old MCC hostage / Mission Wizard HVT). Place a unit with Zeus first, then drop this module on it.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _mouseOver = missionNamespace getVariable ["MCC_curatorMouseOver", []];
private _unit = if (count _mouseOver > 1) then {_mouseOver select 1} else {objNull};

if !(_unit isEqualType objNull && {!isNull _unit} && {_unit isKindOf "CAManBase"} && {alive _unit}) exitWith {
	[objNull, localize "STR_GENERAL_ERROR_NOOBJECTSELECTED"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

if (isPlayer _unit) exitWith {
	[objNull, "Can't make a player a hostage"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

if (_unit getVariable ["MCC_isHostage", false]) exitWith {
	[objNull, "Already a hostage"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

[_unit] remoteExec ["MCC_fnc_curatorMakeHostage", _unit];
[objNull, format ["%1 is now a hostage", name _unit]] call BIS_fnc_showCuratorFeedbackMessage;

deleteVehicle _module;
