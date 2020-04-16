/*======================================================MCC_fnc_MWinitMission=============================================================================================
//Init generated mission - SERVER ONLY
//Example: [
//			[_wholeMap, _totalEnemyUnits,  _minObjectivesDistance, _maxObjectivesDistance, _weatherChange, _preciseMarkers, _playMusic],
//			[_enemySide, _enemyfaction, _sidePlayer, _factionPlayer, _civFaction],
//			[_obj1, _obj2, _obj3],
//			[_isCQB, _isCiv, _armor, _vehicles, _stealth, _isIED, _isAS, _isSB, _isRoadblocks, _animals],
//			[_reinforcement, _artillery]
//		] call MCC_fnc_MWinitMission;
//
//**********************************************************************************************************************
//				Array 0 - General
//	_wholeMap				Boolean, true - search the entire map for a spot, False- search inside the zone only
//	_totalEnemyUnits:			Integer, tottal enemy units
//	_minObjectivesDistance		Integer, minimum distance from objectives
//	_maxObjectivesDistance		Integer, maximum distance from objectives
//	_weatherChange			Boolean, change weather and time of day yes or no
//	_preciseMarkers			Boolean, precise markers yes or no
//	_playMusic				INTEGER, 0 - Play cinematic
//									 1 - Intro Only
//									 2 - None
//
//				Array 1 - Sides
//	_enemySide				Side, what side are we fighting
//	_enemyfaction				String, faction we are fighting
//	_sidePlayer				Side, the defending side
//	_factionPlayer				String, the defending faction
//	_civFaction				String, civilians faction
//
//				Array 2 - Objectives
//	_obj1						String, an objective defined in _objArray or "None" or "Random"
//	_obj2						String, an objective defined in _objArray or "None" or "Random"
//	_obj3						String, an objective defined in _objArray or "None" or "Random"
//
//				Array 3 - Missions' Defines
//	_isCQB:					Boolean, true - isCQB false- isn't CQB
//	_isCiv					Boolean, Civilians yes or no
//	_armor					Boolaen, will be armored units in the mission
//	_vehicles					Boolaen, will be vehicles in the mission
//	_stealth					Boolaen, stealth yes or no
//	_isIED					Boolean, IED yes or no
//	_isAS					Boolean, Armed civilians yes or no
//	_isSB					Boolean, Suicide Bombers yes or no
//	_isRoadblocks				Boolean, RoadBlocks yes or no
//	_animals					Boolean, animals yes or no
//
//				Array 4 - Missions' Assets
//	_reinforcement			Integer, reinforcement 0 - no;	1- Aerial;	2 - Motorized;	3 - Random;
//	_artillery					Integer, reinforcement 0 - no;	1- mortars;	2 - self propeled;	3 - Random;
//================================================================================================================================================================*/
#define	MWinitMissionMusic	["LeadTrack01a_F","LeadTrack02_F","LeadTrack03_F","LeadTrack04a_F","LeadTrack05_F","LeadTrack06_F","AmbientTrack03_F","BackgroundTrack03_F","BackgroundTrack01_F","BackgroundTrack01a_F","BackgroundTrack02_F","LeadTrack01_F_EPA","LeadTrack02_F_EPA","EventTrack01_F_EPA","EventTrack01a_F_EPA","EventTrack03_F_EPA"]

private ["_missionCenter","_missionCenterTrigger","_totalEnemyUnits","_isCQB","_objType","_objArray","_minObjectivesDistance","_maxObjectivesDistance","_objPos","_timeStart","_enemySide","_enemyfaction","_sidePlayer","_factionPlayer","_obj1","_obj2","_obj3","_pos","_center","_wholeMap","_armor","_vehicles","_stealth","_roadPositions","_script_handler","_isIED","_isAS","_isSB","_spawnbehavior","_isRoadblocks","_objectives","_isCiv","_weatherChange","_preciseMarkers","_reinforcement","_artillery","_civFaction","_playMusic","_animals","_markerName","_missionMaker","_campaignMission","_markers"];

private ["_arrayGeneral","_arraySides","_arrayObjectives","_arrayDefines","_arrayAssets"];
_arrayGeneral		= _this select 0;
_wholeMap 				= _arrayGeneral select 0;
_totalEnemyUnits 		= _arrayGeneral select 1;
_minObjectivesDistance 	= _arrayGeneral select 2;
_maxObjectivesDistance	= _arrayGeneral select 3;
_weatherChange 			= _arrayGeneral select 4;
_preciseMarkers 		= _arrayGeneral select 5;
_playMusic 				= _arrayGeneral select 6;
_markers 				= _arrayGeneral param [7,true,[true]];

_arraySides			= _this select 1;
_enemySide 				= _arraySides select 0;
_enemyfaction 			= _arraySides select 1;
_sidePlayer 			= _arraySides select 2;
_factionPlayer 			= _arraySides select 3;
_civFaction 			= _arraySides select 4;

_arrayObjectives	= _this select 2;
_obj1 					= _arrayObjectives select 0;
_obj2 					= _arrayObjectives select 1;
_obj3 					= _arrayObjectives select 2;

_arrayDefines		= _this select 3;
_isCQB 					= _arrayDefines select 0;
_isCiv 					= _arrayDefines select 1;
_armor 					= _arrayDefines select 2;
_vehicles 				= _arrayDefines select 3;
_stealth 				= _arrayDefines select 4;
_isIED 					= _arrayDefines select 5;
_isAS 					= _arrayDefines select 6;
_isSB 					= _arrayDefines select 7;
_isRoadblocks 			= _arrayDefines select 8;
_animals 				= _arrayDefines select 9;

_arrayAssets		= _this select 4;
_reinforcement 			= _arrayAssets select 0;
_artillery 				= _arrayAssets select 1;

_objArray			 	= missionNamespace getVariable ["MCC_MWMissionType",["Secure HVT",
																			   "Kill HVT",
																			   "Destroy Vehicle",
																			   "Destroy AA",
																			   "Destroy Artillery",
																			   "Destroy Weapon Cahce",
																			   "Destroy Fuel Depot",
																			   "Destroy Radar/Radio",
																			   "Acquire Intel",
																			   "Download Intel",
																			   "Capture Area",
																			   "Disarm IED",
																			   "Logistics"
																			  ]];

