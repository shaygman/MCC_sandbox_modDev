/*===================================================================MCC_fnc_LHDspawn=====================================================================================
	Spawn CUP LHD at a given position and set it as a MCC's start location
 	Example: [_pos,_dir,_loadVehicleCargo] spawn MCC_fnc_LHDspawn

 		<IN>
		0:	ARRAY/OBJECT - position or Object
		1:	INTEGER	 - direction of LHD
		2: 	SIDE	- side of the owner
		3: 	BOOLEAN	- if true the LHD will act as a spawning pos
		4: 	BOOLEAN	- if true will spawn CUP LHD otherwise will spawn A3 LHD


		<OUT>
		Name of the LHD
==================================================================================================================================================================*/
private ["_shipParts","_dir","_shipPos","_objects","_parts","_heliPads","_cargoPos","_ship","_pos","_markers","_typeName","_LHDType","_ships","_defualtName","_storePos","_fnc_spawnWeapons"];

#define MCC_billboard   "Land_Noticeboard_F"
#define	MCC_AA_SAM	 	"B_SAM_System_02_F"
#define	MCC_AA_AAA	 	"B_AAA_System_01_F"
#define	MCC_AA_PATRO 	"B_SAM_System_01_F"
#define	MCC_AA_MRLS 	"B_Ship_MRLS_01_F"
#define	MCC_AA_CANON 	"B_Ship_Gun_01_F"
#define	MCC_BOAT_RACK 	"Land_Destroyer_01_Boat_Rack_01_F"
#define	MCC_HELIPAD		"Land_HelipadSquare_F"
#define	MCC_ANCHOR	"Box_FIA_Support_F"


params [
	["_pos", objNull, [objNull,[]]],
	["_dir", 0, [0]],
	["_side", west, [west]],
	["_hq", true, [true]],
	["_LHDType",0,[false,0]],
	["_displayName","",[""]],
	["_store",true,[true]],
	["_rearm",true,[true]]
];

if (!isServer) exitWith {};

//CLose Curator
if ( !isNull(findDisplay 312) ) then {(findDisplay 312) closeDisplay 1};

_markers = [];

//If pos is an object
if (typeName _pos isEqualTo typeName objNull) then {
	_dummy = _pos;
	_dir = getDir _pos;
	_pos = getPos _pos;
	deleteVehicle _dummy;
};


if (!(isClass (configFile >> "CfgVehicles" >> "CUP_LHD_BASE")) && (_LHDType == 3)) exitWith {
	private ["_str","_null"];
	_str = "<t size='0.8' t font = 'puristaLight' color='#FFFFFF'>" + "CUP Addon is required" + "</t>";
	_null = [_str,0,1.1,2,0.1,0.0] spawn bis_fnc_dynamictext;
};



switch (_LHDType) do
{
	case 0: //Destroyer
	{
		_ship = "Land_Destroyer_01_base_F" createVehicle _pos;
		_storePos = [-10,63,9];
	};

	case 1: //Carrier
	{
		_ship = "Land_Carrier_01_base_F" createVehicle _pos;
		_storePos = [-20,90,24];
	};

	case 2: //Submarine
	{
		_ship = "Submarine_01_F" createVehicle _pos;
		_storePos = [10,0,1];
	};

	case 3: //CUP
	{
		_ship = createSimpleObject ["CUP_LHD_BASE", _pos];
		_storePos = [-0.5,40,-4.5];
	};
};


//Spawn Ship
_ship setPosaslw _pos;
_ship setDir _dir;
_shipPos = getPosASL _ship;

//{_x addCuratorEditableObjects [[_ship],false]} forEach allCurators;


// Build Ship Parts
_shipParts = switch (_LHDType) do
			{
				case 0: //Destroyer
				{
					getArray (configFile >> "CfgVehicles" >> "Land_Destroyer_01_base_F" >> "multiStructureParts")
				};

				case 1: //Carrier
				{
					getArray (configFile >> "CfgVehicles" >> "Land_Carrier_01_base_F" >> "multiStructureParts")
				};

				case 2: //Submarine
				{
					[]
				};
				case 3: //CUP
				{
					getArray (configFile >> "CfgVehicles" >> "CUP_B_LHD_WASP_USMC_Empty" >> "shipParts")
				};
			};



