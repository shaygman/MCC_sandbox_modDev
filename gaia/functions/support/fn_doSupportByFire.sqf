/* ----------------------------------------------------------------------------
Function: GAIA_fnc_doSupportByFire

Description:
	Support-by-fire role (GAIA_fnc_assignRoles): the group moves to an overwatch
	position with line of sight on the conflict area and holds there, firing
	(combat mode RED, HOLD waypoint), while other groups attack and flank.
	If the leader already sees a known enemy of the CA from where it is
	(GAIA_fnc_hasLineOfSight) and is 150-800 m away, it holds where it is.
	The order is a "DoAttack" on the CA (GAIA_OrderPosition = CA), so the normal
	issueOrders cancel rules apply (CA gone, order too old, class change).

Parameters:
	0: GROUP
	1: ARRAY - CA position

Returns:
	BOOL - false when no overwatch position was found (caller falls back to doAttack)
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]], ["_caPos", [], [[]]]];

private _leader = leader _group;
if (isNull _group || {!alive _leader} || {count _caPos < 2}) exitWith {false};

private _isVehicle	= (vehicle _leader) != _leader;
private _dist		= _leader distance2D _caPos;
private _pos		= [];

//Already in a good spot?
private _enemy = _leader findNearestEnemy _caPos;
if (
	!isNull _enemy
	&& {(_enemy distance2D _caPos) < (missionNamespace getVariable ["MCC_GAIA_CA_SIZE", 200])}
	&& {_dist > 150}
	&& {_dist < 800}
	&& {[_leader, _enemy, 800, 360] call GAIA_fnc_hasLineOfSight}
) then {
	_pos = getPosATL _leader;
};

if (_pos isEqualTo []) then {
	_pos = if (_isVehicle) then {
		[_caPos, getPosATL _leader, 300, 700, true] call GAIA_fnc_findOverwatch
	} else {
		[_caPos, getPosATL _leader, 200, 450, false] call GAIA_fnc_findOverwatch
	};
};
if (_pos isEqualTo []) exitWith {false};

[_group] call GAIA_fnc_removeWaypoints;
[_group, _pos, "MOVE"] call GAIA_fnc_addAttackWaypoint;
private _wp = [_group, _pos, "HOLD"] call GAIA_fnc_addAttackWaypoint;
_wp setWaypointFormation "LINE";

_group setVariable ["GAIA_Order", "DoAttack", false];
_group setVariable ["GAIA_OrderTime", time, false];
_group setVariable ["GAIA_OrderPosition", _caPos, false];
_group setVariable ["GAIA_Role", "sbf", false];

if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
	diag_log format ["GAIA roles: %1 support-by-fire on CA %2 from %3 (%4 m)", _group, _caPos, _pos, round (_pos distance2D _caPos)];
};

true
