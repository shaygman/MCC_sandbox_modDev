/*================================================================================   MCC_fnc_logisticsBoxDeposit =======================================================
	Deposit a resource box from HQ and add the resources

	<IN>
		0:		SIDE - the side to withdraw resources from
		1:		STRING - resources as: "ammo", "materials" ,"fuel"


	<OUT>
		Nothing



========================================================================================================================================================================*/
#include "..\defines.sqf"

private ["_cratesType","_res","_str","_cost"];

params [
	["_object",objNull,[objNull]],
	["_side",sideLogic,[sideLogic,""]]
];

if (_side isEqualType "") then {

	switch (_side) do
	{
		case "EAST": {_side = east};
		case "WEST": {_side = west};
		case "GUER": {_side = resistance};
		case "CIV": {_side = civilian};
		default	{_side = sideLogic};
	};
};

if (_side == sideLogic || !(alive _object)) exitWith {};

//Find crates types
_cratesType = (missionNamespace getVariable ["MCC_logisticsCrates_TypesWest",[]]) find (typeOf _object);
if (_cratesType == -1) then {
	_cratesType = (missionNamespace getVariable ["MCC_logisticsCrates_TypesEast",[]]) find (typeOf _object);
};

if (_cratesType == -1) exitWith {};

//Get side resources
_res = call compile format ["MCC_res%1",_side];
_str = "";

//If it is a big create
_cost = if (_cratesType > 2) then {CRATE_COST*2} else {CRATE_COST};

//Limited logistics: a used crate is worth only what is left in it
if ((missionNamespace getVariable ["MCC_logisticsMode",0]) > 0) then {
	_cost = floor (_cost * ([_object, _cratesType mod 3] call MCC_fnc_supplyRemaining));
};

switch (_cratesType mod 3) do
{
	//Ammo
	case 0:
	{
		//Add cost
		_str = format ["+%1 <img image='%2' />",_cost, MCC_ICONAMMO];
	};

	//Materials
	case 1:
	{
		//Add cost
		_str = format ["+%1 <img image='%2' />",_cost, MCC_ICONMETERIALS];
	};

	//Fuel
	case 2:
	{
		//Add cost
		_str = format ["+%1 <img image='%2' />",_cost, MCC_ICONFUEL];
	};
};

deleteVehicle _object;

//add resources (server-authoritative)
[_side, _cratesType mod 3, _cost] call MCC_fnc_resChange;

//UI notification
if (_str != "") then {
	playsound "MCC_pop";
	_null = [_str,0,0.5,2,0.1,0.0] spawn bis_fnc_dynamictext;
};