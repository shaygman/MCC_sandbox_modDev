/*============================================================MCC_fnc_compositionsPlace==============================================================================
	Place a composition as defined by config entry

	<IN>
		0:	_pos ARRAY position composition will be place - position player by default
		1:	_azi INTEGER compposition direction - 0 by default
		2: 	_script ARRAY config entry path as defined in cfgGroup for example configfile >> "cfgGroups" >> "Guerrilla" >> "Camps" >> "campA" will be called with an array of ["Guerrilla","Camps","campA"]

	<OUT>
		NONE

	Example:

	[position player, 220, ["Guerrilla","Camps","campA"]] call MCC_fnc_compositionsPlace;

======================================================================================================================================================================*/

params [
	["_pos",position player,[[],objNull]],
	["_azi",0,[0]],
	["_script",[],[[]]]
];
private ["_objs","_multiplyMatrixFunc","_posX", "_posY","_configName"];
_posX = _pos select 0;
_posY = _pos select 1;

_multiplyMatrixFunc =
{
	private ["_array1", "_array2", "_result"];
	_array1 = _this select 0;
	_array2 = _this select 1;

	diag_log format ["MCC DEBUG: %1", [_array1,_array2]];

	_result =
	[
	(((_array1 select 0) select 0) * (_array2 select 0)) + (((_array1 select 0) select 1) * (_array2 select 1)),
	(((_array1 select 1) select 0) * (_array2 select 0)) + (((_array1 select 1) select 1) * (_array2 select 1))
	];
	_result
};


_configName = configFile >> "CfgGroups" >> "Empty";
{
	_configName = _configName >> _x;
} forEach _script;

diag_log format ["MCC DEBUG: %1",_configName];

for "_i" from 0 to ((count _configName) - 1) do
{
	private ["_obj", "_type", "_relPos", "_azimuth", "_fuel", "_damage", "_newObj", "_vehicleinit"];
	_obj = _configName select _i;

	if (isClass _obj) then {
		_type = getText (_obj >> "vehicle");
		_relPos =  getArray (_obj >> "position");
		_azimuth = getNumber (_obj >> "dir");
		_vehicleinit = getText (_obj >> "code");

		private ["_rotMatrix", "_newRelPos", "_newPos"];
		_rotMatrix =[[cos _azi, sin _azi],[-(sin _azi), cos _azi]];
		_newRelPos = [_rotMatrix, _relPos] call _multiplyMatrixFunc;
		private ["_z"];
		if ((count _relPos) > 2) then {_z = _relPos select 2} else {_z = 0};
		_newPos = [_posX + (_newRelPos select 0), _posY + (_newRelPos select 1), _z];
		_newObj = _type createVehicle _newPos;
		_newObj setDir (_azi + _azimuth);
		_newObj setPos _newPos;
		if (!isNil "_fuel") then {_newObj setFuel _fuel};
		if (!isNil "_damage") then {_newObj setDamage _damage};
		if (!isNil "_vehicleinit") then {
			_newObj spawn compile _vehicleinit;
		};

		{_x addCuratorEditableObjects [[_newObj],true]} forEach allCurators;
	};
};
