/* ----------------------------------------------------------------------------
Function: GAIA_fnc_artyMayFire

Description:
	Zone rule for GAIA mortar / artillery groups: may this group fire on a
	position? MOVE groups fire anywhere. NOFOLLOW groups fire only inside their
	own zone, unless the CBA setting MCC_GAIA_ARTY_OUTSIDE_ZONE is on.
	Other intends (DEFEND, FORTIFY, ...) do not fire, as before.

Parameters:
	0: GROUP
	1: ARRAY - target position

Returns:
	BOOL
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]], ["_pos", [], [[]]]];

private _intend = _group getVariable ["GAIA_zone_intend", []];
if (count _intend < 2) exitWith {false};

switch (_intend select 1) do {
	case "MOVE": {true};
	case "NOFOLLOW": {
		(missionNamespace getVariable ["MCC_GAIA_ARTY_OUTSIDE_ZONE", false])
		|| {[_pos, _intend select 0] call GAIA_fnc_inZone}
	};
	default {false};
}