//Remove random and none
{
	_objArray = _objArray - [_x];
} forEach ["None","Random"];

//Lets find the mission maker owner and make sure he'll get the zone markers too.
private ["_missionMaker"];
{
	if (name _x == mcc_missionmaker) exitWith {_missionMaker = owner _x};
} foreach playableUnits;

if (!isnil "_missionMaker") then {
	[] remoteExec ["MCC_fnc_createMCCZones",_missionMaker]
};

MCC_MWCleanup =
{
	params [
		["_markers",[],[[]]]
	];
	//Clear up
	MCC_MWisGenerating = false;
	publicVariable "MCC_MWisGenerating";

	if (!isnil "MCC_worldArea") then {deleteVehicle MCC_worldArea;	MCC_worldArea = nil};
	if (!isnil "MWMissionArea") then {deleteVehicle MWMissionArea;	MWMissionArea = nil};

	//Delete all markers
	{deleteMarker _x} forEach _markers;

	breakout "#all";
};


//For handling spawn
//-------------- Whole map or zone locations?
if (typeName _wholeMap == typeName true ) then {
	_campaignMission = false;
	if (_wholeMap) then	{
		//--------------------------------------------------------------Create a ceneter trigger --------------------------------------------------------------------------
		private ["_worldPath","_mapSize","_mapCenter"];

		if (isnil "MCC_worldArea") then {
			_worldPath = configfile >> "cfgworlds" >> worldname;
			_mapSize = getnumber (_worldPath >> "mapSize");
			if (_mapSize == 0) exitWith {
				diag_log FORMAT ["MCC: Mission Wizard Error: mapSize param not defined for '%1'",worldname];
				[["mapSize param not defined for '%1'",worldname],"bis_fnc_halt",MCC_fnc_halt, false] call BIS_fnc_MP;
				[[_markerName]] call MCC_MWCleanup;
			};

			_mapSize = _mapSize / 2;

			_mapCenter = [
				_mapSize,
				_mapSize
			];

			MCC_worldArea = createtrigger ["emptydetector",_mapCenter];
			MCC_worldArea settriggerarea [_mapSize,_mapSize,0,true];
		};
		MWMissionArea = MCC_worldArea;

		//First time? Let's map the island
		if (isnil "MCC_MWcityLocations") then {
			MCC_MWcityLocations     = [getpos MWMissionArea,15000,"city"] call MCC_fnc_MWbuildLocations;
			MCC_MWmilitaryLocations = [getpos MWMissionArea,15000,"mil"] call MCC_fnc_MWbuildLocations;
			MCC_MWhillsLocations 	= [getpos MWMissionArea,15000,"hill"] call MCC_fnc_MWbuildLocations;
			MCC_MWnatureLocations 	= [getpos MWMissionArea,15000,"nature"] call MCC_fnc_MWbuildLocations;
			MCC_MWmarineLocations	= [getpos MWMissionArea,15000,"marine"] call MCC_fnc_MWbuildLocations;
		};

		//Find out if the map have locations in it.
		MCC_MWBasedLocations = if ((count MCC_MWcityLocations)>2) then {true} else {false};

		//Find mission center
		_center = [getpos MWMissionArea,2000,_isCQB,MCC_MWBasedLocations] call MCC_fnc_MWFindMissionCenter;

		_missionCenter = (_center select 0);
		if (isNil "_missionCenter") exitWith {
			diag_log "MCC: Mission Wizard Error: Can't find mission center";
			["MCC: Mission Wizard Error: Can't find mission center try building your mission in a zone"] remoteExec ["MCC_fnc_halt",_missionMaker];
			[[_markerName]] call MCC_MWCleanup;
		};
	} else {
		//--------------------------------------------------------------Create a ceneter trigger --------------------------------------------------------------------------
		if (count mcc_zone_markposition == 0) exitWith {
			diag_log "MCC: Mission Wizard Error: Create a zone first";
			[["MCC: Mission Wizard Error: Create a zone first"],"MCC_fnc_halt",_missionMaker, false] call BIS_fnc_MP;
			[[_markerName]] call MCC_MWCleanup;
		};

		MWMissionArea = createtrigger ["emptydetector",mcc_zone_markposition];
		MWMissionArea settriggerarea [mcc_zone_marker_X,mcc_zone_marker_Y,0,true];
		MCC_worldArea = MWMissionArea;

		private ["_markerPos","_radius"];
		_radius = (mcc_zone_marker_X + mcc_zone_marker_Y)/2;
		_markerPos = getpos MWMissionArea;

		//Let's map the area
		MCC_MWcityLocations     = [_markerPos,_radius,"city"] call MCC_fnc_MWbuildLocations;
		MCC_MWmilitaryLocations = [_markerPos,_radius,"mil"] call MCC_fnc_MWbuildLocations;
		MCC_MWhillsLocations 	= [_markerPos,_radius,"hill"] call MCC_fnc_MWbuildLocations;
		MCC_MWnatureLocations 	= [_markerPos,_radius,"nature"] call MCC_fnc_MWbuildLocations;
		MCC_MWmarineLocations	= [_markerPos,_radius,"marine"] call MCC_fnc_MWbuildLocations;

		//Find out if the map have locations in it.
		MCC_MWBasedLocations = if (_isCQB) then {
									if ((count MCC_MWcityLocations)>1 || (count MCC_MWmilitaryLocations)>1) then {true} else {false};
								} else {
									if ((count MCC_MWhillsLocations)>1 || (count MCC_MWnatureLocations)>1) then {true} else {false};
								};

		//Find mission center
		_center = [getpos MWMissionArea,_radius,_isCQB,MCC_MWBasedLocations] call MCC_fnc_MWFindMissionCenter;

		//If we stray too far from the center cancel the mission
		_missionCenter = (_center select 0);

		if (isNil "_missionCenter") exitWith {
			diag_log "MCC: Mission Wizard Error: Can't find mission center";
			["MCC: Mission Wizard Error: Can't find mission center try building your mission in a zone"] remoteExec ["MCC_fnc_halt",_missionMaker];
			[[_markerName]] call MCC_MWCleanup;
		};

		if (_missionCenter distance2D _markerPos > _radius) exitWith {
			_missionCenter = nil;
			diag_log "MCC: Mission Wizard Error: Can't find mission center";
			["MCC: Mission Wizard Error: Can't find mission center try building your mission in a zone"] remoteExec ["MCC_fnc_halt",_missionMaker];
			[[_markerName]] call MCC_MWCleanup;
		};
	};
} else {
	_center = _wholeMap;
	_missionCenter = _center select 0;
	_campaignMission = true;
};

