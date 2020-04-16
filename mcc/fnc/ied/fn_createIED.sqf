/*===================================================================MCC_fnc_createIED=================================================================================
 Create an IED mechnic (should run on server only).
	Example:

	[_this,_trapvolume,_IEDExplosionType,_IEDDisarmTime,_IEDJammable,_IEDTriggerType,_trapdistance,_iedside] spawn MCC_fnc_createIED

 Params:
 	_this:				OBJECT - the object that serve as the visual IED
 	_trapvolume:		STRING - explosion radius - "small","medium","large"
 	_IEDExplosionType:	INTEGER - explosion type:
 										0-deadly
 										1 - disabling (will cripple vehicles and soldiers but will not kill) 2 - Fake, will not or lightly wound soldiers.
 	_IEDDisarmTime		INTEGER - Time in second it will take to disarm the IED
 	_IEDJammable		BOOLEAN - true - if jammer vheicle (defined in MCC_IEDJammerVehicles) can jame this IED false if not
 	_IEDTriggerType		INTEGER - 	0- Proximity, will explode if unit from the targer side will move faster then a slow crouch,
 									1- radio will explode if unit from the targer side will get close to it, if assigned to spotter the spotter must be alive,
 									2- manual detontion, only mission maker
 	_trapdistance		INTEGER - Distance were target unit have to get close to the IED to set it off
 	_iedside			ARRAY - Array contains all the sides that will activate the IED [west, east, resistance, civilian]
=================================================================================================================================================================*/

//Made by Shay_Gman (c) 06.14
private ["_pos", "_IEDJammable", "_IEDTriggerType", "_IEDAmbushGroup", "_trapdistance", "_iedside", "_dummy","_ok","_iedDir","_init","_helper","_fnc_iedHandle","_time"];
disableSerialization;

if (!isServer) exitWIth {};

params [
		["_fakeIed",objNull,[objNull]],
		["_trapvolume","medium",["",[]]],
		["_IEDExplosionType",0,[0]],
		["_IEDDisarmTime",10,[0]],
		["_IEDJammable",true,[true]],
		["_IEDTriggerType",0,[0]],
		["_trapdistance",10,[0]],
		["_iedside",[west],[sideLogic,"",[]]]
	];

if (isNull _fakeIed) exitWith {diag_log "MCC Sandbox Error: MCC_fnc_createIED object null "};

_fnc_iedHandle = {
	private ["_nearObjects","_dummyMarker","_armed", "_triggered","_pos","_IedExplosion","_explode","_effect","_hidden","_fakeIed","_arrayTargets","_arrayECM"];

	params [
		["_dummy",objNull,[objNull]],
		["_trapvolume","medium",["",[]]],
		["_IEDExplosionType",0,[0]],
		["_IEDJammable",true,[true]],
		["_IEDTriggerType",0,[0]],
		["_trapdistance",10,[0]],
		["_iedside",[west],[[]]]
	];


	// Target classes that will triger the IED
	_armed 			= _dummy getvariable ["armed",true];		//Did the IED armed?
	_triggered 		= _dummy getvariable ["iedTrigered",false];	//Did the IED triggered?
	_fakeIed 		= _dummy getvariable ["fakeIed",objNull]; 	//The name of the fake IED object
	_explode 		= false; 									//Did the IED explode?

	_hidden = ["IEDLandSmall_Remote_Ammo","IEDLandBig_Remote_Ammo","IEDUrbanSmall_Remote_Ammo","IEDUrbanBig_Remote_Ammo"];

	//Proximity or radio
	while {alive _fakeIed
		   && (_dummy getvariable ["armed",true])
		   && !(_dummy getvariable ["iedTrigered",false])} do {
		sleep 0.4;

		//if not manual detonation
		if !(_IEDTriggerType in [2,4]) then	{
			_pos = getPos _dummy;
			_nearObjects = [];
			_nearObjects = (vehicles inAreaArray [_pos,_trapdistance,_trapdistance,0,false,1]);
			_nearObjects = +_nearObjects + (allUnits inAreaArray [_pos,_trapdistance,_trapdistance,0,false,1]);
			_arrayTargets = _nearObjects select {(speed _x > 5) && (side _x in _iedside)};

			_arrayECM = _pos nearObjects (missionNamespace getVariable ["MCC_iedJammeDistance",80]);
			_arrayECM = _arrayECM select {(_x getvariable ["MCC_ECM",false])};

			{
				if (isEngineOn _x) then {
					[["a3\missions_f_beta\data\sounds\firing_drills\drill_start.wss", _x]] remoteExec ["playSound3D", _x];
				};
			} forEach _arrayECM;

			if (count _arrayTargets > 0) then {
				if (!_IEDJammable) then {
					_dummy setvariable ["iedTrigered",true,true]
				} else {
					if (count _arrayECM <= 0) then {
						_dummy setvariable ["iedTrigered",true,true];
					};
				};
			};
		};
	};


	//delete IED marker
	_dummyMarker = _dummy getvariable "iedMarkerName";
	if (!isnil "_dummyMarker") then {
		[2,compile format ["deletemarkerlocal '%1';",_dummyMarker]] remoteExec ["MCC_fnc_globalExecute",0];
	};

	_armed 		= _dummy getvariable ["armed",false];
	_triggered 	= _dummy getvariable ["iedTrigered",false];

	//Broadcast to fakeIED
	_fakeIed setvariable ["armed",_armed,true];
	_fakeIed setvariable ["iedTrigered",_triggered,true];

	//position of the IED
	_pos=[((getposATL _fakeIed) select 0),(getposATL _fakeIed) select 1,((getPosATL _fakeIed) select 2)];

	switch (_IEDExplosionType) do {
		case 0:	{
			_IedExplosion = MCC_fnc_IedDeadlyExplosion;
		};

		case 1: {
		   _IedExplosion = MCC_fnc_IedDisablingExplosion;
		};

		case 2: {
		   _IedExplosion = MCC_fnc_IedFakeExplosion;
		};

		case 3: {
		   _IedExplosion = {};
		};
	};

	//If triger epxplosion or destroyed
	if ((_armed && _triggered) || (!alive _fakeIed && _armed )) then{
		[_pos,_trapvolume] spawn _IedExplosion;
		_explode = true;
	};

	if (!_armed ) then {
		//If IED critical fail while trying to disarm it
		if (_triggered) then {
			_time = time + 30 ;

			waituntil {(_dummy getvariable ["iedTrigered",false]) || time > _time};

			if (_dummy getvariable ["iedTrigered",false]) then {
				[_pos,_trapvolume] spawn _IedExplosion;
				_explode = true;
			};
		} else {
			if (typeOf _fakeIed in _hidden) then {deleteVehicle _fakeIed};
		};
	};

	sleep 0.2;
	if (_explode) then {
		//If IED is a car lets make it burn
		if (_fakeIed isKindOf "Car" || _fakeIed isKindOf "Wreck_Base") then {
			_fakeIed setdamage 1;
			_effect = "test_EmptyObjectForFireBig" createVehicle (getpos _fakeIed);
			_effect attachto [_fakeIed,[0,0,0]];
			_effect spawn
			{
				sleep 180 + random 360;
				while {!isnull (attachedTo _this)} do {detach _this};
				_nearObjects =  (getpos _this) nearObjects 3;
				{
					if (typeOf _x in ["test_EmptyObjectForFireBig","#particlesource","#lightpoint"]) then {deletevehicle _x};
				} foreach _nearObjects;
			};
		} else {
			if (str _IedExplosion != str {}) then {deletevehicle _fakeIed};
		};
	};

	//Delete helper
	sleep 2;
	[_dummy] spawn MCC_fnc_deleteHelper;

	//fail safe give the game enough time to read the variable from it before deleting it.
	sleep 1;
	if (typeOf _fakeIed in _hidden) then {deletevehicle _fakeIed};

	//Delete the dummyIED
	deletevehicle _dummy;
};

