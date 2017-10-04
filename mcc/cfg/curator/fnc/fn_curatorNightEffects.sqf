//============================================================MCC_fnc_curatorNightEffects========================================================================================
// Manage night effects
//===========================================================================================================================================================================
private ["_pos","_module","_resualt"];
_module = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_pos = getpos _module;

_resualt = ["Set Night Effects",[
 						["Radius",500],
 						["Lights Off",true],
 						["Remove Night Vision",true],
 						["Add Flashlights",true],
 						["Ignore Player's Units",false]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

private ["_radius","_ignorePlayers"];
_radius = _resualt select 0;
_ignorePlayers = _resualt select 4;

//Lights
if (_resualt select 1) then {
	[_pos, _radius, 8,_ignorePlayers] remoteExec ["MCC_fnc_deleteBrush",2];
} else {
	[_pos, _radius, 9,_ignorePlayers] remoteExec ["MCC_fnc_deleteBrush",2];
};

//NV
if (_resualt select 2) then {
	[_pos, _radius, 19,_ignorePlayers] remoteExec ["MCC_fnc_deleteBrush",2];
};

//Flashlights
if (_resualt select 3) then {
	[_pos, _radius, 20,_ignorePlayers] remoteExec ["MCC_fnc_deleteBrush",2];
};


deleteVehicle _module;