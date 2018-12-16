//=====================================MCC_fnc_MWObjectiveHVT=========================================================================================================
// Create an HVT objective
// Example:[_objPos,_isCQB,_hostageRescue] call MCC_fnc_MWObjectiveHVT;
// _objPos = position, objectice position
//_isCQB = Boolean, true - for CQB areay false if it doesn't matters.
//_hostageRescue = Boolean, true - catch him alive, False - kill him
// Return - nothing
//===============================================================================================================================================================
#define	MCC_UNTIE_ICON "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa"

private ["_objPos","_isCQB","_hostageRescue","_buildingPos","_spawnPos","_unitsArray","_faction","_type","_group","_side","_unit","_building","_unitPlaced","_time","_array","_sidePlayer","_factionPlayer","_walking","_preciseMarkers","_selectedBuilding","_fnc_findHVTClass"];

_objPos = _this select 0;
_isCQB = _this select 1;
_hostageRescue = _this select 2;
_side = _this select 3;
_faction = _this select 4;
_sidePlayer = _this select 5;
_factionPlayer = _this select 6;
_preciseMarkers = _this select 7;

MCC_MWcreateHostage =
{
	private ["_side","_spawnPos","_group","_unit","_type","_init","_rank"];
	_side = _this select 0;
	_spawnPos = _this select 1;
	_type = _this select 2;

	_group = creategroup _side;
	_rank = ["PRIVATE","CORPORAL","SERGEANT","LIEUTENANT"] select (floor random 3);
	_unit = _group createUnit [_type, _spawnPos,[],0.5,"NONE"];
	waituntil {alive _unit};
	_unit setrank _rank;
	MCC_tempName = format ["MCC_objectUnits_%1", ["MCC_objectUnitsCounter",1] call bis_fnc_counter];

	//Spawn Hostage
	_null = _unit execVM format ["%1mcc\general_scripts\hostages\create_hostage.sqf", MCC_path];
	_unit setvariable ["vehicleinit",(_unit getvariable ["vehicleinit",""]) + format ["_this execVM ""%1mcc\general_scripts\hostages\create_hostage.sqf"";", MCC_path]];
	{_x addCuratorEditableObjects [[_unit],false]} forEach allCurators;
	_unit;
};

_fnc_findHVTClass = {
	params ["_faction","_side","_random"];

	private ["_unitsArray","_HVTClasses","_hvtClass"];

	_hvtClass = "";

	//Random unit or from MCC_MWHVT variable
	if (_random) then {
		_unitsArray	= [_faction ,"soldier"] call MCC_fnc_makeUnitsArray;
		while {_hvtClass == ""} do {_hvtClass = (_unitsArray call BIS_fnc_selectRandom) select 0};

	} else {
		_HVTClasses = missionNamespace getVariable ["MCC_MWHVT",["B_officer_F","O_officer_F","I_officer_F","C_Nikos"]];

		//Find the right side HVT
		{
			if (([(getNumber(configFile >> "cfgVehicles" >> _x >> "side"))] call BIS_fnc_sideType) == _side) exitWith {
				_hvtClass = _x;
			};
		} forEach _HVTClasses;

		//Can't find - select random
		if (_hvtClass == "") then {
			_unitsArray	= [_faction ,"soldier"] call MCC_fnc_makeUnitsArray;
			while {_hvtClass == ""} do {_hvtClass = (_unitsArray call BIS_fnc_selectRandom) select 0};
		};
	};

	_hvtClass
};