if (isNil "_missionCenter") exitWith {};

//Init the MW groups configs
[_enemyfaction] call MCC_fnc_createConfigs;

_missionCenterTrigger = createtrigger ["emptydetector",_missionCenter];
_missionCenterTrigger settriggerarea [_maxObjectivesDistance*2.5,_maxObjectivesDistance*2.5,0,false];
MCC_MWmissionsCenter set [count MCC_MWmissionsCenter, _missionCenterTrigger];
publicvariable "MCC_MWmissionsCenter";

diag_log format ["MCC Mission Wizard center = %1", _missionCenter];

//Create the marker
_markerName =  FORMAT ["MCCMW_operationMarker_%1",["MCCMW_operationMarker",1] call bis_fnc_counter];
if (!_campaignMission) then {
	[1, "ColorRed",[_maxObjectivesDistance*3,_maxObjectivesDistance*3], "ELLIPSE", "Border", "Empty",_markerName, _missionCenter] call MCC_fnc_makeMarker;
};

//-------------------------------------Mission Name ------------------------------
private ["_factionName","_music","_missionName1","_missionName2","_html","_html2","_control","_tempText","_missionTittle","_sounds","_plainText"];
_sounds = [];

_missionName1 = [
                  ["Desert",["MWName_desert",0.505]],
				  ["Oversized",["MWName_oversized",0.745]],
				  ["Roguish",["MWName_roguish",0.676]],
				  ["Smouldering",["MWName_smoldering",0.781]],
				  ["Cold",["MWName_cold",0.485]],
				  ["Flaring",["MWName_flaring",0.66]],
				  ["Furious",["MWName_furious",0.644]],
				  ["Silver",["MWName_silver",0.595]],
				  ["Vengeance",["MWName_vengeance",0.685]],
				  ["Yellow",["MWName_yellow",0.534]],
				  ["Red",["MWName_red",0.48]],
				  ["Blue",["MWName_blue",0.525]],
				  ["White",["MWName_white",0.31]],
				  ["Gold",["MWName_gold",0.47]],
				  ["Dark",["MWName_dark",0.425]],
				  ["Broken",["MWName_broken",0.61]],
				  ["Morbid",["MWName_morbid",0.67]],
				  ["Flying",["MWName_flying",0.79]],
				  ["Living",["MWName_living",0.62]],
				  ["Swift",["MWName_swift",0.65]],
				  ["Evil",["MWName_evil",0.54]],
				  ["Fallen",["MWName_fallen",0.724]],
				  ["Solitary",["MWName_solitary",1.05]],
				  ["Alpha",["MWName_alpha",0.56]],
				  ["Bravo",["MWName_bravo",0.55]],
				  ["Charlie",["MWName_charlie",0.695]],
				  ["Delta",["MWName_delta",0.665]],
				  ["Echo",["MWName_echo",0.685]],
				  ["Foxtrot",["MWName_foxtrot",0.93]]
				] call BIS_fnc_selectRandom;

_missionName2 = [
                  ["Storm",["MWName_storm",1.2]],
				  ["Lightning",["MWName_lightning",1.2]],
				  ["Rain",["MWName_rain",1.2]],
				  ["Thunder",["MWName_thunder",1.2]],
				  ["Tornado",["MWName_tornado",1.2]],
				  ["Hurricane",["MWName_hurricane",1.2]],
				  ["Flood",["MWName_flood",1.2]],
				  ["Dragonfly",["MWName_dragonfly",1.2]],
				  ["Ocelot",["MWName_ocelot",1.2]],
				  ["Cobra",["MWName_cobra",1.2]],
				  ["Fiend",["MWName_fiend",1.2]],
				  ["Father",["MWName_father",1.2]],
				  ["Horse",["MWName_horse",1.2]],
				  ["Thorn",["MWName_thorn",1.2]],
				  ["Urgency",["MWName_urgency",1.2]],
				  ["Snake",["MWName_snake",1.2]],
				  ["Serpent",["MWName_serpent",1.2]],
				  ["Famine",["MWName_famine",1.2]],
				  ["Cage",["MWName_cage",1.2]],
				  ["Contempt",["MWName_contempt",1.2]],
				  ["Priest",["MWName_priest",1.2]],
				  ["Stranger",["MWName_stranger",1.2]],
				  ["Dagger",["MWName_dagger",1.2]],
				  ["One",["MWName_one",1.2]],
				  ["Two",["MWName_two",1.2]],
				  ["Three",["MWName_three",1.2]],
				  ["Zero",["MWName_zero",1.2]],
				  ["Arrow",["MWName_arrow",1.2]]
				 ] call BIS_fnc_selectRandom;

_sounds set [count _sounds, ["MWName_operation",0.805]];
_sounds set [count _sounds, _missionName1 select 1];
_sounds set [count _sounds, _missionName2 select 1];

//Create the parent Task
private ["_missionObjective","_taskId","_missionName","_multipleObjectives"];

//More then one objective
_multipleObjectives = {_x != "None" && _x != ""} count [_obj1, _obj2, _obj3] > 1;

