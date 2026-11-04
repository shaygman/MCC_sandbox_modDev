/*
	MCC_fnc_supplyTick
	Server, called by MCC_fnc_supplyLoop every few seconds for each registered supply point:
	 1. ACE types: read how much ACE took since the last tick and take it from our stock.
	 2. Engine types: measure what nearby vehicles gained since the last tick (ammo, health, fuel)
	    and take its price (MCC_fnc_supplyVehicleCost) from the stock.
	 3. Turn the engine cargo off when a stock is empty and back on when it is refilled.
	 4. Vehicles parked at their side's base refill from the side's resources (MCC_fnc_resChange).
	Stock lives in the object variables ammoLeft / supplyLeft / fuelLeft (index 0 / 1 / 2, same index as MCC_res).
	Params:
		0: OBJECT - registered supply point
		1: NUMBER - MCC_logisticsMode (1 fuel only, 2 full)
		2: NUMBER - tick counter of the loop
	Returns: Nothing
*/
#define SUPPLY_RADIUS 20
#define SERVICE_GRACE 30

params [["_obj", objNull, [objNull]], ["_mode", 0, [0]], ["_tick", 0, [0]]];

if (isNull _obj || {!alive _obj}) exitWith {};

private _vars = ["ammoLeft", "supplyLeft", "fuelLeft"];
private _types = _obj getVariable ["MCC_supplyTypes", [false, false, false]];
private _cap = _obj getVariable ["MCC_supplyCap", [0, 0, 0]];
private _active = [(_types select 0) && _mode > 1, (_types select 1) && _mode > 1, _types select 2];
private _liters = missionNamespace getVariable ["MCC_logisticsLitersPerUnit", 10];
private _aceRearm = (missionNamespace getVariable ["MCC_isACERearm", false]) && {!isNil "ace_rearm_fnc_getSupplyCount"};
private _aceRefuel = (missionNamespace getVariable ["MCC_isACERefuel", false]) && {!isNil "ace_refuel_fnc_getFuel"};
private _ace = [_aceRearm, false, _aceRefuel];

private _stock = _vars apply {
	private _v = _obj getVariable [_x, 0];
	if (_v isEqualType 0) then {_v} else {0}
};
private _start = +_stock;

//---- 1. ACE counters
if ((_active select 0) && {_aceRearm}) then {
	private _now = [_obj] call ace_rearm_fnc_getSupplyCount;
	private _prev = _obj getVariable ["MCC_supplyAcePrev0", _now];
	if (_now isEqualType 0 && {_now >= 0} && {_prev > _now}) then {_stock set [0, ((_stock select 0) - (_prev - _now)) max 0]};
};
if ((_active select 2) && {_aceRefuel}) then {
	private _now = [_obj] call ace_refuel_fnc_getFuel;
	private _prev = _obj getVariable ["MCC_supplyAcePrev2", _now];
	if (_now isEqualType 0 && {_now >= 0} && {_prev > _now}) then {_stock set [2, ((_stock select 2) - ((_prev - _now) / _liters)) max 0]};
};

//---- 2. Engine supply: what did nearby vehicles take
private _watch = [0, 1, 2] select {(_active select _x) && {!(_ace select _x)} && {(_stock select _x) > 0}};
if (count _watch > 0) then {
	{
		private _veh = _x;
		//Snapshot once per tick per vehicle, keep the previous one
		if ((_veh getVariable ["MCC_supplySnapTick", -10]) != _tick) then {
			_veh setVariable ["MCC_supplySnapPrev", _veh getVariable ["MCC_supplySnap", []]];
			_veh setVariable ["MCC_supplyPrevTick", _veh getVariable ["MCC_supplySnapTick", -10]];
			_veh setVariable ["MCC_supplySnap", [_veh] call MCC_fnc_supplySnapshot];
			_veh setVariable ["MCC_supplySnapTick", _tick];
		};
		private _now = _veh getVariable ["MCC_supplySnap", []];
		private _prev = _veh getVariable ["MCC_supplySnapPrev", []];
		private _serviced = (_veh getVariable ["MCC_supplyServiced", -1000]) > (serverTime - SERVICE_GRACE);

		//Only consecutive snapshots count, and each gain is charged to one supply point only
		if (count _prev == 3 && {count _now == 3} && {(_veh getVariable ["MCC_supplyPrevTick", -10]) == _tick - 1} && {!_serviced}) then {
			private _charged = _veh getVariable ["MCC_supplyCharged", [-10, -10, -10]];
			private _price = [_veh] call MCC_fnc_supplyVehicleCost;
			{
				private _gain = (_now select _x) - (_prev select _x);
				if (_gain > 0.005 && {(_charged select _x) != _tick}) then {
					_stock set [_x, ((_stock select _x) - (_gain * (_price select _x))) max 0];
					_charged set [_x, _tick];
				};
			} forEach _watch;
			_veh setVariable ["MCC_supplyCharged", _charged];
		};
	} forEach (_obj nearEntities [["LandVehicle", "Air", "Ship"], SUPPLY_RADIUS]);
};

