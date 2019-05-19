/*============================================================================================ MCC_fnc_cas ==============================================================

	Simulate Zeus CAS with moded vehicles

	<IN>
		0:		STRING - plane classname
		1:		INTEGER - CAS type: 0-guns 1-rockets 2-all 3-bombs
		2:		INTEGER - Direction of attack
		3:		ARRAY - Position to attack

	<OUT>
		Nothing

==================================================================================================================================================================*/
params [
	["_planeClass","",[""]],
	["_casType",0,[0]],
	["_dir",0,[0]],
	["_pos",[0,0,0],[[]]]
];

//--- if not server exit
if (!isServer) exitWith {};

_planeCfg = configfile >> "cfgvehicles" >> _planeClass;
if !(isclass _planeCfg) exitwith {diag_log format ["MCC ERROE: MCC_fnc_cas Vehicle class '%1' not found", _planeClass], false};

//--- Detect gun
_weaponTypes = switch _casType do {
	case 0: {["machinegun","cannon","horn"]};
	case 1: {["missilelauncher","launcher","rocketlauncher"]};
	case 2: {["machinegun","missilelauncher","cannon","horn","rocketlauncher"]};
	case 3: {["bomblauncher"]};
	default {[]};
};

_weapons = [];
{
	if (tolower ((_x call bis_fnc_itemType) select 1) in _weaponTypes) then {
		_modes = getarray (configfile >> "cfgweapons" >> _x >> "modes");
		if (count _modes > 0) then {
			_mode = _modes select 0;
			if (_mode == "this") then {_mode = _x;};
			_weapons set [count _weapons,[_x,_mode]];
		};
	};
} foreach (_planeClass call bis_fnc_weaponsEntityType);

_pos set [2,(_pos select 2) + getterrainheightasl _pos];

_dis = 3000;
_alt = 1000;
_pitch = atan (_alt / _dis);
_speed = 400 / 3.6;
_duration = ([0,0] distance [_dis,_alt]) / _speed;

_awayPos = [_pos,_dis,_dir] call bis_fnc_relpos;

//--- Create plane
_planePos = [_pos,_dis,_dir + 180] call bis_fnc_relpos;
_planePos set [2,(_pos select 2) + _alt];
_planeSide = (getnumber (_planeCfg >> "side")) call bis_fnc_sideType;
_planeArray = [_planePos,_dir,_planeClass,_planeSide] call bis_fnc_spawnVehicle;
_plane = _planeArray select 0;
_plane setposasl _planePos;
_plane move ([_pos,_dis,_dir] call bis_fnc_relpos);
_plane disableai "move";
_plane disableai "target";
_plane disableai "autotarget";
_plane setcombatmode "blue";

_vectorDir = [_planePos,_pos] call bis_fnc_vectorFromXtoY;
_velocity = [_vectorDir,_speed] call bis_fnc_vectorMultiply;
_plane setvectordir _vectorDir;
[_plane,-90 + atan (_dis / _alt),0] call bis_fnc_setpitchbank;
_vectorUp = vectorup _plane;

//--- Remove all other weapons;
_currentWeapons = weapons _plane;
{
	if !(tolower ((_x call bis_fnc_itemType) select 1) in (_weaponTypes + ["countermeasureslauncher"])) then {
		_plane removeweapon _x;
	};
} foreach _currentWeapons;

//The plane doesn't have a weapon lets add it one
if (count _weapons == 0) then {

	switch (_casType) do
	{
		case 0:	//-- Cannon
		{
			_plane addMagazineGlobal "1000Rnd_Gatling_30mm_Plane_CAS_01_F";
			_plane addWeaponGlobal "Gatling_30mm_Plane_CAS_01_F";

			_weapons pushBack ["Gatling_30mm_Plane_CAS_01_F"];
		};

		case 1:	//-- Rockets
		{
			_plane addMagazineGlobal "7Rnd_Rocket_04_HE_F";
			_plane addWeaponGlobal "Rocket_04_HE_Plane_CAS_01_F";

			_plane addMagazineGlobal "7Rnd_Rocket_04_AP_F";
			_plane addWeaponGlobal "Rocket_04_AP_Plane_CAS_01_F";

			_weapons pushBack ["Rocket_04_HE_Plane_CAS_01_F","Rocket_04_AP_Plane_CAS_01_F"];
		};

		case 2:	//-- Cannon and rockets
		{
			_plane addMagazineGlobal "1000Rnd_Gatling_30mm_Plane_CAS_01_F";
			_plane addWeaponGlobal "Gatling_30mm_Plane_CAS_01_F";

			_plane addMagazineGlobal "7Rnd_Rocket_04_HE_F";
			_plane addWeaponGlobal "Rocket_04_HE_Plane_CAS_01_F";

			_plane addMagazineGlobal "7Rnd_Rocket_04_AP_F";
			_plane addWeaponGlobal "Rocket_04_AP_Plane_CAS_01_F";

			_weapons pushBack ["Rocket_04_HE_Plane_CAS_01_F","Rocket_04_AP_Plane_CAS_01_F","Gatling_30mm_Plane_CAS_01_F"];
		};

		case 3:	//- bombs
		{
			_plane addMagazineGlobal "4Rnd_Bomb_04_F";
			_plane addWeaponGlobal "Bomb_04_Plane_CAS_01_F";

			_weapons pushBack ["Bomb_04_Plane_CAS_01_F"];
		};
	};
};

