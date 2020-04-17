/*=================================================================MCC_fnc_setUnconscious=================================================================================
Set AI unit unconscious from 3den or Curator
=======================================================================================================================================================================*/
private ["_object","_module","_resualt","_enableBleeding","_forceUnconscious"];
_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {};

//did we get here from the 2d editor?
if (typeName (_module getVariable ["enableBleeding",0]) == typeName true) exitWith {

	if (isServer) then {
		_enableBleeding = (_module getVariable ["enableBleeding",false]);
		_forceUnconscious = (_module getVariable ["forceUnconscious",false]);

		//Who synced with the module
		{
			if (_x isKindOf "Man") then {
				[_x,objnull,_enableBleeding,_forceUnconscious] remoteExec ["MCC_fnc_unconscious",_x];
			};
		} forEach (synchronizedobjects _module);
	};
};

_object = missionNamespace getVariable ["MCC_curatorMouseOver",[]];

//if no object selected or not a vehicle
if (count _object <2) exitWith {
	[objNull, localize "STR_GENERAL_ERROR_NOUNITSELECTED"] call bis_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};
_object = _object select 1;

if !(_object isKindOf "Man") exitWith {systemchat "No unit selected"; deleteVehicle _module};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_resualt = ["Set Unconscious",[
 						["Disable Bleeding",false,"Disable bleeding over time and eventually die"],
 						["Force Unconscious",false,"Disable the chance to randomly wake up"]
 					  ],"<t align='center'>Turn AI unit unconscious - will only work while <t underline='true'>MCC medical</t> system is enabled<\t>"] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};
_enableBleeding = _resualt select 0;
_forceUnconscious = _resualt select 1;

[_object,objnull,_enableBleeding,_forceUnconscious] remoteExec ["MCC_fnc_unconscious",_object];

deleteVehicle _module;