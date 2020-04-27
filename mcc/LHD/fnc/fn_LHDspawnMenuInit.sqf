/*===================================================================MCC_fnc_LHDspawnMenuInit======================================================================
	Open the LHD spawn menu
 		<IN>
		0:	INTEGER - LHD level

		<OUT>
		None
==================================================================================================================================================================*/
params [
	["_deck", 0, [0,objNull,[],false]],
	["_lhdIndex", 0, [0,"",objNull,[],false]],
	["_operator", 0, [0,objNull,[],false]],
	["_changeShip", true, [true]]
];


//We came here from curator
if (typeName _deck == typeName objNull) exitWith {
	if ((local _deck) && !(isnull curatorcamera)) then {
		deleteVehicle _deck;
		while {dialog} do {closeDialog 0};

		[0,"",0] spawn MCC_fnc_LHDspawnMenuInit;
	};
};

//Start loading screen
["rsc_loadingScreen", "Loading Ship assets"] call BIS_fnc_startLoadingScreen;

private ["_ship","_camera","_display","_spawnPos","_pos","_dummy","_objects","_displayname","_index","_decks","_shipClass","_availableLHD","_vehicleType","_side"];

_availableLHD = [];
{
	if (!isNull _x &&
	    ((_x getVariable ["MCC_side",sideLogic]) isEqualTo playerSide)
	    ) then {

		_availableLHD pushBack _x;
	};
} forEach (missionNamespace getVariable ["MCC_staticShips",[]]);

if (count _availableLHD == 0) exitWith {
	private ["_str","_null"];
	_str = "<t size='0.8' t font = 'puristaLight' color='#FFFFFF'>" + "Spawn Static Ship First" + "</t>";
	_null = [_str,0,1.1,2,0.1,0.0] spawn bis_fnc_dynamictext;
};

if !(_lhdIndex isEqualType 0) then {_lhdIndex = 0};

//If we came here from a store then choose the ship and don't put any more ships
if (_lhdIndex > 0) then {
	_ship = (missionNamespace getVariable ["MCC_staticShips",[]]) select _lhdIndex;
} else{
	_ship = (_availableLHD select 0);
};

_lhdType = _ship getVariable ["MCC_LHDType",""];

if (isNull _ship || _lhdType isEqualTo "") exitWith {};

_side = _ship getVariable ["MCC_side",sideLogic];
_shipClass = _ship getVariable ["MCC_ShipType",0];

missionNamespace setVariable ["MCC_interatedLHD",_ship];

//init assets
{
	[_x, _side, "", true] call MCC_fnc_vehicleSpawnerBuildCostTable
} forEach ["vehicle","tank","heli","jet","ship"];

//End loading screen
"rsc_loadingScreen" call BIS_fnc_endLoadingScreen;

//Close all dialogs
while {dialog} do {
	closeDialog 0;
	sleep 0.1;
};

//CLose Curator
if ( !isNull(findDisplay 312) ) then {
	(findDisplay 312) closeDisplay 1;
	sleep 1;
};

if (isnil "MCC_LHD_CAM") then {
	private ["_ppgrain"];

	_pos = getposasl _ship;
	_camera = "camera" camcreate _pos;
	_camera cameraeffect ["internal","back"];
	_camera camPrepareFOV 1;
	_camera campreparefocus [-1,-1];
	_camera camSetTarget _ship;

	cameraEffectEnableHUD false;
	showCinemaBorder false;
	_camera camCommitPrepared 0;


	MCC_LHD_CAM = _camera;

	//Do a little cinematic when log in
	if (_changeShip) then {
		_camera camSetRelPos [100,0,1000];
		_camera camcommit 0;

		_ppgrain = ppEffectCreate ["radialBlur", 100];
		_ppgrain ppEffectAdjust [0.5, 0.5, 0.3, 0.3];
		_ppgrain ppEffectCommit 0;
		_ppgrain ppEffectEnable true;

		sleep 0.1;
		playsound "MCC_woosh";
		for "_i" from floor 1000 to 100 step -10 do
		{
			_camera camSetRelPos [100,0,_i];
			_camera camcommit 0.01;
			sleep 0.01;
		};

		ppEffectDestroy _ppgrain;
	};
};



