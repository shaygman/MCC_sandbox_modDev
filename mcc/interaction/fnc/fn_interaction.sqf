//==================================================================MCC_fnc_interaction=========================================================================================
// Interaction perent
//==============================================================================================================================================================================
private ["_targets","_null","_selected","_objects","_dir","_target","_vehiclePlayer","_airports","_counter","_searchArray","_sides","_positionStart","_positionEnd","_pointIntersect","_break","_interactiveObjects","_objArray","_keyName","_key","_text","_objects","_headPos","_upFront","_closeObject","_array"];
disableSerialization;
_break = false;
_text = "";

MCC_interactionKey_holding = _this select 0;


//Find out the key
if (MCC_isCBA) then {
	_key = ["MCC","interactionKey"] call CBA_fnc_getKeybind;
	if (((_key select 5) select 1) select 0) then {_text = "Shift + "};
	if (((_key select 5) select 1) select 1) then {_text = _text + "Ctrl + "};
	if (((_key select 5) select 1) select 2) then {_text = _text + "Alt + "};
	_keyName = format ["%1%2",_text,keyName ((_key select 5) select 0)];

} else {
	waituntil {!isnil "MCC_keyBinds"};

	_key = MCC_keyBinds select 4;
	if (_key select 0) then {_text = "Shift + "};
	if (_key select 1) then {_text = _text + "Ctrl + "};
	if (_key select 2) then {_text = _text + "Alt + "};
	_keyName = format ["%1%2",_text,keyName (_key select 3)];
};

//Fails safe if ui get stuck
if (time > (player getVariable ["MCC_interactionActiveTime",time-5])+10) then {player setVariable ["MCC_interactionActive",false]};

//If we are busy quit
if ((player getVariable ["MCC_interactionActive",false]) || (time < (player getVariable ["MCC_interactionActiveTime",time-5])+0.3) || dialog) exitWith {};

player setVariable ["MCC_interactionActiveTime",time];

//Get objects for survival
_objArray = missionNamespace getVariable ["MCC_SurvivalPlaceHoldersObjects",[] call MCC_fnc_getSurvivalPlaceHolders];

//if ACE is on use it only to halt AI and open doors
if (missionNamespace getVariable ["MCC_isACE",false]) exitWith {

	if (vehicle player == player) then {
		_target = cursorTarget;
		player reveal _target;

		//Try to halt AI
		if (_target isKindof "CAManBase" && (player distance _target < 30)) then {

			//Cant neturalize friendly units
			if ([_target] call MCC_fnc_canHaltAI) then {

				[_target] call MCC_fnc_doHaltAI;
			};
		};

		//Handle house
		if (_target isKindof "house" || _target isKindof "wall") then {
			private ["_door","_animation","_phase","_tempArray"];

			_tempArray = [_target]  call MCC_fnc_isDoor;
			_door = _tempArray select 0;
			_animation = _tempArray select 1;
			_phase = _tempArray select 2;

			[_target,_door,_phase,_animation] call MCC_fnc_doorHandle;
		};
	};
};

