//==================================================================MCC_fnc_globalExecute======================================================================================
// Global execute a command on selected clients or server
// Example: [mode,code] remoteExec ["MCC_fnc_globalExecute", 0];
// Params:
//	mode: number, 0:clients only, 1: server only 2: all clients and server
//	code: code, code to be executed
//==============================================================================================================================================================================
// Runs whatever code it is sent. Used by the mission maker command line ("Global").
// In Strict network security only the server and players allowed to use MCC can trigger it.
if !(["MCC_fnc_globalExecute"] call MCC_fnc_remoteAllowed) exitWith {};
private ["_code","_type"];

_type 	= _this select 0;
_code 	= _this select 1;

switch (_type) do {
	case 0:	//clients
	{
		if (!isServer) then {call _code};
	};

	case 1:	//Server
	{
		if (isServer) then {call _code};
	};

	case 2:	//all
	{
		call _code;
	};
};
