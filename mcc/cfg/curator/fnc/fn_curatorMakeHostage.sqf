/*=================================================================MCC_fnc_curatorMakeHostage=======================================================================
	Runs where the unit is local (AI commands like disableAI need it): makes the unit a hostage through the existing
	MCC hostage script (MCC_fnc_s_create_hostage).
	Params:
		0: OBJECT - the unit
	Returns: nothing
	Example: [_unit] remoteExec ["MCC_fnc_curatorMakeHostage", _unit];
//==================================================================================================================================================================*/
params [["_unit", objNull, [objNull]]];

if (isNull _unit || {!local _unit} || {!alive _unit} || {isPlayer _unit}) exitWith {};
if !(["MCC_fnc_curatorMakeHostage"] call MCC_fnc_remoteAllowed) exitWith {};
if (_unit getVariable ["MCC_isHostage", false]) exitWith {};

_unit setVariable ["MCC_isHostage", true, true];
_unit spawn MCC_fnc_s_create_hostage;
