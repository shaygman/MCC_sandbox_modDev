/* ----------------------------------------------------------------------------
Function: GAIA_fnc_breadcrumbPrune

Description:
	Removes breadcrumbs older than the given life time, caps the number of
	breadcrumbs per side (newest are kept, GAIA_BC_CAP, default 1500) and
	rebuilds the spatial grid for that side (see GAIA_fnc_breadcrumbAdd).
	Server, called once per GAIA cycle per side by GAIA_fnc_analyzeTargets.

Parameters:
	0: SIDE
	1: NUMBER - life time of a breadcrumb in seconds

Returns:
	NUMBER - number of breadcrumbs kept
---------------------------------------------------------------------------- */
params [["_side", sideEmpty, [sideEmpty]], ["_lifeTime", 300, [0]]];

private _suffix = [_side] call GAIA_fnc_sideSuffix;
if (_suffix isEqualTo "") exitWith {0};

if (isNil "GAIA_BC_GRID") then {GAIA_BC_GRID = createHashMap};
private _cellSize = missionNamespace getVariable ["GAIA_BC_CELL", 100];
private _cap = missionNamespace getVariable ["GAIA_BC_CAP", 1500];

private _varName = "MCC_GAIA_BREADCRUMBS_" + _suffix;
private _now = time;
private _flat = (missionNamespace getVariable [_varName, []]) select {(_now - (_x select 1)) <= _lifeTime};

if (count _flat > _cap) then {
	_flat = [_flat, [], {_x select 1}, "DESCEND"] call BIS_fnc_sortBy;
	_flat resize _cap;
};

missionNamespace setVariable [_varName, _flat];

//Rebuild the grid from the flat list (same array references)
private _grid = createHashMap;
{
	private _pos = _x select 0;
	(_grid getOrDefault [[floor ((_pos select 0) / _cellSize), floor ((_pos select 1) / _cellSize)], [], true]) pushBack _x;
} forEach _flat;
GAIA_BC_GRID set [_suffix, _grid];

count _flat
