//==================================================================MCC_fnc_rxUndoLastSpawn===============================================================================
// Delete the last entry of MCC_lastSpawn (an object, or [object, [objects]]) and remove it from the list. Runs on every machine.
// Replaces remote code previously sent through MCC_fnc_globalExecute in mcc\general_scripts\delete\undo.sqf.
// Example: [] remoteExec ["MCC_fnc_rxUndoLastSpawn", 0];
// <IN>
//		Nothing
//
// <OUT>
//		Nothing
//===========================================================================================================================================================================
private ["_last"];

if (isNil "MCC_lastSpawn") exitWith {};

if ((count MCC_lastSpawn)>0) then
{
	_last = MCC_lastSpawn select ((count MCC_lastSpawn)-1);
	if (typeName _last == "ARRAY") then
	{
		deleteVehicle (_last select 0);
		{deleteVehicle _x} forEach (_last select 1);
	}
	else
	{
		deleteVehicle _last;
	};

	MCC_lastSpawn resize ((count MCC_lastSpawn)-1);
};
