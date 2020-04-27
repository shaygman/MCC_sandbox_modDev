// ==================== Respawn ==========================================

//Save Gear
[
    "MCC_saveGearIndex",
    "CHECKBOX",
    ["Save Gear","Players will respawn with the gear they had when they died"],
    ["MCC Respawn","Respawn"],
    false,
    true
] call CBA_Settings_fnc_init;

//Delet players body
[
    "MCC_deletePlayersBody",
    "CHECKBOX",
    ["Delete players bodies","Automatically delete players bodies"],
    ["MCC Respawn","Respawn"],
    false,
    true
] call CBA_Settings_fnc_init;


//Respawn menu
[
    "MCC_openRespawnMenu",
    "CHECKBOX",
    ["Respawn Menu","Custom MCC respawn menu"],
    ["MCC Respawn","Respawn"],
    true,
    true
] call CBA_Settings_fnc_init;

//Respawn Cinematic
[
    "MCC_respawnCinematic",
    "CHECKBOX",
    "Respawn Cinematic",
    ["MCC Respawn","Respawn"],
    true,
    true
] call CBA_Settings_fnc_init;

//Respawn on Leader
[
    "MCC_respawnOnGroupLeader",
    "CHECKBOX",
    ["Respawn On Leader","Allow player to select to respawn on team leader from the MCC respawn menu"],
    ["MCC Respawn","Respawn"],
    false,
    true
] call CBA_Settings_fnc_init;