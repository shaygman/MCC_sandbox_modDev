//====================================================MCC_fnc_populateObjective=================================================================================================
// Populate a zone with enemies.
// Example:[_missionCenterTrigger,_enemyfaction,_civFaction,_totalEnemyUnits, _isCQB, _isCiv, _animals, _vehicles, _armor, _artillery, _isRoadblocks, _isIED, _isAS, _isSB, _reinforcement, _sidePlayer, _enemySide] call MCC_fnc_populateObjective;
// 	_missionCenterTrigger 	Triger, mission center
//	_enemyfaction			String, faction we are fighting
//	_civFaction				String, civilians faction
//	_totalEnemyUnits:		Integer, tottal enemy units
//	_isCQB:					Boolean, true - isCQB false- isn't CQB
//	_isCiv					Boolean, Civilians yes or no
//	_animals				Boolean, animals yes or no
//	_vehicles				Boolaen, will be vehicles in the mission
//	_armor					Boolaen, will be armored units in the mission
//	_artillery					Integer, reinforcement 0 - no;	1- mortars;	2 - self propeled;	3 - Random;
//	_isRoadblocks			Boolean, RoadBlocks yes or no
//	_isIED					Boolean, IED yes or no
//	_isAS					Boolean, Armed civilians yes or no
//	_isSB					Boolean, Suicide Bombers yes or no
//	_reinforcement			Integer, reinforcement 0 - no;	1- Aerial;	2 - Motorized;	3 - Random;
//	_sidePlayer				Side, the defending side
//	_enemySide				Side, what side are we fighting
// Return - nothing
//==============================================================================================================================================================================
private ["_zoneNumber","_unitPlaced","_safepos","_factor","_missionCenter","_missionRadius","_script_handler","_factor","_isCQB","_totalEnemyUnits","_roadPositions","_enemyfaction","_civFaction","_isCiv","_animals","_vehicles","_armor","_artillery","_isRoadblocks","_missionCenterTrigger","_isAS","_isSB","_dir"];
_missionCenterTrigger 	= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_missionCenter	= getpos _missionCenterTrigger;

_enemyfaction	= param [1, "OPF_F", [""]];
_civFaction		= param [2, "CIV_F", [""]];
_totalEnemyUnits= param [3, 20, [0]];
_isCQB			= param [4, false, [true]];
_isCiv			= param [5, false, [true]];
_animals		= param [6, false, [true]];
_vehicles		= param [7, false, [true]];
_armor			= param [8, false, [true]];
_artillery		= param [9, 0, [0]];
_isRoadblocks	= param [10, false, [true]];
_isIED			= param [11, false, [true]];
_isAS			= param [12, false, [true]];
_isSB			= param [13, false, [true]];
_reinforcement	= param [14, 0, [0]];
_sidePlayer		= param [15, west];
_enemySide		= param [16, east];

_missionRadius 	= (((triggerArea _missionCenterTrigger) select 0)+ ((triggerArea _missionCenterTrigger) select 1))/2;
//Let'screate the main zone and placing units
_zoneNumber = (count (missionNamespace getVariable ["MCC_zones_numbers",[]])) + 1;

//Create Zone
[_zoneNumber,_missionCenter,(triggerArea _missionCenterTrigger)] call MCC_fnc_MWUpdateZone;

//Spawn some Infantry groups
_spawnbehavior	= ["MOVE","MOVE","MOVE","NOFOLLOW"] call BIS_fnc_selectRandom;
_factor = if (_isCQB) then {0.1} else {0.2};

_unitPlaced = [(_totalEnemyUnits * _factor),_zoneNumber,_spawnbehavior,_enemySide] call MCC_fnc_MWSpawnInfantry;
if (MCC_debug) then {diag_log format ["Total enemy's infantry Spawned in main zone: %1", _unitPlaced]};

//Garrison
if (_isCQB) then
{
	[[_missionCenter,_missionRadius,0,(_totalEnemyUnits*0.005),_enemyfaction,str _enemySide],"MCC_fnc_garrison",false,false] spawn BIS_fnc_MP;

	//lock some doors
	[_missionCenter,_missionRadius,12] spawn MCC_fnc_deleteBrush;
};

// Is _isCiv
if (_isCiv) then
{
	[[getmarkerpos str _zoneNumber,((getmarkersize str _zoneNumber) select 0) max ((getmarkersize str _zoneNumber) select 1),1,(_totalEnemyUnits*0.005),_civFaction,"CIV"],"MCC_fnc_garrison",false,false] spawn BIS_fnc_MP;
};

//Animals
if (_animals) then
{
	[[_zoneNumber],"MCC_fnc_MWspawnAnimals",false,false] spawn BIS_fnc_MP;
	if (MCC_debug) then {diag_log format ["MCC: MW - Animals Spawned in Zone: %1", _unitPlaced]};
};

