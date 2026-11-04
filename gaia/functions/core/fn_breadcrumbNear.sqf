/* ----------------------------------------------------------------------------
Function: GAIA_fnc_breadcrumbNear

Description:
	Checks whether a side has a (live) breadcrumb closer than a range to a
	position, using the breadcrumb spatial grid (only the cells that can hold a
	breadcrumb within range are checked).

Parameters:
	0: ARRAY - position
	1: SIDE
	2: NUMBER - range in meters

Returns:
	BOOL

Example:
	_isCleared = [_pos, west, MCC_GAIA_CLEARRANGE] call GAIA_fnc_breadcrumbNear;
---------------------------------------------------------------------------- */
params [["_pos", [], [[]]], ["_side", sideEmpty, [sideEmpty]], ["_range", 100, [0]]];

if (count _pos < 2 || {isNil "GAIA_BC_GRID"}) exitWith {false};

private _suffix = [_side] call GAIA_fnc_sideSuffix;
private _grid = GAIA_BC_GRID getOrDefault [_suffix, createHashMap];
if (count _grid == 0) exitWith {false};

private _cellSize = missionNamespace getVariable ["GAIA_BC_CELL", 100];
private _span = ceil (_range / _cellSize);
private _cx = floor ((_pos select 0) / _cellSize);
private _cy = floor ((_pos select 1) / _cellSize);
private _found = false;

for "_ix" from (_cx - _span) to (_cx + _span) do {
	for "_iy" from (_cy - _span) to (_cy + _span) do {
		private _crumbs = _grid getOrDefault [[_ix, _iy], []];
		if ((_crumbs findIf {(_pos distance (_x select 0)) < _range}) > -1) exitWith {_found = true};
	};
	if (_found) exitWith {};
};

_found
