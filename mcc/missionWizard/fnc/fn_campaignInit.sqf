/*======================================================MCC_fnc_campaignInit===========================================================================================
	Init campaign - SERVER ONLY
	_sidePlayer			SIDE - player side
	_factionPlayer		STRNG - faction player- defult "BLU_F"
	_sideEnemy			SIDE - enemy side
	_factionEnemy		STRING - faction enemy default "OPF_F"
	_factionCiv			STRING - faction civilians
	_missionMax			INTEGER - max amount of missions before mission over
	_difficulty			INTEGER - difficulty between 10-40 default is 20
	_sidePlayer2		SIDE - Side of the rival players faction
	_tickets			INTEGER - starting respawn tickets for each side
	_missionRotation	INTEGER - max missions in the same area
	(CBA settings: MCC_campaignAOSize - AO radius, MCC_campaignMaxAOs - simultaneous AOs 1-3,
	 MCC_campaignAmbientCap - ambient groups cap, MCC_MWmaxObjectives - objectives per AO)
	_tileSize			INTEGER - Size of the tile while portfiling the map
	_loadDB				INTEGER  - Should we load the last saved data base
	_playMusic			INTEGER  0 - Play cinematic
  								 1 - Intro Only - Default
								 2 - None
//=====================================================================================================================================================================*/
private ["_sidePlayer","_sideEnemy","_factionCiv","_center","_arrayAssets","_locations","_pos","_temploc","_AOlocation","_missionDone","_missionMax","_AOSize","_factionPlayer","_difficulty","_totalPlayers","_sidePlayer2","_tickets","_missionRotation","_basePos","_tileSize","_reconMission","_tempVar","_loadDb","_playMusic"];

//wait for MCC
waitUntil {!isnil "MCC_initDone"};
waitUntil {MCC_initDone};

_sidePlayer	= param [0, west];
_factionPlayer	= param [1, "BLU_F"];
_sideEnemy	= param [2, east];
_factionEnemy = param [3, "OPF_F"];
_factionCiv	= param [4, "CIV_F"];
_missionMax  = param [5, 10];
_difficulty  = param [6, 20];
_sidePlayer2=  param [7, sideLogic];
_tickets = param [8, 100];
_missionRotation = param [9, 4,[0]];
_tileSize = param [10, 400,[0]];
_loadDb = param [11, false,[false]];
_playMusic = param [12, 1,[0]];

_totalPlayers = ((playersNumber _sidePlayer)+1);
_AOSize = (missionNamespace getVariable ["MCC_campaignAOSize",300]) max 100;		//CBA setting (Phase C)

if (!isServer) exitWith {diag_log "MCC_fnc_campaignInit : Error not running on server"};

//Set campaign var
missionNamespace setVariable ["MCC_isCampaignRuning",true];
publicVariable "MCC_isCampaignRuning";

//Wait for mission start
waitUntil {time > 3};

missionNamespace setVariable ["MCC_campaignEnemyFaction",_factionEnemy];
publicVariable "MCC_campaignEnemyFaction";

//Time Multuplier
if (timeMultiplier < 12) then {setTimeMultiplier 12};

//Load stuff from DB
if (_loadDb) then {
	["MCC_campaign",true,true,true,true,true,true,true,true,true] call MCC_fnc_loadServer;
};

//Add tickets to the sides
if (_tickets > 0) then {
	{
		[_x,_tickets] call BIS_fnc_respawnTickets;
	} forEach [_sidePlayer,_sidePlayer2];
};

//Build the faction's unitsArrays and send it to the server.
_check = [_factionEnemy, _sideEnemy] call MCC_fnc_MWCreateUnitsArray;
waituntil {_check};

[_factionEnemy] call MCC_fnc_createConfigs;

//Search the map for locations
private ["_worldPath","_mapSize","_mapCenter"];

if (isnil "MCC_worldArea") then {
	_worldPath = configfile >> "cfgworlds" >> worldname;
	_mapSize = getnumber (_worldPath >> "mapSize");
	if (_mapSize == 0) then {_mapSize = 10000};

	_mapSize = _mapSize / 2;
	_mapCenter = [_mapSize,_mapSize];

	MCC_worldArea = createtrigger ["emptydetector",_mapCenter];
	MCC_worldArea settriggerarea [_mapSize,_mapSize,0,true];
};

