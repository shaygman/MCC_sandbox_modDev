/* ----------------------------------------------------------------------------
Function: GAIA_fnc_doArtillery

Description:
	Fire mission of a GAIA artillery group (class "Artillery", portfolio
	"DoArtillery": self propelled guns / rocket artillery, artilleryScanner = 1).
	Called once per GAIA cycle by GAIA_fnc_issueOrders (routine fire) and
	GAIA_fnc_requestSupport (support call) while the mission runs.
	Every artillery vehicle of the group fires with its own artillery magazine
	(GAIA_fnc_fireMission, vehicle mode: forwarded to the headless client that
	owns the group). Shorter than a mortar mission:
		round 0: 1 adjusting round per gun, 150 m spread
		round 1: 1 adjusting round per gun,  60 m spread
		round 2: fire for effect, 3 rounds per gun, 25 m spread
		round 3: fire for effect, 2 rounds per gun, 40 m spread -> mission done
	Uses the same group variables as GAIA_fnc_doMortar (GAIA_MortarRound,
	GAIA_MortarTarget), the order is "DoArtillery".

Parameters:
	0: GROUP
	1: ARRAY - target position (ignored while a mission is running: the
	           mission target GAIA_MortarTarget is used)

Returns:
	BOOL - true when the target is in range of at least one gun (and it fired)
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]], ["_pos", [0,0,0], [[]]]];

if (isNull _group) exitWith {false};

//Artillery vehicles of the group
private _guns = [];
{
	private _veh = vehicle _x;
	if (
		alive _x
		&& {_veh != _x}
		&& {alive _veh}
		&& {!(_veh in _guns)}
		&& {getNumber (configOf _veh >> "artilleryScanner") == 1}
		&& {(getArtilleryAmmo [_veh]) isNotEqualTo []}
	) then {_guns pushBack _veh};
} forEach (units _group);
if (_guns isEqualTo []) exitWith {false};

private _round = _group getVariable ["GAIA_MortarRound", 0];

//Busy: finish what we started
if (_round > 0) then {_pos = _group getVariable ["GAIA_MortarTarget", _pos]};

private _ammo = (getArtilleryAmmo [_guns select 0]) select 0;
private _isInRange = (_round > 0) || {(_guns findIf {_pos inRangeOfArtillery [[_x], (getArtilleryAmmo [_x]) select 0]}) > -1};
if (!_isInRange) exitWith {false};

private _spread = 150;
private _rounds = 1;
switch (true) do {
	case (_round < 1): {_spread = 150; _rounds = 1};
	case (_round < 2): {_spread = 60;  _rounds = 1};
	case (_round < 3): {_spread = 25;  _rounds = 3};
	default            {_spread = 40;  _rounds = 2};
};

private _firePos = if (_spread > 0) then {_pos getPos [random _spread, random 360]} else {_pos};
[_group, _firePos, _ammo, _rounds, true] call GAIA_fnc_fireMission;

_round = _round + 1;
if (_round >= 4) then {
	_group setVariable ["GAIA_MortarRound", 0, false];
	_group setVariable ["GAIA_MortarTarget", [0,0,0], false];
} else {
	_group setVariable ["GAIA_MortarRound", _round, false];
	_group setVariable ["GAIA_MortarTarget", _pos, false];
};

//Lets set the current Order.
_group setVariable ["GAIA_Order", "DoArtillery", false];
_group setVariable ["GAIA_OrderTime", time, false];
_group setVariable ["GAIA_OrderPosition", (position leader _group), false];

true