//If just one task no need to create parent
if (_multipleObjectives) then {
	_missionName = (_missionName1 select 0) + " " + (_missionName2 select 0);
	_missionObjective = (createGroup sideLogic) createunit ["MCC_ModuleObjective_FCurator", [-2000,-2000,0],[],0.5,"NONE"];
	_missionObjective setVariable ["BIS_fnc_initModules_disableAutoActivation", false,true];
	_taskId = str _missionObjective + str (["MCC_fnc_moduleObjective_id",1] call bis_fnc_counter);
	_missionObjective setvariable ["RscAttributeOwners",[_sidePlayer,_enemySide],true];
	_missionObjective setvariable ["RscAttributeTaskState","created", true];
	_missionObjective setvariable ["taskName",_taskId,true];
	_missionObjective setvariable ["RscAttributeTaskDescription",[_missionName,_missionName,_missionName],true];
	_missionObjective setvariable ["proiority",-1,true];
	_missionObjective setvariable ["notification",false,true];
	_missionObjective setvariable ["show3d",false,true];
	_missionObjective setvariable ["showMarker",[-2000,-2000,0],true];
	_missionObjective setvariable ["taskType","parent",true];
	_missionObjective setvariable ["updated",true,true];
} else {
	_taskId = "";
};
missionNamespace setVariable ["MCC_fnc_MWinitMission_missionName",_taskId];
publicvariable "MCC_fnc_MWinitMission_missionName";


//---------------------------------------------------------------------------Let's build objectives----------------------------------------------------------------------

_objectives = [];

