/* ----------------------------------------------------------------------------
Function: GAIA_fnc_sideSuffix

Description:
	Returns the suffix GAIA uses in its per side global variable names
	(MCC_GAIA_xxx_WEST / _EAST / _INDEP / _CIV).

Parameters:
	0: SIDE

Returns:
	STRING - "WEST", "EAST", "INDEP", "CIV" or "" for any other side

Example:
	_var = "MCC_GAIA_BREADCRUMBS_" + ([west] call GAIA_fnc_sideSuffix);
---------------------------------------------------------------------------- */
params [["_side", sideEmpty, [sideEmpty]]];

switch (_side) do {
	case west:			{"WEST"};
	case east:			{"EAST"};
	case independent:	{"INDEP"};
	case civilian:		{"CIV"};
	default				{""};
}
