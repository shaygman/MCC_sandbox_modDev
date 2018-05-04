//==================================================================MCC_fnc_initMedic======================================================================================
// init MCC medic system
//======================================================================================================================================================================


MCC_fnc_initMedicLocal = {
	private ["_maxBleeding","_bleeding","_remaineBlood"];
	params ["_unit"];

	if (local _unit) then {

		_maxBleeding = missionNamespace getvariable ["MCC_medicBleedingTime",200];

		//Initate medic system and replace BI default items
		if (_unit isKindOf "CAManBase" && alive _unit && !(_unit getVariable ["MCC_medicEHstarted",false])) then {
			_unit setVariable ["MCC_medicEHstarted",true,true];
			_unit addEventHandler ["HandleDamage", {_this call MCC_fnc_handleDamage}];
			if !(isPlayer _unit) then {
				_unit addEventHandler ["HandleHeal",{
					(_this select 0) setVariable ["MCC_medicBleeding",0,true];
					if (!isplayer (_this select 1) && (_this select 1 != (_this select 0))) then {(_this select 0) setVariable ["MCC_medicUnconscious",false,true]};
					false}];
			};

			//Change Gear
			if (missionNamespace getVariable ["MCC_medicComplex",false]) then {
				_unit spawn	{
					//Gear scripts exc
					{
						if (_x == "FirstAidKit") then {
							_this removeItem _x;
							{_this additem "MCC_bandage"} forEach [1,2];
						};
						if (_x == "Medikit") then {
							_this removeItem _x;
							{_this additem "MCC_bandage"} forEach [1,2,3,4,5,6,7,8,9,10,11,12];
							{_this additem "MCC_epipen"} forEach [1,2,3,4,5,6,7,8,9,10,11,12];
							{_this additem "MCC_salineBag"} forEach [1,2,3,4];
							_this additem "MCC_firstAidKit";
						};
					} forEach (items _this);
				};
			};
		};

		//Manage blood losse and bandaging
		0 = [_unit] spawn MCC_fnc_medicEffects;
	};
};

//Add eh to local players and AI and look for new spawns
0 spawn
{
	while {true} do {
		{
			//Medic effects
			if (missionNamespace getvariable ["MCC_medicSystemEnabled",false]) then {
				[_x] spawn MCC_fnc_initMedicLocal;
			};
		} foreach allUnits;

		sleep 4;
	};
};