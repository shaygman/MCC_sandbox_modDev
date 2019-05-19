//============================================================MCC_fnc_paradrop======================================================================================
// Create a HALO or regular parachute jump for the given unit
//Example:[[pos,[_unit, unitID],halo,hight,jumperNumber],"MCC_fnc_paradrop",true,false] call BIS_fnc_MP;
// Params:
// 	pos: array, position.
//	,[unitID,_unit]: object and number, unit ID for the jump
//	halo:  boolean ,true - halo, false - parajump
//	hight:  number,jump hight
//  jumperNumber: number, jumper number if more then one is jumping inorder to spread them around
//=================================================================================================================================================================
private ["_pos", "_unit", "_halo","_height", "_gwh", "_gwhpos", "_headgear", "_uniform", "_backpack", "_backPackItems","_useUnitPos","_uniformItems", "_parachute", "_jumperNumber", "_chute", "_packHolder","_parachuteBag","_transition"];

_pos 			= _this select 0;
_unit			= if (((_this select 1) select 0) == "") then {(_this select 1) select 1} else {objectFromNetId ((_this select 1) select 0)};
if (isNil "_unit") exitWIth {};
_halo			= _this select 2;
_height			= param [3,500,[0]];
_jumperNumber	= _this select 4;
_parachuteBag = param [5,true,[true]];
_useUnitPos 	= param [6,false,[false]]; //if true will ignor pos and height and will use the unit pos once outside a vehicle
_transition		= param [7,true,[false]]; //if true show transition

_packHolder 	= objNull;

if ( !(isPlayer _unit) && { (_unit == leader _unit) } ) then {
	_unit setDir ( random 360 );
};

//if (isnil "mcc_isparajuming") then {mcc_isparajuming = false};
if (!local _unit || _unit getVariable ["mcc_isparajuming", false]) exitWith {};

_unit setVariable ["mcc_isparajuming", true];

//If is player make some effects
if (isPlayer _unit && _transition) then {
	cutText ["Get Ready to jump","BLACK OUT",1];
	sleep 2;
	playmusic "ac130";
};

