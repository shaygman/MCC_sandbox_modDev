/*
	MCC_fnc_rxApplyFatigue
	Applies the MCC fatigue setting (MCC_disableFatigue) to the local player.
	Sent with remoteExec (target 0) by MCC_fnc_settingsCover.
*/
if (!hasInterface || {isNull player}) exitWith {};
player enableFatigue !(missionNamespace getVariable ["MCC_disableFatigue",false]);
