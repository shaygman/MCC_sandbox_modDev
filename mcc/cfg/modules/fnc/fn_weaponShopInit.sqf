//==================================================================MCC_fnc_weaponShopInit============================================================================
// Sync with triggers to create MCC zones
//==============================================================================================================================================================
private ["_module","_text","_objects","_object","_box","_prices","_persistent","_persistentName"];
if (!isServer) exitWith {};

#define MCC_SHOP_ICON	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa"

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {};

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
		 0,
		 false,
		 false
	] remoteExec ["BIS_fnc_holdActionAdd", [0,2] select isDedicated, _object];;
} forEach _objects;