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
] call CBA_fnc_addSetting;

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
] call CBA_fnc_addSetting;

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
] call CBA_fnc_addSetting;

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
] call CBA_fnc_addSetting;

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
] call CBA_fnc_addSetting;

//AI use smoke grenade and flares
[
    "MCC_GAIA_AMBIANT",
    "CHECKBOX",
   	"AI Use Smoke Grenades & flares",
   	["MCC GAIA","AI Smoke & Flares"],
    false,
    true
] call CBA_fnc_addSetting;

//AI use smoke grenade and flares
[
    "MCC_GAIA_AMBIANT_CHANCE",
    "SLIDER",
   	"Smoke/flares Chance",
  	["MCC GAIA","AI Smoke & Flares"],
    [20, 80, 50, 0],
    true
] call CBA_fnc_addSetting;

//AI Cache
[
    "GAIA_CACHE_STAGE_1",
    "SLIDER",
   	["Cache Distance","How far any player should be from a unit before it cached"],
  	"MCC GAIA",
    [1000, 10000, 3000, 0],
    true
] call CBA_fnc_addSetting;

//AI use smoke grenade and flares
[
    "MCC_GAIA_ATTACKS_FOR_NONGAIA",
    "CHECKBOX",
   	["GAIA Controlls All","If set to everyone GAIA will give order to all units availables even players"],
   	"MCC GAIA",
    false,
    true
] call CBA_fnc_addSetting;

//GAIA target detection range
[
    "MCC_GAIA_TARGET_RANGE",
    "SLIDER",
   	["Target Detection Range","How far around each group leader GAIA looks for enemy targets (nearTargets)"],
   	"MCC GAIA",
    [300, 3000, 1000, 0],
    true
] call CBA_fnc_addSetting;

//GAIA debug / performance log
[
    "MCC_GAIA_debug",
    "CHECKBOX",
   	["GAIA Debug","Write GAIA cycle timings (per phase, groups processed) to the server RPT and enable the GAIA debug markers"],
   	"MCC GAIA",
    false,
    true
] call CBA_fnc_addSetting;

//GAIA vehicles: borrow empty vehicles for long trips, dismount at objective, re-mount after contact
[
    "MCC_GAIA_vehiclesEnabled",
    "CHECKBOX",
   	["Smart Vehicle Use","AI groups borrow empty friendly vehicles for long trips, get out at the objective (leader included) and get back in after a fight"],
   	["MCC GAIA", "Vehicles"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_rideDistance",
    "SLIDER",
   	["Find Ride Distance","Infantry going further than this (meters) look for an empty vehicle"],
   	["MCC GAIA", "Vehicles"],
    [500, 5000, 1500, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_dismountDistance",
    "SLIDER",
   	["Dismount Distance","Groups get out of their vehicle this far (meters) from the objective"],
   	["MCC GAIA", "Vehicles"],
    [100, 1500, 400, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_rideSearchRadius",
    "SLIDER",
   	["Vehicle Search Radius","How far (meters) from the leader a group looks for an empty vehicle"],
   	["MCC GAIA", "Vehicles"],
    [50, 1000, 300, 0],
    true
] call CBA_fnc_addSetting;

//Compatibility with other AI mods
[
    "MCC_GAIA_compatLAMBS",
    "LIST",
   	["LAMBS Danger Compatibility","Auto: if LAMBS Danger is loaded GAIA leaves contact tactics to LAMBS and does not override group behaviour in combat"],
   	["MCC GAIA", "AI Mod Compatibility"],
    [[0, 1, 2], ["Auto", "On", "Off"], 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_compatHBQ",
    "LIST",
   	["HBQ Driving AI Compatibility","Auto: if HBQ Advanced Driving AI is loaded GAIA leaves unstuck and route recovery to HBQ"],
   	["MCC GAIA", "AI Mod Compatibility"],
    [[0, 1, 2], ["Auto", "On", "Off"], 0],
    true
] call CBA_fnc_addSetting;
