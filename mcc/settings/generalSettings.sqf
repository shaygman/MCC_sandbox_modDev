//Teleport
[
    "MCC_t2tIndex",
    "LIST",
    [localize "STR_GENERAL_TELEPORTTOTEAM",localize "STR_GENERAL_TELEPORTONTL"],
    localize "STR_GENERAL_MCCGENERAL",
    [[0,1,2,3],[localize "STR_GENERAL_DISABLED",localize "STR_GENERAL_JIPONLY",localize "STR_GENERAL_AFTERRESPAWN",localize "STR_GENERAL_ALWAYS"],1],
    true,
    {
        params ["_value"];
        if (_value isEqualTo 0) then {MCC_teleportToTeam = false};
    }
] call CBA_Settings_fnc_init;

//MCC Chat
[
    "MCC_MessagesIndex",
    "CHECKBOX",
    ["MCC Chat","Will show MCC chat"],
    localize "STR_GENERAL_MCCGENERAL",
    true,
    true
] call CBA_Settings_fnc_init;

//Sync at start
[
    "MCC_syncOn",
    "CHECKBOX",
    ["Sync Jip","Jip players will sync with server"],
    localize "STR_GENERAL_MCCGENERAL",
    true,
    true
] call CBA_Settings_fnc_init;

//Ambient Birds
[
    "MCC_ambientBirdsSettingIndex",
    "CHECKBOX",
    ["Ambient Birds","Random flocks of birds will take flight when units are near"],
    [localize "STR_GENERAL_MCCGENERAL", "Ambient Birds"],
    true,
    true,
    {
        params ["_value"];
         if (_value) then {
            [] spawn MCC_fnc_ambientBirdsSpawnInit;
        };
    }
] call CBA_Settings_fnc_init;

//Ambient Fire
[
    "MCC_ambientFireSettingIndex",
    "CHECKBOX",
    ["Ambient Fire","Explosive may cause sporadic fires that will spread with the wind need a restart to disable"],
    [localize "STR_GENERAL_MCCGENERAL", "Ambient Fire"],
    true,
    true,
    {
        params ["_value"];
        if (_value) then {
            [] spawn MCC_fnc_ambientFireInit;
        };
    },
    true
] call CBA_Settings_fnc_init;

//Ambient Fire vehicle burn chance
[
    "MCC_fnc_ambientFireInitVehicleBurnChance",
    "SLIDER",
    ["Vehicle fire chance","Chance a destroyed vehicle will start a fire"],
    [localize "STR_GENERAL_MCCGENERAL", "Ambient Fire"],
    [0,100,50,0],
    true,
    {},
    false
] call CBA_Settings_fnc_init;

//Ambient Fire explosives burn chance
[
    "MCC_fnc_ambientFireInitExplosivesBurnChance",
    "SLIDER",
    ["Explosives rounds fire chance","Chance an explosive ammunation start a new fire also effect the chance of non explosive ammunation to start a fire"],
    [localize "STR_GENERAL_MCCGENERAL", "Ambient Fire"],
    [0,100,3,0],
    true,
    {},
    false
] call CBA_Settings_fnc_init;


//Ambient Fire crew burn chance
[
    "MCC_fnc_ambientFireInitCrewBurnChance",
    "SLIDER",
    ["Burning crew escape chance","Chance of each crew member in a destroyed vehicle's to catch on fire runing out of the vehicle"],
    [localize "STR_GENERAL_MCCGENERAL", "Ambient Fire"],
    [0,100,50,0],
    true,
    {},
    false
] call CBA_Settings_fnc_init;

//Ambient Fire burnt crew member will start a new fire
[
    "MCC_fnc_ambientFireInitCrewNewFireChance",
    "SLIDER",
    ["Burning crew new fire chance","Chance a burnet crew member will start a new fire"],
    [localize "STR_GENERAL_MCCGENERAL", "Ambient Fire"],
    [0,100,10,0],
    true,
    {},
    false
] call CBA_Settings_fnc_init;

//Artillery computer
[
    "MCC_artilleryComputerIndex",
    "CHECKBOX",
    ["Artillery Computer","Enable/disable BI artillery computer"],
    [localize "STR_GENERAL_MCCGENERAL", "Artillery"],
    true,
    true,
    {
        params ["_value"];
        enableEngineArtillery _value;
    },
    true
] call CBA_Settings_fnc_init;

//Artillery Spread
[
    "MCC_artillerySpreadArray",
    "EDITBOX",
    ["Artillery spread","First element display name second spread in meters"],
    [localize "STR_GENERAL_MCCGENERAL", "Artillery"],
    '[["On-target",0], ["Precise",100], ["Tight",200], ["Wide",400]]',
    true,
    {
        params ["_value"];
        MCC_artillerySpreadArray = call compile _value;
    }
] call CBA_Settings_fnc_init;

//Time Multiplier
[
    "MCC_timeMultiplier_settings",
    "SLIDER",
    "Time Multiplier",
    localize "STR_GENERAL_MCCGENERAL",
    [0.5, 24, 1, 1],
    true,
    {
        params ["_value"];
        if (isServer) then {setTimeMultiplier _value};
    }
] call CBA_Settings_fnc_init;

//Disable Curator Edit
[
    "MCC_CuratorEditDisabled",
    "CHECKBOX",
    ["Disable MCC Zeus Edit","Disable the custom MCC interface when editing an object in Zeus"],
    localize "STR_GENERAL_MCCGENERAL",
    false,
    false
] call CBA_Settings_fnc_init;

//Logistics
[
    "MCC_allowlogistics",
    "CHECKBOX",
    ["Logistics System","Allows player to load equipment, vehicles, resources and items into vehicles"],
    localize "STR_GENERAL_MCCGENERAL",
    true,
    true
] call CBA_Settings_fnc_init;

//Armed Civilians Weapons
[
    "MCC_armedCivilansWeapons",
    "EDITBOX",
    ["Armed Civilians Weapons","Armed Civilians default Weapons"],
    localize "STR_GENERAL_MCCGENERAL",
    '["hgun_P07_F","hgun_Rook40_F","hgun_ACPC2_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_02_F","SMG_01_F","SMG_02_F","hgun_PDW2000_F"]',
    true,
    {
        params ["_value"];
        MCC_armedCivilansWeapons = call compile _value;
    }
] call CBA_Settings_fnc_init;

// ==================== SQL PDA ==========================================

//SQL PDA
[
    "MCC_allowsqlPDA",
    "CHECKBOX",
    ["SQL PDA Enabled","Any team leader will have access to a PDA that have a Blueforce tracker"],
    [localize "STR_GENERAL_MCCGENERAL","Squad Leader PDA"],
    true,
    true
] call CBA_Settings_fnc_init;
