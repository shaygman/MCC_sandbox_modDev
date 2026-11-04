/* ----------------------------------------------------------------------------
Function: GAIA_fnc_requestSupport

Description:
	GAIA support requests (server, called by GAIA_fnc_issueOrders once per side
	per cycle, after the attack and mortar phases).
	For every conflict area (in priority order) whose threat (CA cost, the
	cached GAIA_fnc_getConflictAreaCost points) is at least
	MCC_GAIA_SUPPORT_THRESHOLD and where own GAIA groups are in contact (leader
	in COMBAT within MCC_GAIA_SUPPORT_CONTACT_RANGE), ONE response is picked:
		ARTY  - an idle GAIA mortar / artillery group in range fires
		        (GAIA_fnc_doMortar / GAIA_fnc_doArtillery). A mortar already firing
		        on the CA counts as the response. Not when danger close.
		CAS   - off-map CAS run (MCC_fnc_cas) with the side's plane class.
		        Not when danger close. Optionally only when the side has an armed
		        aircraft of its own (MCC_GAIA_SUPPORT_CAS_OWNAIR).
		REINF - motorized reinforcements (MCC_fnc_reinforcement) spawned ~2 km
		        behind the friendly group, unloaded near it, then given to GAIA in
		        that group's zone.
	Order of preference: heavily outnumbered (CA points > 4x own points in contact,
	CA points carry the x2/x3 multiplier):
	REINF, ARTY, CAS; armoured CA: CAS, ARTY, REINF; else ARTY, CAS, REINF.
	Limits: per CA cooldown (MCC_GAIA_SUPPORT_CA_COOLDOWN, also covers CAs
	within 2x CA size), per side and type cooldown and budget (number of calls
	per mission), at most GAIA_SUPPORT_PER_CYCLE (1) new response per side per
	cycle. Air CAs are ignored. State lives in the server hashMap GAIA_SUPPORT_STATE.
	Every call is written to the RPT when MCC_GAIA_debug is on.

Parameters:
	0: SIDE
	1: ARRAY   - CA positions of the side (priority order)
	2: HASHMAP - CA position -> CA cost (issueOrders' per cycle cache), may be empty
	3: ARRAY   - GAIA groups of the side
	4: ARRAY   - (optional) groups to leave alone (LAMBS task waypoints)

Returns:
	NUMBER - number of new support responses
---------------------------------------------------------------------------- */
params [
	["_side", sideUnknown, [sideUnknown]],
	["_caList", [], [[]]],
	["_costs", createHashMap, [createHashMap]],
	["_sideGroups", [], [[]]],
	["_skipGroups", [], [[]]]
];

if (!isServer) exitWith {0};
if !(missionNamespace getVariable ["MCC_GAIA_SUPPORT_ENABLED", true]) exitWith {0};
if (_side isEqualTo civilian || {_caList isEqualTo []}) exitWith {0};

if (isNil "GAIA_SUPPORT_STATE") then {GAIA_SUPPORT_STATE = createHashMap};
private _state = GAIA_SUPPORT_STATE getOrDefault [str _side, createHashMap, true];

private _debug			= missionNamespace getVariable ["MCC_GAIA_debug", false];
private _threshold		= missionNamespace getVariable ["MCC_GAIA_SUPPORT_THRESHOLD", 40];
private _contactRange	= missionNamespace getVariable ["MCC_GAIA_SUPPORT_CONTACT_RANGE", 600];
private _caCooldown		= missionNamespace getVariable ["MCC_GAIA_SUPPORT_CA_COOLDOWN", 180];
private _caSize			= missionNamespace getVariable ["MCC_GAIA_CA_SIZE", 200];
private _maxPerCycle	= missionNamespace getVariable ["GAIA_SUPPORT_PER_CYCLE", 1];

//Recent calls [position, time, type], expired ones dropped
private _calls = (_state getOrDefault ["calls", []]) select {(time - (_x select 1)) < _caCooldown};
_state set ["calls", _calls];

//Per side / type cooldown and budget
private _fnc_available = {
	params ["_type", "_cooldownVar", "_cooldownDef", "_budgetVar", "_budgetDef"];
	(time >= ((_state getOrDefault [_type + "last", -1e6]) + (missionNamespace getVariable [_cooldownVar, _cooldownDef])))
	&& {(_state getOrDefault [_type + "used", 0]) < (missionNamespace getVariable [_budgetVar, _budgetDef])}
};
private _fnc_spend = {
	params ["_type"];
	_state set [_type + "used", (_state getOrDefault [_type + "used", 0]) + 1];
	_state set [_type + "last", time];
};

