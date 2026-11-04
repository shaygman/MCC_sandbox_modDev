/*=================================================================MCC_fnc_curatorConvoyStart=======================================================================
	Zeus module "Convoy - Drive To": fills the last spawned MCC convoy with cargo and drives it to the module position
	(MCC_fnc_startConvoy). Replaces the old MCC menu Convoy tab "Start convoy" button.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _pos = getPosATL _module;
private _convoy = (missionNamespace getVariable ["MCC_convoyVehicles", []]) select {alive _x};

if (_convoy isEqualTo []) exitWith {
	[objNull, "Spawn a convoy first (Convoy - Spawn module)"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

private _result = ["Convoy - Drive To", [
	["Send the last spawned convoy here", ["Yes", "Cancel"]]
], "The convoy drives in column to this point, its cargo seats are filled first. Add more Zeus waypoints to its group afterwards if needed."] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo [] || {(_result select 0) != 0}) exitWith {deleteVehicle _module};

[[[_pos select 0, _pos select 1, 0]], "0"] remoteExec ["MCC_fnc_startConvoy", 2];
[objNull, "Convoy is moving"] call BIS_fnc_showCuratorFeedbackMessage;

deleteVehicle _module;
