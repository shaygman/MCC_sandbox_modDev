/*=================================================================MCC_fnc_curatorStartLocation=====================================================================
	Zeus module "Start Location / FOB": builds a side's HQ start location or a FOB respawn point at the module position
	(MCC_fnc_buildSpawnPoint). Replaces the old MCC menu Start Location tab.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _pos = getPosATL _module;
private _dir = getDir _module;

private _result = ["Start Location / FOB", [
	["Side", ["West","East","Independent","Civilian"]],
	["Type", ["HQ (start location)","FOB (respawn point)"]],
	["At mission start", ["Teleport","None","Paradrop","HALO"]],
	["FOB can be destroyed", false],
	["Show HQ icon (3D)", false]
], "Use the 'Respawn / Mission Start' module to teleport players to their start location."] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _sideIndex = _result select 0;
private _sideName = ["west","east","GUER","CIV"] select _sideIndex;
private _isHQ = (_result select 1) == 0;
private _teleport = [1,0,2,3] select (_result select 2);
private _destructable = _result select 3;
private _hud = _result select 4;
private _spawnPos = [_pos select 0, _pos select 1, 0];

if (_isHQ) then {
	if (_sideIndex == 3) then {
		//Civilians have no HQ building, only the start position (old menu behaviour)
		MCC_START_CIV = _spawnPos;
		publicVariable "MCC_START_CIV";
	} else {
		[_spawnPos, _dir, _sideName, "HQ", false, false, true, _teleport, _hud] remoteExec ["MCC_fnc_buildSpawnPoint", 2];
	};
	[objNull, format ["Start location %1 updated", toUpper _sideName]] call BIS_fnc_showCuratorFeedbackMessage;
} else {
	[_spawnPos, _dir, _sideName, "FOB", _destructable, false, false, _teleport] remoteExec ["MCC_fnc_buildSpawnPoint", 2];
	[objNull, "FOB placed"] call BIS_fnc_showCuratorFeedbackMessage;
};

deleteVehicle _module;
