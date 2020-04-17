/*=================================================================MCC_fnc_aas_AIspawn=============================================================================
/*
			Spawns AI in AAS mission in start location and captured zones

			_this select 0 -  _faction			- STRING - faction's name as defined in cfgFaction
			_this select 1 -  _enemySide 		- SIDE - enemy side to handle
			_this select 2 -  _autoBalance		- BOOLEAN - auto balance the number of AI to the numbers of players
			_this select 3 -  _minPerSide		- INTEGER - minimun number of AI no matter how many players
			_this select 4 -  _spawnInDefensive	- BOOLEAN - spawn infantry on defence zones
			_this select 5 -  _searchRadius		- INTEGER - how far should look for empty vehicles around the module location for empty vehicles
			_this select 6 -  _useDefaultGear	- Array - define the roles to spawn and propobility leave empty for non [["rifleman","ar","at","corpsman","marksman","officer"],[0.5,0.1,0.1,0.1,0.1,0.1]] from the RS cfg files.
			_this select 7 -  _startPos			- ARRAY - position of the defualt start location
			_this select 8 -  _spawnVehicles	- BOOLEAN - if true will spawn empty vehicle similar to the enemy vheicles
*/

private ["_sectors","_autoBalance","_minPerSide","_spawnInDefensive","_AIUnits","_enemyNumber","_startPos","_sideNumber","_counter","_unitsArray","_spawnPos","_numberOfGroups","_groupArray","_group","_enemySide","_side","_maxUnits","_defendZonesPos","_areas","_faction","_nearVehicles","_searchRadius","_vehicleClass","_simType","_wepArray","_useDefaultGear","_unitNumber","_groupSize","_tempGroup","_vehicleGear","_i","_enemyVehiclesSims","_spawnVehicles","_friendlyVehiclesSims","_vehiclesToSpawn","_vehiclesArray"];

//Module or function call
if (typeName (_this select 0) != typeName objNull) then {

	if (isServer) then {
		_faction =  param [0, "BLU_F"];
		_side = [(getNumber (configfile >> "CfgFactionClasses" >> _faction >> "side"))] call BIS_fnc_sideType;
		_enemySide = param [1, east];
		_autoBalance = param [2, true];
		_minPerSide = param [3, 20];
		_spawnInDefensive = param [4, true];
		_searchRadius = param [5, 200];
		_useDefaultGear = param [6, []];
		_startPos = param [7, [0,0,0]];
		_spawnVehicles = param [8, true,[true]];
	};
} else {
    _module = param [0, objNull, [objNull]];
    if (isNull _module)  exitWith {diag_log "MCC MCC_fnc_aas_AIspawn: No module found"};

    //Curator
    if ((_module isKindOf "MCC_module_AASSpawnAI") && !(isnull curatorcamera) && (local _module)) then {
    	private ["_factionArray","_resualt"];

    	_factionArray = [];
		{
			_factionArray pushBack (format ["%1 (%2)",(_x select 0), (_x select 1)]);
		} forEach U_FACTIONS;

    	_resualt = [localize "STR_Module__AASSpawnAI_displayName",[
    			[localize "STR_Module__AASSpawnAI_faction1_displayName",_factionArray,"Faction units will spawn next to the module location"],
				[localize "STR_Module__AASSpawnAI_enemySide_displayName",["East","West","Resistance"],"The selected faction will try to capture points from this side"],
				[localize "STR_Module__AASSpawnAI_searchRadius_displayName",500,"How far AI will look for empty vehicles around spawn point"],
				[localize "STR_Module__AASSpawnAI_minAI_displayName",50,"Minimun number of AI for the selected faction on every given moment"],
				[localize "STR_Module__AASSpawnAI_autoBalance_description",true,"Auto balance the number of AI to meet the rival factions"],
				[localize "STR_Module__AASSpawnAI_spawnAIDefensive_displayName",true,"Spawn AI in captured points own by the faction"],
				[localize "STR_Module__AASSpawnAI_useRoles_displayName",true,"Use defined roles from the MCC roles selection system"],
				[localize "STR_Module__AASSpawnAI_spawnVehicles_displayName",true,"Automatically spawn vehicles to match the number and the strength of the opposite side"]
			  ],format ["<t align='center'> %1</t>",localize "STR_Module__AASSpawnAI_ModuleDescription_description"]] call MCC_fnc_initDynamicDialog;

		if (count _resualt == 0) then {deleteVehicle _module} exitWith {
			_faction = ((U_FACTIONS select (_resualt select 0)) select 2);
			_side = [(getNumber (configfile >> "CfgFactionClasses" >> _faction >> "side"))] call BIS_fnc_sideType;
			_enemySide = [(_resualt select 1)] call BIS_fnc_sideType;
			_searchRadius = (_resualt select 2);
			_minPerSide = (_resualt select 3);
			_autoBalance = (_resualt select 4);
			_spawnInDefensive = (_resualt select 5);
			_useDefaultGear = if (_resualt select 6) then {["at","ar","corpsman","rifleman"]} else {[]};
			_spawnVehicles = (_resualt select 7);
			_startPos = getpos _module;

			[_faction, _enemySide, _autoBalance, _minPerSide, _spawnInDefensive, _searchRadius, _useDefaultGear, _startPos, _spawnVehicles] remoteExec ["MCC_fnc_aas_AIspawn", 2];
			_faction = nil;
		};

	} else {
		//3den
		_faction =  _module getVariable ["faction1",""];
		_side = [(getNumber (configfile >> "CfgFactionClasses" >> _faction >> "side"))] call BIS_fnc_sideType;
		_enemySide = [_module getVariable ["enemySide",0]] call BIS_fnc_sideType;
		_autoBalance = _module getVariable ["autoBalance",false];
		_minPerSide = _module getVariable ["minAI",0];
		_spawnInDefensive = _module getVariable ["spawnAIDefensive",true];
		_searchRadius = _module getVariable ["searchRadius",100];
		_useDefaultGear = if (_module getVariable ["useRoles",false]) then {["at","ar","corpsman","rifleman"]} else {[]};
		_startPos = getpos _module;
		_spawnVehicles = _module getVariable ["spawnVehicles",true];
	};

};


