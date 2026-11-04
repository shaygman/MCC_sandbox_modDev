/* ----------------------------------------------------------------------------
Function: fnc_isblacklisted

Description:
	Checks if the given position is witin MCC_GAIA_AWARENESSRANGE of a GAIA
	waypoint (MCC_GAIA_WPPOS_<SIDE>) or of a recent breadcrumb of that side.
	Breadcrumbs are looked up in the breadcrumb spatial grid (GAIA_fnc_breadcrumbNear)
	instead of scanning every breadcrumb.

Parameters:
	- position
	- side

Returns:
	true/false

Author:
	Spirit
---------------------------------------------------------------------------- */
params ["_pos", "_side"];

private _range = MCC_GAIA_AWARENESSRANGE;

//Breadcrumbs (grid)
if ([_pos, _side, _range] call GAIA_fnc_breadcrumbNear) exitWith {true};

//Waypoints in use ([position, group] entries)
private _wpPos = missionNamespace getVariable ["MCC_GAIA_WPPOS_" + ([_side] call GAIA_fnc_sideSuffix), []];

(_wpPos findIf {(_pos distance (_x select 0)) < _range}) > -1
