/*=================================================== MCC_fnc_moduleMusic ===================================================
	Eden module "MCC Music / Sound" (MCC_Module_music). Plays a CfgMusic track or a CfgSounds sound for every player when a
	synced trigger activates, or at mission start when no trigger is synced. Runs on the server only (isGlobal = 0) and plays
	again every time a repeatable trigger activates.

	Params (module framework):
		0: OBJECT - the module logic
		1: ARRAY  - synced units (unused)
		2: BOOL   - activated
	Returns: nothing
*/
params [
	["_logic", objNull, [objNull]],
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if (!isServer || {isNull _logic} || {!_activated}) exitWith {};

[_logic] spawn {
	params ["_logic"];

	waitUntil {sleep 0.5; time > 0};

	private _track = _logic getVariable ["track", ""];
	private _type = _logic getVariable ["trackType", 0];
	if !(_track isEqualType "") exitWith {};
	if !(_type isEqualType 0) then {_type = 0};

	//Stop music
	if (_type == 2) exitWith {"" remoteExec ["playMusic", 0]};
	if (_track == "") exitWith {diag_log "MCC Music module: no track set"};

	if (_type == 1) then {
		if (isClass (configFile >> "CfgSounds" >> _track) || {isClass (missionConfigFile >> "CfgSounds" >> _track)}) then {
			_track remoteExec ["playSound", 0];
		} else {
			diag_log format ["MCC Music module: sound '%1' not found in CfgSounds", _track];
		};
	} else {
		if (isClass (configFile >> "CfgMusic" >> _track) || {isClass (missionConfigFile >> "CfgMusic" >> _track)}) then {
			_track remoteExec ["playMusic", 0];
		} else {
			diag_log format ["MCC Music module: track '%1' not found in CfgMusic", _track];
		};
	};
};
