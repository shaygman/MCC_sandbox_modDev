//AI Skill(overall)
[
    "MCC_AI_Skill_Index",
    "SLIDER",
   	"AI Skill(overall)",
    ["MCC GAIA","AI Skill"],
    [1, 10, 5, 0],
    true,
    {
    	MCC_AI_Skill = MCC_AI_Skill_Index/10;
    	publicVariable "MCC_AI_Skill";
    }
] call CBA_Settings_fnc_init;

//AI Skill(aim)
[
    "MCC_AI_AimIndex",
    "SLIDER",
   	"AI Skill(Aim)",
    ["MCC GAIA","AI Skill"],
    [1, 10, 5, 0],
    true,
    {
    	MCC_AI_Aim = MCC_AI_AimIndex/10;
    	publicVariable "MCC_AI_Aim";
    }
] call CBA_Settings_fnc_init;

//AI Skill(Spot)
[
    "MCC_AI_SpotIndex",
    "SLIDER",
   	"AI Skill(Spot)",
    ["MCC GAIA","AI Skill"],
    [1, 10, 5, 0],
    true,
    {
    	MCC_AI_Spot = MCC_AI_SpotIndex/10;
    	publicVariable "MCC_AI_Spot";
    }
] call CBA_Settings_fnc_init;

//AI Skill(Command)
[
    "MCC_AI_CommandIndex",
    "SLIDER",
   	"AI Skill(Command)",
    ["MCC GAIA","AI Skill"],
    [1, 10, 5, 0],
    true,
    {
    	MCC_AI_Command = MCC_AI_CommandIndex/10;
    	publicVariable "MCC_AI_Command";
    }
] call CBA_Settings_fnc_init;

//AI Skill(Command)
[
    "MCC_AI_CommandIndex",
    "SLIDER",
   	"AI Skill(Command)",
    ["MCC GAIA","AI Skill"],
    [1, 10, 5, 0],
    true,
    {
    	MCC_AI_Command = MCC_AI_CommandIndex/10;
    	publicVariable "MCC_AI_Command";
    }
] call CBA_Settings_fnc_init;

//AI use smoke grenade and flares
[
    "MCC_GAIA_AMBIANT",
    "CHECKBOX",
   	"AI Use Smoke Grenades & flares",
   	["MCC GAIA","AI Smoke & Flares"],
    false,
    true
] call CBA_Settings_fnc_init;

//AI use smoke grenade and flares
[
    "MCC_GAIA_AMBIANT_CHANCE",
    "SLIDER",
   	"Smoke/flares Chance",
  	["MCC GAIA","AI Smoke & Flares"],
    [20, 80, 50, 0],
    true
] call CBA_Settings_fnc_init;

//AI Cache
[
    "GAIA_CACHE_STAGE_1",
    "SLIDER",
   	["Cache Distance","How far any player should be from a unit before it cached"],
  	"MCC GAIA",
    [1000, 10000, 3000, 0],
    true
] call CBA_Settings_fnc_init;

//AI use smoke grenade and flares
[
    "MCC_GAIA_ATTACKS_FOR_NONGAIA",
    "CHECKBOX",
   	["GAIA Controlls All","If set to everyone GAIA will give order to all units availables even players"],
   	"MCC GAIA",
    false,
    true
] call CBA_Settings_fnc_init;