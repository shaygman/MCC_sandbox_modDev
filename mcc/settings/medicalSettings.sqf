if (count (allMissionObjects "MCC_Module_settingsMedicSystem") == 0) then {
	//if ACE enabled exit
	if !(isClass (configFile >> "CfgPatches" >> "ace_medical")) then {

		//Enable MCC Medic System
		[
		    "MCC_medicSystemEnabled",
		    "CHECKBOX",
		   	["Enable MCC Medic System","Requires mission restart!"],
		    "MCC Medical System",
		    false,
		    true
		] call CBA_Settings_fnc_init;

		//Enable MCC Complex Medic System
		[
		    "MCC_medicComplex",
		    "CHECKBOX",
		   	["Complex System","Requires mission restart! Complex system replace all the default ArmA items with advanced items such as bandages, epipens exc"],
		    "MCC Medical System",
		    false,
		    true
		] call CBA_Settings_fnc_init;

		//Medic Heal
		[
		    "MCC_medicOnlyMedicHeals",
		    "CHECKBOX",
		   	["Medic Only Heal","Only medics can use FAK to heal others can only use bandages to stop bleeding"],
		    "MCC Medical System",
		   	false,
		    true
		] call CBA_Settings_fnc_init;

		//Medic HUD
		[
		    "MCC_medicShowWounded",
		    "CHECKBOX",
		   	["Medic HUD","Show wounded units as a cross on HUD"],
		    "MCC Medical System",
		   	false,
		    true
		] call CBA_Settings_fnc_init;

		//Bleeding
		[
		    "MCC_medicBleedingEnabled",
		    "CHECKBOX",
		   	["Bleeding","Players and AI will suffer from bleeding effects and will need to stop bleeding or die over time"],
		    "MCC Medical System",
		    false,
		    true
		] call CBA_Settings_fnc_init;

		//Bleeding Time
		[
		    "MCC_medicBleedingTime",
		    "SLIDER",
		   	["Bleeding Time","How long in seconds it will take for unconscious unit to die from bleeding"],
		    "MCC Medical System",
		    [30,1200,300,0],
		    true
		] call CBA_Settings_fnc_init;

		//Bulletproof Vests Effectiveness
		[
		    "MCC_medicDamageCoef_index",
		    "SLIDER",
		   	["Bulletproof Vests Effectiveness","Players can take more damage than usual"],
		    "MCC Medical System",
		    [0,5,2,0],
		    true,
		    {
		    	MCC_medicDamageCoef = (10-MCC_medicDamageCoef_index)/10;
		    }
		] call CBA_Settings_fnc_init;

		//Punish Team Kill
		[
		    "MCC_medicPunishTK",
		    "CHECKBOX",
		   	["Punish Team Kill","Player who died by friendly fire can forgive or punish the killer"],
		    "MCC Medical System",
		   	false,
		    true
		] call CBA_Settings_fnc_init;
	};
};