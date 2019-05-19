if (count (allMissionObjects "MCC_Module_settingsMechanics") == 0) then {
    //Weapon Change
    [
        "MCC_quickWeaponChange",
        "CHECKBOX",
        ["Weapons Binds","Bind weapon to the 1 - 4 keys"],
        "MCC Mechanics",
        false,
        false
    ] call CBA_Settings_fnc_init;

    //Arcade tanks
    [
        "MCC_arcadeTanks",
        "CHECKBOX",
        ["One Man Tanks","Player can operate a tank by his own driving and shooting"],
        "MCC Mechanics",
        false,
        true
    ] call CBA_Settings_fnc_init;

    //Fatigue
    [
        "MCC_disableFatigue",
        "CHECKBOX",
        ["Fatigue","Enable/Disable players fatigue system"],
        "MCC Mechanics",
        true,
        true,
        {
        	player enableFatigue MCC_disableFatigue
        }
    ] call CBA_Settings_fnc_init;

    //3DTagging
    [
        "MCC_allow3DSpotting",
        "CHECKBOX",
        ["3D Tagging","Squad leader enemy tags and markers will be visible on HUD"],
        "MCC Mechanics",
        true,
        true
    ] call CBA_Settings_fnc_init;

    // ================================ COVER =========================================
    //Cover system
    [
        "MCC_cover",
        "CHECKBOX",
        ["Cover System","Players will automatically pop up or side out of cover while aiming down sights"],
       ["MCC Mechanics","Cover"],
        false,
        false
    ] call CBA_Settings_fnc_init;

    //Cover system UI
    [
        "MCC_coverUI",
        "CHECKBOX",
        ["Cover System UI","Show icons on HUD when in cover"],
       	["MCC Mechanics","Cover"],
        false,
        false
    ] call CBA_Settings_fnc_init;

    //Vault
    [
        "MCC_coverVault",
        "CHECKBOX",
        ["Vault System","Allow players to vault over walls and obstacles - see CBA keybinds"],
        ["MCC Mechanics","Cover"],
        false,
        false
    ] call CBA_Settings_fnc_init;


    //============================ Interaction ====================================
    //Interaction
    [
        "MCC_interaction",
        "CHECKBOX",
        ["Interaction System","Players can interact with object and themseld - see CBA keybinds"],
       ["MCC Mechanics","Interaction"],
        true,
        true
    ] call CBA_Settings_fnc_init;

    //Interaction
    [
        "MCC_ingameUI",
        "CHECKBOX",
        ["Interaction System UI","Show icons on HUD when interaction is available"],
       ["MCC Mechanics","Interaction"],
        true,
        true
    ] call CBA_Settings_fnc_init;

    /* =========================	SURVIVE MOD	========================================*/

    //Survive mod
    [
       "MCC_surviveModAllowSearch_index",
       "LIST",
       ["Survival Mode","Players can loot map objects and need to drink and eat"],
       ["MCC Mechanics","Survival"],
       [[0,1,2],["Disabled","Enabled and enable searching loot","Enabled anf disable searching loot"],0],
        true,
        {
        	MCC_surviveMod = MCC_surviveModAllowSearch_index > 0;
            MCC_surviveModAllowSearch = (MCC_surviveModAllowSearch_index == 1);
        }
    ] call CBA_Settings_fnc_init;

    //Load Player Position
    [
        "MCC_surviveModPlayerPos",
        "CHECKBOX",
        ["Load Player Position","Load last known player position on mission start"],
        ["MCC Mechanics","Survival"],
        false,
        true
    ] call CBA_Settings_fnc_init;

    //LLoad Player Gear
    [
        "MCC_surviveModPlayerGear",
        "CHECKBOX",
        ["Load Player Gear","Load last known player gear on mission start"],
        ["MCC Mechanics","Survival"],
        false,
        true
    ] call CBA_Settings_fnc_init;

    //LLoad Player Stats
    [
        "MCC_surviveModPlayerGear",
        "CHECKBOX",
        ["Load Player Stats","Load last known player stats on mission start"],
        ["MCC Mechanics","Survival"],
        false,
        true
    ] call CBA_Settings_fnc_init;

    // ====================================== AMMO TYPE ========================================================

    //Breaching Ammo
    [
        "MCC_breacingAmmo",
        "EDITBOX",
        ["Breaching Ammo","Shooting this ammo from less then 10 meters will unlock doors"],
        ["MCC Mechanics","Ammo Type"],
        '["prpl_8Rnd_12Gauge_Slug","prpl_6Rnd_12Gauge_Slug","rhsusf_8Rnd_Slug","rhsusf_5Rnd_Slug"]',
        true,
        {
            params ["_value"];
            MCC_breacingAmmo = call compile _value;
        }
    ] call CBA_Settings_fnc_init;

    //Non Lethal Ammo
    [
        "MCC_nonLeathalAmmo",
        "EDITBOX",
        ["Non Lethal Ammo","Shooting this ammo from less then 10 meters will unlock doors"],
        ["MCC Mechanics","Ammo Type"],
        '["prpl_8Rnd_12Gauge_Slug","prpl_6Rnd_12Gauge_Slug","rhsusf_8Rnd_Slug","rhsusf_5Rnd_Slug"]',
        true,
        {
            params ["_value"];
            MCC_nonLeathalAmmo = call compile _value;
        }
    ] call CBA_Settings_fnc_init;
};