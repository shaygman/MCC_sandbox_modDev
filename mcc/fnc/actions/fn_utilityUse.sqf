/*============================================================MCC_fnc_utilityUse==========================================================================================
//use utility
// Example: [] call MCC_fnc_utilityUse;
========================================================================================================================================================================*/

private ["_utility","_vel","_dir","_handPos","_item","_mag","_itemClass","_charges","_cfg","_putCfg","_putCfgArray","_putCfgName","_magMuzzle","_ins","_interaction"];
_primaryMod = _this select 0;
_interaction = param [1,false,[false]];

_mag 		= (player getVariable ["MCC_utilityItem",["",""]]) select 0;
_itemClass	= getText (configfile >> "CfgMagazines" >> _mag >> "ammo");

if (_mag == "" && _primaryMod) exitWith {};

if (!_primaryMod) exitWith {
	_charges = player getVariable ["MCC_utilityActiveCharges",[]];
	if (count _charges > 0 ) then {
		_utility = _charges select 0;
		_charges set [0,-1];
		_charges = _charges - [-1];
		_utility setdamage 1;
		player setVariable ["MCC_utilityActiveCharges",_charges];
	};
};

switch (true) do {
	case (isClass (configFile >> "CfgMagazines" >> _mag)) : {player removeMagazine _mag;};
	case (isClass (configFile >> "CfgWeapons" >> _mag)) : {player removeItem _mag;};
	case (isClass (configFile >> "CfgGlasses" >> _mag)) : {player removeItem _mag;};
};

player playactionNow "putdown";
sleep 0.3;
_handPos = player selectionPosition "LeftHand";
_utility = _itemClass createvehicle (player modelToWorld [(_handPos select 0),(_handPos select 1)+1.8,(_handPos select 2)]);
0 = [_utility,(owner player)] remoteExec ["setOwner", 2];

//Stick it to a vehicle
private ["_vehicle","_relPos","_handPos","_upFront","_headPos","_objects","_closeObject","_relDir","_n"];
_headPos = player selectionPosition "head";
_upFront = player modelToWorld [(_headPos select 0),(_headPos select 1)+2,(_headPos select 2)];
_objects = (lineintersectsWith [ATLToASL (player modelToWorld _headPos), ATLToASL _upFront, objNull, objNull, true]);

if (count _objects > 0) then {
	_closeObject = _objects select 0;
	if ((_closeObject isKindOf "LandVehicle") || (_closeObject isKindOf "Air") || (_closeObject isKindOf "Ship")) then {_vehicle = _closeObject};
};

if (getnumber (configfile >> "CfgMagazines" >> _mag >> "type")==512) then {

	//Attach it to vehicle
	if !(isNil "_vehicle") then {
		_handPos = player selectionPosition "LeftHand";
		_upFront = player modelToWorld _handPos;
		_n = 0;
		while {!lineIntersects [ATLToASL _upFront, ATLToASL (player modelToworld [0,_n,1.5])]} do
		{
			_n = _n + 0.1;
		};
		_upFront = player modelToWorld [(_handPos select 0),_n,(_handPos select 2)];
		_relPos = _vehicle worldToModel _upFront;
		_utility attachTo [_vehicle, _relPos];
		_relDir = [_vehicle, player] call BIS_fnc_relativeDirTo;
		switch (true) do
		{
		    case (_relDir >= 315 || _relDir <= 45): {_utility setVectorDirAndUp [[0,0,1],[0,1,0]]};
		    case (_relDir >= 135 && _relDir <= 225): {_utility setVectorDirAndUp [[0,0,1],[0,-1,0]]};
		    case (_relDir >= 45 && _relDir <= 135): {_utility setVectorDirAndUp [[0,0,1],[1,0,0]]};
		    case (_relDir > 225 && _relDir < 315): {_utility setVectorDirAndUp [[0,0,1],[-1,0,0]]};
		};
	} else {
		//Atach to walls
		_ins = lineIntersectsSurfaces [
										  AGLToASL positionCameraToWorld [0,0,0],
										  AGLToASL positionCameraToWorld [0,0,5],
										  player,
										  objNull,
										  true,
										  1,
										  "GEOM",
										  "NONE"
										 ];

		_utility setPosASL (_ins select 0 select 0);
		_utility setPosASL (_ins select 0 select 0);
 		_utility setVectorUp (_ins select 0 select 1);
	};

	_charges = player getVariable ["MCC_utilityActiveCharges",[]];
	_charges pushback _utility;
	player setVariable ["MCC_utilityActiveCharges",_charges];

} else {
	_utility setpos (player modelToWorld [(_handPos select 0),(_handPos select 1)+1,0]);
	_utility setdir getdir player;
};

if (!(_mag in magazines player) && !(_mag in items player) && !_interaction) then {
	player setVariable ["MCC_utilityItem",["",""]];
	[5] call MCC_fnc_weaponSelect;
};

if (_itemClass in ["MCC_ammoBox"]) then {
	[[_utility, "Hold %1 to resupply"], "MCC_fnc_createHelper", false] call BIS_fnc_MP;
	_utility spawn	{
		private ["_t"];
		_t = time + 600;
		while {alive _this && time < _t} do {sleep 5};
		if (alive _this) exitWith {deleteVehicle _this};
	};
};