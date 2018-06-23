/*=================================================================MCC_fnc_setUnconscious=================================================================================
Set AI unit unconscious from 3den or Curator
=======================================================================================================================================================================*/
private ["_object","_module","_resualt","_enableBleeding","_forceUnconscious"];
_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {};

//did we get here from the 2d editor?
if (typeName (_module getVariable ["enableBleeding",0]) == typeName true) exitWith {

	_enableBleeding = (_module getVariable ["enableBleeding",false]);
	_forceUnconscious = (_module getVariable ["forceUnconscious",false]);

	//Who synced with the module
	{
		if (_x isKindOf "Man") then {
			[_x,objnull,_enableBleeding,_forceUnconscious] remoteExec ["MCC_fnc_unconscious",_x];
		};
	} forEach (synchronizedobjects _module);
};

_object = missionNamespace getVariable ["MCC_curatorMouseOver",[]];

//if no object selected or not a vehicle
_str = "<t size='0.8' t font = 'puristaLight' color='#FFFFFF'>" + "No unit selected" + "</t>";
if (count _object <2) exitWith {[_str,0,1.1,2,0.1,0.0] spawn bis_fnc_dynamictext; deleteVehicle _module};
_object = _object select 1;

if !(_object isKindOf "Man") exitWith {systemchat "No unit selected"; deleteVehicle _module};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_resualt = ["Set Unconscious",[
 						["Disable Bleeding",false],
 						["Force Unconscious",false]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};
_enableBleeding = _resualt select 0;
_forceUnconscious = _resualt select 1;

[_object,objnull,_enableBleeding,_forceUnconscious] remoteExec ["MCC_fnc_unconscious",_object];

deleteVehicle _module;