{
	_objType = _x;

	if (_objType != "None") then {

		MCC_MWObjectivesNames = nil;

		//Random Mission
		if (_objType == "Random") then {_objType = _objArray select (floor random count _objArray)};


		_objPos = [];
		_timeStart = time;
		while {(count _objPos == 0) && (time < _timeStart +5)} do {
			_objPos = [_missionCenterTrigger,_isCQB, _minObjectivesDistance, _maxObjectivesDistance] call MCC_fnc_MWfindObjectivePos;
			sleep 0.1;
		};

		//Lets try again
		if (count _objPos == 0) then {
			_isCQB = false;
			_objPos = [_missionCenter,_isCQB,0, _maxObjectivesDistance*3] call MCC_fnc_MWfindObjectivePos;
		};

		if (count _objPos > 0 && ((_objPos distance2D _missionCenter) < (_maxObjectivesDistance*3))) then {

			if (["Destroy", _objType] call BIS_fnc_inString) then {
				[_objPos, _isCQB, _enemySide, _enemyfaction,_preciseMarkers,_objType,_campaignMission,_sidePlayer] remoteExec ["MCC_fnc_MWObjectiveDestroy",2];
			} else {
				switch (true) do {

					case (_objType in ["Secure HVT"]): {

						private ["_defendingFaction","_defendingSide"];
						//Change faction because we are dealing with a hostage and not an enemy
						if ((random 1)>0.5) then {
							_defendingFaction 	= _factionPlayer;
							_defendingSide 		= _sidePlayer;
						} else {
							_defendingFaction = _civFaction;
							_defendingSide = civilian
						};

						//Spawn a hostage on the server
						[_objPos, _isCQB, true, _enemySide, _enemyfaction, _defendingSide, _defendingFaction,_preciseMarkers] remoteExec ["MCC_fnc_MWObjectiveHVT",2];
					};

					case (_objType in ["Kill HVT"]): {
						[_objPos, _isCQB, false, _enemySide, _enemyfaction, _sidePlayer, _factionPlayer,_preciseMarkers] remoteExec ["MCC_fnc_MWObjectiveHVT",2];
					};

					case (_objType in ["Acquire Intel","Download Intel"]): {
						[_objPos, _isCQB, _enemySide, _enemyfaction,_preciseMarkers,_sidePlayer,(_objType isEqualTo "Download Intel")] remoteExec ["MCC_fnc_MWObjectiveIntel",2];

					};

					case (_objType in ["Capture Area"]): {
						[_objPos, _isCQB,_enemySide, _enemyfaction,_sidePlayer,_preciseMarkers,_campaignMission,_maxObjectivesDistance] remoteExec ["MCC_fnc_MWObjectiveClear",2];
					};

					case (_objType in ["Disarm IED"]): {
						[_objPos, _isCQB,_enemySide, _enemyfaction,_sidePlayer,_preciseMarkers] remoteExec ["MCC_fnc_MWObjectiveDisable",2];
					};

					case (_objType in ["Logistics"]): {
						//[_objPos, _isCQB,_enemySide, _enemyfaction,_sidePlayer,_preciseMarkers,_campaignMission,_maxObjectivesDistance] remoteExec ["MCC_fnc_MWObjectiveLogistics",2];

						[_objPos, _isCQB,_enemySide, _enemyfaction, _sidePlayer, _factionPlayer, _civFaction, _preciseMarkers] spawn {
							params ["_objPos", "_isCQB","_enemySide", "_enemyfaction","_sidePlayer","_factionPlayer","_civFaction","_preciseMarkers"];

							private ["_supplyTruck","_startPos","_unit","_supplyTruckClass","_aidSide","_unitsArray","_units","_counter","_group"];

							_objPos set [2,0];

							//Find a supply truck
							_supplyTruckClass = "C_Van_01_box_F";
							/*
							{
								if (((getNumber (configfile >> "CfgVehicles" >> _x >> "side")) call BIS_fnc_sideType) isEqualTo _sidePlayer) exitWith {
									_supplyTruckClass = _x
								};
							} forEach (missionNamespace getVariable ["MCC_supplyTracks",[]]);

							if (isNil "_supplyTruckClass") then {
								_supplyTruckClass = "C_Van_01_box_F";
							};
							*/

							_startPos = [_sidePlayer,_supplyTruckClass] call MCC_fnc_MWGetStartLocation;

							if (count _startPos <= 0) exitWith {
								diag_log "MCC_fnc_MCCMissioWizard: Error Can't find a start location position";
								[[_markerName]] call MCC_MWCleanup;
							};

							_supplyTruck = _supplyTruckClass createVehicle _startPos;

							//Add to curator
							{_x addCuratorEditableObjects [[_supplyTruck],true]} forEach allCurators;

							_aidSide = "civ"; //["civ","military"] call BIS_fnc_selectRandom;

							//If not CQB spawn some POI
							if !(_isCQB) then {
								_objPos = [_objPos,"civ"] call MCC_fnc_buildRandomComposition;
							};

							//Garrison with some friendly troops
							if (_aidSide == "civ") then {
								[_objPos,30,0,4,_civFaction, civilian] remoteExec ["MCC_fnc_garrison",2];
							} else {
								[_objPos,30,0,4,_factionPlayer, _sidePlayer] remoteExec ["MCC_fnc_garrison",2];
							};

							//Spawn one group in defend
							_unitsArray = [_enemyfaction ,"soldier"] call MCC_fnc_makeUnitsArray;

							if (count _unitsArray > 0) then {
								if (count _unitsArray > 6) then {_unitsArray resize 6};

								_units = [];

								_objPos = [_objPos,0,100,2,0,50,0] call BIS_fnc_findSafePos;

							    _counter = floor random 8;

								for "_i" from 1 to _counter do {
									_units pushBack ((_unitsArray call bis_fnc_selectRandom) select 0);
								};

								_group = [_objPos, _units, 1, _enemySide, false, false] call MCC_fnc_groupSpawn;
								[_group, _objPos] call bis_fnc_taskDefend;
							};
							//Land_WaterBottle_01_stack_F Land_FoodSacks_01_small_brown_idap_F
							[_supplyTruck, _objPos,"Logistics",_preciseMarkers,_enemySide,400] call MCC_fnc_MWCreateTask;
						};

						//prevent spawning garrison in houses
						_isCQB = false;
					};
				};
			};

			//Stealth mission
			/*
			if (_stealth) then {
				private ["_activate","_cond","_alarm"];
				switch (_sidePlayer) do {
					case west: {_activate =  "WEST"; _cond = "WEST D"};
					case east: {_activate =  "EAST"; _cond = "EAST D"};
					case resistance: {_activate =  "GUER"; _cond = "GUER D"};
					case civilian: {_activate =  "CIV"; _cond = "CIV D"};
				};
				_alarm = "Land_Loudspeakers_F" createVehicle ([_objPos,1,100,10,0,10,0,[],[[-500,-500,0],[-500,-500,0]]] call BIS_fnc_findSafePos);

				//for saving
				_init = format ["['', %1, 100, 100, '%2', '%3', 'AlarmSfx',false] call MCC_fnc_MusicTrigger",getpos _alarm, _activate, _cond];
				_alarm setVariable ["vehicleinit",_init];
				{_x addCuratorEditableObjects [[_alarm],false]} forEach allCurators;

				[["", getpos _alarm, 100, 100, _activate, _cond,"AlarmSfx",false],"MCC_fnc_MusicTrigger",true,false] spawn BIS_fnc_MP;
			};
			*/

			sleep 1;

			waituntil {!isnil "MCC_MWObjectivesNames"};
			_objPos = MCC_MWObjectivesNames select 0;

			//Lets create a zone
			_zoneNumber = (count (missionNamespace getVariable ["MCC_zones_numbers",[]])) + 1;
			_script_handler = [_zoneNumber,_objPos,_maxObjectivesDistance*(if (_campaignMission) then {1} else {2})] call MCC_fnc_MWUpdateZone;
			waituntil {_script_handler};

			//Spawn some Infantry groups
			_spawnbehavior	= ["NOFOLLOW","bisd"] call BIS_fnc_selectRandom;
			_unitPlaced = [(_totalEnemyUnits*0.2),_zoneNumber,_spawnbehavior,_enemySide] call MCC_fnc_MWSpawnInfantry;
			if (MCC_debug) then {diag_log format ["Total enemy's infantry Spawned in zone%1: %2", _zoneNumber,_unitPlaced]};

			// Is CQB
			if (_isCQB) then {
				[[_objPos,(_maxObjectivesDistance*0.5),0,(_totalEnemyUnits*0.05) min 2,_enemyfaction, _enemySide],"MCC_fnc_garrison",false,false] spawn BIS_fnc_MP;
			};

			// Is _isCiv
			if (_isCiv) then {
				[[_objPos,(_maxObjectivesDistance*0.5),1,(_totalEnemyUnits*0.05) min 2,_civFaction,"CIV"],"MCC_fnc_garrison",false,false] spawn BIS_fnc_MP;
			};


			//Suicide Bombers
			private ["_name","_objectType","_unitsArray","_pos"];
			_unitsArray 	= [_civFaction, "soldier"] call MCC_fnc_makeUnitsArray;		//Let's build the faction unit's array

			if (_isSB && (count _unitsArray > 0)) then {
				for [{_i = 0},{_i <=(_totalEnemyUnits/30)},{_i = _i+1}] do {
					if (random 1 >0.5) then {
						//Name the bomber.
						_objectType = (_unitsArray call BIS_fnc_selectRandom) select 0;
						_pos = [[[_objPos,(_maxObjectivesDistance*0.7)]],["water"],{true}] call BIS_fnc_randomPos;

						[[_pos,_objectType,"large",floor (random 2),_sidePlayer],"MCC_fnc_SBSingle",false,false] spawn BIS_fnc_MP;

						//Debug
						if (MCC_debug) then {
							private ["_marker","_name"];
							_name = FORMAT ["SBMarker_%1", ["SBMarker",1] call bis_fnc_counter];
							_marker = createMarkerLocal[_name, _pos];
							_marker setMarkerTypeLocal "mil_dot";
							_marker setMarkerColorLocal "ColorOrange";
							_marker setMarkerSizeLocal[0.4, 0.4];
							_marker setMarkerTextLocal "SB";
						};
					};
				};
			};

			//Armed Civilans
			if (_isAS && (count _unitsArray > 0)) then {
				for [{_i = 0},{_i <=(_totalEnemyUnits/15)},{_i = _i+1}] do {
					if (random 1 >0.5) then {
						//Name the AC.
						_objectType = (_unitsArray call BIS_fnc_selectRandom) select 0;
						_pos = [[[_objPos,(_maxObjectivesDistance*0.7)]],["water"],{true}] call BIS_fnc_randomPos;

						[_pos,_objectType,_sidePlayer,"Armed Civilian",random 360] remoteExec ["MCC_fnc_ACSingle", 2];

						//Debug
						if (MCC_debug) then {
							private ["_marker","_name"];
							_name = FORMAT ["ACMarker_%1", ["ACMarker_",1] call bis_fnc_counter];
							_marker = createMarkerLocal[_name, _pos];
							_marker setMarkerTypeLocal "mil_dot";
							_marker setMarkerColorLocal "ColorOrange";
							_marker setMarkerSizeLocal[0.4, 0.4];
							_marker setMarkerTextLocal "AC";
						};
					};
				};
			};

			_objectives pushBack MCC_MWObjectivesNames;
		};
	};
} foreach [_obj1,_obj2,_obj3];