//--- Play radio
[_plane,"CuratorModuleCAS"] call bis_fnc_curatorSayMessage;

//--- Approach
_fire = [] spawn {waituntil {false}};
_fireNull = true;
_time = time;
_offset = if ({_x == "missilelauncher"} count _weaponTypes > 0) then {20} else {0};


waituntil {

	_fireProgress = _plane getvariable ["fireProgress",0];

	//--- Set the plane approach vector
	_plane setVelocityTransformation [
		_planePos, [_pos select 0,_pos select 1,(_pos select 2) + _offset + _fireProgress * 12],
		_velocity, _velocity,
		_vectorDir,_vectorDir,
		_vectorUp, _vectorUp,
		(time - _time) / _duration
	];
	_plane setvelocity velocity _plane;

	//--- Fire!
	if ((getposasl _plane) distance _pos < 1000 && _fireNull) then {


		//--- Create laser target
		private _targetType = if (_planeSide getfriend west > 0.6) then {"LaserTargetW"} else {"LaserTargetE"};
		_target = ((_pos nearEntities [_targetType,250])) param [0,objnull];

		if (isnull _target) then {
			_target = createvehicle [_targetType,_pos,[],0,"none"];
		};

		_plane reveal lasertarget _target;
		_plane dowatch lasertarget _target;
		_plane dotarget lasertarget _target;

		_fireNull = false;
		terminate _fire;

		_fire = [_plane, _weapons, _target, _casType] spawn {
			params ["_plane", "_weapons", "_target", "_casType"];
			_planeDriver = driver _plane;
			_pos = getPosATL _target;

			//We have weapons
			_duration = 4;
			private _sleep = if (_casType == 3) then {2} else {0.1};

			_time = time + _duration;

			waituntil {
				{
					_planeDriver fireattarget [_target,(_x select 0)];
				} foreach _weapons;
				_plane setvariable ["fireProgress",(1 - ((_time - time) / _duration)) max 0 min 1];
				sleep _sleep;
				time > _time || isnull _plane //--- Shoot only for specific period or only one bomb
			};

			/*
			//We don't have weapons time to simulate
			switch (_casType) do
			{
				case 0:	//-- Guns
				{
					_plane addMagazineGlobal "1000Rnd_Gatling_30mm_Plane_CAS_01_F";
					_plane addWeaponGlobal "Gatling_30mm_Plane_CAS_01_F";

					duration = 4;
					_time = time + _duration;

					waituntil {
						_planeDriver fireattarget [_target,"Gatling_30mm_Plane_CAS_01_F"];
						_plane setvariable ["fireProgress",(1 - ((_time - time) / _duration)) max 0 min 1];
						sleep 0.1;
						time > _time || isnull _plane //--- Shoot only for specific period or only one bomb
					};
				};

				case 1:
				{
					for [{_x=1},{_x<=12},{_x=_x+1}] do
					{
						_nul=[[(_pos select 0)+50 - random 100,(_pos select 1)+50 - random 100,_pos select 2], getpos _plane,"M_AT",200,true,""] execVM MCC_path + "mcc\general_scripts\CAS\missile_guide.sqf";
						[[netid _plane,_plane], "missileLunch"] remoteExec ["MCC_fnc_globalSay3D",0];
						sleep 0.2;
					};
				};

				case 2: //-- bombs away
				{
					for [{_i=1},{_i<=12},{_i=_i+1}] do
					{
						_offset = if (_i mod 2 == 0) then {4} else {-4};
						_bomb = "Bo_Mk82" createvehicle [getpos _plane select 0,getpos _plane select 1,3000]; 	//make the bomb
						_bomb setpos (_plane modelToWorld [_offset,-3,-6]);
						_bomb setdir getdir _plane;
						_bomb setVectorUp (vectorup _plane);
						_velocity = velocity _plane;
						_velocity set [2,-30];
						_bomb setVelocity _velocity;

						[[netid _plane,_plane], format["bon_Shell_In_v0%1",[1,2,3,4,5,6,7] select round random 6]] remoteExec ["MCC_fnc_globalSay3D",0];
						sleep 0.3;
					};
				};

				case 3:	//- Bombs
				{
					_nul=[_pos, getpos _plane,"Bo_GBU12_LGB",100,false,""] execVM MCC_path + "mcc\general_scripts\CAS\missile_guide.sqf";
				};
			};
			*/
			sleep 1;

			//--- Delete target
			if (alive _target) then {
				_target spawn {sleep 5; deleteVehicle _this};
			};
		};
	};

	sleep 0.01;
	scriptdone _fire || isnull _plane
};

_plane setvelocity velocity _plane;
_plane flyinheight _alt;
_plane enableAI "move";
_plane moveTo _awayPos;

//--- Fire CM
for "_i" from 0 to 5 do {
	driver _plane forceweaponfire ["CMFlareLauncher","Burst"];
	_time = time + 1.1;
	waituntil {time > _time || ! (alive _plane)};
};

waituntil {(_plane distance _pos > 2000) || !(alive driver _plane)};

//--- Delete plane
if (alive _plane) then {
	_group = group _plane;
	_crew = crew _plane;
	deletevehicle _plane;
	{deletevehicle _x} foreach _crew;
	deletegroup _group;
};
