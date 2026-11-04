/* ----------------------------------------------------------------------------
Function: GAIA_fnc_findLZ

Description:
	Helicopter landing zone near a position: flat (max gradient 0.15), dry,
	at least 12 m from objects, within 150 m (GAIA_fnc_safePos, which never
	returns the map center). Falls back to the position itself.

Parameters:
	0: ARRAY  - wanted position
	1: NUMBER - (optional) search radius, default 150

Returns:
	ARRAY - LZ position

Example:
	_lz = [getPosATL leader _group] call GAIA_fnc_findLZ;
---------------------------------------------------------------------------- */
params [["_pos", [], [[]]], ["_radius", 150, [0]]];

if !([_pos] call GAIA_fnc_isValidPos) exitWith {_pos};

[_pos, 0, _radius, 12, 0, 0.15, 0, _pos] call GAIA_fnc_safePos
