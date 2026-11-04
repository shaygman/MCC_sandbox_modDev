/*
	MCC_fnc_rxAddCatapultAction
	Adds the "Steam Catapult" action to an aircraft on a CUP LHD deck.
	Sent with remoteExec (target 0, JIP) by MCC_fnc_LHDspawnVehicle.
	Params:
		0: OBJECT - the aircraft
*/
params [["_cargo", objNull, [objNull]]];
if (!hasInterface || {isNull _cargo}) exitWith {};

_cargo addAction ["<t color=""#ff1111"">Steam Catapult</t>",{
	_target = (_this select 0);
	driver (_target) action ["ENGINEON", _target];
	addCamShake [5, 4, 15];
	for [{_i=1},{_i<=50},{_i=_i+5}] do {
		_target setvelocity [_i* sin (getdir _target),_i * cos (getdir _target),.15];
		sleep 0.02;
	};
},[],1,true,true,"action","(driver _target == _this) && (isEngineOn _target) &&(_target distance2D (missionNamespace getVariable ['MCC_startfly',[0,0,0]])<15)"];