//--------------------------------------------- ARTY ---------------------------------------------
private _fnc_arty = {
	if !(missionNamespace getVariable ["MCC_GAIA_SUPPORT_ARTY", true]) exitWith {false};
	if (_dangerClose) exitWith {false};

	//A mortar / artillery group is already firing on it
	if ((_sideGroups findIf {
		alive (leader _x)
		&& {(_x getVariable ["GAIA_MortarRound", 0]) > 0}
		&& {((_x getVariable ["GAIA_MortarTarget", [0,0,0]]) distance2D _caPos) < 150}
	}) > -1) exitWith {true};

	if !(["ARTY", "MCC_GAIA_SUPPORT_ARTY_COOLDOWN", 60, "MCC_GAIA_SUPPORT_ARTY_BUDGET", 20] call _fnc_available) exitWith {false};

	private _fired = false;
	{
		private _g = _x;
		private _portfolio = _g getVariable ["GAIA_Portfolio", []];
		if (
			(("DoMortar" in _portfolio) || {"DoArtillery" in _portfolio})
			&& {alive (leader _g)}
			&& {!(_g in _skipGroups)}
			&& {(_g getVariable ["GAIA_MortarRound", 0]) == 0}
			&& {[_g, _caPos] call GAIA_fnc_artyMayFire}
		) then {
			_fired = if ("DoArtillery" in _portfolio) then {[_g, _caPos] call GAIA_fnc_doArtillery} else {[_g, _caPos] call GAIA_fnc_doMortar};
			if (isNil "_fired") then {_fired = false};
		};
		if (_fired) exitWith {};
	} forEach _sideGroups;

	if (_fired) then {["ARTY"] call _fnc_spend};
	_fired
};

//--------------------------------------------- CAS ---------------------------------------------
private _fnc_planeClass = {
	private _suffix = [_side] call GAIA_fnc_sideSuffix;
	private _list = [missionNamespace getVariable ["MCC_GAIA_SUPPORT_CAS_PLANE_" + _suffix, ""]];
	_list append (switch (_side) do {
		case west:			{["B_Plane_CAS_01_dynamicLoadout_F", "B_Plane_CAS_01_F"]};
		case east:			{["O_Plane_CAS_02_dynamicLoadout_F", "O_Plane_CAS_02_F"]};
		case independent:	{["I_Plane_Fighter_03_dynamicLoadout_F", "I_Plane_Fighter_03_CAS_F"]};
		default				{[]};
	});
	private _idx = _list findIf {_x != "" && {isClass (configFile >> "CfgVehicles" >> _x)} && {_x isKindOf "Plane"}};
	if (_idx < 0) then {""} else {_list select _idx}
};

private _fnc_cas = {
	if !(missionNamespace getVariable ["MCC_GAIA_SUPPORT_CAS", true]) exitWith {false};
	if (_dangerClose || {isNil "MCC_fnc_cas"}) exitWith {false};
	if !(["CAS", "MCC_GAIA_SUPPORT_CAS_COOLDOWN", 300, "MCC_GAIA_SUPPORT_CAS_BUDGET", 2] call _fnc_available) exitWith {false};
	if (
		(missionNamespace getVariable ["MCC_GAIA_SUPPORT_CAS_OWNAIR", false])
		&& {(vehicles findIf {(_x isKindOf "Air") && {alive _x} && {(side _x) isEqualTo _side} && {canFire _x}}) < 0}
	) exitWith {false};

	private _plane = call _fnc_planeClass;
	if (_plane == "") exitWith {false};

	//Run parallel to the friendly line, not over the friendlies' heads
	private _dir = (((leader _ref) getDir _caPos) + 90) mod 360;
	private _casType = [0, 2] select _armor;
	[_plane, _casType, _dir, [_caPos select 0, _caPos select 1, 0]] spawn MCC_fnc_cas;

	["CAS"] call _fnc_spend;
	true
};