//-----------------------------------------------------------------------------Main zone-----------------------------------------------------------------------------------------------
private ["_unitPlaced","_safepos","_factor"];

[_missionCenterTrigger,_enemyfaction,_civFaction,_totalEnemyUnits, false, false, _animals, _vehicles, _armor, _artillery, _isRoadblocks, _isIED, false, false, _reinforcement, _sidePlayer, _enemySide, _markers] call MCC_fnc_populateObjective;


MCC_MWMissions pushback _objectives;
publicVariable "MCC_MWMissions";

if (_weatherChange != 0) then {
	//------------------- Time ---------------------------------------------------------------------------------
	private ["_hour"];
	if (_stealth) then {
		_hour = if (random 1 > 0.5) then {floor (random 5)} else {floor ((random 3)+20)};
	} else {
		_hour = floor (random 24);
	};

	MCC_date	= date;
	MCC_date	= [(MCC_date select 0) + floor (random 10 - random 10), floor ((random 12)+1)  ,  floor ((random 28)+1), _hour,  floor (random 60)];
	publicVariable "MCC_date";

	[[MCC_date],"MCC_fnc_setTime",true,false] call BIS_fnc_MP;


	//------------------- Weather ---------------------------------------------------------------------------------

	if !(_weatherChange in [2,3,4]) then {
		private "_monthFactor";
		["clear",false] remoteExec ["MCC_fnc_ppEffects",0,false];

		_monthFactor = [1,1,0.8,0.8,0.6,0.4,0.2,0.2,0.4,0.6,0.8,1] select ((MCC_date select 1)-1);
					//     1 , 2,  3   , 4    , 5     , 6    , 7   , 8    , 9    , 10   , 11   , 12

		MCC_Overcast	= (random (_monthFactor/2)) + _monthFactor/2;
		MCC_WindForce 	= (random (_monthFactor/2)) + _monthFactor/2;
		MCC_Waves 		= (random (_monthFactor/2)) + _monthFactor/2;

		if (MCC_Overcast > 0.6) then {
			MCC_Rain 		= (random (_monthFactor/2)) + _monthFactor/2;
			MCC_Lightnings	= (random (_monthFactor/2)) + _monthFactor/2;
			MCC_Fog 		= ((random (_monthFactor/2)) + _monthFactor/2)/5;

			publicVariable "MCC_Overcast";
			publicVariable "MCC_WindForce";
			publicVariable "MCC_Waves";
			publicVariable "MCC_Rain";
			publicVariable "MCC_Lightnings";
			publicVariable "MCC_Fog";

			[[[MCC_Overcast, MCC_WindForce, MCC_Waves, MCC_Rain, MCC_Lightnings, MCC_Fog]],"MCC_fnc_setWeather",true,false] call BIS_fnc_MP;
		} else {
			[[MCC_Overcast, MCC_WindForce, MCC_Waves]] remoteExec ["MCC_fnc_setWeather",0];
			publicVariable "MCC_Overcast";
			publicVariable "MCC_WindForce";
			publicVariable "MCC_Waves";
		};
	} else {
		if (_weatherChange == 2) then {["sandstorm",false] remoteExec ["MCC_fnc_ppEffects",0,false]};
		if (_weatherChange == 3) then {["storm",false] remoteExec ["MCC_fnc_ppEffects",0,false]};
		if (_weatherChange == 4) then {["snow",false] remoteExec ["MCC_fnc_ppEffects",0,false]};
	};
};

//Force AI to use flashlights

[position _missionCenterTrigger, (triggerArea _missionCenterTrigger) select 0,(triggerArea _missionCenterTrigger) select 1] spawn {
	params [
			["_pos", [0,0,0], [[]]],
			["_sizeA", 50, [0]],
			["_sizeB", 40, [0]]
		];
	sleep 10;

	if (sunOrMoon <0.5) then {

		[_pos,(_sizeA) max (_sizeB),19,true] spawn MCC_fnc_deleteBrush;
		[_pos,(_sizeA) max (_sizeB),20,true] spawn MCC_fnc_deleteBrush;
	};
};


// ------------------  CREATE BRIEFINGS --------------------------------------------------------------------------
//-----------------  CREATE BRIEFINGS --------------------------------------------------------------------------

_factionName = getText (configfile >> "CfgFactionClasses" >> _enemyfaction >> "displayName");

private _missionText = "";

