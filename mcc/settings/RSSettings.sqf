if (count (allMissionObjects "MCC_Module_settingsRS") == 0) then {

    //Role Selection activated
    [
        "CP_activated",
        "CHECKBOX",
        ["Enable Role Selection","Enable role selection menu allows player to gain XP and unlock new weapons and items"],
        "MCC Role Selection",
        false,
        true
    ] call CBA_Settings_fnc_init;


    //All Weapons
    [
        "MCC_rsAllWeapons",
        "CHECKBOX",
        ["Unlock All Weapons","Unlock All Weapons ignoting the player level"],
        "MCC Role Selection",
        false,
        true
    ] call CBA_Settings_fnc_init;

    //Kit Change
    [
        "MCC_allowChangingKits",
        "CHECKBOX",
        ["Role Change","Players can change roles in HQ"],
        "MCC Role Selection",
        true,
        true
    ] call CBA_Settings_fnc_init;

    //Kit Weapons penalty
    [
        "MCC_rsEnableRoleWeapons",
        "CHECKBOX",
        ["Restrict Weapons","Players using weapons outside of their role (eg rifleman using sniper rifle) will get penalty by increased weapon sway"],
        "MCC Role Selection",
        false,
        true
    ] call CBA_Settings_fnc_init;

    //Vehicles penalty
    [
        "MCC_rsEnableDriversPilots",
        "CHECKBOX",
        ["Restrict Vehicles","Players can't use vehicles outside of their role (eg rifleman driving a tank) except light vehicles"],
        "MCC Role Selection",
        false,
        true
    ] call CBA_Settings_fnc_init;

    //Default groups
    [
        "CP_defaultGroups",
        "EDITBOX",
        ["Group Callsigns","Default groups callsigns"],
        "MCC Role Selection",
        '["Alpha","Bravo","Charlie","Delta"]',
        true,
        {
            params ["_value"];
            CP_defaultGroups = call compile _value;
        }
    ] call CBA_Settings_fnc_init;

    //---------------------------- Experiance points -----------------------------------
    /*
    //XP Gain
    [
        "CP_gainXP",
        "CHECKBOX",
        ["Gain XP automatically","Players will gain XP by killing and doing role's actions"],
        ["MCC Role Selection","Experiance Points"],
        true,
        true
    ] call CBA_Settings_fnc_init;
    */
    //XP notifications
    [
        "CP_expNotifications",
        "CHECKBOX",
        ["Gain XP notifications","Players will get notifications when gaining XP"],
        ["MCC Role Selection","Experiance Points"],
        true,
        true
    ] call CBA_Settings_fnc_init;

    //XP needed
    [
        "CP_XPperLevel",
        "SLIDER",
        ["Base Xp","Base Xp needed for each level, Exp will raise by 5% each level"],
        ["MCC Role Selection","Experiance Points"],
        [1000, 10000, 4000, 0],
        true
    ] call CBA_Settings_fnc_init;
    /*
    //----------------------------- Flags ---------------------------------------
    //west
    [
        "CP_flagWest",
        "EDITBOX",
        ["Flag west","Default flag for west side"],
        ["MCC Role Selection","Flags"],
        '"\a3\Data_f\Flags\flag_nato_co.paa"',
        true,
        {
            params ["_value"];
            CP_flagWest = call compile _value;
        }
    ] call CBA_Settings_fnc_init;

    //east
    [
        "CP_flagEast",
        "EDITBOX",
        ["Flag east","Default flag for east side"],
        ["MCC Role Selection","Flags"],
        '"\a3\Data_f\Flags\flag_CSAT_co.paa"',
        true,
        {
            params ["_value"];
            CP_flagEast = call compile _value;
        }
    ] call CBA_Settings_fnc_init;

    //resistance
    [
        "CP_flagGUER",
        "EDITBOX",
        ["Flag resistance","Default flag for resistance side"],
        ["MCC Role Selection","Flags"],
        '"\a3\Data_f\Flags\flag_AAF_co.paa"',
        true,
        {
            params ["_value"];
            CP_flagGUER = call compile _value;
        }
    ] call CBA_Settings_fnc_init;
    */
};