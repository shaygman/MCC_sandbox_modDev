/*====================================== MCC_fnc_AASgroupSpawn ==============================================================================================
	Spawn group for MCC Advance and secure
*/

private ["_unitNumber","_groupSize","_useDefaultGear","_groupArray","_defaultGroups","_group","_tempGroup","_unit","_selectedRole","_side","_unitsArray","_spawnPos","_i","_p","_t"];
_unitNumber = param [0,4];
_groupSize = param [1,6];
_useDefaultGear = param [2,[]];
_vehicle = param [3,objNull];
_side = param [4,sideUnknown];
_unitsArray = param [5,[]];
_spawnPos = param [6,[]];

_groupArray = [];
for "_p" from 1 to _unitNumber step 1 do {
	_groupArray pushBack ((_unitsArray call bis_fnc_selectRandom) select 0);
};

_fnc_killed = {
	params ["_unit"];
	private _side = side _unit;
	waituntil {!alive _unit};
	[_side,-1] call BIS_fnc_respawnTickets


	/*
		_unit addEventHandler ["killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			format ["SIDE KILLED %1",side _unit];
			[side _unit,-1] call BIS_fnc_respawnTickets
		}];
	*/
};

//find group
_defaultGroups = missionNamespace getVariable [format ["CP_%1Groups",_side],[]];
_group = grpNull;

for "_p" from 0 to (count _defaultGroups -1) step 1 do {
	_tempGroup = (_defaultGroups select _p) select 0;

	//vehicles put in a seperated group
	if (isNull _vehicle) then {
		if (!(_tempGroup getVariable ["locked",false]) && (!isPlayer leader _tempGroup) && ((count units _tempGroup)+_unitNumber) <= _groupSize  && ({vehicle _x != _x} count units _tempGroup == 0)) then {
			_group = _tempGroup;
		};
	} else {
		if (!(_tempGroup getVariable ["locked",false]) && count units _tempGroup == 0) then {
			_group = _tempGroup;
		};
	};

	if (!isNull _group) exitWith {};
};

if (isNull _group) then {
	_group = createGroup _side;
	waituntil {!isnil "_group"};
	_name = ["Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel","India","Juliett","Kilo","Lima","Mike","November","Oscar","Papa"] select (count _defaultGroups min 15);
	_group setVariable ["MCC_CPGroup",true,true];
	_group setVariable ["name",_name,true];
	_defaultGroups pushBack [_group,_name];
	missionNamespace setVariable [format ["CP_%1Groups",_side],_defaultGroups];
	publicVariable format ["CP_%1Groups",_side];
};


_group setVariable ["MCC_canbecontrolled",true,true];

//spawn unit
if (isNull _vehicle) then {
	{
		_unit =_group createUnit [(_groupArray call bis_fnc_selectRandom), _spawnPos, [], 0, "FORM"];
		waitUntil {alive _unit};

		[_unit] spawn _fnc_killed;

		//set gear
		if (count _useDefaultGear > 0) then {
			{
				_selectedRole = _x;
				if ({(_x getVariable ["CP_role",""]) == _selectedRole} count (units _group) == 0) exitWith {};
			} forEach _useDefaultGear;
			[_selectedRole,_unit] call MCC_fnc_gearAI;
		};

		{_x addCuratorEditableObjects [[_unit],false]} forEach allCurators;
	} forEach _groupArray;
} else {
	private ["_cfg","_turrets","_path","_index","_isCargo","_t"];
	_cfg = configFile >> "CfgVehicles" >> typeOf _vehicle;
	_turrets = [_cfg >> "turrets"] call BIS_fnc_returnVehicleTurrets;			//All turrets were found, now spawn crew for them
	_path = [];
	_t = 0;
	_index = 0;

	//driver
	_unit = _group createUnit [getText(_cfg >> "crew"), position _vehicle, [], 0, "NONE"];
	_unit assignAsDriver _vehicle;
	_unit moveindriver _vehicle;
	[_unit] spawn _fnc_killed;

	//set gear
	if (count _useDefaultGear > 0) then {
		[(_useDefaultGear) call bis_fnc_selectRandomWeighted,_unit] spawn MCC_fnc_gearAI;
	};
	{_x addCuratorEditableObjects [[_unit],false]} forEach allCurators;

	while {_t < (count _turrets)} do {
		private ["_turretIndex", "_thisTurret"];
		_turretIndex = _turrets select _t;
		_thisTurret = _path + [_turretIndex];
		_turretPath = configName ((configFile >> "CfgVehicles" >> typeOf _vehicle >> "turrets") Select _index);

		_isCargo = ["cargo",tolower _turretPath] call BIS_fnc_inString;
		if (isNull (_vehicle turretUnit _thisTurret) && !_isCargo) then {
			_unit = _group createUnit [getText(_cfg >> "crew"), position _vehicle, [], 0, "NONE"];
			_unit moveInTurret [_vehicle, _thisTurret];

			//set gear
			if (count _useDefaultGear > 0) then {
				[(_useDefaultGear) call bis_fnc_selectRandomWeighted,_unit] spawn MCC_fnc_gearAI;
			};

			[_unit] spawn _fnc_killed;

			{_x addCuratorEditableObjects [[_unit],false]} forEach allCurators;
		};

		_t = _t + 2;
		_index = _index + 1;
	};
};

_group