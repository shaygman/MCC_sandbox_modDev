/*=================================================================MCC_fnc_saveCargoBox==================================================================================
  save or load the cargo box items from the server using iniDB
  Parameter(s):
     0: OBJECT - cargoBox/vault item
     1: STRING - save file name
=========================================================================================================================================================================*/
private ["_object","_cargo","_saveName"];
_object = param [0,objnull,[missionNamespace,objnull]];
_saveName = param [1,"vaultObjects",[""]];

if (isNull _object) exitWith {};

_cargo = _object getvariable ["MCC_virtual_cargo",[[],[],[],[]]];

if (str _cargo == "[[],[],[],[]]") then {
    //No cargo lets see if we have it on the server
    _cargo = [format ["SERVER_%1_%2",toupper worldName,toUpper missionName], "vaultObjects", _saveName, "read",[],true] call MCC_fnc_handleDB;
    if (str _cargo == "[]") then {
       _cargo = [[],[],[],[]];
    };

    _object setvariable ["MCC_virtual_cargo",_cargo,true];

} else {
	[format ["SERVER_%1_%2",toupper worldName,toUpper missionName], "vaultObjects", _saveName, "write",_cargo,true] call MCC_fnc_handleDB;
};