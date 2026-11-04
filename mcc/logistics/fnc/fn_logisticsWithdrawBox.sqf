/*======================================================================= MCC_fnc_logisticsWithdrawBox =========================================================================

	withdraw a box from HQ and reduce the resources - always local to the player

	<IN>
		0:		SIDE - the side to withdraw resources from
		1:		STRING - resources as: "ammo", "materials" ,"fuel"


	<OUT>
		Nothing
*/
#include "..\defines.sqf"
private ["_cratesType","_res","_str","_box"];
private _index = -1;

params [
	["_side",sideLogic,[sideLogic,""]],
	["_boxType","",[""]]
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

if (_side == sideLogic || _boxType == "") exitWith {};


//Find crates types
_cratesType = missionNamespace getVariable ["MCC_logisticsCrates_TypesWest",[]];
if (count _cratesType <=0) exitWith {diag_log "MCC Logistics: Error MCC_logisticsCrates_TypesWest not defined"};

//Get side resources
_res = call compile format ["MCC_res%1",_side];
_str = "";

switch (tolower _boxType) do
{
	case "ammo":
	{
		if ((_res select 0) >= CRATE_COST) then {

			//Spawn box
			_str = format ["-%1 <img image='%2' />",CRATE_COST, MCC_ICONAMMO];
			_box = (_cratesType select 0) createVehicle position player;

			_index = 0;
		} else {
			_str = "Not Enough Ammo";
		};
	};

	case "materials":
	{
		if ((_res select 1) >= CRATE_COST) then {

			//Spawn box
			_str = format ["-%1 <img image='%2' />",CRATE_COST, MCC_ICONMETERIALS];
			_box = (_cratesType select 1) createVehicle position player;

			_index = 1;
		} else {
			_str = "Not Enough Materials";
		};
	};

	case "fuel":
	{
		if ((_res select 2) >= CRATE_COST) then {

			//Spawn box
			_str = format ["-%1 <img image='%2' />",CRATE_COST, MCC_ICONFUEL];
			_box = (_cratesType select 2) createVehicle position player;

			_index = 2;
		} else {
			_str = "Not Enough Fuel";
		};
	};
};

//reduce cost (server-authoritative)
if (_index >= 0) then {
	[_side, _index, -CRATE_COST] call MCC_fnc_resChange;

	//Limited logistics: track the crate's stock
	if ((missionNamespace getVariable ["MCC_logisticsMode",0]) > 0) then {[_box] call MCC_fnc_supplyRegister};
};

if (_str != "") then {
	playsound "MCC_pop";
	_null = [_str,0,0.5,2,0.1,0.0] spawn bis_fnc_dynamictext;
};