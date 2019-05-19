/*=============================================================MCC_fnc_addVelocity=========================================================================================
	adds velocity to object depends on its current velocity and with relation to center - create a shockwave
	 <IN>
		0: Object: OBJECT
		1: velocity:INTEGER - added velocity
		2: levitation:INTEGER - added Upword velocity
		3: center: OBJECT/POSITION - (optional) can be the center of velocity to simulate a shock wave - objnull for none
		4: simDamage: BOOLEAN - (optional) if set to true the script will prevent physics damage  DEFAULT true.
		5: shellshockEffect: BOOLEAN - (optional) if set to true will inflict shellshock effect on player unit including blury vision, flash and shakes.


		EXAMPLE:
		[player,10,10] call MCC_fnc_addVelocity

	<OUT>
		Nothing
//======================================================================================================================================================================*/

params [["_object", objNull, [objNull]],
		["_speed", 0, [0]],
		["_levitation", 0, [0]],
		["_center", objNull, [objNull,[]]],
		["_simDamage", true, [true]],
		["_shellshockEffect", true, [true]]
	   ];

if (isNull _object) exitWith {diag_log "MCC Error: MCC_fnc_addVelocity - invalid object"};
if (!local _object) exitWith  {diag_log "MCC Error: MCC_fnc_addVelocity - Object isn't local"};

private ["_vel","_dir"];
_object = vehicle _object;
_vel = velocity _object;

if (_center isEqualType objNull) then {
	_dir = if (isNull _center) then {direction _object} else {_center getDir _object};
} else {
	_dir = _center getDir _object;
};

//Lets try ragdolls but it doesn't work on AI
if (isplayer _object && ( vehicle _object == _object) ) then {

	//Stop damage
	if (_simDamage) then {_object allowDamage false};

	private "_rag";
	_rag = "Land_Can_V3_F" createVehicleLocal [0,0,0];
	_rag setMass 1e10;
	_rag attachTo [_object, [0,0,0], "Spine3"];

	_rag setVelocity [
		(_vel select 0) + (sin _dir * _speed),
		(_vel select 1) + (cos _dir * _speed),
		(_vel select 2) + _levitation
	];

	detach _rag;

	0 = _rag spawn {
	    deleteVehicle _this;
	};

	//Add shelshock effects
	1 fadeMusic 0;
	0.5 fadeSound 0.2;
	playSound ["combat_deafness", true];

	[] spawn {
		sleep 0.5;
		15 fadeSound 1;
	};

	if (_shellshockEffect) then {
		[] spawn {
			addCamShake [2, 5, 20];

			private ["_blur"];
			_blur = ppEffectCreate ["DynamicBlur", 474];
			_blur ppEffectEnable true;
			_blur ppEffectAdjust [0];
			_blur ppEffectCommit 0;

			waitUntil {ppEffectCommitted _blur};

			_blur ppEffectAdjust [10];
			_blur ppEffectCommit 0;

			titleCut ["", "WHITE IN", 1+(random 3)];

			_blur ppEffectAdjust [0];
			_blur ppEffectCommit 3+(random 5);

			waitUntil {ppEffectCommitted _blur};

			_blur ppEffectEnable false;
			ppEffectDestroy _blur;
		};
	};

	//Resume damage
	waitUntil{sleep 0.05; (velocity _object) distance [0,0,0] < 0.1};
	if (_simDamage) then {_object allowDamage true};

} else {
	_object setVelocity [
		(_vel select 0) + (sin _dir * _speed),
		(_vel select 1) + (cos _dir * _speed),
		(_vel select 2) + _levitation
	];
};