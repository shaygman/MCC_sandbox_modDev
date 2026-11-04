/*
	MCC_fnc_rxAddShipControlAction
	Adds the "Ship Control" action that opens the ship spawn menu.
	Sent with remoteExec (target 0, JIP) by MCC_fnc_LHDSpawn.
	Params:
		0: OBJECT - the ship's control object
		1: NUMBER - the ship's index in the ships array
*/
params [["_dummy", objNull, [objNull]], ["_index", 0, [0]]];
if (!hasInterface || {isNull _dummy}) exitWith {};

_dummy addAction ["<t color=""#ff1111"">Ship Control</t>", {[0, (_this select 3), 2] spawn MCC_fnc_LHDspawnMenuInit}, _index];
