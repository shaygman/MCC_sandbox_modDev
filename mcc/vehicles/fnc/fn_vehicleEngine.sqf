/*================== MCC_fnc_vehicleEngine ==================================================
Turn vehicles engine on or off and force it with a loop thats ends when the vehicle is dead or set variable "MCCcuratorUnitEngine" to 2

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
private ["_engine"];

if (isNull _entity || !local _entity) exitWith {};

switch (_mode) do
{
	case 1:	{_engine = false; _entity setVariable ["MCCcuratorUnitEngine",_mode,true]};
	case 2:	{_engine = false; _entity setVariable ["MCCcuratorUnitEngine",_mode,true]};
	default {_engine = true; _entity setVariable ["MCCcuratorUnitEngine",_mode,true]};
};

//If auto no need for a loop
if (_mode == 2) exitWith {};

_entity engineOn _engine;

/*
while {alive _entity && (_entity getVariable ["MCCcuratorUnitEngine",-1] == _mode)} do {
	_entity engineOn _engine;
	sleep 0.01;
};
*/