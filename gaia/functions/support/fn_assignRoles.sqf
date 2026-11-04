/* ----------------------------------------------------------------------------
Function: GAIA_fnc_assignRoles

Description:
	Coordinated attack on one conflict area (called by GAIA_fnc_issueOrders,
	scheduled, once per CA per cycle with the groups it selected for that CA).
	Instead of every group running GAIA_fnc_doAttack on its own, one pass gives
	each NEW responder a role, taking the roles of groups already on this CA
	(GAIA_Order "DoAttack", GAIA_OrderPosition = CA, GAIA_Role) into account:
		attack - GAIA_fnc_doAttack (main effort, direct approach). Groups already
		         in combat close to the CA, air and ships always attack.
		sbf    - GAIA_fnc_doSupportByFire (one per CA): vehicle groups with guns
		         (Tank, Car, MotorizedRecon, AA) or, with 3+ ground groups, an
		         infantry group. Overwatch position with line of sight.
		flank  - GAIA_fnc_doFlank (max 2, alternating sides): approach from another
		         bearing than the main attack.
		hold   - GAIA_fnc_doHold (max 1, with 4+ ground groups): reserve, committed
		         when no attack-role group is left on the CA.
	A single responder (and the CBA setting MCC_GAIA_COORDINATION off) keeps the
	old behaviour: GAIA_fnc_doAttack. Groups already on this CA are not re-ordered.

Parameters:
	0: SIDE
	1: ARRAY - CA position
	2: ARRAY - responders (groups selected by issueOrders for this CA this cycle)
	3: ARRAY - all GAIA groups of the side (registry snapshot of issueOrders)

Returns:
	NUMBER - number of groups that got a new order
---------------------------------------------------------------------------- */
params [["_side", sideUnknown, [sideUnknown]], ["_caPos", [], [[]]], ["_responders", [], [[]]], ["_sideGroups", [], [[]]]];

if (_responders isEqualTo [] || {count _caPos < 2}) exitWith {0};

private _fnc_pause = {if (canSuspend) then {sleep 0.05}};

//Old behaviour
if (!(missionNamespace getVariable ["MCC_GAIA_COORDINATION", true]) || {count _responders == 1}) exitWith {
	{
		//A group already on this CA keeps its order and role (doAttack is a no-op for it)
		if (
			(_x getVariable ["GAIA_Order", ""]) != "DoAttack"
			|| {((_x getVariable ["GAIA_OrderPosition", [0,0,0]]) distance2D _caPos) >= 1}
		) then {_x setVariable ["GAIA_Role", "attack", false]};
		[_x, _caPos] call GAIA_fnc_doAttack;
	} forEach _responders;
	count _responders
};

private _ground		= ["Infantry", "ReconInfantry", "Car", "MotorizedRecon", "MotorizedInfantry", "MechanizedInfantry", "Tank", "AA", "Unknown"];
private _sbfClasses	= ["Tank", "Car", "MotorizedRecon", "AA"];

//Groups already working on this CA and their roles
private _onCA = _sideGroups select {
	alive (leader _x)
	&& {(_x getVariable ["GAIA_Order", ""]) == "DoAttack"}
	&& {((_x getVariable ["GAIA_OrderPosition", [0,0,0]]) distance2D _caPos) < 1}
};
private _roleOf = {_this getVariable ["GAIA_Role", "attack"]};
private _attackers	= _onCA select {(_x call _roleOf) == "attack" && {(_x getVariable ["GAIA_class", ""]) in _ground}};
private _nrSbf		= {(_x call _roleOf) == "sbf"} count _onCA;
private _nrFlank	= {(_x call _roleOf) == "flank"} count _onCA;
private _holders	= _onCA select {(_x call _roleOf) == "hold"};

//New responders, closest first (the ones already on this CA keep their order)
private _new = _responders select {!(_x in _onCA) && {alive (leader _x)}};
_new = [_new, [_caPos], {(leader _x) distance2D _input0}, "ASCEND"] call BIS_fnc_sortBy;

private _nrGround = ({(_x getVariable ["GAIA_class", ""]) in _ground} count (_new + _onCA));
private _mainBearing = if (_attackers isNotEqualTo []) then {_caPos getDir (leader (_attackers select 0))} else {-1};
private _flankSign = [1, -1] select ((_nrFlank mod 2) == 1);
private _issued = 0;

{
	//Pause first: the order time set below must be later than the start of this issueOrders
	//round, or the group would count as "not ordered this round" for the next CA
	call _fnc_pause;
	private _grp	= _x;
	private _class	= _grp getVariable ["GAIA_class", ""];
	private _leader	= leader _grp;
	private _engaged = (behaviour _leader == "COMBAT") && {(_leader distance2D _caPos) < 400};
	private _role	= "attack";

	switch (true) do {
		//Air, ships and groups already fighting there: attack, as before
		case (!(_class in _ground) || _engaged): {_role = "attack"};
		//Nobody leads the assault yet
		case (_mainBearing < 0): {_role = "attack"};
		case (
			_nrSbf == 0
			&& {(_class in _sbfClasses) || {_class in ["Infantry", "ReconInfantry"] && {_nrGround >= 3}}}
		): {_role = "sbf"};
		case (_nrFlank < 2): {_role = "flank"};
		case (_holders isEqualTo [] && {_nrGround >= 4}): {_role = "hold"};
		default {_role = "attack"};
	};

	private _done = switch (_role) do {
		case "sbf":		{[_grp, _caPos] call GAIA_fnc_doSupportByFire};
		case "flank":	{[_grp, _caPos, _mainBearing, _flankSign] call GAIA_fnc_doFlank};
		case "hold":	{[_grp, _caPos] call GAIA_fnc_doHold};
		default			{false};
	};
	if (isNil "_done") then {_done = false};

	if (_done) then {
		switch (_role) do {
			case "sbf":		{_nrSbf = _nrSbf + 1};
			case "flank":	{_nrFlank = _nrFlank + 1; _flankSign = -(_grp getVariable ["GAIA_FlankSign", _flankSign])};
			case "hold":	{_holders pushBack _grp};
		};
	} else {
		_role = "attack";
		[_grp, _caPos] call GAIA_fnc_doAttack;
		_grp setVariable ["GAIA_Role", "attack", false];
		if (_class in _ground) then {
			_attackers pushBack _grp;
			if (_mainBearing < 0) then {_mainBearing = _caPos getDir _leader};
		};
	};
	_issued = _issued + 1;
} forEach _new;

//Reserve: commit it when no ground attack-role group is left on this CA
if (_holders isNotEqualTo [] && {(_attackers findIf {alive (leader _x) && {(units _x) isNotEqualTo []}}) < 0}) then {
	private _grp = _holders select 0;
	if (alive (leader _grp)) then {
		_grp setVariable ["GAIA_Order", "Commit", false];
		[_grp, _caPos] call GAIA_fnc_doAttack;
		_grp setVariable ["GAIA_Role", "attack", false];
		_issued = _issued + 1;
		if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
			diag_log format ["GAIA roles: reserve %1 committed to CA %2 (no attack group left)", _grp, _caPos];
		};
	};
};

if ((missionNamespace getVariable ["MCC_GAIA_debug", false]) && {_new isNotEqualTo []}) then {
	diag_log format ["GAIA roles %1: CA %2 responders %3 (new %4) -> %5",
		_side, _caPos, count _responders, count _new,
		(_new + _onCA) apply {[_x, _x getVariable ["GAIA_Role", "?"]]}
	];
};

_issued
