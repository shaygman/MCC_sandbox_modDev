/* ----------------------------------------------------------------------------
Function: GAIA_fnc_dangerClose

Description:
	Danger-close check for indirect fire and CAS: are there friendly (own side or
	allied, not civilian) men or vehicles near a position? One nearEntities call.

Parameters:
	0: ARRAY  - position
	1: SIDE   - side that wants to fire
	2: NUMBER - (optional) radius in meters, default setting MCC_GAIA_SUPPORT_DANGERCLOSE (200)

Returns:
	BOOL - true when friendlies are within the radius (do NOT fire)

Example:
	if !([_caPos, east] call GAIA_fnc_dangerClose) then {...};
---------------------------------------------------------------------------- */
params [["_pos", [], [[]]], ["_side", sideUnknown, [sideUnknown]], ["_radius", -1, [0]]];

if (count _pos < 2) exitWith {true};
if (_radius < 0) then {_radius = missionNamespace getVariable ["MCC_GAIA_SUPPORT_DANGERCLOSE", 200]};

private _near = _pos nearEntities [["CAManBase", "Car", "Tank", "StaticWeapon"], _radius];

(_near findIf {
	alive _x
	&& {
		(side _x) isEqualTo _side
		|| {(side _x) isNotEqualTo civilian && {((side _x) getFriend _side) >= 0.6}}
	}
}) > -1