if (_isCQB) then {

	_selectedBuilding = ([_objPos, 100] call MCC_fnc_MWFindbuildingPos) call BIS_fnc_selectRandom;
	_building = _selectedBuilding select 0;
	_buildingPos = _selectedBuilding select 1;
 	if (isnil "_buildingPos") exitWith {debuglog "MCC MW - MWObjectiveHVT - No building pos foudn"};

	_unitPlaced = false;
	_time = time;

	 while {!_unitPlaced && (time <= (_time + 5))} do {
		_spawnPos	= _building buildingPos (floor random _buildingPos);

		//No other unit in the spawn position?
		if (count (nearestObjects [_spawnPos, ["Man"], 1])<1) then {
			if (_hostageRescue) then {

				//find Hostage class
				_type = [_factionPlayer, _sidePlayer, false] call _fnc_findHVTClass;

				_unit = [_sidePlayer,_spawnPos,_type] call MCC_MWcreateHostage;
				waituntil {alive _unit};

				[_unit, getpos _unit,"Secure_HVT",_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;

			} else {

				//find HVT class
				_type = [_faction, _side, false] call _fnc_findHVTClass;
				_unit = [_spawnPos, _type, _sidePlayer,"Armed Civilian",random 360,true] call MCC_fnc_ACSingle;
				waituntil {alive _unit};

				[_unit, getpos _unit,"Kill_HVT",_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;
			};

			_unitPlaced = true;

			//Lets spawn some body guards
			[[getpos _unit,30,0,2,_faction, _side],"MCC_fnc_garrison",false,false] spawn BIS_fnc_MP;
		};
	};
} else {

	//Clear area
	[_objPos,50,true] call MCC_fnc_hideTerrainObjectsArea;

	//Open area
	_objPos = [_objPos] call MCC_fnc_buildRandomComposition;
	[_objPos,30,0,4,_faction, _side] remoteExec ["MCC_fnc_garrison",2];

	_group = creategroup _side;

	if (_hostageRescue) then {
		//find Hostage class
		_type = [_factionPlayer, _sidePlayer, false] call _fnc_findHVTClass;

		//Find an empry spot
		_spawnPos = _objPos findEmptyPosition [0,100,_type];
		_unit = [_sidePlayer,_spawnPos,_type] call MCC_MWcreateHostage;

		//Start Briefings
		waituntil {alive _unit};

		[_unit, getpos _unit,"Secure_HVT",_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;
		//Static Patrol
		_walking = false;

	} else {

		//find HVT class
		_type = [_faction, _side, false] call _fnc_findHVTClass;

		//Find an empry spot
		_spawnPos = _objPos findEmptyPosition [0,100,_type];

		//walking HVT?
		_walking = if (random 1 < 0.5) then {true} else {false};

		if (_walking) then {
			_unit = _group createUnit [_type ,_spawnPos,[],0.5,"NONE"];
			waituntil {alive _unit};

			//Add to zeus
			{[[_x,_unit],{(_this select 0) addCuratorEditableObjects [[_this select 1],true];}] remoteExec ["BIS_fnc_spawn",_x]} forEach allCurators;

			MCC_tempName = format ["MCC_objectUnits_%1", ["MCC_objectUnitsCounter",1] call bis_fnc_counter];
			_init = FORMAT [";%1 = _this;",MCC_tempName];

			[[[netid _unit,_unit], _init], "MCC_fnc_setVehicleInit", true, true] spawn BIS_fnc_MP;

		} else {
			_unit = [_spawnPos, _type, _sidePlayer,"Armed Civilian",random 360,true] call MCC_fnc_ACSingle;
		};

		[_unit, getpos _unit,"Kill_HVT",_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;
	};

	//Lets spawn some body guards
	_unitsArray 	= [_faction ,"soldier"] call MCC_fnc_makeUnitsArray;
	private _guardsNumber = floor random 5;

	for [{_i=0},{_i< _guardsNumber},{_i=_i+1}] do {

		_type = _unitsArray select floor (random 4);
		_spawnPos = (getpos _unit) findEmptyPosition [0,100,(_type select 0)];
		_unit = _group createUnit [_type select 0,_spawnPos,[],0.5,"NONE"];
		waituntil {alive _unit};

		//Add to zeus
		{[[_x,_unit],{(_this select 0) addCuratorEditableObjects [[_this select 1],true];}] remoteExec ["BIS_fnc_spawn",_x]} forEach allCurators;
	};

	_group setFormDir (round(random 360));

	if (_walking) then {
		[_group, _spawnPos, 150] call BIS_fnc_taskPatrol;
	} else {
		[_group, _spawnPos] call bis_fnc_taskDefend;
	};
};