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

//XP Gain
[
    "CP_gainXP",
    "CHECKBOX",
    ["Gain XP automatically","Players will gain XP by killing and doing role's actions"],
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
    true,
    true
] call CBA_Settings_fnc_init;

//Vehicles penalty
[
    "MCC_rsEnableDriversPilots",
    "CHECKBOX",
    ["Restrict Vehicles","Players can't use vehicles outside of their role (eg rifleman driving a tank) except light vehicles"],
    "MCC Role Selection",
    true,
    true
] call CBA_Settings_fnc_init;