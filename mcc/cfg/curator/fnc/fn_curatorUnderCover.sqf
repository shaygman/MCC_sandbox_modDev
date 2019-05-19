//============================================================MCC_fnc_curatorUnderCover========================================================================================
// Sets units as undercover agents
//===========================================================================================================================================================================
private ["_object","_module","_resualt","_removeGear","_synced"];
_module = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _module) exitWith {};

//did we get here from the 2d editor?
if (typeName (_module getVariable ["removeGear",true]) == typeName 0) exitWith {

	_removeGear = (_module getVariable ["removeGear",0]) == 1;

	//Who synced with the module
	_synced = synchronizedobjects _module;

	if (player in _synced)then {
		[player,_removeGear] call MCC_fnc_undercoverInit;
	};
};

_object = missionNamespace getVariable ["MCC_curatorMouseOver",[]];

//if no object selected or not a vehicle
_str = "<t size='0.8' t font = 'puristaLight' color='#FFFFFF'>" + "No vehicle selected" + "</t>";
if (count _object <2) exitWith {[_str,0,1.1,2,0.1,0.0] spawn bis_fnc_dynamictext; deleteVehicle _module};
_object = _object select 1;

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_resualt = ["Undercover Agents",[
 						["Remove Weapons",true]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};
_removeGear = _resualt select 0;

[_object,_removeGear] remoteExec ["MCC_fnc_undercoverInit",_object];

deleteVehicle _module;