_fnc_spawnWeapons = {
	params [
		["_ship",objNull,[objNull]],
		["_side",sideLogic,[sideLogic]],
		["_weapons",[],[[]]]
	];

	private ["_dummy"];

	{
		_dummy =([[0,0,0], 0, (_x select 0), _side] call bis_fnc_spawnvehicle) select 0;
		_dummy allowDamage false;
		_dummy setDir (_x select 2);
		_dummy attachTo [_ship,(_x select 1)];
		//{_x addCuratorEditableObjects [[_dummy],false]} forEach allCurators;
		detach _dummy;
		_dummy setDir (_x select 2);
		_dummy spawn {waitUntil {isTouchingGround _this}; _this allowDamage true};

		//If there is a script
		if (count _x > 3) then {
			_dummy spawn compile (_x select 3);
		};

	} forEach _weapons;
};

//build ship
switch (_LHDType) do
{
	case 0: //Destroyer
	{
		[_ship] call BIS_fnc_Destroyer01PosUpdate;
		//_ship remoteExec ["BIS_fnc_Destroyer01Init",0];
		sleep 2;


		//spawn mobile defense
		[_ship, _side,[
					[MCC_AA_MRLS,[0.0853271,-62.5142,14],180],
					[MCC_AA_CANON,[0.392456,-78.3921,15],180,'(group _this) setvariable ["MCC_canbecontrolled",true,true];'],
					[MCC_AA_SAM,[0.355652,50.5234,20],180],
					[MCC_AA_AAA,[0.0202637,-47.999,18],180],
					[MCC_AA_AAA,[0.394226,36.05,22],0],
					[MCC_BOAT_RACK,[11.7208,12.7422,8],0,'_this remoteExec ["BIS_fnc_BoatRack01Init",0,true];'],
					[MCC_BOAT_RACK,[-11.4057,12.835,8],0,'_this remoteExec ["BIS_fnc_BoatRack01Init",0,true];'],
					[MCC_HELIPAD,[0.876953,75.5786,9],0]
				  ]] spawn _fnc_spawnWeapons;

	};

	case 1: //Carrier
	{
		[_ship] call BIS_fnc_Carrier01PosUpdate;
		sleep 5;
		_ship remoteExec ["BIS_fnc_Carrier01Init",0];

		//spawn mobile defense
		[_ship, _side,[
					[MCC_AA_SAM,[30,175,24],0],
					[MCC_AA_SAM,[-40,179,24],0],
					[MCC_AA_SAM,[-30,-100,24],0],
					[MCC_AA_AAA,[-30,-105,21],0],
					[MCC_AA_AAA,[25,-115,20],0],
					[MCC_HELIPAD,[20,50,24],0],
					[MCC_HELIPAD,[37,70,24],0],
					[MCC_HELIPAD,[-22,-55,24],0],
					[MCC_HELIPAD,[5,-55,24],0],
					[MCC_HELIPAD,[-30,70,24],0],
					[MCC_HELIPAD,[-30,50,24],0]
				  ]] spawn _fnc_spawnWeapons;
	};

	case 3: //CUP
	{

		_ship setVariable ["CUP_WaterVehicles_BuildFinished",false];

		_ship setDir ((getDir _ship) - 180);

		_dir = getDir _ship;
		_shipPos = getPosASL _ship;

		_ship setVariable ["CUP_WaterVehicles_Dir",_dir];

		// diag_log str(_dir);

		//freeze all objects that arent the ship to prevent them from falling to the ground
		_objects = nearestObjects [_ship,[],(sizeOf (typeOf _ship))];

		{_x enableSimulationGlobal false;} forEach _objects;

		//spawn the ship
		_parts = [];
		{
			private ["_section"];
			_section = _x createVehicle _shipPos;
			_section setDir _dir;
			_section setPos _shipPos;

			_parts pushBack _section;
		} forEach _shipParts;

		//Store parts
		_ship setVariable ["CUP_WaterVehicles_shipParts",_parts];

		//hide but dont delete the helper so it can be accessed later if needed
		_ship hideObjectGlobal true;

		//give the surrounding objects their simulation back
		{_x enableSimulationGlobal true;} forEach _objects;

		_ship setVariable ["CUP_WaterVehicles_BuildFinished",true];


		// Spawn weapons and lights
		//[_ship] call CUP_fnc_spawnShipWeapons;
		[_ship] call CUP_fnc_spawnShipLights;

		if (is3DEN) then {
			[_ship] call CUP_fnc_EdenShip;
		} else {
			// Create heli pads
			_heliPads = [];
			{
				private ["_pad"];
				_pad = "HeliH" createVehicle [0,0,0];
				_pad attachTo [_ship,[0,0,0],_x];

				_heliPads pushBack _pad;
			} forEach (getArray (configFile >> "CfgVehicles" >> typeOf _ship >> "heliPads"));
			_ship setVariable ["CUP_WaterVehicles_heliPads",_heliPads];

			// Init CUP virtual vehicle cargo
			[_ship,"init"] call CUP_fnc_virtualVehicleCargo;

			// Move in cargo position
			_cargoPos = AGLToASL (_ship modelToWorld (_ship selectionPosition "player_cargo_pos"));
			_ship setVariable ["CUP_WaterVehicles_cargoPos",_cargoPos,true];
		};


		//Aresting gear
		private ["_temp_pos","_dummy","_logcClass"];

		//H (Invisable) Startfly
		_temp_pos = _ship modeltoworld [10,100,-4.5];
		_dummy = "HeliH" createVehicle _temp_pos;
		_dummy setDir ((getDir _ship));
		_dummy setPos _temp_pos;
		missionNamespace setVariable ["MCC_startfly",_dummy];
		publicVariable "MCC_startfly";

		//H (Invisable) Cables
		_temp_pos = _ship modeltoworld [10,-60,-4.5];
		_dummy = "HeliH" createVehicle _temp_pos;
		_dummy setDir ((getDir _ship));
		_dummy setPos _temp_pos;
		missionNamespace setVariable ["MCC_cables",_dummy];
		publicVariable "MCC_cables";

		//Arresting Gear trigger
		private ["_trg"];
		_trg = createTrigger ["EmptyDetector", _temp_pos];
		_trg setDir ((getDir _ship));
		_trg setPos _temp_pos;
		_trg setTriggerArea [15, 10, 0, false];
		_trg setTriggerActivation ["ANYPLAYER", "PRESENT", true];
		_trg setTriggerStatements ["this", "{[thisTrigger, _x] remoteExec ['MCC_fnc_arrestingGear',_x]} forEach thisList;", ""];

		//Arresting Gear marker
		_dummy = createmarker ["gear",_temp_pos];
		_dummy setMarkerShape "RECTANGLE";
		_dummy setMarkerSize [15, 10];
		_dummy setMarkerBrush "Solid";
		_dummy setMarkerColor "ColorRed";

		_markers pushBack _dummy;

		private ["_vehicle"];

		//Spawn two tractors
		{
			_vehicle = createVehicle ["CUP_B_TowingTractor_USMC", [0,0,0], [], 0, "NONE"];
			_vehicle allowDamage false;
			_vehicle setDamage 0;
			_vehicle attachTo [_ship, [0,0,1], _x];
			_vehicle setVariable ["CUP_WaterVehicles_LHD_respawnPosition", _x, true];

			while {!(isNull attachedTo _vehicle)} do  {detach _vehicle; sleep 0.1};
			_vehicle setDir (direction _ship);
			_vehicle allowDamage true;

			/*
			// For each vehicle add an action to detach from the ship - MP compliant
			[
				[_vehicle,[format ["%1 %2",localize "STR_CUP_CFG_RELEASEVEHICLE", (getText (configFile >> "CfgVehicles" >> "CUP_B_TowingTractor_USMC" >> "displayName"))], {[_this, "CUP_fnc_detachFromShip", _this select 0, false, true] call BIS_fnc_MP},nil, 1.5, false, true]],
				"addAction", true, true
			] call BIS_fnc_MP;
			*/

			{_x addCuratorEditableObjects [[_vehicle],false]} forEach allCurators;
		} forEach ["fd_cargo_pos_20","fd_cargo_pos_21"];


		//spawn mobile defense
		[_ship, _side,[
					[MCC_AA_AAA,[-8.4,-21.3,6],0],
					[MCC_AA_AAA,[13.6,123.8,-6.8],180],
					[MCC_AA_SAM,[-12.1,-33.6,2.5],0],
					[MCC_AA_SAM,[0,123,-5],1],
					[MCC_AA_PATRO,[-12.1,-41.1,3],0],
					[MCC_AA_PATRO,[-13.6,124.2,-6.8],0]
				  ]] spawn _fnc_spawnWeapons;

		//Create ILS
		_temp_pos = _ship modeltoworld [10,100,-4.5];
		_logcClass = if (missionNamespace getVariable ["MCC_isMode",false]) then {"mcc_sandbox_moduleILS"} else {"logic"};
		_dummy = (createGroup sideLogic) createunit [_logcClass, _temp_pos ,[],0.5,"NONE"];
		_dummy setPos _temp_pos;
		_dummy setVariable ["MCC_runwayName","LHD",true];
		_dummy setVariable ["MCC_runwayDis",100,true];
		_dummy setVariable ["MCC_runwaySide",-1,true];
		_dummy setVariable ["MCC_runwayCircles",true,true];
		_dummy setVariable ["MCC_runwayAG",(missionNamespace getVariable ["MCC_cables",objNull]),true];

		//Create Markers
		_dummy = createmarker ["MCC_LHD",_shipPos];
		_dummy setMarkerShape "RECTANGLE";
		_dummy setMarkerSize [20, 130];
		_dummy setMarkerBrush "Solid";
		_dummy setMarkerColor "ColorBlue";
		_markers pushBack _dummy;

		_dummy = createmarker ["MCC_LHD_NAME",(_ship modeltoworld [0,100,0])];
		_dummy setMarkerText "LHD";
		_dummy setMarkerColor "ColorBlack";
		_dummy setMarkerShape "ICON";
		_dummy setMarkerType "mil_dot";
		_markers pushBack _dummy;

		_ship setVariable ["MCC_LHDMarkers",_markers,true];
	};
};