createDialog "MCC_LHDSpawn";
_camera = missionNamespace getVariable ["MCC_LHD_CAM",objNull];

switch (_deck) do
{
	case 0:
	{
		switch (_shipClass) do
		{
			case 0:	//Destroyer
			{
				_camera camSetRelPos [100,0,55];
				_spawnPos = [[30,12.7422,0],[0.876953,80,9]];
			};

			case 1:	//Carrier
			{
				_camera camSetRelPos [100,0,100];
				_spawnPos = [[20,50,24],[37,70,24],[-22,-55,24],[5,-55,24],[-30,70,24],[-30,50,24],[-30,30,24],[-30,10,24],[-30,-10,24]];
			};

			case 2:	//Submarine
			{
				_camera camSetRelPos [60,0,60];
				_spawnPos = [[20,30,0],[20,15,0],[20,0,0],[20,-15,0],[20,-30,0]];
			};

			case 3:	//CUP LHD
			{
				_camera camSetRelPos [100,0,100];
				 _spawnPos = ["fd_cargo_pos_2","fd_cargo_pos_3","fd_cargo_pos_4","fd_cargo_pos_5","fd_cargo_pos_6","fd_cargo_pos_7","fd_cargo_pos_8","fd_cargo_pos_9","fd_cargo_pos_10","fd_cargo_pos_11","fd_cargo_pos_12","fd_cargo_pos_13","fd_cargo_pos_14","fd_cargo_pos_15","fd_cargo_pos_16","fd_cargo_pos_17","fd_cargo_pos_18","fd_cargo_pos_19"];
			};
		};
	};

	case 1:
	{
		switch (_shipClass) do
		{
			case 0:	//Destroyer
			{
				_camera camSetRelPos [-100,0,55];
				_spawnPos = [[-30,12.835,0],[0.876953,80,9]];
			};

			case 1:	//Carrier
			{
				_spawnPos = [];
			};

			case 2:	//Submarine
			{
				_spawnPos = [];
			};

			case 3:	//CUP LHD
			{
				_camera camSetRelPos [-4,50,-8];
				_spawnPos = ["veh_cargo_pos_8","veh_cargo_pos_9","veh_cargo_pos_13","veh_cargo_pos_14","veh_cargo_pos_18","veh_cargo_pos_19","veh_cargo_pos_10","veh_cargo_pos_11","veh_cargo_pos_12","veh_cargo_pos_15"];
			};
		};
	};

	case 2:
	{
		_camera camSetRelPos [-5,98,-8];
		_spawnPos = ["veh_cargo_pos_1","veh_cargo_pos_2","veh_cargo_pos_3","veh_cargo_pos_4","veh_cargo_pos_5"];
	};

	case 3:
	{
		_camera camSetRelPos [-4,50,-16];
		_spawnPos = ["veh_cargo_pos_29","veh_cargo_pos_30","veh_cargo_pos_31","veh_cargo_pos_32","veh_cargo_pos_33","veh_cargo_pos_34","veh_cargo_pos_35","veh_cargo_pos_36","veh_cargo_pos_37","veh_cargo_pos_38","veh_cargo_pos_39","veh_cargo_pos_40"];
	};

	case 4:
	{
		_camera camSetRelPos [0,110,-16];
		_spawnPos = ["veh_cargo_pos_41","veh_cargo_pos_42","veh_cargo_pos_43","veh_cargo_pos_44","veh_cargo_pos_45","veh_cargo_pos_46"];
	};
};

_camera camCommitPrepared 0;
camUseNVG (sunOrMoon < 0.5);
disableSerialization;

_display = uiNamespace getVariable ["MCC_LHD_MENU", displayNull];

