//=====================================MCC_fnc_MWObjectiveHVT=========================================================================================================
// Create an HVT objective
// Example:[_objPos,_isCQB,_alive] call MCC_fnc_MWObjectiveHVT;
// _objPos = position, objectice position
//_isCQB = Boolean, true - for CQB areay false if it doesn't matters.
//_alive = Boolean, true - catch him alive, False - kill him
// Return - nothing
//===============================================================================================================================================================
#define	MCC_UNTIE_ICON "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa"
#define MCC_MWSITES [["Guerrilla","Camps","CampA"],["Guerrilla","Camps","CampB"],["Guerrilla","Camps","CampC"],["Guerrilla","Camps","CampD"],["Guerrilla","Camps","CampE"],["Guerrilla","Camps","CampF"],["Military","Outposts","OutpostA"],["Military","Outposts","OutpostB"],["Military","Outposts","OutpostC"],["Military","Outposts","OutpostD"],["Military","Outposts","OutpostE"],["Military","Outposts","OutpostF"],["MCC_comps","civilians","slums"],["MCC_comps","Guerrilla","campSite"]]

private ["_objPos","_isCQB","_alive","_buildingPos","_spawnPos","_unitsArray","_faction","_type","_group","_side","_unit","_building","_unitPlaced","_time","_array","_sidePlayer","_factionPlayer","_walking","_preciseMarkers","_HVTClasses","_selectedBuilding"];

_objPos = _this select 0;
_isCQB = _this select 1;
_alive = _this select 2;
_side = _this select 3;
_faction = _this select 4;
_sidePlayer = _this select 5;
_factionPlayer = _this select 6;
_preciseMarkers = _this select 7;

_HVTClasses = missionNamespace getVariable ["MCC_MWHVT",["B_officer_F","O_officer_F","I_officer_F","C_Nikos"]];

MCC_MWcreateHostage =
{
	private ["_side","_spawnPos","_group","_unit","_type","_init","_rank"];
	_side = _this select 0;
	_spawnPos = _this select 1;
	_type = _this select 2;

	_group = creategroup _side;
	_rank = ["PRIVATE","CORPORAL","SERGEANT","LIEUTENANT"] select (floor random 3);
	_unit = _group createUnit [_type select 0,_spawnPos,[],0.5,"NONE"];
	waituntil {alive _unit};
	_unit setrank _rank;
	MCC_tempName = format ["MCC_objectUnits_%1", ["MCC_objectUnitsCounter",1] call bis_fnc_counter];

	//Spawn Hostage
	_null = _unit execVM format ["%1mcc\general_scripts\hostages\create_hostage.sqf", MCC_path];
	_unit setvariable ["vehicleinit",(_unit getvariable ["vehicleinit",""]) + format ["_this execVM ""%1mcc\general_scripts\hostages\create_hostage.sqf"";", MCC_path]];
	{_x addCuratorEditableObjects [[_unit],false]} forEach allCurators;
	_unit;
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
			if (_alive) then {

				//Hostage
				_unitsArray	= [_factionPlayer ,"soldier"] call MCC_fnc_makeUnitsArray;		//Let's build the faction unit's array
				_type = [""];

				//Karts again?!
				while {(_type select 0) in ["C_Driver_1_F"] || (_type select 0) == ""} do
				{
					_type = _unitsArray call BIS_fnc_selectRandom;
				};

				_unit = [_sidePlayer,_spawnPos,_type] call MCC_MWcreateHostage;
				waituntil {alive _unit};

				[_unit,"Secure_HVT",_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;

			} else {

				//HVT
				switch _side do
					{
						case west: {_type =   _HVTClasses select 0};
						case east: {_type =   _HVTClasses select 1};
						case resistance:  {_type =   _HVTClasses select 2};
						default {_type =   _HVTClasses select 3};
					};
				_unit = [_spawnPos, _type, _sidePlayer,"Armed Civilian",random 360,true] call MCC_fnc_ACSingle;
				waituntil {alive _unit};

				[_unit,"Kill_HVT",_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;
			};

			_unitPlaced = true;

			//Lets spawn some body guards
			[[getpos _unit,30,0,2,_faction, _side],"MCC_fnc_garrison",false,false] spawn BIS_fnc_MP;
		};
	};
} else {
	//Open area
	[_objPos, random 360, (MCC_MWSITES call BIS_fnc_selectRandom)] call MCC_fnc_compositionsPlace;
	[_objPos,30,0,4,_faction, _side] remoteExec ["MCC_fnc_garrison",2];

	_group = creategroup _side;

	if (_alive) then {
		//Hostage

		//Let's build the faction unit's array
		_unitsArray	= [_factionPlayer ,"soldier"] call MCC_fnc_makeUnitsArray;
		_type = _unitsArray call BIS_fnc_selectRandom;

		//Find an empry spot
		_spawnPos = _objPos findEmptyPosition [0,100,(_type select 0)];
		_unit = [_sidePlayer,_spawnPos,_type] call MCC_MWcreateHostage;

		//Start Briefings
		waituntil {alive _unit};

		[_unit,"Secure_HVT",_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;
		//Static Patrol
		_walking = false;

	} else {

		//HVT
		switch _side do
			{
				case west: {_type =   _HVTClasses select 0};
				case east: {_type =   _HVTClasses select 1};
				case resistance:  {_type =   _HVTClasses select 2};
				default {_type =   _HVTClasses select 3};
			};

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

		[_unit,"Kill_HVT",_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;
	};

	//Lets spawn some body guards
	_unitsArray 	= [_faction ,"soldier"] call MCC_fnc_makeUnitsArray;

	for [{_i=0},{_i<3},{_i=_i+1}] do {

		_type = _unitsArray select round (random 4);
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