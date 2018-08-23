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
private ["_shipParts","_dir","_shipPos","_objects","_parts","_heliPads","_cargoPos","_ship","_pos","_markers","_typeName","_LHDType","_ships","_defualtName"];

#define    MCC_billboard    "Land_Noticeboard_F"

params [
	["_pos", objNull, [objNull,[]]],
	["_dir", 0, [0]],
	["_side", west, [west]],
	["_hq", true, [true]],
	["_LHDType",0,[false,0]],
	["_displayName","",[""]],
	["_store",true,[true]]
];

//If pos is an object
if (typeName _pos isEqualTo typeName objNull) then {
	_dir = getDir _pos;
	_pos = getPosASL _pos;
};

if (!isServer) exitWith {};

//CLose Curator
if ( !isNull(findDisplay 312) ) then {(findDisplay 312) closeDisplay 1};

_markers = [];

/*
shipParts[] = {"CUP_LHD_1","CUP_LHD_2","CUP_LHD_3","CUP_LHD_4","CUP_LHD_5","CUP_LHD_6","CUP_LHD_7","CUP_LHD_house_1","CUP_LHD_house_2","CUP_LHD_elev_1","CUP_LHD_elev_2","CUP_LHD_Light2","CUP_LHD_Int_1","CUP_LHD_Int_2","CUP_LHD_Int_3"};

model = "\CUP\WaterVehicles\CUP_WaterVehicles_LHD\LHD_select_B.p3d";
*/

systemChat str _LHDType;
if (!(isClass (configFile >> "CfgVehicles" >> "CUP_LHD_BASE")) && (_LHDType == 2)) exitWith {
	private ["_str","_null"];
	_str = "<t size='0.8' t font = 'puristaLight' color='#FFFFFF'>" + "CUP Addon is required" + "</t>";
	_null = [_str,0,1.1,2,0.1,0.0] spawn bis_fnc_dynamictext;
};



switch (_LHDType) do
{
	case 2: //CUP
	{
		_ship = createSimpleObject ["CUP_LHD_BASE", _pos];
	};

	case 1: //Carrier
	{
		_ship = "Land_Carrier_01_base_F" createVehicle _pos;
	};

	default //Destroyer
	{
		_ship = "Land_Destroyer_01_base_F" createVehicle _pos;
	};
};

//Spawn Ship
_ship setPosasl _pos;
_ship setDir _dir;
_shipPos = getPosASL _ship;

//{_x addCuratorEditableObjects [[_ship],false]} forEach allCurators;


// Build Ship Parts
_shipParts = switch (_LHDType) do
			{
				case 2: //CUP
				{
					getArray (configFile >> "CfgVehicles" >> "CUP_B_LHD_WASP_USMC_Empty" >> "shipParts")
				};

				case 1: //Carrier
				{
					getArray (configFile >> "CfgVehicles" >> "Land_Carrier_01_base_F" >> "multiStructureParts")
				};

				default //Destroyer
				{
					getArray (configFile >> "CfgVehicles" >> "Land_Destroyer_01_base_F" >> "multiStructureParts")
				};
			};

if (count _shipParts == 0) exitWith {};