//Set Ships as a service centers
if (_rearm) then {
	_ship setVariable ["MCC_fnc_pylonsChangeSource",true,true];
};

//Set vars
switch (_LHDType) do
{
	//Destroyer
	case 0:
	{
		_ship setVariable ["MCC_LHDType","BI_destroyer",true];
		_defualtName = "Destroyer";
	};

	//Carrier
	case 1:
	{
		_ship setVariable ["MCC_LHDType","BI_carrier",true];
		_defualtName = "Carrier";
	};

	//Submarine
	case 2:
	{
		_ship setVariable ["MCC_LHDType","BI_Submarine",true];
		_defualtName = "Submarine";
	};

	//CUP
	case 3:
	{
		_ship setVariable ["MCC_LHDType","CUP_lhd",true];
		_defualtName = "LHD";
	};
};

_ship setVariable ["MCC_isLHD",true,true];
_ship setVariable ["MCC_ShipType",_LHDType,true];	// 0- destroyer 1 - carrier 2- cup LHD
_ship setVariable ["teleport",1,true];
_ship setVariable ["MCC_side",_side,true];
_ship setVariable ["MCC_LHDDisplayName",if (_displayName isEqualTo "") then {_defualtName} else {_displayName}];

//Open dialog
if (_hq) then {
	_pos = getposasl _ship;
	_pos = _pos vectorAdd [0,0,17];
	_startLocationName = format ["MCC_START_%1", _side];
	missionNamespace setVariable [_startLocationName,_pos];
	publicVariable _startLocationName;
};

