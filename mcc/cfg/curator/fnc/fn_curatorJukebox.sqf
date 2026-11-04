/*=================================================================MCC_fnc_curatorJukebox===========================================================================
	Zeus module "Jukebox": play music or a sound to every player now, stop the music, or create an area trigger at the
	module position that plays the track when activated (MCC_fnc_MusicTrigger). Replaces the old MCC menu Jukebox tab.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _pos = getPosATL _module;
private _radii = [25,50,100,200,300,500,1000];
private _activateArray = missionNamespace getVariable ["MCC_musicActivateby_array", ["ANY"]];
private _condArray = missionNamespace getVariable ["MCC_musicCond_array", ["PRESENT"]];

private _result = ["Jukebox", [
	["Type", ["Music", "Sound"]],
	["Action", ["Play to everyone now", "Stop music for everyone", "Play when area trigger activates"]],
	["Trigger radius (m)", _radii apply {str _x}],
	["Trigger activated by", _activateArray],
	["Trigger condition", _condArray]
]] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _isMusic = (_result select 0) == 0;
private _action = _result select 1;

//Stop
if (_action == 1) exitWith {
	"" remoteExec ["playMusic", 0];
	deleteVehicle _module;
};

//Build the tracks list (same configs as the old jukebox)
private _cfgs = if (_isMusic) then {
	[missionConfigFile >> "CfgMusic", configFile >> "CfgMusic"]
} else {
	[missionConfigFile >> "CfgSounds", configFile >> "CfgSounds", configFile >> "CfgSFX"]
};

private _tracks = [];
{
	{
		private _name = getText (_x >> "name");
		if (_name isEqualTo "") then {_name = configName _x};
		_tracks pushBack [_name, configName _x];
	} forEach ("true" configClasses _x);
} forEach _cfgs;

if (_tracks isEqualTo []) exitWith {
	[objNull, "No tracks found"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

//Wait for the first dialog to close before opening the next one
waitUntil {isNull (findDisplay 1031982)};

private _resultTrack = ["Jukebox - select track", [
	["Track", _tracks apply {_x select 0}]
]] call MCC_fnc_initDynamicDialog;

if (_resultTrack isEqualTo []) exitWith {deleteVehicle _module};

private _track = (_tracks select (_resultTrack select 0)) select 1;

if (_action == 0) then {
	if (_isMusic) then {
		_track remoteExec ["playMusic", 0];
	} else {
		if (isClass (configFile >> "CfgSounds" >> _track) || {isClass (missionConfigFile >> "CfgSounds" >> _track)}) then {
			_track remoteExec ["playSound", 0];
		} else {
			[objNull, "Only CfgSounds sounds can be played directly, use an area trigger for SFX"] call BIS_fnc_showCuratorFeedbackMessage;
		};
	};
} else {
	private _radius = _radii select (_result select 2);
	private _activate = _activateArray select (_result select 3);
	private _cond = _condArray select (_result select 4);
	["", [_pos select 0, _pos select 1, 0], _radius, _radius, _activate, _cond, _track, _isMusic] remoteExec ["MCC_fnc_MusicTrigger", 0];
	[objNull, format ["Trigger created: %1 (%2, %3)", _track, _activate, _cond]] call BIS_fnc_showCuratorFeedbackMessage;
};

deleteVehicle _module;
