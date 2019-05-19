//==================================================================MCC_fnc_coverInit================================================================================
//Init Cover System
//==================================================================================================================================================================
//Not a client
0 spawn {
	if (!hasInterface || isDedicated) exitWith {};

	waituntil {!(IsNull (findDisplay 46))&& (missionNamespace getVariable ["MCC_cover",false])};

	["MCC_fnc_coverEH", "onEachFrame", {[] call MCC_fnc_cover}] call BIS_fnc_addStackedEventHandler;
};