/*===================================  MCC_fnc_MWGetStartLocation ==================================================
		Find a start location based on MCC HQ if non present then BI respawn position if non present then players position

		<IN>
			0:		SIDE - side player
			1:		STRING - vehicle class to find empty position for it

	*/

	params [
		["_sidePlayer",sideLogic,[sideLogic]],
		["_vehicleClass","",[""]]
	];

	private ["_respawns","_startPos","_fnc_startPos","_unit"];

	_fnc_startPos = {
		params ["_sidePlayer","_vehicleClass","_startPos"];

		if (isNil "_startPos") exitWith {nil};

		if (_vehicleClass == "") then {
			_startPos = _startPos findEmptyPosition [5,50];
		} else {
			_startPos = _startPos findEmptyPosition [5,50,_vehicleClass];
		};

		_startPos
	};

	//Find mission start position
	//First look for MCC HQ
	_startPos = missionNameSpace getvariable [(format ["MCC_START_%1",nil]),[]];

	if (!isNil "_startPos") then {
		if (count _startPos <=0) then {
			_startPos = nil;
		} else {
			_startPos = [_sidePlayer, _vehicleClass, _startPos] call _fnc_startPos;
		};
	};

	//Second look for BI respawn pos
	if (isNil "_startPos") then {
		{
			_startPos = [_sidePlayer, _vehicleClass, (position _x)] call _fnc_startPos;
			if (count _startPos >0) exitWith {};
		} forEach (_sidePlayer call BIS_fnc_getRespawnPositions);
	};

	if (isNil "_startPos") then {
		{
			_unit = leader _x;
			if (isPlayer _unit && side _unit == _sidePlayer && isTouchingGround _unit && alive _unit) exitWith {
				_startPos = [_sidePlayer, _vehicleClass, (position _unit)] call _fnc_startPos;
				if (count _startPos >0) exitWith {};
			};
		} forEach allGroups;
	};

	if (!isNil "_startPos") then {_startPos} else {[]};