_groupSize = 5;

//If not server or already initilize exit
if (isNil "_faction") exitWith {};

private _varName = format ["MCC_fnc_aas_AIspawnActive_%1", _faction];
if (!isServer || (missionNamespace getVariable [_varName,false])) exitWith {systemChat "Faction AAS already initilized"};
missionNamespace setVariable [_varName,true];
publicVariable _varName;

[_side] spawn MCC_fnc_aas_AIControl;

//Spawn AI
_unitsArray 	= [_faction,"soldier","men",false] call MCC_fnc_makeUnitsArray;
if (count _unitsArray < 4) then {
	_unitsArray = [_faction,"soldier","",false] call MCC_fnc_makeUnitsArray;
};

//No units get out
if (count _unitsArray <2) exitWith {diag_log "MCC: MCC_fnc_aas_AIControl _unitsArray < 2"};

_sectors = [];

//Get all sectors
{_sectors pushBack _x} foreach (allMissionObjects "moduleSector_f");
{_sectors pushBack _x} foreach (allMissionObjects "moduleSectorDummy_f");
{
	if (((_x getvariable ["ScoreReward",0]) call bis_fnc_parsenumber)>0) then {_sectors pushBack _x}
} foreach (allMissionObjects "logic");

while {true} do {

	_enemyNumber =  0;
	_sideNumber =  0;

	_enemyNumber = _enemySide countSide allUnits;
	_sideNumber = _side countSide allUnits;

	_maxUnits = if (_autoBalance) then {_enemyNumber max _minPerSide} else {_minPerSide};
	_counter = (_maxUnits - _sideNumber) max 0;

	//Find spawn pos
	_defendZonesPos = [];
	if (_spawnInDefensive) then {

	 	//Get a defend zone that is not contested
		{
			if ((_x getvariable ["owner",sideunknown]) == _side) then {
				_areas = _x getvariable ["areas",[]];
				{
					if (((triggerArea _x) select 0) == 0) then {
			   			_defendZonesPos pushBack position _x;
			   		};
				} forEach _areas;
			};
		} forEach _sectors;

		//did we found any zone?
		_spawnPos = if (count _defendZonesPos > 0) then {_defendZonesPos call bis_fnc_selectRandom} else {_startPos};
	} else {
		_spawnPos = _startPos;
	};

	//Spawn vehicles
	if (_spawnVehicles) then {
		private ["_vehicleClass","_vehicle"];

		//Get how many vehicle class on each side.
		_friendlyVehiclesSims = [];
		_enemyVehiclesSims = [];
		{
			if (vehicle _x != _x &&
			    driver vehicle _x == _x) then {

				if (side _x == _enemySide) then {
					_enemyVehiclesSims pushBack (getText(configFile >> "CfgVehicles">> typeof vehicle _x >> "simulation"));
				};

				if (side _x == _side) then {
					_friendlyVehiclesSims pushBack (getText(configFile >> "CfgVehicles">> typeof vehicle _x >> "simulation"));
				};
			};
		} forEach allUnits;

		//Find only deltas between
		_vehiclesToSpawn = [];
		{
			_vehicleClass = _x;
			if ({_x == _vehicleClass} count _friendlyVehiclesSims <= 0) then {_vehiclesToSpawn pushBack _vehicleClass};
		} forEach _enemyVehiclesSims;

		//Spawn vehicles
		{
			_vehiclesArray	= [_faction,_x] call MCC_fnc_makeUnitsArray;
			if (count _vehiclesArray > 0) then {
				_vehicle = ((_vehiclesArray call bis_fnc_selectRandom) select 0) createVehicle _startPos;

				//workaround to delete turrets that somehow simulate as tanks WTF?!
				if (!(_vehicle isKindOf "StaticWeapon") && canMove _vehicle) then {
					_vehicleGear = if (_vehicle isKindOf "air") then {[["pilot"],[1]]} else {[["crew"],[1]]};
					_group = [_groupSize,_groupSize,_vehicleGear,_vehicle,_side,_unitsArray,_spawnPos] call MCC_fnc_AASgroupSpawn;
					_counter =( _counter - count crew _vehicle) max 0;
					_vehicle lock true;
				} else {
					deleteVehicle _vehicle;
					_counter = (_counter - 4) max 0;
				};
			};
		} forEach _vehiclesToSpawn;
	};

	//Find nearest vehicles
	_nearVehicles = nearestObjects [_startPos, ["Motorcycle","Car","Tank"], _searchRadius];  //"Helicopter"


	{
		_vehicleClass = tolower (gettext (configFile >> "CfgVehicles" >> typeof _x >> "vehicleClass"));
		_simType = tolower (getText  (configFile >> "CfgVehicles" >> typeof _x >> "simulation"));
		_wepArray = (getArray  (configFile >> "CfgVehicles" >> typeof _x >> "weapons"));

		//Spawn crew
		if (_counter > _groupSize &&
			(count ((typeof _x) call GAIA_fnc_getTurretWeapons)>0 || count _wepArray > 1)
			) then {
				_vehicleGear = if (_x isKindOf "air") then {[["pilot"],[1]]} else {[["crew"],[1]]};
				_group = [_groupSize,_groupSize,_vehicleGear,_x,_side,_unitsArray,_spawnPos] call MCC_fnc_AASgroupSpawn;
				_counter =( _counter - count crew _x) max 0;
		};

	} forEach _nearVehicles;

	//Spawn AI
	_numberOfGroups = (_counter / _groupSize);

	if (_numberOfGroups > 0) then {
		for [{_i=1},{_i<=_numberOfGroups},{_i=_i+1}] do {

			_group = [_groupSize,_groupSize,_useDefaultGear,objNull,_side,_unitsArray,_spawnPos] call MCC_fnc_AASgroupSpawn;
			sleep 1;
		};


		//spawn the rest as a group - DISABLED WE WANT A FULL SQUAD SPAWN
		if (_counter mod _groupSize > 0) then {
			[_counter mod _groupSize,_groupSize,_useDefaultGear,objNull,_side,_unitsArray,_spawnPos] call MCC_fnc_AASgroupSpawn;
		};
	};

	sleep 10;
};