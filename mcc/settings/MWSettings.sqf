//HVT
[
    "MCC_MWHVT",
    "EDITBOX",
    ["HVT (man)","Unit that will be used as high value target"],
    "MCC Mission Wizard",
    '["B_officer_F","O_officer_F","I_officer_F","C_Nikos"]',
    true,
    {
        params ["_value"];
        MCC_MWHVT = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Radio
[
    "MCC_MWRadio",
    "EDITBOX",
    ["Radio Tower (Land)","Object that will be used in destroy radio missions"],
    "MCC Mission Wizard",
    '["Land_TTowerBig_2_F"]',
    true,
    {
        params ["_value"];
        MCC_MWRadio = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Fuel Tanks
[
    "MCC_MWFuelTanks",
    "EDITBOX",
    ["Fuel Tanks (Land)","Object that will be used in destroy fuel tanks missions"],
    "MCC Mission Wizard",
    '["Land_dp_smallTank_F","Land_ReservoirTank_V1_F","Land_dp_bigTank_F"]',
    true,
    {
        params ["_value"];
        MCC_MWFuelTanks = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Radar(Land)
[
    "MCC_MWradar",
    "EDITBOX",
    ["Radar (Land)","Object that will be used in destroy radar missions"],
    "MCC Mission Wizard",
    '["Land_Radar_Small_F","B_Radar_System_01_F","O_Radar_System_02_F"]',
    true,
    {
        params ["_value"];
        MCC_MWradar = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Armor
[
    "MCC_MWTanks",
    "EDITBOX",
    ["Armored Vehicles (Vehicle)","Vehicle that will be used in destroy armored vehicle missions"],
    "MCC Mission Wizard",
    '["B_MBT_01_cannon_F","O_MBT_02_cannon_F"]',
    true,
    {
        params ["_value"];
        MCC_MWTanks = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Air
[
    "MCC_MWAir",
    "EDITBOX",
    ["Air Vehicles (Vehicle)","Vehicle that will be used in destroy air vehicle missions"],
    "MCC Mission Wizard",
    '["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_UAV_02_F","O_UAV_02_CAS_F","B_Heli_Attack_01_F","I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]',
    true,
    {
        params ["_value"];
        MCC_MWAir = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Anti-Air(Vehicle)
[
    "MCC_MWAA",
    "EDITBOX",
    ["Anti-Air (Vehicle)","Vehicle that will be used in destroy anti-air missions"],
    "MCC Mission Wizard",
    '["B_APC_Tracked_01_AA_F","O_APC_Tracked_02_AA_F","I_APC_Wheeled_03_cannon_F"]',
    true,
    {
        params ["_value"];
        MCC_MWAA = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Artillery
[
    "MCC_MWArtillery",
    "EDITBOX",
    ["Artillery (Vehicle)","Vehicle that will be used in destroy artillery missions"],
    "MCC Mission Wizard",
    '["B_MBT_01_arty_F","B_MBT_01_mlrs_F","O_MBT_02_arty_F","O_Mortar_01_F","I_Mortar_01_F"]',
    true,
    {
        params ["_value"];
        MCC_MWArtillery = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Ammo cache (Box)
[
    "MCC_MWcache",
    "EDITBOX",
    ["Ammo cache (Box)","Ammo box that will be used in destroy cache vehicle missions"],
    "MCC Mission Wizard",
    '["Box_East_AmmoVeh_F","Land_Pallet_MilBoxes_F"]',
    true,
    {
        params ["_value"];
        MCC_MWcache = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;



//Intel Objects(Small Items)
[
    "MCC_MWIntelObjects",
    "EDITBOX",
    ["Intel Objects (Small Items)","Object that will be used in find intel missions"],
    "MCC Mission Wizard",
    '["Land_File2_F","Land_FilePhotos_F","Land_Laptop_unfolded_F","Land_SatellitePhone_F","Land_Suitcase_F"]',
    true,
    {
        params ["_value"];
        MCC_MWIntelObjects = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//IED(Small Items)
[
    "MCC_MWIED",
    "EDITBOX",
    ["IED (Small Items)","Object that will be used in disarm IED missions"],
    "MCC Mission Wizard",
    '["IEDLandSmall_Remote_Ammo","IEDLandBig_Remote_Ammo","IEDUrbanSmall_Remote_Ammo","IEDUrbanBig_Remote_Ammo"]',
    true,
    {
        params ["_value"];
        MCC_MWIED = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Composition Civ
[
    "MCC_MWSITES",
    "EDITBOX",
    ["Compositions civilians",'Will be used as compositions for civilians must be defined in ("CfgGroups" >> "Empty")'],
    "MCC Mission Wizard",
    '[["Guerrilla","Camps","CampA"],["Guerrilla","Camps","CampB"],["Guerrilla","Camps","CampC"],["Guerrilla","Camps","CampD"],["Guerrilla","Camps","CampE"],["Guerrilla","Camps","CampF"],["MCC_comps","civilians","slums"],["MCC_comps","Guerrilla","campSite"]]',
    true,
    {
        params ["_value"];
        MCC_MWSITES = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//Composition Military
[
    "MCC_MWSITESmilitary",
    "EDITBOX",
    ["Compositions military",'Will be used as compositions for military must be defined in ("CfgGroups" >> "Empty")'],
    "MCC Mission Wizard",
    '[["Military","Outposts","OutpostA"],["Military","Outposts","OutpostB"],["Military","Outposts","OutpostC"],["Military","Outposts","OutpostD"],["Military","Outposts","OutpostE"],["Military","Outposts","OutpostF"]]',
    true,
    {
        params ["_value"];
        MCC_MWSITESmilitary = (parseSimpleArray ("[" + _value + "]")) param [0, []];
    }
] call CBA_fnc_addSetting;

//==================================================== Phase C: bigger missions ====================================================
//Mission Wizard: number of objectives per mission (dialog sends 3, extra ones are random picks)
[
    "MCC_MWmaxObjectives",
    "SLIDER",
    ["Max objectives","Objectives per Mission Wizard mission. The dialog sets the first 3, anything above 3 is a random objective type"],
    ["MCC Mission Wizard","Mission size"],
    [1, 8, 3, 0],
    true,
    {
        params ["_value"];
        MCC_MWmaxObjectives = (round _value) max 1 min 8;
    }
] call CBA_fnc_addSetting;

//Mission Wizard: mission size multiplier on the enemy count
[
    "MCC_MWmissionSize",
    "LIST",
    ["Mission size","Multiplier on the number of enemies (and objective area for big missions)"],
    ["MCC Mission Wizard","Mission size"],
    [[0.5, 1, 1.75, 2.5], ["Small","Normal","Large","Huge"], 1],
    true
] call CBA_fnc_addSetting;

//Mission Wizard: hard cap on spawned units per generated mission
[
    "MCC_MWmaxSpawnedUnits",
    "SLIDER",
    ["Max spawned units","Hard cap (performance) on the units one Mission Wizard mission or campaign AO may spawn"],
    ["MCC Mission Wizard","Mission size"],
    [30, 600, 200, 0],
    true,
    {
        params ["_value"];
        MCC_MWmaxSpawnedUnits = round _value;
    }
] call CBA_fnc_addSetting;

//Mission Wizard: players slider range in the MW dialog (sets MCC_MWmaxPlayers)
[
    "MCC_MWmaxPlayersSetting",
    "SLIDER",
    ["Max players","Top of the players slider in the Mission Wizard dialog"],
    ["MCC Mission Wizard","Mission size"],
    [10, 150, 40, 0],
    true,
    {
        params ["_value"];
        MCC_MWmaxPlayers = round _value;
    }
] call CBA_fnc_addSetting;

//Campaign: AO radius
[
    "MCC_campaignAOSize",
    "SLIDER",
    ["Campaign AO size","Objective radius (m) of every campaign AO"],
    ["MCC Mission Wizard","Campaign"],
    [150, 1500, 300, 0],
    true,
    {
        params ["_value"];
        MCC_campaignAOSize = round _value;
    }
] call CBA_fnc_addSetting;

//Campaign: simultaneous AOs
[
    "MCC_campaignMaxAOs",
    "SLIDER",
    ["Campaign simultaneous AOs","How many campaign AOs can be active at the same time"],
    ["MCC Mission Wizard","Campaign"],
    [1, 3, 1, 0],
    true,
    {
        params ["_value"];
        MCC_campaignMaxAOs = (round _value) max 1 min 3;
    }
] call CBA_fnc_addSetting;

//Campaign: ambient spawn cap
[
    "MCC_campaignAmbientCap",
    "SLIDER",
    ["Campaign ambient groups cap","Max ambient enemy groups the campaign keeps around players (2 per player up to this)"],
    ["MCC Mission Wizard","Campaign"],
    [0, 60, 18, 0],
    true,
    {
        params ["_value"];
        MCC_campaignAmbientCap = round _value;
    }
] call CBA_fnc_addSetting;
