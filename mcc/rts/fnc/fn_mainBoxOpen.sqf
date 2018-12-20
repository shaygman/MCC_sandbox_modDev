//==================================================================MCC_fnc_mainBoxOpen===========================================================================
// Opens the main box (survival box on start location)
// Example:[_object]  call MCC_fnc_mainBoxOpen;
// <IN>
//      <_object>           The box vehicle
//
// <OUT>
//      <Nothing>
//===========================================================================================================================================================================
private ["_target"];
disableSerialization;

_object = param [0,missionnamespace,[missionnamespace,objnull]];
_null = [_object] call MCC_fnc_mainBoxInit;
