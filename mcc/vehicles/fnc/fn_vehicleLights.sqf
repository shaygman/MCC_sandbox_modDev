/*================== MCC_fnc_vehicleLights ==================================================
Turn vehicles lights on or off and force it wiht a loop thats ends when the vehicle is dead or set variable "MCCcuratorUnitLights" to 2

NEED TO RUN WHERE THE VEHICLE IS LOCAL

<IN>
	0:		OBJECT: vehicle
	1:		INTEGER: 	0 - on
						1 - off
						2 - auto

==============================================================================================*/
params [
	["_entity",objNull,[objNull]],
	["_mode",0,[0]]
];
private ["_lights"];

if (isNull _entity || !local _entity) exitWith {};

switch (_mode) do
{
	case 1:	{_lights = false; _entity setVariable ["MCCcuratorUnitLights",_mode,true]};
	case 2:	{_lights = false; _entity setVariable ["MCCcuratorUnitLights",_mode,true]};
	default {_lights = true; _entity setVariable ["MCCcuratorUnitLights",_mode,true]};
};

//If auto no need for a loop
if (_mode == 2) exitWith {};

while {alive _entity && (_entity getVariable ["MCCcuratorUnitLights",-1] == _mode)} do {
	_entity setPilotLight _lights;
	_entity setCollisionLight _lights;
	sleep 0.01;
};