//Build Locations
_locations = [];

//Any user defined locations?
{
	if (markerType _x == "Empty") then {
		if (["ao",_x] call bis_fnc_inString) then {_locations pushBack [getMarkerPos _x, markerText _x]};
	};
} forEach allMapMarkers;

//If no user defined locations lets find map locations.
if (count _locations == 0) then {
	_pos = getpos MCC_worldArea;
	{
		_temploc = [_pos,15000,_x] call MCC_fnc_MWbuildLocations;
		{
			if (((missionNamespace getVariable ["MCC_START_WEST",[0,0,0]]) distance (getpos (_x select 0)) >700) &&
				((missionNamespace getVariable ["MCC_START_EAST",[0,0,0]]) distance (getpos (_x select 0)) >700) &&
				((missionNamespace getVariable ["MCC_START_GUER",[0,0,0]]) distance (getpos (_x select 0)) >700)) then {

				_locations pushBack [getpos (_x select 0), _x select 1];
			};

		} forEach _temploc;
	} forEach ["city","mil","nature"]; //,"mil","hill","nature","marine"
};

//Still no location go bruth force
if (count _locations == 0) then {
	for "_i" from 1 to 100  do {
		_temploc = [[getpos MCC_worldArea, MCC_worldArea], "ground", ["water"],{}] call BIS_fnc_randomPos;
		_locations pushBack [_temploc, ""];
	};
};

//init map markers
[_sideEnemy,_tileSize,0.2,_locations,400,0.4,_loadDb] call MCC_fnc_campaignInitMap;

//Mark the starting bases
{
	_basePos = switch (_x) do
				{
					case east: {missionNamespace getVariable ["MCC_START_EAST",[0,0,0]]};
					case west: {missionNamespace getVariable ["MCC_START_WEST",[0,0,0]]};
					case resistance: {missionNamespace getVariable ["MCC_START_GUER",[0,0,0]]};
					default	{[0,0,0]};
				};
	if !(_basePos isEqualTo [0,0,0]) then {
		[_basePos,1000,_x,0.2] call MCC_fnc_campaignPaintMarkers;
	};
} forEach [_sidePlayer,_sidePlayer2];

//Spawn enemy ambient patrols
[500,round (missionNamespace getVariable ["MCC_campaignAmbientCap",18]),_factionEnemy] spawn MCC_fnc_campaignSpawnAIInit;


//Pick first location
_missionDone = 0;

/*
//Mark all the locations as hot spots
{
	[(_x select 0),400,_sideEnemy,0.4,[_sidePlayer,_sidePlayer2]] spawn MCC_fnc_campaignPaintMarkers;
	sleep 0.1;
} forEach _locations;
*/

//main mission loop
private ["_AOlocationPos","_AOlocationName","_index","_goodLocation"];

//Sort locations by distance from the players base
_basePos = switch (_sidePlayer) do
			{
				case east: {missionNamespace getVariable ["MCC_START_EAST",[0,0,0]]};
				case west: {missionNamespace getVariable ["MCC_START_WEST",[0,0,0]]};
				case resistance: {missionNamespace getVariable ["MCC_START_GUER",[0,0,0]]};
				default	{[0,0,0]};
			};
_locations = [_locations,[_basePos],{_input0 distance (_x select 0)},"ASCEND"] call BIS_fnc_sortBy;

//Start the campaign missions?
if (_missionMax == 0) exitWith {
	["sidetickets"] call  BIS_fnc_endMissionServer;
};

//Save DB every 20 minutes
["MCC_campaign",1200,true] spawn MCC_fnc_saveServer;


