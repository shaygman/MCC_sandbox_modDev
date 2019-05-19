/*====================================		MCC_fnc_undercoverInit ==================================
	Init under cover script

*/
private ["_unit", "_removeWeapons","_null"];
_unit =  param [0, objNull, [objNull]];
_removeWeapons =  param [1, false, [false]];

if (isNull _unit) exitWith {};
if (_unit != player || !local _unit) exitWith {diag_log "MCC_fnc_undercoverInit: not a player unit"};

//Add EH
if !(player getVariable ["MCC_underCoverInitEH",false]) then {
	player setvariable ["MCC_underCoverInitEH",true];
	player addEventHandler ["killed", {(_this select 0) spawn MCC_fnc_undercoverInit}];
};

waitUntil {alive player && time > 0};
0 spawn MCC_fnc_undercoverNearTargets;

if (_removeWeapons) then {removeallweapons player};
player setcaptive true;

_null = player addaction ["Draw Weapon", MCC_fnc_undercoverHandleGun,0,6,false,true,"","_target == _this && handgunWeapon _target == '' && _target getVariable ['MCC_undercoverGunHolstered',false]"];
_null = player addaction ["Holster Weapon", MCC_fnc_undercoverHandleGun,0,6,false,true,"","_target == _this && handgunWeapon _target != ''"];



