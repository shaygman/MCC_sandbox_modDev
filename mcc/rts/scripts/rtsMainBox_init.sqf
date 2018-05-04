private ["_mccdialog","_comboBox","_displayname","_pic", "_index", "_array", "_class","_boxName","_tempBox","_displayArray"];
waituntil {dialog};
disableSerialization;

_mccdialog = _this select 0;
uiNamespace setVariable ["MCC_rtsMainBox", _mccdialog];

//Do we have a box for our side?
_boxName = format ["MCC_rtsMainBox%1",playerSide];
if (isnil _boxName) then
{
	_tempBox = "ReammoBox_F" createvehicle [0,0,(random 200)+200];
	_tempBox enableSimulation false;
	_tempBox allowDamage false;
	missionNamespace setVariable [_boxName, _tempBox];
	publicVariable _boxName;
};

//Don't have the box exit
_tempBox = missionNamespace getVariable [_boxName, objNull];
if (isNull _tempBox) exitWith {};

//Get valor points
(_mccdialog displayCtrl 4) ctrlSetText str (player getVariable ["MCC_valorPoints",50]);
//index load

_comboBox = _mccdialog displayCtrl 2;
lbClear _comboBox;
_comboBox lbSetCurSel 0;


_displayArray = [];

{
	disableSerialization;
	_array = [0, _x] call MCC_fnc_boxMakeWeaponsArray;
	_comboBox = mccdialog displayCtrl (if (isplayer _x) then {1} else {0});
	lbClear _comboBox;

	{
		_displayname 	= _x select 0;
		_class 			= _x select 1;
		_pic 			= _x select 2;
		_valor			= _x select 3;

		if !(_displayname in _displayArray) then
		{
			_index 			= _comboBox lbAdd (format ["%1 X %2",_displayname, ({_displayname== (_x select 0)} count _array)]);
			_comboBox lbSetPicture [_index, _pic];
			_comboBox lbSetData [_index, _class];
			_comboBox lbSetTooltip [_index,format ["%1 Valor points", _valor]];
			_displayArray pushback _displayname;
		};

	} foreach _array;

	_comboBox lbSetCurSel 0;
} foreach [_tempBox,player];



//Load available resources
_mccdialog spawn {
	private ["_array"];
	disableSerialization;

	while {(str (_this displayCtrl 0) != "No control")} do {
		_array = call compile format ["MCC_res%1",playerside];
		{_this displayCtrl _x ctrlSetText str floor (_array select _forEachIndex)} foreach [81,82,83,84,85];
		sleep 0.1;
	};
};

