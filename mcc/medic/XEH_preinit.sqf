//Add Event handlers

//If ACE medic is on exit
if (!(isClass (configFile >> "CfgPatches" >> "ace_medical")) && (missionNamespace getvariable ["MCC_medicSystemEnabled",false])) then {

	["CAManBase", "init",MCC_fnc_initMedicXEH] call CBA_fnc_addClassEventHandler;
	["CAManBase", "Respawn",MCC_fnc_initMedicXEH] call CBA_fnc_addClassEventHandler;
} else {
	diag_log format ["%1 MCC Medic System: Can't init ACE medic is on", time];
};

