//===================================================================MCC_fnc_broadcast=========================================================================================
// Create a virtual camera and broadcast a short PiP video to all clients for 15 seconds. 
// Example: [[netid soldier1,soldier1], 0] remoteExec ["MCC_fnc_broadcast",0];
// Params:
// 	soldier1: object - livefeed target
//	 0: number - video mode 0: video, 1:night vision, 2:thermal
//==============================================================================================================================================================================	
private "_dummy";
_dummy = if (((_this select 0) select 0)=="") then {(_this select 0) select 1} else {objectFromNetId ((_this select 0) select 0)}; 
[_dummy, (_this select 1)] spawn MCC_fnc_s_umBroadcast;