//Vehicles
if (_vehicles) then
{
	_unitPlaced = [(_totalEnemyUnits*0.6),_zoneNumber,MCC_MWGroupArrayCar,MCC_MWunitsArrayCar,5,15,"LAND",_enemySide] call MCC_fnc_MWSpawnVehicles;
	if (MCC_debug) then {diag_log format ["Total enemy's Vehicles Spawned in main zone: %1", _unitPlaced]};
};

//Armor
if (_armor) then
{
	_unitPlaced = [(_totalEnemyUnits*0.4),_zoneNumber,MCC_MWGroupArrayArmored,MCC_MWunitsArrayArmored,10,30,"LAND",_enemySide] call MCC_fnc_MWSpawnVehicles;
	if (MCC_debug) then {diag_log format ["Total enemy's Armor Spawned in main zone: %1", _unitPlaced]};
};

//Support
if (_vehicles && (random 1 > 0.5)) then
{
	_unitPlaced = [(_totalEnemyUnits*0.3),_zoneNumber,MCC_MWGroupArraySupport,MCC_MWunitsArraySupport,10,30,"LAND",_enemySide] call MCC_fnc_MWSpawnVehicles;
	if (MCC_debug) then {diag_log format ["Total enemy's Support Vehicles Spawned in main zone: %1", _unitPlaced]};
};

//Artillery
if (_artillery != 0) then
{
	[[(_totalEnemyUnits*0.2),_missionCenter,_missionRadius,MCC_MWunitsArrayStatic,5,10,_enemySide,_artillery,_zoneNumber],"MCC_fnc_MWSpawnStatic",false,false] spawn BIS_fnc_MP;
	if (MCC_debug) then {diag_log "Enemy's Artillery Spawned in main zone"};
};

//Static
if (random 1 > 0.3) then
{
	[[(_totalEnemyUnits*0.2),_missionCenter,_missionRadius,MCC_MWunitsArrayStatic,4,8,_enemySide,999,_zoneNumber],"MCC_fnc_MWSpawnStatic",false,false] spawn BIS_fnc_MP;
	if (MCC_debug) then {diag_log "Enemy's Static Weapons Spawned in main zone"};
};

//Ship
_safepos =[_missionCenter ,1,(_missionRadius*2.5),2,2,10,0,[],[[-500,-500,0],[-500,-500,0]]] call BIS_fnc_findSafePos; //Check if they are water
if (str _safepos != "[-500,-500,0]") then
{
	_unitPlaced = [(_totalEnemyUnits*0.2),_zoneNumber,MCC_MWGroupArrayShip,MCC_MWunitsArrayShip,5,15,"WATER",_enemySide] call MCC_fnc_MWSpawnVehicles;
	if (MCC_debug) then {diag_log format ["Total enemy's Ships Vehicles Spawned in main zone: %1", _unitPlaced]};
};

//CheckPoints
if (_isRoadblocks) then
{
	_roadPositions = [_missionCenter,(_missionRadius*0.7)] call MCC_fnc_findRoadsLeadingZone;
	if (count _roadPositions >0) then
	{
		private ["_roadConnectedTo","_connectedRoad","_dir"];
		{
			if (random 1 > 0.5) then
			{
				_roadConnectedTo 	= roadsConnectedTo _x;
				_connectedRoad 		= _roadConnectedTo select 0;
				if (!isnil "_connectedRoad") then
				{
					_dir			 	= [_x, _connectedRoad] call BIS_fnc_DirTo;
					_pos				= getpos _x;

					if (isnil "_dir") then {_dir = 0};

					//If no buildings around
					if ((nearestBuilding _pos) distance _pos >30) then
					{
						[[_pos, _dir, _enemyfaction, _enemySide],"MCC_fnc_buildRoadblock",false,false] spawn BIS_fnc_MP;
					};
				};
			};
		} foreach _roadPositions;
	};
};

