//==========================================================MCC_fnc_curatorDoorLock========================================================================================
// Manage doors status
//===========================================================================================================================================================================
private ["_pos","_module","_resualt"];
_module = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_pos = getpos _module;

_resualt = ["Lock/Unlock Doors",[
 						["Radius",500],
 						["Lock Doors",["Lock All","Lock Random","Unlock All"]]
 					  ],format ["<t align='center'> %1</t>","Lock or unlock buildings doors in the given radius, locked door can be opened with breaching charges or lockpicking using MCC interaction"]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

private ["_radius"];
_radius = _resualt select 0;

[[_pos, _radius, (_resualt select 1)+10], "MCC_fnc_deleteBrush", false, false] call BIS_fnc_MP;

deleteVehicle _module;