/*
	GAIA_fnc_safePos
	BIS_fnc_findSafePos that never returns the map center. On failure returns the fallback position.
	Params:
		0: ARRAY  - center position
		1: NUMBER - min distance
		2: NUMBER - max distance
		3: NUMBER - min distance from objects
		4: NUMBER - water mode (0 land, 1 both, 2 water)
		5: NUMBER - max gradient
		6: NUMBER - shore mode
		7: ARRAY  - (optional) fallback, default = center position
	Returns: ARRAY - position
*/
params ["_center", "_min", "_max", "_objDist", "_water", "_grad", "_shore", ["_fallback", []]];

if (_fallback isEqualTo []) then {_fallback = _center};
if !([_center] call GAIA_fnc_isValidPos) exitWith {_fallback};

private _pos = [_center, _min, _max, _objDist, _water, _grad, _shore, [], [_fallback, _fallback]] call BIS_fnc_findSafePos;
if !([_pos] call GAIA_fnc_isValidPos) then {_pos = _fallback};
_pos
