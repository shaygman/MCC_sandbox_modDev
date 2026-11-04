/* ----------------------------------------------------------------------------
Function: GAIA_fnc_doHold

Description:
	Hold / reserve role (GAIA_fnc_assignRoles): the group takes a covered
	position about 450 m from the conflict area on its own side and holds
	there (HOLD waypoint). GAIA_fnc_assignRoles commits it to the attack when
	no attack-role group is left on that CA.
	The order is a "DoAttack" on the CA (GAIA_OrderPosition = CA).

Parameters:
	0: GROUP
	1: ARRAY - CA position

Returns:
	BOOL - true
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]], ["_caPos", [], [[]]]];

private _leader = leader _group;
if (isNull _group || {!alive _leader} || {count _caPos < 2}) exitWith {false};

private _ca2D	= [_caPos select 0, _caPos select 1, 0];
private _pos	= getPosATL _leader;

//Further out than the reserve line: move up to it, in cover when possible
if ((_leader distance2D _ca2D) > 500) then {
	private _p = _ca2D getPos [450, _ca2D getDir _leader];
	private _cover = selectBestPlaces [_p, 60, "forest+trees+houses-(10*sea)", 5, 1];
	if (_cover isNotEqualTo []) then {
		private _c = (_cover select 0) select 0;
		if (!(surfaceIsWater _c) && {[_c] call GAIA_fnc_isValidPos}) then {_p = _c};
	};
	if (!(surfaceIsWater _p) && {[_p] call GAIA_fnc_isValidPos}) then {_pos = _p};
};

[_group] call GAIA_fnc_removeWaypoints;
if ((_leader distance2D _pos) > 30) then {[_group, _pos, "MOVE"] call GAIA_fnc_addAttackWaypoint};
[_group, _pos, "HOLD"] call GAIA_fnc_addAttackWaypoint;

_group setVariable ["GAIA_Order", "DoAttack", false];
_group setVariable ["GAIA_OrderTime", time, false];
_group setVariable ["GAIA_OrderPosition", _caPos, false];
_group setVariable ["GAIA_Role", "hold", false];

if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
	diag_log format ["GAIA roles: %1 holds in reserve for CA %2 at %3", _group, _caPos, _pos];
};

true
