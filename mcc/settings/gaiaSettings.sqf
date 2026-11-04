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

//------------------------------ GAIA coordination (Phase B) ------------------------------
//Per conflict area roles: attack / flank / support-by-fire / reserve
[
    "MCC_GAIA_COORDINATION",
    "CHECKBOX",
   	["Coordinated Attacks","Groups sent to the same enemy contact get roles: main attack, flank from another direction, support-by-fire from an overwatch position, reserve. Off: every group attacks on its own (old behaviour)"],
   	["MCC GAIA", "Coordination"],
    true,
    true
] call CBA_fnc_addSetting;

//------------------------------ GAIA support requests ------------------------------
[
    "MCC_GAIA_SUPPORT_ENABLED",
    "CHECKBOX",
   	["AI Support Requests","GAIA calls artillery, CAS or reinforcements on strong enemy contacts its groups are fighting (one response per contact)"],
   	["MCC GAIA", "Support Requests"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_THRESHOLD",
    "SLIDER",
   	["Threat Threshold","Minimum threat points of an enemy contact before support is called (a rifleman is 4 points, 6 inside a GAIA zone; vehicles more)"],
   	["MCC GAIA", "Support Requests"],
    [10, 300, 40, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_CONTACT_RANGE",
    "SLIDER",
   	["Contact Range","Support is only called when a GAIA group in combat is this close (meters) to the enemy contact"],
   	["MCC GAIA", "Support Requests"],
    [200, 2000, 600, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_CA_COOLDOWN",
    "SLIDER",
   	["Contact Cooldown","Seconds before the same enemy contact can get another support response"],
   	["MCC GAIA", "Support Requests"],
    [30, 1800, 180, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_DANGERCLOSE",
    "SLIDER",
   	["Danger Close Distance","No artillery, mortar or CAS when friendly troops are this close (meters) to the target"],
   	["MCC GAIA", "Support Requests"],
    [50, 600, 200, 0],
    true
] call CBA_fnc_addSetting;

//Artillery / mortars
[
    "MCC_GAIA_SUPPORT_ARTY",
    "CHECKBOX",
   	["Artillery Support","GAIA mortar and artillery groups answer support requests"],
   	["MCC GAIA", "Support Requests"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_ARTY_COOLDOWN",
    "SLIDER",
   	["Artillery Cooldown","Seconds between two artillery support calls of one side"],
   	["MCC GAIA", "Support Requests"],
    [0, 1200, 60, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_ARTY_BUDGET",
    "SLIDER",
   	["Artillery Budget","Artillery support calls per side for the whole mission"],
   	["MCC GAIA", "Support Requests"],
    [0, 100, 20, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_ARTY_OUTSIDE_ZONE",
    "CHECKBOX",
   	["NOFOLLOW Artillery Fires Outside Zone","Mortar / artillery groups with a NOFOLLOW zone may fire at targets outside their own zone"],
   	["MCC GAIA", "Support Requests"],
    false,
    true
] call CBA_fnc_addSetting;

//CAS
[
    "MCC_GAIA_SUPPORT_CAS",
    "CHECKBOX",
   	["CAS Support","GAIA calls an off-map close air support run"],
   	["MCC GAIA", "Support Requests"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_CAS_OWNAIR",
    "CHECKBOX",
   	["CAS Needs Own Aircraft","CAS is only called when the side has an armed aircraft of its own in the mission"],
   	["MCC GAIA", "Support Requests"],
    false,
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_CAS_COOLDOWN",
    "SLIDER",
   	["CAS Cooldown","Seconds between two CAS calls of one side"],
   	["MCC GAIA", "Support Requests"],
    [60, 3600, 300, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_CAS_BUDGET",
    "SLIDER",
   	["CAS Budget","CAS runs per side for the whole mission"],
   	["MCC GAIA", "Support Requests"],
    [0, 20, 2, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_CAS_PLANE_WEST",
    "EDITBOX",
   	["CAS Plane BLUFOR","Plane class for BLUFOR CAS runs (empty: vanilla default)"],
   	["MCC GAIA", "Support Requests"],
    "",
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_CAS_PLANE_EAST",
    "EDITBOX",
   	["CAS Plane OPFOR","Plane class for OPFOR CAS runs (empty: vanilla default)"],
   	["MCC GAIA", "Support Requests"],
    "",
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_CAS_PLANE_INDEP",
    "EDITBOX",
   	["CAS Plane Independent","Plane class for Independent CAS runs (empty: vanilla default)"],
   	["MCC GAIA", "Support Requests"],
    "",
    true
] call CBA_fnc_addSetting;

//Reinforcements
[
    "MCC_GAIA_SUPPORT_REINF",
    "CHECKBOX",
   	["Reinforcements","GAIA calls motorized reinforcements when its groups are heavily outnumbered or nothing else is available"],
   	["MCC GAIA", "Support Requests"],
    true,
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_REINF_COOLDOWN",
    "SLIDER",
   	["Reinforcement Cooldown","Seconds between two reinforcement calls of one side"],
   	["MCC GAIA", "Support Requests"],
    [60, 3600, 600, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_REINF_BUDGET",
    "SLIDER",
   	["Reinforcement Budget","Reinforcement calls per side for the whole mission"],
   	["MCC GAIA", "Support Requests"],
    [0, 20, 2, 0],
    true
] call CBA_fnc_addSetting;

[
    "MCC_GAIA_SUPPORT_REINF_SIZE",
    "LIST",
   	["Reinforcement Size","Number of vehicles: small 2, medium 3, large 4"],
   	["MCC GAIA", "Support Requests"],
    [[0, 1, 2], ["Small", "Medium", "Large"], 0],
    true
] call CBA_fnc_addSetting;

//------------------------------ GAIA vehicles: unstick ------------------------------
[
    "MCC_GAIA_UNSTICK",
    "CHECKBOX",
   	["Unstick Vehicles","Tanks and armed cars that have not moved for about a minute re-plan their route, back up, then get a new order (off when HBQ Driving AI handles it)"],
   	["MCC GAIA", "Vehicles"],
    true,
    true
] call CBA_fnc_addSetting;

//------------------------------ Headless clients ------------------------------
[
    "MCC_GAIA_HC_BALANCE",
    "CHECKBOX",
   	["Headless Client Balancing","GAIA groups spawned during the mission are moved to the connected headless clients, round robin"],
   	["MCC GAIA", "Headless Clients"],
    true,
    true
] call CBA_fnc_addSetting;
