/*=================================================== MCC_fnc_moduleFireMission ===================================================
	Eden module "MCC Fire Mission" (MCC_Module_fireMission). Fires artillery at the module position (or at a synced
	object/unit, taken when the mission fires) when a synced trigger activates, or at mission start when no trigger is synced.
	Runs on the server only (isGlobal = 0); fires again every time a repeatable trigger activates.

	Source:
		- synced artillery vehicles/statics with crew: real guns (doArtilleryFire with their first magazine in range)
		- otherwise (or when no synced gun is in range): simulated shells with MCC_fnc_artillery (MCC_artilleryTypeArray)

	Params (module framework):
		0: OBJECT - the module logic
		1: ARRAY  - synced units (unused)
		2: BOOL   - activated
	Returns: nothing
*/
params [
	["_logic", objNull, [objNull]],
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if (!isServer || {isNull _logic} || {!_activated}) exitWith {};

//One fire mission at a time per module
if (_logic getVariable ["MCC_fireMissionBusy", false]) exitWith {};
_logic setVariable ["MCC_fireMissionBusy", true];

[_logic] spawn {
	params ["_logic"];

	waitUntil {sleep 0.5; time > 0};
	private _initTimeout = diag_tickTime + 60;
	waitUntil {sleep 1; (missionNamespace getVariable ["MCC_initDone", false]) || {diag_tickTime > _initTimeout}};

	private _fnc_num = {
		params ["_name", "_default"];
		private _v = _logic getVariable [_name, _default];
		if (_v isEqualType "") then {_v = parseNumber _v};
		if !(_v isEqualType 0) then {_v = _default};
		_v
	};

	private _shellIndex	= round (["shellType", 1] call _fnc_num);
	private _spread		= (["spread", 100] call _fnc_num) max 0;
	private _rounds		= (round (["rounds", 4] call _fnc_num)) max 1 min 50;
	private _salvos		= (round (["salvos", 1] call _fnc_num)) max 1 min 20;
	private _salvoDelay	= (["salvoDelay", 30] call _fnc_num) max 0;
	private _shellDelay	= (["shellDelay", 1] call _fnc_num) max 0.2;
	private _startDelay	= (["startDelay", 0] call _fnc_num) max 0;

	if (_startDelay > 0) then {sleep _startDelay};

	private _synced = synchronizedObjects _logic;
	private _guns = _synced select {
		!(_x isKindOf "EmptyDetector") && {alive _x} && {!isNull gunner _x} && {getNumber (configOf _x >> "artilleryScanner") == 1}
	};
	{
		if (_x isKindOf "Man" && {vehicle _x != _x} && {getNumber (configOf (vehicle _x) >> "artilleryScanner") == 1}) then {
			_guns pushBackUnique (vehicle _x);
		};
	} forEach _synced;

	//Target: a synced object that is not a gun or a trigger, else the module
	private _targetIdx = _synced findIf {!(_x isKindOf "EmptyDetector") && {!(_x in _guns)} && {!((vehicle _x) in _guns)}};
	private _targetObj = if (_targetIdx >= 0) then {_synced select _targetIdx} else {_logic};

	private _types = missionNamespace getVariable ["MCC_artilleryTypeArray", [["HE 120mm","Sh_120mm_HE_Tracer_Red",1,30]]];
	private _type = _types select ((_shellIndex max 0) min ((count _types) - 1));
	_type params ["_shellName", "_shellClass", "_simulate"];
	//3 = laser guided: needs a laser target and the old menu missile script - drop it as a plain shell instead
	if (_simulate == 3) then {_simulate = 1};

	for "_s" from 1 to _salvos do {
		private _pos = getPosATL _targetObj;
		_pos set [2, 0];

		//Real guns first
		private _fired = false;
		{
			private _gun = _x;
			if (alive _gun && {!isNull gunner _gun}) then {
				private _mags = getArtilleryAmmo [_gun];
				private _mag = _mags findIf {_pos inRangeOfArtillery [[_gun], _x]};
				if (_mag >= 0) then {
					private _aim = _pos getPos [random _spread, random 360];
					_gun doArtilleryFire [_aim, _mags select _mag, _rounds];
					_fired = true;
				};
			};
		} forEach _guns;

		//Simulated barrage (no gun / out of range)
		if (!_fired) then {
			if (count _guns > 0) then {diag_log format ["MCC Fire Mission module: no synced gun in range of %1, using simulated shells", _pos]};
			[_pos, _shellClass, _spread, _rounds, _simulate, _shellDelay] call MCC_fnc_artillery;
		};

		if (_s < _salvos) then {sleep (_salvoDelay max 1)};
	};

	//Simulated shells run in their own scripts: keep the module busy a bit so a trigger spam does not stack salvos
	sleep 5;
	_logic setVariable ["MCC_fireMissionBusy", false];
};
