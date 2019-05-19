/*======================================================MCC_fnc_MWObjectiveIntel==========================================================================================Create a pick intel objective
// Example:[_objPos,_isCQB,_side,_faction] call MCC_fnc_MWObjectiveIntel;
// _objPos = position, objectice position
//_isCQB = Boolean, true - for CQB areay false if it doesn't matters.
//_side = enemy side
//_faction = enemy Faction
// Return - nothing
//===============================================================================================================================================================*/
private ["_objPos","_isCQB","_side","_faction","_preciseMarkers","_objType","_spawnPos","_time","_sidePlayer","_object","_dummyObject","_spawndir","_unitsArray","_group","_init","_range","_selectedBuilding","_building","_buildingPos","_isDownloadIntel","_taskType","_foundBuilding"];

_objPos = _this select 0;
_isCQB = _this select 1;
_side = _this select 2;
_faction = _this select 3;
_preciseMarkers = _this select 4;
_sidePlayer =  param [5, west,[sideLogic,""]];
_isDownloadIntel = param [6,false,[false]];
_taskType = if (_isDownloadIntel) then {"downloadIntel"} else {"pick_intel"};
_foundBuilding = false;

_objType = if (_isDownloadIntel) then {"Land_DataTerminal_01_F"} else {
	 (missionNamespace getVariable ["MCC_MWIntelObjects",["Land_File2_F","Land_FilePhotos_F","Land_Laptop_unfolded_F","Land_SatellitePhone_F","Land_Suitcase_F"]]) call BIS_fnc_selectRandom
};


//If not CQB spawn some POI
if !(_isCQB) then {

	//Clear area
	[_objPos,50,true] call MCC_fnc_hideTerrainObjectsArea;

	_objPos = [_objPos] call MCC_fnc_buildRandomComposition;
};

//Lets spawn some body guards
_range = if (_isCQB) then {30} else {60};
[_objPos,_range,0,4,_faction, _side] remoteExec ["MCC_fnc_garrison",2];

//Lets find out if we have a building close by
_selectedBuilding = ([_objPos, 100] call MCC_fnc_MWFindbuildingPos) call BIS_fnc_selectRandom;
_building = _selectedBuilding select 0;
_buildingPos = _selectedBuilding select 1;

_spawnPos = _objPos;

if (!(isnil "_buildingPos") &&
    (_isCQB || (! _isCQB && (_building distance2D _objPos) <= 50))
    ) then {

	_time = time;
	_spawnPos	= _building buildingPos (floor random _buildingPos);

	//No other unit in the spawn position?
	while {((count (nearestObjects [_spawnPos, ["Man"], 1])) > 0)} do {
		_spawnPos	= _building buildingPos (floor random _buildingPos);
		sleep 0.1;
	};

	_foundBuilding = true;
};


if (_isDownloadIntel) then {
	_object = _objType createvehicle _spawnPos;
	if !(_foundBuilding) then {
		_spawnPos = _spawnPos findEmptyPosition [2,40,_objType];
	};

	_object setPos _spawnPos;
	_object setVariable ["MCC_intelItem",true,true];

} else {
	//Spawn the intel
	_dummyObject = "Land_WoodenTable_small_F" createvehicle _spawnPos;
	_dummyObject enablesimulation false;

	{_x addCuratorEditableObjects [[_dummyObject],false]} forEach allCurators;

	if !(_foundBuilding) then {
		_spawnPos = _spawnPos findEmptyPosition [2,40,"Land_WoodenTable_small_F"];
	};

	_dummyObject setPos _spawnPos;

	_object = _objType createvehicle _spawnPos;
	_object setPos (_dummyObject modelToWorld [0,0,0.43]);
	_object setdir (getdir _dummyObject);
	_object enablesimulation false;
};

//Pick Item
_init = '_this call MCC_fnc_pickItem';
[[netID _object,_object], _init] remoteExec ["MCC_fnc_setVehicleInit",0];

{_x addCuratorEditableObjects [[_object],false]} forEach allCurators;

//Start Briefings
[_object, getpos _object,_taskType,_preciseMarkers,_side,400,_sidePlayer] call MCC_fnc_MWCreateTask;






