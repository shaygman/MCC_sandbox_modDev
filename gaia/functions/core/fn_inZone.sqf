/* ----------------------------------------------------------------------------
Function: GAIA_fnc_inZone

Description:
	Fast replacement of GAIA_fnc_isPositionInMarker for GAIA zones.
	Area markers (RECTANGLE / ELLIPSE) are tested with the engine command
	inArea; any other marker shape falls back to GAIA_fnc_isPositionInMarker
	so the result stays the same as before.

Parameters:
	0: ARRAY - position
	1: STRING - marker name

Returns:
	BOOL

Example:
	_inside = [getPos leader _group, "3"] call GAIA_fnc_inZone;
---------------------------------------------------------------------------- */
params [["_pos", [], [[]]], ["_marker", "", [""]]];

if (count _pos < 2) exitWith {false};

//Same guard as GAIA_fnc_isPositionInMarker: a marker at [0,0,0] does not exist
private _markerPos = getMarkerPos _marker;
if ((_markerPos distance [0,0,0]) == 0) exitWith {false};

if ((toUpper (markerShape _marker)) in ["RECTANGLE","ELLIPSE"]) then {
	_pos inArea _marker
} else {
	[_pos, _marker] call GAIA_fnc_isPositionInMarker
}
