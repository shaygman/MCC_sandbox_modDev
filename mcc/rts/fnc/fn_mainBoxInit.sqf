/*================================================ MCC_fnc_mainBoxInit ====================================================
	Open the vault (main cargo box)
*/

private ["_mccdialog","_comboBox","_displayname","_pic", "_index", "_array", "_class","_boxName","_tempBox","_displayArray","_prices"];
_tempBox = param [0,objNull,[objNull,sideUnknown]];
_prices = param [1,0.5,[0]];

disableSerialization;


MCC_fnc_mainBoxInitRefreshBox = {
	//startLoadingScreen [""];

	//Refresh box arrays
	params ["_tempBox","_prices"];
	private ["_array","_i"];
	for "_i" from 1 to 12 step 1 do
	{
		_array = [_i, _tempBox,"",_prices] call MCC_fnc_boxMakeWeaponsArray;
		_array sort true;

		missionNamespace setVariable [format ["MCC_fnc_mainBoxInit_tempBox_%1",_i],_array];
	};

	//endLoadingScreen;
};

_tempBox setVariable ["MCC_prices",_prices,true];

//if it is a side box
if (typeName _tempBox isEqualTo typeName sideUnknown) then {
	//Do we have a box for our side?
	_boxName = format ["MCC_rtsMainBox%1",playerSide];

	if (isnil _boxName) then {
		_tempBox = "ReammoBox_F" createvehicle [0,0,(random 200)+200];
		_tempBox enableSimulation false;
		_tempBox allowDamage false;
		_tempBox setVariable ["MCC_virtualBox",true,true];
		missionNamespace setVariable [_boxName, _tempBox];
		publicVariable _boxName;
	};

	_tempBox = missionNamespace getVariable [_boxName, objNull];
};



createDialog "MCC_rtsMainBox";
waituntil {dialog};

//create blur effect
private ["_blur"];
_blur = ppEffectCreate ["DynamicBlur", 474];
_blur ppEffectEnable true;
_blur ppEffectAdjust [1];
_blur ppEffectCommit 0.2;

_mccdialog = uiNamespace getVariable ["MCC_rtsMainBox", displayNull];
if (isNull _mccdialog) exitWith {};

_eh = (_mccdialog displayCtrl 1) ctrlAddEventHandler ["LBSelChanged",{
		params ["_ctrl","_index"];
		private _class = _ctrl lbData _index;
		if ((([_class] call BIS_fnc_itemType) select 0) == "Weapon") then {
			_null = [5,_class] execVM format ["%1mcc\rts\scripts\rtsMainBox_change.sqf",missionNamespace getVariable ["MCC_path",""]];
		};
	}];

//Don't have the box exit
if (isNull _tempBox) exitWith {};

player setVariable ["MCC_interactedBox", _tempBox];

//Get valor points
(_mccdialog displayCtrl 4) ctrlSetText ([(player getVariable ["MCC_valorPoints",50])] call MCC_fnc_formatNumber);


_comboBox = _mccdialog displayCtrl 2;
lbClear _comboBox;
{
	_displayname = _x;
	_comboBox lbAdd _displayname;
} foreach ["Binoculars", "Items","Uniforms", "Launchers", "Machine Guns", "Pistols", "Rifles","Sniper Rifles","Magazines","Under Barrel","Grenades","Explosive","Survival"];

_comboBox lbSetCurSel 0;

//Pre build all the arrays to save time
[_tempBox,_prices] call MCC_fnc_mainBoxInitRefreshBox;

{
	_displayArray = [];

	//save time and get the preloaded array
	if (_x isEqualTo _tempBox) then {
		_array = missionNamespace getVariable ["MCC_fnc_mainBoxInit_tempBox_1",[]];
	} else {
		_array = [1, player,"",_prices] call MCC_fnc_boxMakeWeaponsArray;
		_array sort true;
	};

	_comboBox = _mccdialog displayCtrl (if (isplayer _x) then {1} else {0});
	lbClear _comboBox;

	{
		_displayname 	= _x select 0;
		_class 			= _x select 1;
		_pic 			= _x select 2;
		_valor			= _x select 3;
		//_valor = [_class,_prices] call MCC_fnc_getWeaponCost;

		if !(_displayname in _displayArray) then
		{
			_i = _comboBox lbAdd _displayname;
			_comboBox lbSetPicture [_i, _pic];
			_comboBox lbSetTextRight [_i,format ["%1 $", _valor]];
			_comboBox lbSetData [_i, _class];
			_comboBox lbSetTooltip [_i,str ({_displayname== (_x select 0)} count _array)];
			_displayArray pushback _displayname;
		};

	} foreach _array;

	_comboBox lbSetCurSel 0;
} foreach [_tempBox,player];

_blur spawn {
	disableSerialization;
	private ["_array","_mccdialog"];
	_mccdialog = uiNamespace getVariable ["MCC_rtsMainBox", displayNull];
	while {(str (_mccdialog displayCtrl 0) != "No control")} do {

		//Load available resources
		_array = call compile format ["MCC_res%1",playerside];
		{_mccdialog displayCtrl _x ctrlSetText ([(_array select _forEachIndex)] call MCC_fnc_formatNumber)} foreach [81,82,83,84,85];
	};

	_this ppEffectAdjust [0];
	_this ppEffectCommit 0.2;
	uisleep 0.2;
	ppEffectDestroy _this;
};