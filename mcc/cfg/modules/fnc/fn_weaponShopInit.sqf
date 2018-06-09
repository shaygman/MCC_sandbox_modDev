//==================================================================MCC_fnc_weaponShopInit============================================================================
// Sync with triggers to create MCC zones
//==============================================================================================================================================================
private ["_module","_text","_objects","_object","_box","_prices","_persistent","_persistentName","_pos","_resualt"];
#define MCC_SHOP_ICON	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa"
#define	TEMPBOX	"B_CargoNet_01_ammo_F"

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {};

_pos = getpos _module;

//did we get here from the 2d editor?
if (typeName (_module getVariable ["prices",true]) == typeName 0) then {

	if (!isServer) exitWith {};

	_text = _module getVariable ["tittle","Open Shop"];
	_prices = _module getVariable ["prices",0.5];
	_persistent = _module getVariable ["persistent",false];
	_persistentName =  _module getVariable ["persistentName","testShop"];

	//Find all the boxes and place holders
	_objects = [];
	{
		if (_x isKindOf "ReammoBox_F" || _x isKindOf "ReammoBox") then {
			_box = _x;
		} else {
			_objects pushBack _x;
		};
	} forEach (synchronizedObjects _module);

	if (isNil "_box") exitWith {};

	_box enableSimulation false;
	_box allowDamage false;
	_box hideObjectGlobal true;

	//If persistent DB
	if (_persistent) then {
		_box setVariable ["MCC_virtualBox",true,true];
		_box setVariable ["MCC_virtualBoxSaveName",_persistentName,true];
	};

	//add objects actions
	{
		_object = _x;

		[
			 _object,
			 _text,
			 MCC_SHOP_ICON,
			 MCC_SHOP_ICON,
			 "(alive _target) && (_target distance _this < 5)",
			 "(alive _target) && (_target distance _this < 5)",
			 {},
			 {},
			 {_arguments spawn MCC_fnc_mainBoxInit},
			 {},
			 [_box,_prices],
			 1,
			 100,
			 false,
			 false
		] remoteExec ["BIS_fnc_holdActionAdd", 0, _object];
	} forEach _objects;

} else {

	_resualt = ["Weapons Shop",[
 						["Binos",true],
 						["Items",true],
 						["Uniforms",true],
 						["Rocket Launchers",true],
 						["Automatic Rifles",true],
 						["Pistols",true],
 						["Rifles",true],
 						["Sniper Rifles",true],
 						["Backpacks",true],
 						["Prices",10]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

	_box = TEMPBOX createVehicle _pos;
	_box enableSimulation false;
	_box allowDamage false;
	_box hideObjectGlobal true;

	_object =  TEMPBOX createVehicle _pos;
	_box allowDamage false;

	clearItemCargoGlobal _box;
	clearMagazineCargoGlobal _box;
	clearWeaponCargoGlobal _box;
	clearBackpackCargoGlobal _box;

	//Binos
	if (_resualt select 0) then {
		{
			_box addWeaponCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["W_BINOS",[]]);
	};

	//Items
	if (_resualt select 1) then {
		{
			_box addItemCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["W_ITEMS",[]]);
	};

	//Uniforms
	if (_resualt select 2) then {
		{
			_box addItemCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["U_UNIFORM",[]]);
	};

	//Launchers
	if (_resualt select 3) then {
		{
			_box addWeaponCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["W_LAUNCHERS",[]]);
	};

	//Automatic Rifles
	if (_resualt select 4) then {
		{
			_box addWeaponCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["W_MG",[]]);
	};

	//Pistols
	if (_resualt select 5) then {
		{
			_box addWeaponCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["W_PISTOLS",[]]);
	};

	//Rifles
	if (_resualt select 6) then {
		{
			_box addWeaponCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["W_RIFLES",[]]);
	};

	//Snipers
	if (_resualt select 7) then {
		{
			_box addWeaponCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["W_SNIPER",[]]);
	};

	//Backpacks
	if (_resualt select 8) then {
		{
			_box addBackpackCargoGlobal [(_x select 0),10];
		} forEach (missionNamespace getvariable ["W_RUCKS",[]]);
	};

	//Magazines
	{
		{
				_box addMagazineCargoGlobal [(_x select 0),50];
		} forEach _x;
	} foreach [
			(missionNamespace getvariable ["U_MAGAZINES",[]]),
			(missionNamespace getvariable ["U_UNDERBARREL",[]]),
			(missionNamespace getvariable ["U_GRENADE",[]]),
			(missionNamespace getvariable ["U_EXPLOSIVE",[]])
		];

	//get prices
	_prices = ((_resualt select 9)/10) max 0.1;

	//Spawn action
	[
		 _object,
		 "Open Shop",
		 MCC_SHOP_ICON,
		 MCC_SHOP_ICON,
		 "(alive _target) && (_target distance _this < 5)",
		 "(alive _target) && (_target distance _this < 5)",
		 {},
		 {},
		 {_arguments spawn MCC_fnc_mainBoxInit},
		 {},
		 [_box,_prices],
		 1,
		 100,
		 false,
		 false
	] remoteExec ["BIS_fnc_holdActionAdd", 0, _object];

	deleteVehicle _module
};

