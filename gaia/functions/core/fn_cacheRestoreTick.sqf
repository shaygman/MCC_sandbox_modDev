/* ----------------------------------------------------------------------------
Function: GAIA_fnc_cacheRestoreTick

Description:
	World level part of the old GAIA cache loop, called about once per second by
	the GAIA per-frame handler (server, unscheduled):
		- restores far cached (stage 2) groups when a player comes within
		  GAIA_CACHE_STAGE_2 of their stored position (GAIA_fnc_uncacheFar)
		- starts delayed MCC spawns (MCC_DELAYED_SPAWNS) when a player comes
		  within GAIA_CACHE_STAGE_2

Parameters:
	none

Returns:
	nothing
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};

private _range = missionNamespace getVariable ["GAIA_CACHE_STAGE_2", 2000];

//Far cache (stage 2) restore
private _stage2 = missionNamespace getVariable ["MCC_GAIA_CACHE_STAGE2", []];
if (_stage2 isNotEqualTo []) then {
	private _keep = [];
	{
		if ([_x, _range] call GAIA_fnc_isNearPlayer) then {
			[(missionNamespace getVariable ["GAIA_CACHE_" + str(_x), [0,0,0]])] call GAIA_fnc_uncacheFar;
			missionNamespace setVariable ["GAIA_CACHE_" + str(_x), nil];
		} else {
			_keep pushBack _x;
		};
	} forEach _stage2;
	MCC_GAIA_CACHE_STAGE2 = _keep;
};

//Delayed spawning (MCC_DELAYED_SPAWNS is filled by mcc_pv_handler)
private _delayed = missionNamespace getVariable ["MCC_DELAYED_SPAWNS", []];
if (_delayed isNotEqualTo []) then {
	private _keep = [];
	{
		if ([_x, _range] call GAIA_fnc_isNearPlayer) then {
			private _ar = (missionNamespace getVariable ["MCC_DELAY" + str(_x), [0,0,0]]);
			//Disable delayed (we are the delayed spawn)
			_ar set [27, false];
			_ar remoteExec ["mcc_setup", 2];
		} else {
			_keep pushBack _x;
		};
	} forEach _delayed;
	MCC_DELAYED_SPAWNS = _keep;
};
