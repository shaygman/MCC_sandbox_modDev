/*=================================================================MCC_fnc_curatorBriefing==========================================================================
	Zeus module "Briefing": adds a briefing (diary) entry for everyone or one side, also for players joining later.
	Replaces the old MCC menu Briefing tab.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _sections = ["Situation","Enemy Forces","Friendly Forces","Mission","Special Tasks","Fire Support"];
private _sides = [sideLogic, west, east, resistance, civilian];

private _result = ["Briefing", [
	["Section", _sections],
	["For", ["Everyone","West","East","Independent","Civilian"]],
	["Text", ""]
], "Adds a diary entry under Briefing for the chosen players."] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _text = _result select 2;
if (_text isEqualTo "") exitWith {
	[objNull, "Briefing text is empty"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

[_sections select (_result select 0), _text, _sides select (_result select 1)] remoteExec ["MCC_fnc_curatorBriefingLocal", 0, true];
[objNull, "Briefing updated"] call BIS_fnc_showCuratorFeedbackMessage;

deleteVehicle _module;