if (_halo) then {
		//HALO
		_headgear = headgear _unit; 		//Remove uniforms and add HALO gear
		_uniform = uniform _unit;
		_uniformItems = uniformItems _unit;

		_backpack = backpack _unit;
		_backPackItems = backPackItems _unit;

		removeHeadgear _unit;
		removeUniform _unit;
		removeBackpack _unit;

		_unit addHeadgear "H_CrewHelmetHeli_B";
		_unit forceAddUniform  "U_B_HeliPilotCoveralls";

		if ( isPlayer _unit ) then
		{
			if (_backpack != "") then
			{
				_packHolder = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "can_collide"]; //create an empty holder
				_packHolder addBackpackCargo [_backpack, 1]; //place your old backpack into the empty holder
				_packHolder attachTo [_unit,[0.1,0.56,-.72],"pelvis"]; //attach empty holder to unit
				_packHolder setVectorDirAndUp [[0,1,0],[0,0,-1]]; //set the vector and direction of the empty holder
			};

			_unit addBackpack "B_Parachute";
		};

		//wait until outside
		waitUntil {vehicle _unit == _unit};

		//if use unit pos
		if (_useUnitPos) then {
			_pos =position _unit;
			_height = _pos select 2;
		};

		_unit setpos [(_pos select 0) + (_jumperNumber*20), _pos select 1,_height];

		sleep 2;

		if ( isPlayer _unit ) then {
			cutText ["","BLACK IN",1];
			playmusic "";

			while { alive _unit && (vehicle _unit == _unit) } do {playmusic "mcc_wind"; sleep 4.6};

			//Opening Chute
			if (_backpack != "") then
			{
				_packHolder = nearestObject [getPos _unit, "GroundWeaponHolder"];
				_packHolder attachTo [vehicle _unit,[0.1,0.72,0.52],"pelvis"]; //attach the empty holder to the new position
				_packHolder setVectorDirAndUp [[0,0.1,1],[0,1,0.1]]; //set the new vector direction
			};
		} else {
			_unit allowDamage false;
			_dir = direction (leader _unit);
			_unit playmoveNow "HaloFreeFall_non";
			waitUntil { (((getPosATL _unit) select 2) < 180) || !(alive _unit) };
			_parachute = createVehicle ["NonSteerable_Parachute_F", position _unit, [], ((_dir)-3+(random 6)), 'NONE'];
			_parachute setPos (getPos _unit);
			_unit moveindriver _parachute;
		};

		while {alive _unit && (((getpos _unit) select 2)> 1) && !isTouchingGround _unit} do {sleep 1};

		if !(alive _unit) exitwith {};

		if ( isPlayer _unit ) then
		{
			if (_backpack != "") then
			{
				{
					//player globalChat str ["obj: ", typeOf _x];
					if ( typeOf _x == "groundWeaponHolder" ) then

					{
						detach _x;
						sleep 0.1;
						deleteVehicle _x;
					};
				} forEach attachedObjects _unit;

				sleep 0.1;
				_unit addBackpack _backpack;

				clearItemCargoGlobal unitBackpack _unit; // delete all default items from backback

				// add original backpack load again
				{
					switch (true) do
						{
							case (isClass (configFile >> "CfgMagazines" >> _x)) : {(unitBackpack _unit) addMagazineCargoGlobal [_x,1]};
							case (isClass (configFile >> "CfgWeapons" >> _x)) : {(unitBackpack _unit) addItemCargoGlobal [_x,1]};
							case (isClass (configFile >> "CfgGlasses" >> _x)) : {(unitBackpack _unit) addItemCargoGlobal [_x,1]};
						};
				} foreach _backPackItems;
			};

			sleep 0.05;

			// Add parachute backpack, this will place backpack on the ground near player
			_unit addBackpack "B_Parachute";

			hintSilent "pickup backpack or drop parachute to change gear";

			//Only if player grabs backpack the change gear scenario will be started
			_timeOut = time + 600;
			while { (alive _unit) && (backpack _unit == "B_Parachute") && (time < _timeOut) } do { sleep 0.5;};

			// if killed or after 10 minutes still no gear change exit HALO script
			if ( !(alive _unit) || ( time > _timeOut )) exitwith {};

			//Remove HALO gear and add normal gear
			cutText ["Changing Gear","BLACK OUT",0.5];

			if (_headgear != "") then { removeHeadgear _unit; _unit addHeadgear _headgear };
			if (_uniform != "") then { removeUniform _unit; _unit forceAddUniform  _uniform };

			{
				switch (true) do
				{
					case (isClass (configFile >> "CfgMagazines" >> _x)) : {player addmagazine _x};
					case (isClass (configFile >> "CfgWeapons" >> _x)) : {player additem _x};
					case (isClass (configFile >> "CfgGlasses" >> _x)) : {player additem _x};
				};
			} foreach _uniformItems;
			sleep 4;
			cutText ["","BLACK IN",2];
		}
		else
		{
			if (_headgear != "") then { removeHeadgear _unit; _unit addHeadgear _headgear };
			if (_uniform != "") then { removeUniform _unit; _unit forceAddUniform  _uniform };

			{
				switch (true) do
				{
					case (isClass (configFile >> "CfgMagazines" >> _x)) : {player addmagazine _x};
					case (isClass (configFile >> "CfgWeapons" >> _x)) : {player additem _x};
					case (isClass (configFile >> "CfgGlasses" >> _x)) : {player additem _x};
				};
			} foreach _uniformItems;

			_unit setCombatMode "AWARE";
		};
} else {

	//Parachute
	//wait until outside
	waitUntil {vehicle _unit == _unit};

	//if use unit pos
	if (_useUnitPos) then {
		_pos =position _unit;
		_height = _pos select 2;
	};

	_unit setpos [(_pos select 0) + (_jumperNumber*20), _pos select 1,_height];

	sleep 2;

	_dir = direction (leader _unit);

	_unit allowDamage false;
	_backpack =  backpack _unit;

	if (_backpack != "") then {
		_packHolder = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "can_collide"]; //create an empty holder
		_packHolder addBackpackCargo [_backpack, 1]; //place your old backpack into the empty holder
		_packHolder attachTo [_unit,[0.1,0.56,-.72],"pelvis"]; //attach empty holder to unit
		_packHolder setVectorDirAndUp [[0,1,0],[0,0,-1]]; //set the vector and direction of the empty holder
	};

	if !(isPlayer _unit) then {
		waitUntil { (((getPosATL _unit) select 2) < 225) || !(alive _unit) };
		_chute = "NonSteerable_Parachute_F";

		_dir = direction (leader _unit);
		_unit setDir _dir;
	} else {
		cutText ["","BLACK IN",1];
		playmusic "";
		_chute = "Steerable_Parachute_F";

		0 spawn {
			while {!isTouchingGround player} do {
				playmusic "mcc_wind";
				sleep 4.4;
			};
		};

		waitUntil {! alive _unit || (((getPosATL _unit) select 2) < 100) };
	};


	_parachute = createVehicle [_chute, position _unit, [], ((_dir)-3+(random 6)), 'NONE'];
	_parachute setPos (getPos _unit);

	_unit moveindriver _parachute;
	_unit allowDamage true;

	if (!alive _unit) exitWith {};

	//Opening Chute
	if (!isnil "_packHolder") then {
		_packHolder attachTo [vehicle _unit,[0.1,0.72,0.52],"pelvis"]; //attach the empty holder to the new position
		_packHolder setVectorDirAndUp [[0,0.1,1],[0,1,0.1]]; //set the new vector direction
	};

	while { (alive _unit) && (((getpos _unit) select 2)> 1) && !(isTouchingGround _unit) } do {sleep 1};
	if (!alive _unit) exitwith {};

	if (isPlayer _unit) then {
		if (!isnil "_packHolder") then {
			deleteVehicle _packHolder; //delete the temp backpack and empty holder
		};

		//Spawn bag near the drop
		if (_parachuteBag) then {
			_parachute = "B_Parachute" createVehicle (getpos _unit);
			sleep 0.3;
			_parachute setPos (getpos _unit);
		};
	} else {
		_unit setCombatMode "AWARE";
	};
};

_unit setVariable ["mcc_isparajuming", false];