//Outside of vehicle
if (vehicle player == player) then {
	_target = cursorTarget;
	player reveal _target;

	if (isNull _target) then {
		_headPos = player selectionPosition "head";
		_upFront = player modelToWorld [(_headPos select 0),(_headPos select 1)+3,(_headPos select 2)];
		_objects = (lineintersectsWith [ATLToASL (player modelToWorld _headPos), ATLToASL _upFront, objNull, objNull, true]);

		if (count _objects > 0) then {
			_target = _objects select 0;
		};
	};

	_objects = player nearObjects [MCC_dummy,10];

	//Handle IED
	if (count _objects > 0) then {
		_selected = ([_objects,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy) select 0;
		_dir	  = [player, _selected] call BIS_fnc_relativeDirTo;
		if (_dir>340 || _dir < 20) exitWith {
			//IED
			if (((_selected getVariable ["MCC_IEDtype",""]) == "ied") && !(_selected getVariable ["MCC_isInteracted",false])) then {
				_null= [player,_selected] call MCC_fnc_interactIED;
				_break = true;
			};
		};
	};

	if (_break) exitWith {};

	if (_target isKindof "weaponHolderSimulated") then {
		_objects = _target nearObjects ["man", 5];
		{
			if (alive _x) then {_objects set [_foreachIndex,-1]};
		} foreach _objects;
		_objects = _objects - [-1];

		{
			_objects set [_forEachIndex, [_x distance _target, _x]];
		} forEach _objects;
		_objects sort true;

		_target = (_objects select 0) select 1;
	};

	//Handle supply crate
	if (typeof _target in (missionNamespace getVariable ["MCC_logisticsCrates_TypesWest",[]]) ||
	    typeof _target in (missionNamespace getVariable ["MCC_logisticsCrates_TypesEast",[]])) exitWith {
		_null= [_target] call MCC_fnc_interactUtility;
		_break = true;
	};

	//Handle house
	if ((_target isKindof "house" || _target isKindof "wall" || _target isKindof "AllVehicles" || _target isKindof "ReammoBox_F" || _target isKindOf "Thing") && !(_target isKindof "CAManBase")) exitWith
	{
		_null= [_target] call MCC_fnc_interactDoor
	};

	//Handle man
	if (_target isKindof "CAManBase" && (player distance _target < 30)) exitWith {
		_null= [_target, player,_keyName] call MCC_fnc_interactMan;
		player setVariable ["MCC_interactionActive",false];
		_break = true;
	};

	if (_break) exitWith {};

	//Not MCC object
	_positionStart 	= eyePos player;
	_positionEnd 	= ATLtoASL screenToWorld [0.5,0.5];
	_pointIntersect = lineIntersectsWith [_positionStart, _positionEnd, player, objNull, true];
	if (count _pointIntersect > 0 && (missionNamespace getVariable ["MCC_surviveMod",false]) && (missionNamespace getVariable ["MCC_surviveModAllowSearch",false])) then {
		_selected = _pointIntersect select ((count _pointIntersect)-1);

		if (player distance _selected < 20) exitWith {
			if (missionNamespace getVariable ["MCC_debug",false]) then {systemChat str _selected; copyToClipboard "MCC Items Name: " + str _selected};
			if ((({[_x , str _selected] call BIS_fnc_inString} count _objArray)>0) && (isNull attachedTo _selected)) then {
				missionNameSpace setVariable ["MCC_interactionObjects", [[getpos _selected, format ["Hold %1 to search",_keyName]]]];

				[_selected] call MCC_fnc_interactObject;
				_break = true;
			};
		};
	};

	if (_break) exitWith {};
} else {
	if (!(missionNamespace getVariable ["MCC_interactionKey_holding",false])) exitWith {};

	MCC_fnc_vehicleCargoMenuClicked = {
		private ["_ctrl","_index","_ctrlData","_object","_animation","_phase","_door","_locked"];
		disableSerialization;

		_ctrlData	= param [0,"",[""]];
		_object		= vehicle player;

		switch (true) do {
			case (_ctrlData in ["commander","driver"]) : {player action [format ["moveTo%1",_ctrlData], _object]};
			case (_ctrlData == "cargo") : {player action ["MoveToCargo", _object, (_object emptyPositions "cargo")-1]};
			case (_ctrlData == "load") : {[player] call MCC_fnc_loadTruckUI};
			case (_ctrlData == "dropOff") : {[] call MCC_fnc_requestDropOff};
			case (["gunner",_ctrlData] call BIS_fnc_inString) : 	{
				call compile format ["player action ['MoveToTurret',vehicle player,%1]",([_ctrlData,"[01234567890]"] call BIS_fnc_filterString)];
			};
			case (["ils" , _ctrlData] call BIS_fnc_inString) :	{
				//find the right runway from the data we gave - we have to filter it
				((player getVariable ["interactWith",[]]) select call compile ([_ctrlData,"1234567890"] call BIS_fnc_filterString)) call MCC_fnc_ilsChilds;
			};
			case (_ctrlData == "abort") : {player setVariable ["MCC_ILSAbort",true]};
			case (_ctrlData == "reel") : {_object call MCC_fnc_attachPod};
			case (_ctrlData == "releasepod") : {_object call MCC_fnc_releasePod};
			case (_ctrlData == "artillery") : {_object call MCC_fnc_openArtillery};
			case (_ctrlData == "components") : {
				_array = [["[(missionNamespace getVariable ['MCC_interactionLayer_0',[]]),1] spawn MCC_fnc_interactionsBuildInteractionUI","Back",format ["%1mcc\interaction\data\iconBack.paa",MCC_path]]];
				private _cfgAnimationSources = "getText (_x >> 'source') == 'user' && getText (_x >> 'displayName') != ''" configClasses (configFile >> "CfgVehicles" >> typeof vehicle player >> "AnimationSources");

				{
					_array pushBack ([format ["vehicle player animateSource [%1,%2]",str configName _x, 1-((vehicle player) animationPhase configName _x) ],getText (_x >> "displayName"),getText (configfile >> "CfgVehicles" >> typeOf vehicle player >> "Icon")]);
				} forEach _cfgAnimationSources;

				[_array,1] call MCC_fnc_interactionsBuildInteractionUI;
			};
		};
	};

	_vehiclePlayer = vehicle player;

	_displayName 	= getText (configfile >> "CfgVehicles" >> typeof _vehiclePlayer >> "displayName");
	_pic		 	= getText (configfile >> "CfgVehicles" >> typeof _vehiclePlayer >> "picture");

	_array 			= [["closeDialog 0",_displayName,_pic]];

	//Generic Vehicle action
	_cargoUnits 	= assignedCargo _vehiclePlayer;
	_gunnerUnits 	= [gunner _vehiclePlayer];
	_driverUnits 	= [driver _vehiclePlayer];
	_commanderUnits = [commander _vehiclePlayer];
	{
		if ((((_vehiclePlayer emptyPositions _x)>0) ||
			(((_vehiclePlayer emptyPositions _x)==0) && (({!isPlayer _x && !isnull _x} count call compile format ["_%1Units",_x])>=1)))  &&
		    ((vectorUp _vehiclePlayer) select 2) >0 &&
			locked _vehiclePlayer <2) then
			{
				_locked = switch (_x) do {
								case "driver": {if (lockedDriver _vehiclePlayer) then {true} else {false}};
								default {false};
							};
				_array pushBack [format ["['%1'] spawn MCC_fnc_vehicleCargoMenuClicked",_x],format ["Move to %1 sit",if (_vehiclePlayer isKindof "air" && _x == "driver") then {"pilot"} else {_x}],format ["\A3\ui_f\data\igui\cfg\actions\getin%1_ca.paa",_x]];
			};
	} foreach ["commander","driver","cargo"];

	//turrets
	private ["_i","_entry","_turrets","_path","_count"];
	_entry = configFile >> "CfgVehicles" >> typeof _vehiclePlayer;
	_turrets = [_entry >> "turrets"] call BIS_fnc_returnVehicleTurrets;
	_path = [];
	_i = 0;
	_count 	= 0;
	while {_i < (count _turrets)} do {
		private ["_turretIndex", "_thisTurret","_unit"];
		_turretIndex 	= _turrets select _i;
		_thisTurret 	= _path + [_turretIndex];
		_unit 			= _vehiclePlayer turretUnit _thisTurret;

		if ((isNull _unit || (!isNull _unit && !isPlayer _unit)) && !(_vehiclePlayer lockedTurret _thisTurret) && (locked _vehiclePlayer <2)) then {
			_array pushBack [format ["['gunner%1'] spawn MCC_fnc_vehicleCargoMenuClicked",_thisTurret],format ["Move to %1",configName ((_entry >> "turrets") select _count)],"\A3\ui_f\data\igui\cfg\actions\getingunner_ca.paa"];
		};
		_i = _i + 2;
		_count = _count + 1;
	};

	//dropOff
	if ((player in (assignedCargo  _vehiclePlayer)) && (player == leader player) && !isnull driver _vehiclePlayer  && locked _vehiclePlayer <2) then
	{
		_array pushBack ["['dropOff'] spawn MCC_fnc_vehicleCargoMenuClicked","Request Drop-off",_pic];
	};

	//Logistics
	if ((typeof _vehiclePlayer in MCC_supplyTracks || (_vehiclePlayer isKindOf "helicopter" && ((getpos _vehiclePlayer) select 2) > 15)) && (player == driver _vehiclePlayer) && (speed _vehiclePlayer < 10) && (missionNamespace getVariable ["MCC_allowlogistics",true])) then
	{
		_array pushBack ["['load'] spawn MCC_fnc_vehicleCargoMenuClicked","Logistics",_pic];
	};

	//Artillery
	if (getNumber (configfile >> "CfgVehicles" >> typeof _vehiclePlayer >> "artilleryScanner") == 1) then
	{
		_array pushBack ["['artillery'] spawn MCC_fnc_vehicleCargoMenuClicked","Artillery Computer",_pic];
	};

	//MCC ILS
	if ((_vehiclePlayer isKindOf "air") && (player == Driver _vehiclePlayer)) then {
		_airports = [];
		_counter = 0;
		_searchArray = if (MCC_isMode) then {allMissionObjects "mcc_sandbox_moduleILS"} else {allMissionObjects "logic"};

		{
			_sides = _x getVariable ["MCC_runwaySide",-1];
			_sides = if (_sides isEqualTo -1) then {[east,west,resistance,civilian]} else {[_sides call bis_fnc_sideType]};

			if (typeName (_x getVariable ["MCC_runwayDis",0]) isEqualTo typeName 0) then {
				if (((_x getVariable ["MCC_runwayDis",0])>0) && (playerside in _sides)) then
				{
					_airports set [_counter,[_x,(_x getVariable ["MCC_runwayName","Runway"]),(_x getVariable ["MCC_runwayDis",0]),(_x getVariable ["MCC_runwayAG",objNull]),(_x getVariable ["MCC_runwayCircles",true])]];
					_counter = _counter +1;
				};
			};
		} foreach _searchArray;

		if (player getVariable ["MCC_ILSAbort",true]) then
		{
			{
				_array pushBack [format ["['ils_%1'] spawn MCC_fnc_vehicleCargoMenuClicked",_foreachIndex],format ["Land %1",_x select 1],_pic];
			} foreach _airports;
		}
		else
		{
			_array pushBack ["['abort'] spawn MCC_fnc_vehicleCargoMenuClicked","Abort ILS",_pic];
		};

		player setVariable ["interactWith",_airports];
	};

	//Pylon change
	if ((player == leader _vehiclePlayer) &&
	    (speed _vehiclePlayer <= 0) &&
	    ({_x getVariable ["MCC_fnc_pylonsChangeSource",false]} count (position player nearObjects 100) > 0)
	   ) then {
	   	_array pushBack ["[false,vehicle player] spawn MCC_fnc_pylonsChange","Rearm",format ["%1data\IconAmmo.paa",MCC_path]];
	};

	//Components
	if ((player == leader _vehiclePlayer) &&
	    (speed _vehiclePlayer <= 10) &&
	    count ("getText (_x >> 'source') == 'user' && getText (_x >> 'displayName') != ''" configClasses (configFile >> "CfgVehicles" >> typeof _vehiclePlayer >> "AnimationSources")) > 0
	   ) then {
	   	_array pushBack ["['components'] spawn MCC_fnc_vehicleCargoMenuClicked","Components",format ["%1data\IconRepair.paa",MCC_path]];
	};

	//Taru pods
	if ((_vehiclePlayer isKindOf "O_Heli_Transport_04_F") && (player == Driver _vehiclePlayer)&& isnull(_vehiclePlayer getVariable ["MCC_attachedPod",objnull])) then
	{
		_attachedCargo = (ropeAttachedObjects _vehiclePlayer) select 0;
		if (!isnil "_attachedCargo") then
		{
			if (_attachedCargo isKindOf "Pod_Heli_Transport_04_base_F") then
			{
				_array set [count _array,["reel",format ["Reel in %1",getText (configfile >> "CfgVehicles" >> typeof _attachedCargo >> "displayName")],_pic]];
			};
		};
	};

	//Taru pods
	if ((_vehiclePlayer isKindOf "O_Heli_Transport_04_F") && (player == Driver _vehiclePlayer) && !isnull(_vehiclePlayer getVariable ["MCC_attachedPod",objnull])) then {
			_array pushBack ["['releasepod'] spawn MCC_fnc_vehicleCargoMenuClicked",format ["Drop %1",getText (configfile >> "CfgVehicles" >> typeof (_vehiclePlayer getVariable ["MCC_attachedPod",objnull]) >> "displayName")],_pic];
	};

	//Open dialog
	if (count _array == 1) exitWith {player setVariable ["MCC_interactionActive",false]};
	[_array,0] call MCC_fnc_interactionsBuildInteractionUI;
	waituntil {dialog};
	waituntil {!dialog};
};

if !(_break) then {
	player setVariable ["MCC_interactionActive",false];
};