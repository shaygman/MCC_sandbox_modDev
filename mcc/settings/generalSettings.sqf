if (count (allMissionObjects "MCC_Module_settings") == 0) then {
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

    //Artillery computer
    [
        "MCC_artilleryComputerIndex",
        "CHECKBOX",
        ["Artillery Computer","Enable/disable BI artillery computer"],
        ["MCC General", "Artillery"],
        true,
        true,
        {
            params ["_value"];
            enableEngineArtillery _value;
        }
    ] call CBA_Settings_fnc_init;

    //Artillery Spread
    [
        "MCC_artillerySpreadArray",
        "EDITBOX",
        ["Artillery spread","First element display name second spread in meters"],
        ["MCC General", "Artillery"],
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

    //Logistics
    [
        "MCC_allowlogistics",
        "CHECKBOX",
        ["Logistics System","Allows player to load equipment, vehicles, resources and items into vehicles"],
        "MCC General",
        true,
        true
    ] call CBA_Settings_fnc_init;

    //Armed Civilians Weapons
    [
        "MCC_armedCivilansWeapons",
        "EDITBOX",
        ["Armed Civilians Weapons","Armed Civilians default Weapons"],
        "MCC General",
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
        ["MCC General","Squad Leader PDA"],
        true,
        true
    ] call CBA_Settings_fnc_init;
};