/*-------------------------------------------------------- Campaign AOs (Phase C) ------------------------------------------------------------
	Up to MCC_campaignMaxAOs AOs run at the same time. Every AO is its own MW mission (own zones/objectives) with a mission id;
	its objective modules carry MCC_MWmissionId and MCC_fnc_MWinitMission publishes MCC_MWMissionRuning_<id>.
	The campaign progresses (rewards, borders, difficulty, new AO) whenever any AO is done.
	AO record: [id, pos, name, recon, ticketsStart, obj2, state (0 generating / 1 running), startTime]
	Nothing of the AO state is saved: after a DB load (MCC_fnc_loadServer) new AOs are picked from the saved tiles.
---------------------------------------------------------------------------------------------------------------------------------------------------*/
private _activeAOs = [];
private _missionsStarted = 0;
private _campaignWon = false;

//Pick the next AO location - [] if none. Locations too close to a running AO are kept for later.
private _fnc_pickLocation = {
	private _picked = [];
	private _deferred = [];
	private _recon = random 1 <= 0.2;

	while {count _locations > 0 && {count _picked == 0}} do {
		private _index = if (_recon) then {floor random count _locations} else {0};
		private _candidate = _locations deleteAt _index;
		private _candidatePos = _candidate select 0;

		if (({((_x select 1) distance2D _candidatePos) < (_AOSize * 4)} count _activeAOs) > 0) then {
			_deferred pushBack _candidate;
		} else {
			if ((([_candidatePos] call MCC_fnc_campaignGetNearestTile) select 1) == _sideEnemy) then {
				_picked = [_candidate, _recon];
			};
		};
		sleep 0.5;
	};

	_locations = _deferred + _locations;
	_picked
};

//Start a new AO (spawns MCC_fnc_MWinitMission, the generation itself is queued by MCC_fnc_MWgenLock)
private _fnc_startAO = {
	params ["_AOlocation","_reconMission"];
	private _AOlocationPos = _AOlocation select 0;
	private _AOlocationName = _AOlocation select 1;
	private _aoId = format ["campaignAO_%1", ["MCC_campaignAOid",1] call bis_fnc_counter];

	private _totalEnemyUnits = (_totalPlayers/2)*_difficulty;
	private _isCQB =  (count (nearestObjects [_AOlocationPos,["House","Ruins","Church","FuelStation","Strategic"],200])) > 2;
	private _isCiv = false;
	private _animals = random 1 > 0.5;
	private _vehicles = (random 100 < (_difficulty)*2) && (_missionsStarted >= 3); //No vehicles in the first 3 missions
	private _armor = (random 100 < (_difficulty)) && (_missionsStarted >= 4); //No armor in the first 4 missions;
	private _artillery = if ((random 100 < (_difficulty)*2) && (_missionsStarted >= 3)) then {[1,1,1,1,2] call BIS_fnc_selectRandom} else {0}; //No artillery in the first 3 missions;
	private _isRoadblocks = random 1 > 0.5;
	private _isIED = random 1 > 0.7;
	private _isAS = random 1 > (missionNamespace getvariable [format ["MCC_civRelations_%1",_sidePlayer],0.5]);
	private _isSB = random 1 > (missionNamespace getvariable [format ["MCC_civRelations_%1",_sidePlayer],0.5]);
	private _reinforcement =if (random 100 < (_difficulty)*2 || _reconMission) then {[1,1,1,1,2] call BIS_fnc_selectRandom} else {0};
	private _obj1 = if (_reconMission) then {["Destroy Vehicle","Destroy AA","Destroy Artillery","Destroy Weapon Cahce","Destroy Fuel Depot","Secure HVT","Kill HVT","Acquire Intel","Download Intel"] call BIS_fnc_selectRandom} else {["Destroy Vehicle","Destroy AA","Destroy Artillery","Destroy Weapon Cahce","Destroy Fuel Depot","Secure HVT","Kill HVT","Acquire Intel","Download Intel","Capture Area","Capture Area","Capture Area","Capture Area","Capture Area","Capture Area","Capture Area","Capture Area","Disarm IED"] call BIS_fnc_selectRandom};
	private _obj2 = if (random 80 < _difficulty) then {"Destroy Radar/Radio"} else {"None"};
	private _sideObjectives = ["Destroy Vehicle","Destroy AA","Destroy Artillery","Destroy Weapon Cahce","Destroy Fuel Depot","Secure HVT","Kill HVT","Acquire Intel","Disarm IED"];
	private _objectivesList = [_obj1, _obj2];

	//3rd objective and, when MCC_MWmaxObjectives > 3, extra ones - each with a difficulty based chance
	private _maxObjectives = (round (missionNamespace getVariable ["MCC_MWmaxObjectives",3])) max 3 min 8;
	for "_i" from 3 to _maxObjectives do {
		_objectivesList pushBack (if (random 80 < _difficulty) then {selectRandom _sideObjectives} else {"None"});
	};

	private _weatherChange = 0;
	private _preciseMarkers = false;

	diag_log format ["MCC campaign: starting AO %1 at %2 (%3) recon: %4 objectives: %5", _aoId, _AOlocationPos, _AOlocationName, _reconMission, _objectivesList];

	[
		[_AOlocation, _totalEnemyUnits,  100, _AOSize, _weatherChange, _preciseMarkers, _playMusic],
		[_sideEnemy, _factionEnemy, _sidePlayer, _factionPlayer, _factionCiv],
		_objectivesList,
		[_isCQB, _isCiv, _armor, _vehicles, _reconMission, _isIED, _isAS, _isSB, _isRoadblocks, _animals],
		[_reinforcement, _artillery],
		_aoId
	] spawn MCC_fnc_MWinitMission;

	_missionsStarted = _missionsStarted + 1;
	_activeAOs pushBack [_aoId, _AOlocationPos, _AOlocationName, _reconMission, 0, _obj2, 0, diag_tickTime];
};