//build ship
switch (_LHDType) do
{
	case 2: //CUP
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
		//[_ship] call CUP_fnc_spawnShipLights;

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

			detach _vehicle;
			_vehicle setDir (direction _ship);
			_vehicle allowDamage true;

			// For each vehicle add an action to detach from the ship - MP compliant
			[
				[_vehicle,[format ["%1 %2",localize "STR_CUP_CFG_RELEASEVEHICLE", (getText (configFile >> "CfgVehicles" >> "CUP_B_TowingTractor_USMC" >> "displayName"))], {[_this, "CUP_fnc_detachFromShip", _this select 0, false, true] call BIS_fnc_MP},nil, 1.5, false, true]],
				"addAction", true, true
			] call BIS_fnc_MP;


			{_x addCuratorEditableObjects [[_vehicle],false]} forEach allCurators;
		} forEach ["fd_cargo_pos_20","fd_cargo_pos_21"];

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

	case 1: //Carrier
	{
		[_ship] call BIS_fnc_Carrier01PosUpdate;
		sleep 5;
		_ship remoteExec ["BIS_fnc_Carrier01Init",0];

		//spawn mobile defense
		{
			_dummy =([[0,0,0], 0, (_x select 0), _side] call bis_fnc_spawnvehicle) select 0;
			_dummy attachTo [_ship,(_x select 1)];
			{_x addCuratorEditableObjects [[_dummy],false]} forEach allCurators;
			detach _dummy;
		} forEach [
					["B_SAM_System_02_F",[30,175,23]],
					["B_SAM_System_02_F",[-40,179,23]],
					["B_SAM_System_02_F",[-30,-100,23]],
					["B_AAA_System_01_F",[-30,-105,20]],
					["B_AAA_System_01_F",[25,-115,19]]
				  ];

		//spawn store
		if (_store) then {
			_dummy = MCC_billboard createVehicle (_ship modelToWorld [0,0,100]);
			_dummy attachTo [_ship,[-20,80,24]];
			_dummy allowDamage false;
			_dummy enableSimulationGlobal false;
			_dummy setObjectTexture [0,"\A3\boat_f\Boat_Armed_01\data\ui\Boat_Armed_01_minigun.paa"];
			_dummy setObjectTexture [1,'#(rgb,8,8,3)color(0.5,0.5,0.5,0.1)'];
    		_dummy setObjectTexture [2,'#(rgb,8,8,3)color(0.5,0.5,0.5,0.1)'];
			[_dummy, ["<t color=""#ff1111"">Ship Control</t>", {[0,"",2] spawn MCC_fnc_LHDspawnMenuInit}]] remoteExec ["addAction",0,true];
			{_x addCuratorEditableObjects [[_dummy],false]} forEach allCurators;
		};
	};

	default //Destroyer
	{
		[_ship] call BIS_fnc_Destroyer01PosUpdate;
		sleep 5;
		_ship remoteExec ["BIS_fnc_Destroyer01Init",0];

		/*
		//spawn mobile defense
		{
			_dummy =([[0,0,0], 0, (_x select 0), _side] call bis_fnc_spawnvehicle) select 0;
			_dummy attachTo [_ship,(_x select 1)];
			{_x addCuratorEditableObjects [[_dummy],false]} forEach allCurators;
			detach _dummy;
		} forEach [
					["B_SAM_System_02_F",[30,175,23]],
					["B_SAM_System_02_F",[-40,179,23]],
					["B_SAM_System_02_F",[-30,-100,23]],
					["B_AAA_System_01_F",[-30,-105,20]],
					["B_AAA_System_01_F",[25,-115,19]]
				  ];

		//spawn store
		if (_store) then {
			_dummy = MCC_billboard createVehicle (_ship modelToWorld [0,0,100]);
			_dummy attachTo [_ship,[20,70,24]];
			_dummy allowDamage false;
			_dummy enableSimulationGlobal false;
			_dummy setObjectTexture [0,"\A3\boat_f\Boat_Armed_01\data\ui\Boat_Armed_01_minigun.paa"];
			_dummy setObjectTexture [1,'#(rgb,8,8,3)color(0.5,0.5,0.5,0.1)'];
    		_dummy setObjectTexture [2,'#(rgb,8,8,3)color(0.5,0.5,0.5,0.1)'];
			[_dummy, ["<t color=""#ff1111"">Ship Control</t>", {[0,"",2] spawn MCC_fnc_LHDspawnMenuInit}]] remoteExec ["addAction",0,true];
			{_x addCuratorEditableObjects [[_dummy],false]} forEach allCurators;
		};
		*/
	};
};

//Set vars
switch (_LHDType) do
{
	//CUP
	case 2:
	{
		_ship setVariable ["MCC_LHDType","CUP_lhd",true];
		_defualtName = "LHD";
	};

	//Carrier
	case 1:
	{
		_ship setVariable ["MCC_LHDType","BI_carrier",true];
		_defualtName = "Carrier";
	};

	//Destroyer
	default
	{
		_ship setVariable ["MCC_LHDType","BI_destroyer",true];
		_defualtName = "Destroyer";
	};
};

_ship setVariable ["MCC_isLHD",true,true];
_ship setVariable ["teleport",1,true];
_ship setVariable ["MCC_side",_side,true];
_ship setVariable ["MCC_LHDDisplayName",if (_displayName isEqualTo "") then {_defualtName} else {_displayName}];

//Create start location
[_side,_ship] call BIS_fnc_addRespawnPosition;

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

_ship

