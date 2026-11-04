//==================================================================MCC_fnc_rxCuratorAddEditable===============================================================================
// Add objects to the MCC curator (MCC_curator) editable objects. Runs on the server, where MCC_curator is defined.
// Replaces remote code previously sent through BIS_fnc_spawn in MCC_fnc_vehicleSpawner / MCC_fnc_vehicleSpawnerInit.
// Example: [[_vehicle]] remoteExec ["MCC_fnc_rxCuratorAddEditable", 2];
// <IN>
//	_objects:					ARRAY of OBJECTS - objects to add
//
// <OUT>
//		Nothing
//===========================================================================================================================================================================
params [["_objects",[],[[]]]];

if (isNil "MCC_curator") exitWith {};
MCC_curator addCuratorEditableObjects [_objects,false];
