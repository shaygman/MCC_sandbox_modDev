//============================================================MCC_fnc_curatorWarZone========================================================================================
// Create war zone effect"
//===========================================================================================================================================================================
private ["_pos","_module","_resualt"];
_module = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_pos = getpos _module;

_resualt = ["Add Atmosphere",[
						["Radius",1000]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

private ["_radius"];
_radius = _resualt select 0;

[_pos, _radius, 13,_ignorePlayers] remoteExec ["MCC_fnc_deleteBrush",2];

deleteVehicle _module;