_ships = missionNamespace getVariable ["MCC_staticShips",[]];
_ships pushBack _ship;
missionNamespace setVariable ["MCC_staticShips",_ships];
publicVariable "MCC_staticShips";

//spawn store
if (_store) then {
	_dummy = MCC_billboard createVehicle (_ship modelToWorld [0,0,100]);
	_dummy attachTo [_ship,_storePos];
	_dummy allowDamage false;
	_dummy enableSimulationGlobal false;
	_dummy setObjectTexture [0,"\A3\boat_f\Boat_Armed_01\data\ui\Boat_Armed_01_minigun.paa"];
	_dummy setObjectTexture [1,'#(rgb,8,8,3)color(0.5,0.5,0.5,0.1)'];
	_dummy setObjectTexture [2,'#(rgb,8,8,3)color(0.5,0.5,0.5,0.1)'];
	[_dummy, ["<t color=""#ff1111"">Ship Control</t>", format ["[0,%1,2] spawn MCC_fnc_LHDspawnMenuInit", _ships find _ship]]] remoteExec ["addAction",0,true];
	//{_x addCuratorEditableObjects [[_dummy],false]} forEach allCurators;
};

//Create box
_storePos set [1, (_storePos select 1) + 2] ;
_storePos set [2, (_storePos select 2) + 1] ;
_dummy = MCC_ANCHOR createvehicle (_ship modelToWorld [0,0,100]);
_dummy allowDamage false;
_dummy setVariable ["mcc_delete",false,true];
_dummy setVariable ["mcc_mainBoxSide",_side,true];
_dummy setVariable ["MCC_kitSelect",["all"],true];
_dummy attachTo [_ship,_storePos];
0 = [_side, _dummy] spawn MCC_fnc_makeObjectVirtualBox;

sleep 1;

//Create start location
//[_ship, direction _ship, _side, "FOB",false,false] spawn MCC_fnc_buildSpawnPoint;
[_side,_ship] call BIS_fnc_addRespawnPosition;



_ship

