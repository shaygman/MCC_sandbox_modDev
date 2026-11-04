if (count (allMissionObjects "MCC_Module_settingsMechanics") == 0) then {
    //Weapon Change
    [
        "MCC_quickWeaponChange",
        "CHECKBOX",
        ["Weapons Binds","Bind weapon to the 1 - 4 keys"],
        "MCC Mechanics",
        false,
        false
    ] call CBA_fnc_addSetting;

    //Arcade tanks
    [
        "MCC_arcadeTanks",
        "CHECKBOX",
        ["One Man Tanks","Player can operate a tank by his own driving and shooting"],
        "MCC Mechanics",
        false,
        true
    ] call CBA_fnc_addSetting;

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
    ] call CBA_fnc_addSetting;

    //3DTagging
    [
        "MCC_allow3DSpotting",
        "CHECKBOX",
        ["3D Tagging","Squad leader enemy tags and markers will be visible on HUD"],
        "MCC Mechanics",
        true,
        true
    ] call CBA_fnc_addSetting;

    // ================================ COVER =========================================
    //Cover system
    [
        "MCC_cover",
        "CHECKBOX",
        ["Cover System","Players will automatically pop up or side out of cover while aiming down sights"],
       ["MCC Mechanics","Cover"],
        false,
        false
    ] call CBA_fnc_addSetting;

    //Cover system UI
    [
        "MCC_coverUI",
        "CHECKBOX",
        ["Cover System UI","Show icons on HUD when in cover"],
       	["MCC Mechanics","Cover"],
        false,
        false
    ] call CBA_fnc_addSetting;

    //Vault
    [
        "MCC_coverVault",
        "CHECKBOX",
        ["Vault System","Allow players to vault over walls and obstacles - see CBA keybinds"],
        ["MCC Mechanics","Cover"],
        false,
        false
    ] call CBA_fnc_addSetting;


    //============================ Interaction ====================================
    //Interaction
    [
        "MCC_interaction",
        "CHECKBOX",
        ["Interaction System","Players can interact with object and themseld - see CBA keybinds"],
       ["MCC Mechanics","Interaction"],
        true,
        true
    ] call CBA_fnc_addSetting;

    //Interaction
    [
        "MCC_ingameUI",
        "CHECKBOX",
        ["Interaction System UI","Show icons on HUD when interaction is available"],
       ["MCC Mechanics","Interaction"],
        true,
        true
    ] call CBA_fnc_addSetting;

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
    ] call CBA_fnc_addSetting;

    //Load Player Position
    [
        "MCC_surviveModPlayerPos",
        "CHECKBOX",
        ["Load Player Position","Load last known player position on mission start"],
        ["MCC Mechanics","Survival"],
        false,
        true
    ] call CBA_fnc_addSetting;

    //LLoad Player Gear
    [
        "MCC_surviveModPlayerGear",
        "CHECKBOX",
        ["Load Player Gear","Load last known player gear on mission start"],
        ["MCC Mechanics","Survival"],
        false,
        true
    ] call CBA_fnc_addSetting;

    //LLoad Player Stats
    [
        "MCC_surviveModPlayerStats",
        "CHECKBOX",
        ["Load Player Stats","Load last known player stats on mission start"],
        ["MCC Mechanics","Survival"],
        false,
        true
    ] call CBA_fnc_addSetting;

    // ====================================== AMMO TYPE ========================================================

    //Breaching Ammo
    [
        "MCC_breacingAmmo",
        "EDITBOX",
        ["Breaching Ammo","Magazine classes. Shooting this ammo from less then 10 meters will unlock doors. ""auto"" = every shotgun slug magazine found in the loaded mods"],
        ["MCC Mechanics","Ammo Type"],
        '["auto"]',
        true,
        {
            params ["_value"];
            MCC_breacingAmmo = (parseSimpleArray ("[" + _value + "]")) param [0, []];
            if (!isNil "MCC_fnc_compatApply") then {["MCC_breacingAmmo"] call MCC_fnc_compatApply};
        }
    ] call CBA_fnc_addSetting;

    //Non Lethal Ammo
    [
        "MCC_nonLeathalAmmo",
        "EDITBOX",
        ["Non Lethal Ammo","Magazine classes. Shooting this ammo at a unit closer than 30 meters stuns it instead of killing it. ""auto"" = every shotgun slug magazine found in the loaded mods"],
        ["MCC Mechanics","Ammo Type"],
        '["auto"]',
        true,
        {
            params ["_value"];
            MCC_nonLeathalAmmo = (parseSimpleArray ("[" + _value + "]")) param [0, []];
            if (!isNil "MCC_fnc_compatApply") then {["MCC_nonLeathalAmmo"] call MCC_fnc_compatApply};
        }
    ] call CBA_fnc_addSetting;
};