/*=========================================================== MCC_fnc_undercoverNearTargets=======================

	handle near targets for undercover script
*/
#define LEGAL_WEAPON_TYPES [4096,131072]
#define	SCARESOUND	"EXP_m05_dramatic"
#define	HIDDEN	"Simulation_Restart"


private ["_enemySides","_group", "_unit", "_spotted", "_spottedWithWeapon", "_nearTargets", "_count", "_nearCount","_leader","_canSee","_scareEffect","_spottedEffect"];

_spottedWithWeapon = false;
_count = 0;

_scareEffect = {
	private ["_blurEffects"];
	_blurEffects = ppEffectCreate ["ChromAberration", 440];
	_blurEffects ppEffectForceInNVG true;
	_blurEffects ppEffectAdjust [0.05,0.05,true];
	_blurEffects ppEffectEnable true;

	playSound SCARESOUND;

	_blurEffects ppEffectCommit 0.5;
	sleep 0.5;

	_blurEffects ppEffectAdjust [0,0,true];
	_blurEffects ppEffectCommit 0.5;
	sleep 0.5;

	ppEffectDestroy [_blurEffects];
};

_spottedEffect = {
	private ["_blurEffects"];
	_blurEffects = ppEffectCreate ["RadialBlur", 100];
	_blurEffects ppEffectForceInNVG true;
	_blurEffects ppEffectAdjust [0.05,0.05,0.4,0.4];
	_blurEffects ppEffectEnable true;

	playSound SCARESOUND;

	_blurEffects ppEffectCommit 0.5;

	waitUntil {captiveNum player > 0};

	playsound HIDDEN;

	_blurEffects ppEffectAdjust [0,0,0,0];
	_blurEffects ppEffectCommit 0.5;
	sleep 0.5;

	ppEffectDestroy [_blurEffects];
};

while { alive player } do {

	_enemySides = [playerSide] call bis_fnc_enemySides;
	_spotted = false;

	{
		_group = _x;
		if (side _group in _enemySides) then {

			_leader = leader _group;
			_nearTargets = (leader _group) nearTargets 500;

			{
				_unit = _x select 4;
				if (_unit == player) then {
					_spotted = true;


					/*
					_weapons = weapons player;

					{
						if !(getNumber(configFile >> "CfgWeapons" >> _x >> "type") in LEGAL_WEAPON_TYPES) exitWith {
							_spottedWithWeapon = true;
							_unit setCaptive false;
						};
					} forEach _weapons;
					*/

					_canSee = false;

					{
						if ([_x,player,500] call GAIA_fnc_haslineofsight) exitWith {_canSee = true};
					} forEach units _group;

					if (_canSee) then {

						//if have visable weapon
						if (currentWeapon player != "") exitWith {
							(leader _group) setVariable ["MCC_undercoverSpottedTime",time+120];
							0 spawn _spottedEffect;
							_spottedWithWeapon = true;
							_unit setCaptive false;
						};

						if (!_spottedWithWeapon &&
					    	(
					    	 ({(player distance _x) < 6} count (units _group) > 0) ||
					    	 ((leader _group) getVariable ["MCC_undercoverSpottedTime",0]) > time ||
					    	 (vehicle player == player && ((speed player > 10) || (stance player != "STAND")))
					    	)
						   ) then {

							if ((player getVariable ["MCC_undercoverNearEnemy",0])>2) then {
								0 spawn _spottedEffect;
								_spottedWithWeapon = true;
								_unit setCaptive false;
							} else {

								//Got suspicious
								0 spawn _scareEffect;

								(player setVariable ["MCC_undercoverNearEnemy",(player getVariable ["MCC_undercoverNearEnemy",0])+1]);
							};
						} else {
							player setVariable ["MCC_undercoverNearEnemy",0];
						};
					};
				};

				// quit the nearTargets loop if player was spotted
				if (_spotted) exitWith {};
			} forEach _nearTargets;
		};

		// quit the groups loop if player was spotted
		if (_spottedWithWeapon) exitWith {};
	} forEach allGroups;

	// Set unit to captive status when he was not spotted anymore, while he was spottedWithWeapon before
	if (_spottedWithWeapon && !_spotted) then {
		_count = _count +1;

		 //if unit is hidden more then 2 minutes it will be captive again.
		if (_count>100) then {
			_count = 0;
			_spottedWithWeapon = false;
			player setCaptive true;
		};
	};

	sleep 3;
};