//AO finished generating: radio tower CAS, night atmosphere, tickets snapshot
private _fnc_AOrunning = {
	params ["_ao"];
	_ao params ["_aoId","_AOlocationPos","_AOlocationName","_reconMission","_ticketsStart","_obj2"];

	//CAS
	if (_obj2 == "Destroy Radar/Radio") then {
		private _tower = _AOlocationPos nearObjects [(missionNamespace getVariable ["MCC_MWRadio",["Land_TTowerBig_2_F"]]) select 0, (_AOSize*2.5)];
		if (count _tower > 0) then {
			[_tower select 0,_sideEnemy, _factionEnemy, _sidePlayer] spawn {
				params ["_tower","_sideEnemy","_factionEnemy","_sidePlayer"];

				sleep (60 + (random 120));
				while {(alive _tower)} do {
					[_tower,_sideEnemy, _factionEnemy, _sidePlayer] call MCC_fnc_enemyCAS;
					sleep (480 + (random 480));
				};
			};
		};
	};

	//If night mission remove NV from AI and add falshlight to build atmoshphere
	if (sunOrMoon < 1) then {
		{
			private _unit = _x;
			if !(isPlayer _unit) then {
				{
					_unit unassignItem _x;
					_unit removeItem _x;
				} foreach ["NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP"];

				if !("acc_flashlight" in primaryWeaponItems _unit) then {
					_unit addPrimaryWeaponItem "acc_flashlight";
				};
				_unit enablegunlights "forceOn";
			};
		} foreach (_AOlocationPos nearObjects ["Man", _AOSize*4]);
	};

	_ao set [4, [_sidePlayer] call BIS_fnc_respawnTickets];
	_ao set [6, 1];
};