//Location
switch (true) do
{
	case (_stealth):
	{
		 _html = format ["<t size='1.1' color='#a8e748' underline='true' align='center'>Black Ops: </t><t size='1.1' color='#a8e748' underline='true' align='center'>%1 %2.</t>",toupper (_missionName1 select 0),toupper (_missionName2 select 0)];
		_missionTittle = format ["<t size='1.1' color='#a8e748' underline='true' align='center'>Black Ops: </t><t size='1.1' color='#a8e748' underline='true' align='center'><marker name='%3'>%1 %2.</marker></t>",toupper (_missionName1 select 0),toupper (_missionName2 select 0),_markerName];
		_plainText = [[format ["Black Ops: %1 %2.",toupper (_missionName1 select 0),toupper (_missionName2 select 0)],"<t size='1.0' color='#a8e748' font='PuristaBold'>%1</t><br/>",3]];

		_missionText = format ["Black Ops: %1 %2.",toupper (_missionName1 select 0),toupper (_missionName2 select 0)];
	};

	case ((_center select 1) != ""):
	{
		_tempText = ["Attack On","The Battle For","Assault On","The Fight For"] call BIS_fnc_selectRandom;
        _html = format ["<t size='1.1' color='#a8e748' underline='true' align='center' >Operation: </t><t size='1.1' color='#a8e748' underline='true' align='center'>%1 %2. %3 %4</t>",toupper (_missionName1 select 0),toupper (_missionName2 select 0),_tempText,(_center select 1)];
		_missionTittle = format ["<t size='1.1' color='#a8e748' underline='true' align='center' >Operation: </t><t size='1.1' color='#a8e748' underline='true' align='center'><marker name='%5'>%1 %2. %3 %4</marker></t>",toupper (_missionName1 select 0),toupper (_missionName2 select 0),_tempText,(_center select 1),_markerName];
		_plainText = [[format ["Operation: %1 %2. %3 %4.",toupper (_missionName1 select 0),toupper (_missionName2 select 0),_tempText,(_center select 1)],"<t size='1.0' color='#a8e748' font='PuristaBold'>%1</t><br/>",3]];

		_missionText = format ["Operation: %1 %2. %3 %4.",toupper (_missionName1 select 0),toupper (_missionName2 select 0),_tempText,(_center select 1)];
	};

	default
	{
		 _html = format ["<t size='1.1' color='#a8e748' underline='true' align='center'>Operation: </t><t size='1.1' color='#a8e748' underline='true' align='center'>%1 %2.</t>",toupper (_missionName1 select 0),toupper (_missionName2 select 0)];
		_missionTittle = format ["<t size='1.1' color='#a8e748' underline='true' align='center'>Operation: </t><t size='1.1' color='#a8e748' underline='true' align='center'><marker name='%3'>%1 %2.</marker></t>",toupper (_missionName1 select 0),toupper (_missionName2 select 0),_markerName];
		_plainText = [[format ["Operation: %1 %2.",toupper (_missionName1 select 0),toupper (_missionName2 select 0)],"<t size='1.0' color='#a8e748' font='PuristaBold'>%1</t><br/>",3]];

		_missionText = format ["Operation: %1 %2.",toupper (_missionName1 select 0),toupper (_missionName2 select 0)];
	};
};

//General
_tempText = [
              ["presence in the area has been increased",["general1",2.67]],
			  ["have established a foothold in the area",["general2",2.73]],
			  ["forces are active in the area",["general3",2.2]]
			] call BIS_fnc_selectRandom;
_html = _html + format ["<br/><br/><t size='0.8' color='#E2EEE0'>%1 %2. </t>",_factionName, _tempText select 0];
_html2 = format ["<br/><br/><t>%1 %2.</t>",_factionName,_tempText select 0];
_missionText =  _missionText + format ["<br/><br/>%1 %2.",_factionName,_tempText select 0];

//_plainText pushback [format ["%1 %2. ",_factionName, _tempText select 0],"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
_sounds set [count _sounds, _tempText select 1];

//_isCQB
if (_isCQB) then {
    _tempText = [
	              [" and they have taken up defensive positions inside buildings.",["isCQB1",3.49]],
				  [" and they are using civilian buildings to fortify themselves.",["isCQB2",3.69]]
				] call BIS_fnc_selectRandom;
    _html = _html + format ["<t size='0.8' color='#E2EEE0'> %1.</t>",_tempText select 0];
	_html2 = _html2 + format ["%1",_tempText select 0];
	_missionText =  _missionText + format ["%1 <br/>",_tempText select 0];
	//_plainText pushback [_tempText select 0,"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
	_sounds set [count _sounds, _tempText select 1];
};

/*
_html = _html + format ["<t size='0.8' color='#E2EEE0'>HQ informs us that infantry are present. </t>",_factionName];
_missionText =  _missionText + format ["HQ informs us that infantry are present.",_factionName];
//_plainText pushback ["HQ informs us that infantry are present.","<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
_sounds set [count _sounds, ["infantrypresent",3]];
*/

//_vehicles
if (_vehicles) then {
    _html = _html + format ["<t size='0.8' color='#E2EEE0'>You may also encounter %1 technicals or soft vehicles. </t>",_factionName];
	_html2 = _html2 + format ["<br/>You may also encounter %1 technicals or soft vehicles.",_factionName];
	_missionText =  _missionText + format ["<br/>You may also encounter %1 technicals or soft vehicles.<br/>",_factionName];
	//_plainText pushback [format ["You may also encounter %1 technicals or soft vehicles.",_factionName],"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
	_sounds set [count _sounds, ["isVehicles",2.88]];
};

//_armor
if (_armor) then {
    _html = _html + format ["<t size='0.8' color='#E2EEE0'>Be aware that there may be %1 armored vehicles or even MBT's operating in the OP. </t>",_factionName];
	_html2 = _html2 + format ["<br/>Be aware that there may be %1 armored vehicles or even MBT operating in the OP.",_factionName];
	_missionText =  _missionText + format ["<br/>Be aware that there may be %1 armored vehicles or even MBT operating in the OP.<br/>",_factionName];
	//_plainText pushback [format ["Be aware that there may be %1 armored vehicles or even MBT operating in the OP.",_factionName],"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
	_sounds set [count _sounds, ["isArmor",4.68]];
};

//Artillery
if (_artillery != 0) then {
	_html = _html + format ["<t size='0.8' color='#E2EEE0'>%1 may also have artillery operating in the area. </t>",_factionName];
	_html2 = _html2 + format ["<br/>%1 may also have artillery operating in the area.",_factionName];
	_missionText =  _missionText + format ["<br/>%1 may also have artillery operating in the area.<br/>",_factionName];
	//_plainText pushback [format ["%1 may also have artillery operating in the area.",_factionName],"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
	_sounds set [count _sounds, ["isArtillery",2.96]];
};

//_isRoadblocks
if (_isRoadblocks) then {
    _html = _html + format ["<br/><t size='0.8' color='#E2EEE0'>%1 forces have established hasty checkpoints on some of the roads leading in and out of the area. </t>",_factionName];
	_html2 = _html2 + format ["<br/>%1 forces have established hasty checkpoints on some of the roads leading in and out of the area.",_factionName];

	_missionText =  _missionText + format ["<br/>%1 forces have established hasty checkpoints on some of the roads leading in and out of the area.<br/>",_factionName];
	//_plainText pushback [format ["%1 forces have established hasty checkpoints on some of the roads leading in and out of the area.",_factionName],"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
	_sounds set [count _sounds, ["isRoadblocks",4.33]];
};