if (typeName _iedside == "STRING") then {
	_iedside = switch (tolower _iedside) do
				{
				   case "west":	{[west]};
				   case "east":	{[east]};
				   case "guer":	{[resistance]};
				   case "civ":	{[civilian]};
				   default {[west]};
				};
};

if (typeName _iedside == typeName sideLogic) then {_iedside = [_iedside]};

_pos 	= getposatl _fakeIed;
_iedDir =  getdir _fakeIed;

_dummy = createVehicle [MCC_dummy, _pos, [], 0, "NONE"];

//If it is a mini-game
if (_IEDTriggerType >=3) then {
	_dummy setVariable ["MCC_isIEDMiniGame",true,true];
} else {
	if (MCC_isACE) then {
		_dummy setVariable ["ACE_Explosives_Explosive",_fakeIed,true];
	};
};

hideObjectGlobal _dummy;
_dummy addEventHandler ["handleDamage",{_this call MCC_fnc_iedHit;0}];
_dummy attachto [_fakeIed,[0,0,0]];

[_fakeIed, _dummy] spawn
{
	private ["_fakeIedS"];
	_fakeIedS 	= _this select 0;
	_dummy 		= _this select 1;
	waituntil {!alive _fakeIedS || isnull _fakeIedS};
	sleep 1;
	deletevehicle _dummy;
};

_dummy setvariable ["fakeIed", _fakeIed ,true];
_dummy setvariable ["armed", true, true];
_dummy setvariable ["MCC_disarmTime", _IEDDisarmTime  , true];
_dummy setvariable ["iedMarkerName", "IED", true];
_dummy setvariable ["iedTrigered", false, true];
_dummy setvariable ["iedAmbush", false, true];
_dummy setvariable ["MCC_IEDtype", "ied", true];

//Create helper
[[_dummy,"Hold %1 to disarm"], "MCC_fnc_createHelper", false] call BIS_fnc_MP;

//If it is radio IED
if (_IEDTriggerType == 1) then {
	_dummy setvariable ["iedTrigereRadio", true, true];
} else {
	_dummy setvariable ["iedTrigereRadio", false, true];
};

_fakeIed setvariable ["realIed", _dummy ,true];

//Sync it with pre-sync IED
if (str (_fakeIed getVariable ["syncedObject", [0,0,0]]) != "[0,0,0]") then
{
	[[getpos _fakeIed , (_fakeIed getVariable ["syncedObject", [0,0,0]])],"MCC_fnc_iedSync",false,false] call BIS_fnc_MP;
};

//Spawn the IED script
_ok = [_dummy,_trapvolume,_IEDExplosionType,_IEDJammable,_IEDTriggerType,_trapdistance,_iedside] spawn _fnc_iedHandle;

[_dummy,_fakeIed];