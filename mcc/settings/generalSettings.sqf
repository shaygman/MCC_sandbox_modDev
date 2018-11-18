//Teleport
[
    "MCC_t2tIndex",
    "LIST",
    ["Teleport to Team","Players can teleport to squad leader"],
    "MCC General",
    [[0,1,2,3],["Disabled","JIP Only","After Respawn","Always"],1],
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
    "MCC General",
    true,
    true
] call CBA_Settings_fnc_init;

//Sync at start
[
    "MCC_syncOn",
    "CHECKBOX",
    ["Sync Jip","Jip players will sync with server"],
    "MCC General",
    true,
    true
] call CBA_Settings_fnc_init;

//Logistics
[
    "MCC_allowlogistics",
    "CHECKBOX",
    ["Logistics System","Allows player to load equipment, vehicles, resources and items into vehicles"],
    "MCC General",
    true,
    true
] call CBA_Settings_fnc_init;

//Artillery computer
[
    "MCC_artilleryComputerIndex",
    "CHECKBOX",
    ["Artillery Computer","Enable/disable BI artillery computer"],
    "MCC General",
    true,
    true,
    {
        params ["_value"];
        enableEngineArtillery _value;
    }
] call CBA_Settings_fnc_init;

//Time Multiplier
[
    "MCC_timeMultiplier_settings",
    "SLIDER",
    "Time Multiplier",
    "MCC General",
    [0.5, 24, 1, 1],
    true,
    {
        params ["_value"];
        setTimeMultiplier _value;
    }
] call CBA_Settings_fnc_init;

//Disable Curator Edit
[
    "MCC_CuratorEditDisabled",
    "CHECKBOX",
    ["Disable MCC Zeus Edit","Disable the custom MCC interface when editing an object in Zeus"],
    "MCC General",
    false,
    false
] call CBA_Settings_fnc_init;

//Armed Civilians Weapons
[
    "MCC_armedCivilansWeapons",
    "EDITBOX",
    ["Armed Civilians Weapons","Armed Civilians default Weapons"],
    "MCC General",
    '["hgun_P07_F","hgun_Rook40_F","hgun_ACPC2_F","hgun_Pistol_heavy_01_F","hgun_Pistol_heavy_02_F","SMG_01_F","SMG_02_F","hgun_PDW2000_F"]',
    true
] call CBA_Settings_fnc_init;
// ==================== Respawn ==========================================

//Save Gear
[
    "MCC_saveGearIndex",
    "CHECKBOX",
    ["Save Gear","Players will respawn with the gear they had when they died"],
    ["MCC General","Respawn"],
    false,
    true
] call CBA_Settings_fnc_init;

//Delet players body
[
    "MCC_deletePlayersBody",
    "CHECKBOX",
    ["Delete players bodies","Automatically delete players bodies"],
    ["MCC General","Respawn"],
    false,
    true
] call CBA_Settings_fnc_init;

//Respawn menu
[
    "MCC_openRespawnMenu",
    "CHECKBOX",
    ["Respawn Menu","Custom MCC respawn menu"],
    ["MCC General","Respawn"],
    true,
    true
] call CBA_Settings_fnc_init;

//Respawn Cinematic
[
    "MCC_respawnCinematic",
    "CHECKBOX",
    "Respawn Cinematic",
    ["MCC General","Respawn"],
    true,
    true
] call CBA_Settings_fnc_init;

//Respawn on Leader
[
    "MCC_respawnOnGroupLeader",
    "CHECKBOX",
    ["Respawn On Leader","Allow player to select to respawn on team leader from the MCC respawn menu"],
    ["MCC General","Respawn"],
    false,
    true
] call CBA_Settings_fnc_init;

// ==================== SQL PDA ==========================================

//SQL PDA
[
    "MCC_allowsqlPDA",
    "CHECKBOX",
    ["SQL PDA Enabled","Any team leader will have access to a PDA that have a Blueforce tracker"],
    ["MCC General","Squad Leader PDA"],
    true,
    true
] call CBA_Settings_fnc_init;


// ==================== Commander Console ==========================================
//Commander Console
[
    "MCC_allowConsole",
    "CHECKBOX",
    ["Commander Conosle Enabled","Player can become a side commander from the MCC respawn screen"],
    ["MCC General","Commander Console"],
    true,
    true
] call CBA_Settings_fnc_init;

//Commander Console Show units without GPS
[
    "MCC_ConsoleOnlyShowUnitsWithGPS",
    "CHECKBOX",
    ["Show units without GPS","Blueforce tracker show units without GPS on commander console"],
    ["MCC General","Commander Console"],
    true,
    true
] call CBA_Settings_fnc_init;

//Commander Show friendly WP
[
    "MCC_ConsolePlayersCanSeeWPonMap",
    "CHECKBOX",
    ["Show friendly WP","Show friendly group way points on console"],
    ["MCC General","Commander Console"],
    true,
    true
] call CBA_Settings_fnc_init;

//Commander Console Can command AI
[
    "MCC_ConsoleCanCommandAI",
    "CHECKBOX",
    ["Command AI","Commander can issue order to AI groups given to him by mission maker"],
    ["MCC General","Commander Console"],
    true,
    true
] call CBA_Settings_fnc_init;

//Commander Console Purchable airDrops
[
    "MCC_defaultSupplyDropsEnabled",
    "CHECKBOX",
    ["Purcase air drop","Commander can trade resources for air Drops - works only on mission restart"],
    ["MCC General","Commander Console"],
    true,
    true
] call CBA_Settings_fnc_init;

//Commander Console Purchable CAS
[
    "MCC_defaultCASEnabled",
    "CHECKBOX",
    ["Purcase CAS","Commander can trade resources for close air support - works only on mission restart"],
    ["MCC General","Commander Console"],
    true,
    true
] call CBA_Settings_fnc_init;

//RTS
[
    "MCC_allowRTS",
    "CHECKBOX",
    ["RTS","Enable Real Time Strategy mod from the commander console, build, expend and conquare"],
    ["MCC General","Commander Console"],
    true,
    true
] call CBA_Settings_fnc_init;