_decks = switch (_shipClass) do
			{
				case 0:
				{
					["Portside","Starboard"];
				};

				case 1:
				{
					["Flight Deck"];
				};

				case 2:
				{
					["Deck"];
				};

				case 3:
				{
					["Flight Deck","Upper Deck Front","Upper Deck Back","Lower Deck","Well Deck"];
				};

				default
				{
					["Flight Deck"];
				};
			};

//Add decks control
{
	_ctrl = _display ctrlCreate ["RscButtonMenu", -1];
	_ctrl ctrlSetPosition [0.05*safezoneW+safezoneX, 0.05*safezoneH+safezoneY + (_foreachindex*0.06*safezoneH),0.1*safezoneW,0.05*safezoneH];
	_ctrl ctrlsetText _x;


	_ctrl ctrlAddEventHandler ["MouseButtonUp",format [
	    "
	   closeDialog 0;
	   [%1,%2,%3,false] spawn MCC_fnc_LHDspawnMenuInit;
	",_foreachindex, (_availableLHD find _ship),_operator]];

	_ctrl ctrlCommit 0;
} forEach _decks;

//If more then one carrier and a commander or a mission maker
if (_operator <=1) then {
	{
		_ctrl = _display ctrlCreate ["RscButtonMenu", -1];
		_ctrl ctrlSetPosition [0.21*safezoneW+safezoneX + (_foreachindex*0.11*safezoneW), 0.05*safezoneH+safezoneY ,0.1*safezoneW,0.05*safezoneH];
		_ctrl ctrlsetText (_x getVariable ["MCC_LHDDisplayName","Ship"]);


		_ctrl ctrlAddEventHandler ["MouseButtonUp",format [
		    "
		   closeDialog 0;
		   [%1, %2, %3] spawn MCC_fnc_LHDspawnMenuInit;
		",0,(_availableLHD find _x),_operator]];

		_ctrl ctrlCommit 0;
	} forEach _availableLHD;
};

//Add exit ctrl
_ctrl = _display ctrlCreate ["RscButtonMenu", -1];
_ctrl ctrlSetPosition [0.85*safezoneW+safezoneX, 0.85*safezoneH+safezoneY,0.1*safezoneW,0.05*safezoneH];
_ctrl ctrlsetText "Exit";
_ctrl ctrlAddEventHandler ["MouseButtonUp","closeDialog 0"];
_ctrl ctrlCommit 0;
sleep 0.1;

//Build SpawnPos
_objects = [];
{
	_dummy = "HeliH" createVehicle [0,0,0];
	waitUntil {alive _dummy};

	switch (_shipClass) do
	{
		case 3: {_dummy attachTo [_ship,[0,0,0],_x]};

		default {_dummy attachTo [_ship,_x]};
	};

	_pos = worldToScreen (getPosASL _dummy);
	_pos set [2,0.02*safezoneW];
	_pos set [3,0.03*safezoneH];

	if ((typeName (_pos select 0) isEqualTo typeName 0)) then {
		_ctrl = _display ctrlCreate ["RscButtonMenu", -1];
		_ctrl ctrlSetPosition _pos;
		_ctrl ctrlsetText (str _foreachindex);
		_ctrl ctrlSetBackgroundColor [0, 0, 0, 0.5];
		_ctrl ctrlAddEventHandler ["MouseButtonUp",format ["['updateSpawn',%1,'%2', %3] spawn MCC_fnc_LHDspawnVehicle",_deck, _x, _operator]];
		_ctrl ctrlCommit 0;
		_objects pushBack _dummy;
	};
	sleep 0.001;
} forEach _spawnPos;

{deleteVehicle _dummy} forEach _objects;

waitUntil {!dialog};

if !(isnil "MCC_LHD_CAM") then {MCC_LHD_CAM cameraeffect ["terminate","back"];camdestroy MCC_LHD_CAM;};
MCC_LHD_CAM = nil;