//_isIED
if (_isIED || _isSB) then {
    _html = _html + format ["<t size='0.8' color='#E2EEE0'>Keep an eye out for anything that might look suspicious, as we believe that %1 may employ IEDs, or even suicide attacks. </t>",_factionName];
	_html2 = _html2 + format ["<br/>Keep an eye out for anything that might look suspicious, as we believe that %1 may employ IEDs, or even suicide attacks.",_factionName];
	_missionText =  _missionText + format ["<br/>Keep an eye out for anything that might look suspicious, as we believe that %1 may employ IEDs, or even suicide attacks.<br/>",_factionName];
	//_plainText pushback [format ["Keep an eye out for anything that might look suspicious, as we believe that %1 may employ IEDs, or even suicide attacks.",_factionName],"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
	_sounds set [count _sounds, ["isIED",6.4]];
};
//_isAS
if (_isAS) then {
    _html = _html + format ["<t size='0.8' color='#E2EEE0'>The local civilians support %1, so be on the look out for any strange behavior. But keep civilian casualties to a minimum as the top Brass don't want to draw unnecessary attention. </t>",_factionName];
	_html2 = _html2 + format ["The local civilians support %1, so be on the look out for any strange behavior. But keep civilian casualties to a minimum as the top Brass do not want to draw unnecessary attention.",_factionName];

	_missionText =  _missionText + format ["<br/>The local civilians support %1, so be on the look out for any strange behavior. But keep civilian casualties to a minimum as the top Brass do not want to draw unnecessary attention.",_factionName];
	//_plainText pushback [format ["The local civilians support %1, so be on the look out for any strange behavior. But keep civilian casualties to a minimum as the top Brass do not want to draw unnecessary attention.",_factionName],"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
	_sounds set [count _sounds, ["isAS",10.77]];
};

//Reinforcment
if (_reinforcement in [1,2,3] || _stealth) then {
	private "_text";
	switch (_reinforcement) do {
		case 0: {
			_text = "";
			_sounds set [count _sounds, ["isReinforcement_generic",8.1]];
		};

		case 1: {
			_text = " aerial ";
			_sounds set [count _sounds, ["isReinforcement1",8.56]];
		};

		case 2: {
			_text = " motorized ";
			_sounds set [count _sounds, ["isReinforcement2",8.4]];
		};

		case 3: {
			_text = " aerial and motorized ";
			_sounds set [count _sounds, ["isReinforcement3",9.12]];
		};
	};


	_html = _html +"<br/><t size='0.8' color='#E2EEE0'>The enemy have" + _text + "QRF forces nearby. Expect enemy reinforcements should they become aware of your presence. </t>";
	_html2 = _html2 +"<br/>The enemy have" + _text + "QRF forces nearby. Expect enemy reinforcements should they become aware of your presence.";

	_missionText =  _missionText + format ["<br/><br/>The enemy have %1 QRF forces nearby. Expect enemy reinforcements should they become aware of your presence.",_text];
	//_plainText pushback [format ["The enemy have%1QRF forces nearby. Expect enemy reinforcements should they become aware of your presence",_text],"<t size='0.7' color='#E2EEE0' font='PuristaMedium'>%1</t>",0];
};

_html = _html + format ["<br/><t size='0.8' color='#E2EEE0'>Go over your objectives, gear up and get ready. Mission is a go!</t>",_factionName];
_sounds set [count _sounds, ["isMissiongo",6.2]];

//Update parent module
if (_multipleObjectives) then {
	_missionObjective setvariable ["RscAttributeTaskDescription",[_missionText, _missionName,""],true];
	_missionObjective setvariable ["updated",true,true];
};

//Briefings
_music = MWinitMissionMusic call BIS_fnc_selectRandom;

if (_playMusic > 0 ) then {_music = ""};

[[_html2, ((_missionName1 select 0) +" " + (_missionName2  select 0)), [_missionTittle], [_missionCenter,_objectives,1,_html,_sounds,_music,_plainText,_sidePlayer,_playMusic,_preciseMarkers]],"MCC_fnc_makeBriefing",false,false] spawn BIS_fnc_MP;


//Broadcast missionInfo to all side
missionNamespace setVariable [format ["MCC_missionsInfo_%1", _sidePlayer],[_missionCenter,_objectives,1,_html,_sounds]];
publicVariable format ["MCC_missionsInfo_%1", _sidePlayer];

//Clear up
MCC_MWisGenerating = false;
publicVariable "MCC_MWisGenerating";

if (!isnil "MCC_worldArea") then {deleteVehicle MCC_worldArea;	MCC_worldArea = nil};
if (!isnil "MWMissionArea") then {deleteVehicle MWMissionArea;	MWMissionArea = nil};

//Wait till mission end
[_missionCenter,_maxObjectivesDistance,_markerName] spawn {
	params ["_missionCenter","_maxObjectivesDistance","_markerName"];

	missionNamespace setVariable ["MCC_MWMissionRuning",true];
	publicvariable "MCC_MWMissionRuning";

	while {{(_x getvariable ["MCC_customTask",false]) && ((_x getvariable ["RscAttributeTaskState",""]) in ["created","assigned"])} count (allMissionObjects "MCC_ModuleObjective_FCurator") > 0} do {
		sleep 1;
	};

	/*
	while {{alive _x && !((_x getvariable ["taskType",""]) isEqualTo "parent")} count (allMissionObjects "MCC_ModuleObjective_FCurator") > 0} do {
		sleep 1;
	};
	*/

	missionNamespace setVariable ["MCC_MWMissionRuning",false];
	publicvariable "MCC_MWMissionRuning";

	//Global Radio message when done
	(selectRandom ["cp_mission_accomplished_1", "cp_mission_accomplished_2", "cp_mission_accomplished_3"]) remoteExec ["playSound",0];
	deleteMarker _markerName;
};