//---- 4. Refill vehicles at their base (crates are not refilled: they are bought and deposited)
if ((_obj getVariable ["MCC_supplyIsVehicle", false]) && {speed _obj < 5}) then {
	private _baseSide = [_obj] call MCC_fnc_supplyNearBase;
	if !(_baseSide isEqualTo sideUnknown) then {
		private _crewSide = if (count crew _obj > 0) then {side group effectiveCommander _obj} else {_baseSide};
		if (_crewSide isEqualTo _baseSide) then {
			private _res = missionNamespace getVariable [format ["MCC_res%1", _baseSide], [0,0,0,0,0]];
			private _rate = missionNamespace getVariable ["MCC_logisticsRefillRate", 100];
			private _changes = [];
			{
				if (_active select _x) then {
					private _give = floor (((_cap select _x) - (_stock select _x)) min _rate min (_res param [_x, 0]));
					if (_give > 0) then {
						_stock set [_x, (_stock select _x) + _give];
						_changes pushBack [_x, -_give];
					};
				};
			} forEach [0, 1, 2];
			if (count _changes > 0) then {[_baseSide, _changes] call MCC_fnc_resChange};
		};
	};
};

//---- write back stock and mirror it to ACE
{
	if (_active select _x) then {
		if !((_stock select _x) isEqualTo (_start select _x)) then {
			_obj setVariable [_vars select _x, _stock select _x, true];
		};
	};
} forEach [0, 1, 2];

if ((_active select 0) && {_aceRearm}) then {
	private _v = floor (_stock select 0);
	if !(([_obj] call ace_rearm_fnc_getSupplyCount) isEqualTo _v) then {[_obj, _v] call ace_rearm_fnc_setSupplyCount};
	_obj setVariable ["MCC_supplyAcePrev0", _v];
};
if ((_active select 2) && {_aceRefuel}) then {
	private _l = (_stock select 2) * _liters;
	private _cur = [_obj] call ace_refuel_fnc_getFuel;
	if (!(_cur isEqualType 0) || {abs (_cur - _l) > 0.5}) then {[_obj, _l] call ace_refuel_fnc_setFuel};
	_obj setVariable ["MCC_supplyAcePrev2", _l];
};

//---- 3. Engine cargo on/off
private _on = _obj getVariable ["MCC_supplyCargoOn", [true, true, true]];
private _orig = _obj getVariable ["MCC_supplyOrigCargo", [1, 1, 1]];
private _cmds = ["setAmmoCargo", "setRepairCargo", "setFuelCargo"];
private _gets = [getAmmoCargo _obj, getRepairCargo _obj, getFuelCargo _obj];
{
	if ((_active select _x) && {!(_ace select _x)}) then {
		private _want = (_stock select _x) > 0;
		private _cur = _gets select _x;
		switch (true) do {
			//Empty: cut the engine supply
			case (!_want && {_cur > 0}): {
				[_obj, 0] remoteExecCall [_cmds select _x, _obj];
			};
			//Has stock: keep engine cargo up (our stock is the real limit)
			case (_want && {_cur < 0.5 * ((_orig select _x) max 0.01)} && {(_orig select _x) > 0}): {
				[_obj, (_orig select _x) min 1] remoteExecCall [_cmds select _x, _obj];
			};
		};
		_on set [_x, _want];
	};
} forEach [0, 1, 2];
_obj setVariable ["MCC_supplyCargoOn", _on];
