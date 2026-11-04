/* ----------------------------------------------------------------------------
Function: GAIA_fnc_registrySweep

Description:
	Cheap periodic consistency pass over the GAIA group registry (server only).
	Called by the GAIA per-frame handler every ~10 seconds (unscheduled).
		- Prunes null groups, groups without units, groups that lost their
		  GAIA_ZONE_INTEND and groups that changed side (those get re-added
		  under their new side in the same pass).
		- Auto-registers every group that has a GAIA_ZONE_INTEND but is not
		  registered yet (so intends set by code that does not call
		  GAIA_fnc_registerGroup are not missed).
		- Rebuilds GAIA_CACHE_GROUPS: all groups flagged "mcc_gaia_cache"
		  (these may be non GAIA groups, they are only used for caching).

Parameters:
	none

Returns:
	NUMBER - number of registered groups after the sweep
---------------------------------------------------------------------------- */
if (!isServer) exitWith {0};

if (isNil "GAIA_REGISTRY") then {GAIA_REGISTRY = createHashMap};

//Prune
{
	private _key = _x;
	private _arr = GAIA_REGISTRY getOrDefault [_key, []];
	private _keep = [];
	{
		if (
			!isNull _x
			&& {(units _x) isNotEqualTo []}
			&& {(str (side _x)) isEqualTo _key}
			&& {(_x getVariable ["GAIA_ZONE_INTEND",[]]) isNotEqualTo []}
		) then {
			_keep pushBack _x;
		} else {
			if (!isNull _x) then {_x setVariable ["GAIA_REG_SIDE", nil]};
		};
	} forEach _arr;
	GAIA_REGISTRY set [_key, _keep];
} forEach (keys GAIA_REGISTRY);

//Add missing groups and collect cached groups
private _cacheGroups = [];
{
	if (
		(_x getVariable ["GAIA_REG_SIDE", ""]) isEqualTo ""
		&& {(_x getVariable ["GAIA_ZONE_INTEND",[]]) isNotEqualTo []}
		&& {(units _x) isNotEqualTo []}
	) then {
		[_x] call GAIA_fnc_registerGroup;
	};
	if (_x getVariable ["mcc_gaia_cache", false]) then {_cacheGroups pushBack _x};
} forEach allGroups;

GAIA_CACHE_GROUPS = _cacheGroups;

private _total = 0;
{_total = _total + count _y} forEach GAIA_REGISTRY;
_total
