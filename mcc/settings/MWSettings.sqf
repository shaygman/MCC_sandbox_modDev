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
        MCC_MWHVT = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWRadio = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWFuelTanks = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWradar = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWTanks = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWAir = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWAA = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWArtillery = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWcache = call compile _value;
    }
] call CBA_Settings_fnc_init;



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
        MCC_MWIntelObjects = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWIED = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWSITES = call compile _value;
    }
] call CBA_Settings_fnc_init;

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
        MCC_MWSITESmilitary = call compile _value;
    }
] call CBA_Settings_fnc_init;