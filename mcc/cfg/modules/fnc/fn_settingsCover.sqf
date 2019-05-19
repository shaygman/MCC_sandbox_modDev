//==================================================================MCC_fnc_settingsCover============================================================================
// module
// Example: [] call MCC_fnc_settingsCover;
// _group1 = group, the group name
//==============================================================================================================================================================
private ["_module","_var"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};


if (typeName (_module getVariable ["cover",true]) == typeName 0) exitWith {
	//cover
	_var 	= _module getvariable ["cover",1];
	MCC_cover = if (_var == 0) then {false} else {true};

	//coverUI
	_var 	= _module getvariable ["coverUI",1];
	MCC_coverUI = if (_var == 0) then {false} else {true};

	//cover Vault
	_var 	= _module getvariable ["coverVault",1];
	MCC_coverVault = if (_var == 0) then {false} else {true};

	//Switch weapon
	_var 	= _module getvariable ["switchWeapons",1];
	MCC_quickWeaponChange = if (_var == 0) then {false} else {true};

	//interaction
	_var 	= _module getvariable ["interaction",1];
	MCC_interaction = if (_var == 0) then {false} else {true};

	//interaction UI
	_var 	= _module getvariable ["interactionUI",0];
	MCC_ingameUI = if (_var == 0) then {false} else {true};



	/* =========================	SURVIVE MOD	========================================*/
	//Survive mod player Pos
	MCC_surviveModPlayerPos	= _module getvariable ["survivePlayerPosition",false];

	//Survive mod player Gear
	MCC_surviveModPlayerGear	= _module getvariable ["survivePlayerGear",false];

	//Survive mod player status
	MCC_surviveModPlayerStats	= _module getvariable ["survivePlayerStats",false];

	//Survive mod
	_var 	= _module getvariable ["survive",0];
	MCC_surviveMod = _var > 0;
	MCC_surviveModAllowSearch = _var ==1;

	/* =================================================================================*/


	//Action menu
	_var 	= _module getvariable ["actionMenu",1];
	MCC_showActionKey = if (_var == 0) then {false} else {true};

	//Arcade Tanks
	MCC_arcadeTanks = ((_module getvariable ["arcadeTanks",0])==1);

	//Disable Fatigue
	MCC_disableFatigue = ((_module getvariable ["fatigue",0])==1);
	player enableFatigue !(missionNamespace getVariable ["MCC_disableFatigue",false]);

	//Breaching Ammo
	MCC_breacingAmmo = call compile (_module getvariable ["breachingAmmo","[]"]);

	//Non Lethal Ammo
	MCC_nonLeathalAmmo = call compile (_module getvariable ["nonLeathalAmmo","[]"]);
};

//Not curator exit
if !(local _module) exitWith {};

_resualt = ["Settings MCC Mechanics",[
 						["Action Menu",(missionNamespace getVariable ["MCC_showActionKey",true])],
 						["Cover System",(missionNamespace getVariable ["MCC_cover",true])],
 						["Cover System UI",(missionNamespace getVariable ["MCC_coverUI",true])],
 						["Vault/Climb",(missionNamespace getVariable ["MCC_coverVault",true])],
 						["Weapons Binds",(missionNamespace getVariable ["MCC_quickWeaponChange",true])],
 						["Interaction",(missionNamespace getVariable ["MCC_interaction",true])],
 						["Interaction UI",(missionNamespace getVariable ["MCC_ingameUI",true])],
 						["One Man Tanks",(missionNamespace getVariable ["MCC_arcadeTanks",true])],
 						["Disable Fatigue",(missionNamespace getVariable ["MCC_disableFatigue",true])],
 						["Survival Mod",["No","Yes - Enable searching loot","Yes - Disable searching loot"]],
 						["(Survival) Load Player Position",(missionNamespace getVariable ["MCC_surviveModPlayerPos",false])],
 						["(Survival) Load Player Gear",(missionNamespace getVariable ["MCC_surviveModPlayerGear",false])],
 						["(Survival) Load Player Stats",(missionNamespace getVariable ["MCC_surviveModPlayerStats",false])]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

{
	missionNamespace setVariable [_x,_resualt select _foreachindex];
	publicvariable _x;
} forEach ["MCC_showActionKey",
           "MCC_cover",
           "MCC_coverUI",
           "MCC_coverVault",
           "MCC_quickWeaponChange",
           "MCC_interaction",
           "MCC_ingameUI",
           "MCC_arcadeTanks",
           "MCC_disableFatigue"
          ];

//Survival
_var = (_resualt select 9);
MCC_surviveMod = (_resualt select 9) > 0;
publicvariable "MCC_surviveMod";

MCC_surviveModAllowSearch = _var ==1;
publicvariable "MCC_surviveModAllowSearch";

{
	missionNamespace setVariable [_x,_resualt select (_foreachindex + 10)];
	publicvariable _x;
} forEach ["MCC_surviveModPlayerPos",
           "MCC_surviveModPlayerGear",
           "MCC_surviveModPlayerStats"
          ];

//Fatigue
{player enableFatigue !(missionNamespace getVariable ["MCC_disableFatigue",false])} remoteExec ["bis_fnc_call", 0];

deleteVehicle _module;