//==================================================================MCC_fnc_setTime======================================================================================
// Setstime on all clients
// Example: [year, month, day, hour, minute] remoteExec ["MCC_fnc_setTime",0];
//	year: number, YYYY
//	month: number, MM
//	day: number, DD
//	hour: number, HH
// 	minute: number, mm
//==============================================================================================================================================================================	

private ["_time"];

_time = _this select 0;
setDate _time;
