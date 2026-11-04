/* ----------------------------------------------------------------------------
Function: GAIA_fnc_getGroups

Description:
	Returns the GAIA registered groups (groups with a GAIA_ZONE_INTEND).
	Always returns a new array (a copy), so callers may modify it freely.
	Null groups are filtered out; groups may still be empty or have a dead
	leader, check that where it matters. Returns [] on machines other than the server.

Parameters:
	0: SIDE (optional) - only groups of this side. Omit ([] call) for all sides.

Returns:
	ARRAY of GROUP

Example:
	_westGroups = [west] call GAIA_fnc_getGroups;
	_allGroups  = [] call GAIA_fnc_getGroups;
---------------------------------------------------------------------------- */
params [["_side", sideEmpty, [sideEmpty]]];

if (isNil "GAIA_REGISTRY") exitWith {[]};

private _result = [];

if (_side isEqualTo sideEmpty) then {
	{_result append _y} forEach GAIA_REGISTRY;
} else {
	_result = +(GAIA_REGISTRY getOrDefault [str _side, []]);
};

_result select {!isNull _x}
