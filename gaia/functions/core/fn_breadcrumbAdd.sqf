/* ----------------------------------------------------------------------------
Function: GAIA_fnc_breadcrumbAdd

Description:
	Drops a breadcrumb ([position,time]) for a side (server, called by
	GAIA_fnc_analyzeTargets). Breadcrumbs are stored twice, sharing the same
	[position,time] arrays:
		- MCC_GAIA_BREADCRUMBS_<SIDE>: flat array (kept for compatibility, e.g. GAIA_fnc_isCleared)
		- GAIA_BC_GRID: hashMap str side -> hashMap [cellX,cellY] -> array of breadcrumbs
		  (cell size GAIA_BC_CELL meters) used for fast proximity lookups.
	A breadcrumb closer than GAIA_BC_MERGE meters to an existing one in the same
	cell only refreshes the time of that one, so static groups do not pile up
	thousands of breadcrumbs.

Parameters:
	0: SIDE
	1: ARRAY - position

Returns:
	nothing
---------------------------------------------------------------------------- */
params [["_side", sideEmpty, [sideEmpty]], ["_pos", [], [[]]]];

if (count _pos < 2) exitWith {};

private _suffix = [_side] call GAIA_fnc_sideSuffix;
if (_suffix isEqualTo "") exitWith {};

if (isNil "GAIA_BC_GRID") then {GAIA_BC_GRID = createHashMap};
private _cellSize = missionNamespace getVariable ["GAIA_BC_CELL", 100];
private _merge = missionNamespace getVariable ["GAIA_BC_MERGE", 10];

private _grid = GAIA_BC_GRID getOrDefault [_suffix, createHashMap, true];
private _cell = [floor ((_pos select 0) / _cellSize), floor ((_pos select 1) / _cellSize)];
private _crumbs = _grid getOrDefault [_cell, [], true];

private _idx = _crumbs findIf {((_x select 0) distance _pos) < _merge};
if (_idx > -1) then {
	//Same array is referenced by the flat list, so this refreshes both
	(_crumbs select _idx) set [1, time];
} else {
	private _crumb = [_pos, time];
	_crumbs pushBack _crumb;
	private _varName = "MCC_GAIA_BREADCRUMBS_" + _suffix;
	private _flat = missionNamespace getVariable [_varName, []];
	_flat pushBack _crumb;
	missionNamespace setVariable [_varName, _flat];
};