//AO done: rewards, delete its objectives, clean up, borders
private _fnc_AOdone = {
	params ["_ao"];
	_ao params ["_aoId","_AOlocationPos","_AOlocationName","_reconMission","_ticketsStart"];

	//Get the objectives of this AO
	private _objectives = (allMissionObjects "MCC_ModuleObjective_FCurator") select {(_x getvariable ["MCC_customTask",false]) && {(_x getVariable ["MCC_MWmissionId",""]) == _aoId}};

	private _activeObjectivesSide1 = _objectives select {_sidePlayer in (_x getvariable ["RscAttributeOwners",[]])};
	private _activeObjectivesSide2 = _objectives select {_sidePlayer2 in (_x getvariable ["RscAttributeOwners",[]])};

	private _failedObjectivesSide1 = _activeObjectivesSide1 select {(_x getvariable ["RscAttributeTaskState",""]) != "Succeeded"};
	private _failedObjectivesSide2 = _activeObjectivesSide2 select {(_x getvariable ["RscAttributeTaskState",""]) != "Succeeded"};

	sleep 2;
	private _ticketsEnd = [_sidePlayer] call BIS_fnc_respawnTickets;
	private _sumTickets = _ticketsStart - _ticketsEnd;

	if (_sidePlayer != sideLogic) then {
		["Main",count _activeObjectivesSide1,count _failedObjectivesSide1,_sidePlayer,_totalPlayers,_difficulty,60,[0.2,0.4,0.2,0.15,0.05],_sumTickets] spawn MCC_fnc_missionDone;
	};

	if (_sidePlayer2 != sideLogic) then {
		["Main",count  _activeObjectivesSide2,count _failedObjectivesSide2,_sidePlayer2,_totalPlayers,_difficulty,60,[0.2,0.4,0.2,0.15,0.05]] spawn MCC_fnc_missionDone;
	};

	//delete this AO's objectives (other AOs keep theirs)
	{deleteVehicle _x} forEach ((allMissionObjects "MCC_ModuleObjective_FCurator") select {(_x getVariable ["MCC_MWmissionId",""]) == _aoId});

	//clean up
	[_AOlocationPos,_AOSize*2] spawn {
		params [["_AOlocationPos",[0,0,0],[[],objNull]],
				["_AOSize",200,[0]]
			   ];

		while {{_x distance2D _AOlocationPos < _AOSize} count (allPlayers - entities "HeadlessClient_F") > 0} do {sleep 10};
		[_AOlocationPos,_AOSize,0] call MCC_fnc_deleteBrush
	};

	if !(_reconMission) then {
		//Expend borders
		private _markerColor = switch (_sidePlayer) do
								{
									case west: {"ColorWEST"};
									case resistance: {"ColorGUER"};
									case east: {"ColorEAST"};
									default	{""};
								};
		{
			_x setMarkerColor _markerColor;
			_x setMarkerAlpha 0.2;
		} foreach ([_sideEnemy,false] call MCC_fnc_campaignGetBorders);
	};

	_missionDone = _missionDone + 1;
	_difficulty = (_difficulty * 1.1) min 60;
};

//main mission loop
while {true} do {
	private _maxAOs = (round (missionNamespace getVariable ["MCC_campaignMaxAOs",1])) max 1 min 3;

	//Start AOs until we have enough running
	while {count _activeAOs < _maxAOs && {_missionsStarted <= _missionMax} && {count _locations > 0}} do {
		//update borders
		{
			_x setMarkerAlpha 0.4;
		} forEach ([_sideEnemy] call MCC_fnc_campaignGetBorders);

		private _picked = call _fnc_pickLocation;
		if (count _picked == 0) exitWith {};

		_picked call _fnc_startAO;
		sleep 5;
	};

	//Nothing running and nothing to start: done (won if we ran out of enemy locations before the mission limit)
	if (count _activeAOs == 0) exitWith {
		_campaignWon = _missionsStarted <= _missionMax;
	};

	//Follow the running AOs
	{
		private _ao = _x;
		private _aoId = _ao select 0;
		private _running = missionNamespace getVariable [format ["MCC_MWMissionRuning_%1",_aoId],false];

		if ((_ao select 6) == 0) then {
			if (_running) then {
				[_ao] call _fnc_AOrunning;
			} else {
				//Generation never came up (should not happen) - drop the AO
				if (diag_tickTime > ((_ao select 7) + 1800)) then {
					diag_log format ["MCC campaign: AO %1 did not start in time, dropped", _aoId];
					_activeAOs deleteAt (_activeAOs find _ao);
				};
			};
		} else {
			if (!_running) then {
				[_ao] call _fnc_AOdone;
				missionNamespace setVariable [format ["MCC_MWMissionRuning_%1",_aoId],nil,true];
				_activeAOs deleteAt (_activeAOs find _ao);
			};
		};
	} forEach (_activeAOs select {true});	//shallow copy: records stay shared with _activeAOs

	sleep 5;
};

if (_campaignWon) exitWith {
	//Mission won outro
	["everyonewon"] remoteExec ["BIS_fnc_endMissionServer", 2]
};

//Mission over
["sidetickets"] call  BIS_fnc_endMissionServer;
