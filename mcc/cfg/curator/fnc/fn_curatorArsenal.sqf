/*=================================================================MCC_fnc_curatorArsenal===========================================================================
	Zeus module "Arsenal (Zeus player)": closes Zeus and opens the full Virtual Arsenal for the Zeus player's own unit.
	Replaces the old MCC menu Arsenal button.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

deleteVehicle _module;

if (!alive player) exitWith {};

(findDisplay 312) closeDisplay 2;
waitUntil {isNull curatorCamera && {isNull (findDisplay 312)}};
sleep 0.5;
["Open", true] call BIS_fnc_arsenal;