//IEDs
if (_isIED) then
{
	private ["_name","_objectType","_iedpos","_iedX","_iedY","_groupArray","_dir"];
	_roadPositions = [_missionCenter,(_missionRadius*0.5)] call MCC_fnc_findRoadsLeadingZone;
	if (count _roadPositions >0) then
	{
		_unitsArray 	= [_civFaction,"carx"] call MCC_fnc_makeUnitsArray;
		if (count _unitsArray > 0) then {
			{
				if (random 1 > 0.3) then
				{

					//Name the ied.
					_name = format ["IEDObject_%1", ["IEDObject_",1] call bis_fnc_counter];

					//Care or hidden?
					if (random 1 < 0.3) then
					{
						//Why the hell we have karts in a milsim?!
						_objectType = "";
						while {_objectType in ["","C_Kart_01_Blu_F","C_Kart_01_F","C_Kart_01_F_Base","C_Kart_01_Fuel_F","C_Kart_01_Red_F","C_Kart_01_Vrana_F"]} do
						{
							_objectType = (_unitsArray call BIS_fnc_selectRandom) select 0;
							sleep 0.1;
						};
					}
					else
					{
						_objectType = (missionNamespace getVariable ["MCC_MWIED",["IEDLandSmall_Remote_Ammo","IEDLandBig_Remote_Ammo","IEDUrbanSmall_Remote_Ammo","IEDUrbanBig_Remote_Ammo"]]) call BIS_fnc_selectRandom;
					};

					//Find road direction
					_roadConnectedTo 	= roadsConnectedTo _x;

					if (count _roadConnectedTo > 0) then {
						_connectedRoad = _roadConnectedTo select 0;
						if (isNil "_connectedRoad") then {_dir = 0} else {
							_dir = [_x, _connectedRoad] call BIS_fnc_DirTo;
						};
					} else {
						_dir = 0;
					};

					//Let's not place it on road but to the side of the road.
					_iedX = 4;
					_iedY = 0;
					_iedpos = _x modeltoworld [_iedX,_iedY,0];

					while {isOnRoad _iedpos} do
					{
						_iedX = _iedX + 1;
						_iedY = _iedY + 1;
						_iedpos = _x modeltoworld [_iedX,_iedY,0];
					};

					//Spawn the IED
					[[_iedpos,_objectType,"large",floor (random 2),2,false,0,((random 25) + 15),_sidePlayer,_name,_dir,true,_enemySide],"MCC_fnc_trapSingle",false,false] spawn BIS_fnc_MP;

					//Debug
					if (MCC_debug) then
						{
							private ["_marker","_name"];
							_name = FORMAT ["iedMarker_%1", ["iedMarker_",1] call bis_fnc_counter];
							_marker = createMarkerLocal[_name, _iedpos];
							_marker setMarkerTypeLocal "mil_dot";
							_marker setMarkerColorLocal "ColorOrange";
							_marker setMarkerSizeLocal[0.4, 0.4];
							_marker setMarkerTextLocal "IED";
						};

				};
			} foreach _roadPositions;
		};
	};
};

//Reinforcment
if (_reinforcement in [1,2,3]) then
{
	private ["_cond","_end"];
	_cond = [0.3];
	_end = [0,0,0,0,0,0,0,1,1,1,2] call BIS_fnc_selectRandom;
	for "_x" from 1 to _end step 1 do
	{
		_cond set [_x, (_cond select (_x-1)) + 0.3];
	};

	[[_reinforcement,_enemySide,getpos _missionCenterTrigger, triggerArea _missionCenterTrigger, _cond,_zoneNumber,_enemyfaction,MCC_debug,_totalEnemyUnits],"MCC_fnc_MWreinforcement",false,false] call BIS_fnc_MP;
};

//all sides but the enemy
private _playersSides = [west,east,resistance] - [_enemySide];

//Suicide Bombers
private ["_name","_objectType","_unitsArray","_pos"];
_unitsArray 	= [_civFaction, "soldier"] call MCC_fnc_makeUnitsArray;		//Let's build the faction unit's array

if (_isSB) then {

	for [{_i = 0},{_i <=(_totalEnemyUnits/30)},{_i = _i+1}] do {

		if (random 1 >0.5) then	{
			//Name the bomber.
			_objectType = (_unitsArray call BIS_fnc_selectRandom) select 0;
			_pos = [[[_missionCenter,(_missionRadius*0.7)]],["water","out"],{true}] call BIS_fnc_randomPos;

			[[_pos,_objectType,"large",floor (random 2),_playersSides],"MCC_fnc_SBSingle",false,false] spawn BIS_fnc_MP;

			//Debug
			if (MCC_debug) then
				{
					private ["_marker","_name"];
					_name = FORMAT ["SBMarker_%1", ["SBMarker_",1] call bis_fnc_counter];
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
if (_isAS) then {

	for [{_i = 0},{_i <=(_totalEnemyUnits/15)},{_i = _i+1}] do {

		if (random 1 >0.5) then {

			//Name the AC.
			_objectType = (_unitsArray call BIS_fnc_selectRandom) select 0;
			_pos = [[[_missionCenter,(_missionRadius*0.7)]],["water","out"],{true}] call BIS_fnc_randomPos;

			[[_pos,_objectType,_playersSides,"Armed Civilian",random 360],"MCC_fnc_ACSingle",false,false] spawn BIS_fnc_MP;

			//Debug
			if (MCC_debug) then
				{
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