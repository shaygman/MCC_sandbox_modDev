/*
	MCC_fnc_resChange
	Server-authoritative change of a side's resources MCC_res<SIDE> = [ammo, repair, fuel, food, meds].
	Can be called anywhere: on a client it forwards itself to the server with remoteExecCall.
	The server applies the change atomically, clamps every value at 0 and broadcasts MCC_res<SIDE>
	(setVariable with publish), so every existing reader keeps working.
	Do NOT mutate the array you got from missionNamespace before calling this (it is shared by reference
	on the hosting machine and the change would be applied twice).

	Params:
		0: SIDE - side whose resources change
		1: NUMBER, STRING or ARRAY -
			NUMBER 0-4 index, or STRING "ammo", "repair" ("materials", "supply"), "fuel", "food", "med" ("meds"),
			or ARRAY of [key, delta] pairs to change several values at once (param 2 is then ignored),
			or STRING "all" together with param 2 = ARRAY of 5 numbers to set the whole array (implies set)
		2: NUMBER or ARRAY - delta to add (negative to spend), or the new value when param 3 is true
		3: BOOL - (optional, default false) true: set the value instead of adding to it
	Returns: ARRAY - the new resources array on the server, [] on a client (the change is sent to the server)
	Examples:
		[playerSide, "ammo", -200] call MCC_fnc_resChange;
		[west, [["ammo",-30],["fuel",-10]]] call MCC_fnc_resChange;
		[east, "all", [1000,1000,1000,200,200]] call MCC_fnc_resChange;
*/
params [
	["_side", sideUnknown, [west]],
	["_key", 0, [0, "", []]],
	["_delta", 0, [0, []]],
	["_set", false, [false]]
];

if !(_side in [west, east, resistance, civilian]) exitWith {[]};

//Forward to the server
if (!isServer) exitWith {
	[_side, _key, _delta, _set] remoteExecCall ["MCC_fnc_resChange", 2];
	[]
};

//Network guard: MCC-authorized senders may do anything; any other player may only add/spend on his own side
if (isRemoteExecuted && {remoteExecutedOwner != clientOwner}) then {
	private _ok = ["MCC_fnc_resChange"] call MCC_fnc_remoteAllowed;
	if (!_ok && {!_set} && {!(_key isEqualTo "all")}) then {
		private _sender = remoteExecutedOwner;
		private _idx = allPlayers findIf {owner _x == _sender};
		_ok = _idx >= 0 && {(side group (allPlayers select _idx)) isEqualTo _side};
	};
	if (!_ok) then {_side = sideUnknown};
};
if (_side isEqualTo sideUnknown) exitWith {
	diag_log format ["MCC resources: refused resChange from owner %1", remoteExecutedOwner];
	[]
};

private _fnc_index = {
	params ["_k"];
	if (_k isEqualType 0) exitWith {if (_k >= 0 && _k <= 4) then {floor _k} else {-1}};
	if !(_k isEqualType "") exitWith {-1};
	switch (toLowerANSI _k) do {
		case "ammo": {0};
		case "repair";
		case "materials";
		case "supply": {1};
		case "fuel": {2};
		case "food": {3};
		case "med";
		case "meds": {4};
		default {-1};
	};
};

private _varName = format ["MCC_res%1", _side];
private _result = [];

//isNil runs the block unscheduled so two server scripts can't interleave the read-modify-write
isNil {
	private _res = +(missionNamespace getVariable [_varName, [1000,1000,1000,200,200]]);
	while {count _res < 5} do {_res pushBack 0};

	private _changes = switch (true) do {
		case (_key isEqualTo "all"): {[]};
		case (_key isEqualType []): {_key};
		default {[[_key, _delta]]};
	};

	if (_key isEqualTo "all") then {
		if (_delta isEqualType [] && {count _delta >= 5}) then {
			{
				if (_x isEqualType 0) then {_res set [_forEachIndex, (_x max 0)]};
			} forEach (_delta select [0,5]);
		};
	} else {
		{
			_x params [["_k", -1, [0, ""]], ["_d", 0, [0]]];
			private _i = [_k] call _fnc_index;
			if (_i >= 0) then {
				private _new = if (_set) then {_d} else {(_res select _i) + _d};
				_res set [_i, (_new max 0)];
			};
		} forEach _changes;
	};

	missionNamespace setVariable [_varName, _res, true];
	_result = _res;
};

_result
