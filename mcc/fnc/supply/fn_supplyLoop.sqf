/*
	MCC_fnc_supplyLoop
	Server loop of the limited logistics system (MCC_logisticsMode 1 or 2). Every 5 s it runs
	MCC_fnc_supplyTick on every registered supply point; every 30 s it scans for new supply objects
	(vehicles and crates whose class has transportAmmo/Repair/Fuel or ACE supply config).
	When the mode is switched to Off it restores the engine cargo it cut and empties the registry.
	Started by MCC_fnc_supplyInit (spawned, server only).
	Params: none
	Returns: Nothing
*/
#define TICK_DELAY 5
#define SCAN_DELAY 30

if (!isServer) exitWith {};
if (!isNil "MCC_supplyLoopRunning") exitWith {};
MCC_supplyLoopRunning = true;
if (isNil "MCC_supplyRegistry") then {MCC_supplyRegistry = []};

private _tick = 0;
private _nextScan = 0;

while {true} do {
	sleep TICK_DELAY;
	private _mode = missionNamespace getVariable ["MCC_logisticsMode", 0];

	if (_mode isEqualTo 0) then {
		//Turned off: give back unlimited engine supply
		if (count MCC_supplyRegistry > 0) then {
			{
				if (!isNull _x) then {
					private _obj = _x;
					private _orig = _obj getVariable ["MCC_supplyOrigCargo", [1, 1, 1]];
					private _types = _obj getVariable ["MCC_supplyTypes", [false, false, false]];
					{
						if ((_types select _forEachIndex) && {(_orig select _forEachIndex) > 0}) then {
							[_obj, (_orig select _forEachIndex) min 1] remoteExecCall [_x, _obj];
						};
					} forEach ["setAmmoCargo", "setRepairCargo", "setFuelCargo"];
				};
			} forEach MCC_supplyRegistry;
			MCC_supplyRegistry = [];
		};
	} else {
		_tick = _tick + 1;

		if (time >= _nextScan) then {
			_nextScan = time + SCAN_DELAY;
			{
				if (!(_x in MCC_supplyRegistry) && {true in ([typeOf _x] call MCC_fnc_supplyTypes)}) then {
					[_x] call MCC_fnc_supplyRegister;
				};
			} forEach vehicles;
		};

		MCC_supplyRegistry = MCC_supplyRegistry select {!isNull _x && {alive _x}};
		{
			[_x, _mode, _tick] call MCC_fnc_supplyTick;
		} forEach MCC_supplyRegistry;
	};
};
