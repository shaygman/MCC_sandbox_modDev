/*
	MCC_fnc_rxEjectUnconscious
	Pulls an unconscious unit out of a vehicle and keeps it unconscious.
	Sent with remoteExec to the unit's owner by MCC_fnc_interactDoor.
	Params:
		0: OBJECT - the unit
*/
params [["_unit", objNull, [objNull]]];
if (isNull _unit || {!local _unit}) exitWith {};

[_unit] spawn {
	params ["_unit"];
	_unit setUnconscious false;
	unassignVehicle _unit;
	[_unit] orderGetIn false;
	_unit action ["Eject", vehicle _unit];
	moveOut _unit;
	waitUntil {vehicle _unit == _unit};
	sleep 0.1;
	_unit setUnconscious true;
};
