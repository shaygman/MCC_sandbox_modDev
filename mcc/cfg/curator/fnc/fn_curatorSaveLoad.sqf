/*=================================================================MCC_fnc_curatorSaveLoad==========================================================================
	Zeus module "Save / Load Mission": opens the MCC save/load screen (save to profile slots or clipboard, load, export
	to SQM / composition, activate or clear the persistent database). Replaces the old MCC menu Save/Load button.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

deleteVehicle _module;

if !(createDialog "MCC_SaveLoadScreen") then {
	[objNull, "Could not open the MCC save/load screen"] call BIS_fnc_showCuratorFeedbackMessage;
};
