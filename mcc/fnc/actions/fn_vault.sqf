/*=============================================================MCC_fnc_vault===============================================================================================
//Vault over an obstacle
// Example: [] call MCC_fnc_vault;
//======================================================================================================================================================================*/

private ["_endPos","_hight","_startAnim","_endAnim"];
_hight = player getVariable ["MCC_wallAhead",""];

player SetVariable ["MCC_vaultOver",true];

switch (_hight) do
{
	case "low":
	{
		_startAnim = "AovrPercMrunSrasWrflDf";
		_endAnim = "";
		_endPos = player modelToworld [0,1.5,1];
	};

	case "med":
	{
		_startAnim = "GetInMRAP_01_cargoRfl";
		_endAnim = "AcrgPknlMstpSnonWnonDnon_AmovPercMstpSrasWrflDnon_getOutMedium";
		_endPos = player modelToworld [0,2,1];
	};

	case "high":
	{
		_startAnim = "GetInMRAP_01_cargoRfl";
		_endAnim = "AcrgPknlMstpSnonWnonDnon_AmovPercMstpSrasWrflDnon_getOutHigh";
		_endPos = player modelToworld [0,2.2,1];
	};
};

player setpos (player modelToworld [0,-0.2,0]);
//player switchmove _startAnim;
[[player, _startAnim, true, 0], "MCC_fnc_setUnitAnim", true, false] call BIS_fnc_MP;

waituntil {(animationState player) != _startAnim};

switch (_hight) do
{
	case "low":
	{
		sleep 0.3;
	};

	default
	{
		sleep 1;
	};
};


player setpos _endPos;

if (_endAnim != "") then {
	[[player, _endAnim, true, 0], "MCC_fnc_setUnitAnim", true, false] call BIS_fnc_MP;
};

sleep 1;
player SetVariable ["MCC_vaultOver",false];
player setVariable ["MCC_wallAhead",""];