//--------------------------------------------- REINFORCEMENTS ---------------------------------------------
private _fnc_reinf = {
	if !(missionNamespace getVariable ["MCC_GAIA_SUPPORT_REINF", true]) exitWith {false};
	if (isNil "MCC_fnc_reinforcement") exitWith {false};
	if !(["REINF", "MCC_GAIA_SUPPORT_REINF_COOLDOWN", 600, "MCC_GAIA_SUPPORT_REINF_BUDGET", 2] call _fnc_available) exitWith {false};

	private _zone = (_ref getVariable ["GAIA_zone_intend", []]) param [0, ""];
	if (_zone isEqualTo "") exitWith {false};
	private _faction = faction (leader _ref);

	private _bearing = _caPos getDir (leader _ref);
	private _end = _caPos getPos [(((leader _ref) distance2D _caPos) + 300) max 500, _bearing];
	if ((surfaceIsWater _end) || {!([_end] call GAIA_fnc_isValidPos)}) then {_end = getPosATL (leader _ref)};

	//Spawn point: far behind the friendly group, dry, near a road (MCC_fnc_reinforcement needs one), no player close
	private _players = missionNamespace getVariable ["GAIA_PLAYER_LIST", []];
	private _start = [];
	{
		private _d = _x;
		{
			private _p = _caPos getPos [_d, _bearing + _x];
			if (
				!(surfaceIsWater _p)
				&& {[_p] call GAIA_fnc_isValidPos}
				&& {(_players findIf {(_x distance2D _p) < 1000}) < 0}
				&& {(_p nearRoads 500) isNotEqualTo []}
			) exitWith {_start = _p};
		} forEach [0, 30, -30];
		if (_start isNotEqualTo []) exitWith {};
	} forEach [2000, 2500, 3000];
	if (_start isEqualTo []) exitWith {false};

	private _size = 9 + ((missionNamespace getVariable ["MCC_GAIA_SUPPORT_REINF_SIZE", 0]) min 2 max 0);
	[_end, _side, _size, _zone, _faction, _start] spawn MCC_fnc_reinforcement;

	["REINF"] call _fnc_spend;
	true
};

//--------------------------------------------- Per CA ---------------------------------------------
private _issued = 0;
{
	if (_issued >= _maxPerCycle) exitWith {};
	private _caPos = _x;

	private _cost = _costs getOrDefault [_caPos, []];
	if (_cost isEqualTo []) then {
		_cost = [_side, _caPos] call GAIA_fnc_getConflictAreaCost;
		if (isNil "_cost") then {_cost = []};
	};

	if (
		count _cost > 2
		&& {((_cost select 2) >= _threshold)}
		&& {!((_cost select 0) in ["Helicopter", "Autonomous"])}
		&& {(_calls findIf {((_x select 0) distance2D _caPos) < (_caSize * 2)}) < 0}
	) then {
		private _contact = _sideGroups select {
			alive (leader _x)
			&& {behaviour (leader _x) == "COMBAT"}
			&& {((leader _x) distance2D _caPos) < _contactRange}
		};
		if (_contact isNotEqualTo []) then {
			private _threat		= _cost select 2;
			private _caClass	= _cost select 0;
			private _ownPoints	= 0;
			{_ownPoints = _ownPoints + (_x getVariable ["GAIA_points", 0])} forEach _contact;
			_contact = [_contact, [_caPos], {(leader _x) distance2D _input0}, "ASCEND"] call BIS_fnc_sortBy;
			private _ref		= _contact select 0;
			private _armor		= _caClass in ["Tank", "Car", "MotorizedRecon", "MotorizedInfantry", "MechanizedInfantry", "AA", "Artillery", "Static"];
			private _dangerClose = [_caPos, _side] call GAIA_fnc_dangerClose;

			private _order = switch (true) do {
				//CA points carry a x2 (x3 in a GAIA zone) multiplier, own points do not
				case (_threat > (4 * (_ownPoints max 1))): {["REINF", "ARTY", "CAS"]};
				case (_armor): {["CAS", "ARTY", "REINF"]};
				default {["ARTY", "CAS", "REINF"]};
			};

			private _done = "";
			{
				private _ok = switch (_x) do {
					case "ARTY":	{call _fnc_arty};
					case "CAS":		{call _fnc_cas};
					case "REINF":	{call _fnc_reinf};
					default			{false};
				};
				if (isNil "_ok") then {_ok = false};
				if (_ok) exitWith {_done = _x};
			} forEach _order;

			if (_done != "") then {
				_calls pushBack [_caPos, time, _done];
				_issued = _issued + 1;
			};

			if (_debug) then {
				diag_log format ["GAIA support %1: CA %2 threat %3 (%4) vs own %5 in contact (%6 groups), danger close %7 -> %8 | used ARTY %9 CAS %10 REINF %11",
					_side, _caPos, round _threat, _caClass, round _ownPoints, count _contact, _dangerClose,
					[_done, "none available"] select (_done == ""),
					_state getOrDefault ["ARTYused", 0], _state getOrDefault ["CASused", 0], _state getOrDefault ["REINFused", 0]
				];
			};
		};
	};
} forEach _caList;

_issued
