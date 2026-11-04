/* ----------------------------------------------------------------------------
Function: GAIA_fnc_perFrame

Description:
	Body of the GAIA CBA per-frame handler (installed by GAIA_fnc_startGaiaCache
	on the server and on headless clients). Never sleeps, never spawns per group.

	Server, every frame:
		- GAIA_fnc_groupTick for GAIA_GROUP_BUDGET (default 5) groups, round robin
		  over a snapshot of the registry + cache flagged groups. A new snapshot is
		  taken at most every GAIA_GROUP_PASS_MIN seconds (default 1), so a group is
		  ticked at most once per second.
		- GAIA_fnc_groupMaintenance for GAIA_MAINT_BUDGET (default 5) groups, round
		  robin over a snapshot of allGroups, new snapshot at most every
		  GAIA_MAINT_PASS_MIN seconds (default 2). Starts at mission time 120.
		- every ~1 s: refresh the player list (GAIA_PLAYER_LIST) and run
		  GAIA_fnc_cacheRestoreTick.
		- every ~10 s: GAIA_fnc_registrySweep.
	Headless client, every frame:
		- GAIA_fnc_groupMaintenance for GAIA_MAINT_BUDGET LOCAL groups.

Parameters:
	CBA per-frame handler arguments (unused)

Returns:
	nothing
---------------------------------------------------------------------------- */
private _now = time;

//------------------------------- Server only work -------------------------------
if (isServer) then {

	//Player list + far cache restore, once per second
	if (_now >= GAIA_PF_NEXT_SECOND) then {
		GAIA_PF_NEXT_SECOND = _now + 1;
		private _players = playableUnits select {isPlayer _x};
		if (playableUnits isEqualTo []) then {_players = [player]};
		GAIA_PLAYER_LIST = _players;
		GAIA_PLAYER_LIST_TIME = _now;
		[] call GAIA_fnc_cacheRestoreTick;
	};

	//Registry sweep, every 10 seconds
	if (_now >= GAIA_PF_NEXT_SWEEP) then {
		GAIA_PF_NEXT_SWEEP = _now + (missionNamespace getVariable ["GAIA_SWEEP_INTERVAL", 10]);
		private _registered = [] call GAIA_fnc_registrySweep;
		if (MCC_GAIA_DEBUG) then {
			diag_log format ["GAIA PFH: registered %1, cache groups %2, tick snapshot %3, maintenance snapshot %4, far cached %5, fps %6",
				_registered, count GAIA_CACHE_GROUPS, count GAIA_PF_SNAP, count GAIA_PF_MSNAP,
				count (missionNamespace getVariable ["MCC_GAIA_CACHE_STAGE2", []]), round diag_fps];
		};
	};

	//Per group tick
	if (GAIA_PF_IDX >= count GAIA_PF_SNAP) then {
		if (_now >= GAIA_PF_NEXT_PASS) then {
			GAIA_PF_NEXT_PASS = _now + (missionNamespace getVariable ["GAIA_GROUP_PASS_MIN", 1]);
			private _snap = ([] call GAIA_fnc_getGroups) + (missionNamespace getVariable ["GAIA_CACHE_GROUPS", []]);
			GAIA_PF_SNAP = _snap arrayIntersect _snap;
			GAIA_PF_IDX = 0;
		};
	};
	private _budget = missionNamespace getVariable ["GAIA_GROUP_BUDGET", 5];
	while {_budget > 0 && {GAIA_PF_IDX < count GAIA_PF_SNAP}} do {
		private _group = GAIA_PF_SNAP select GAIA_PF_IDX;
		GAIA_PF_IDX = GAIA_PF_IDX + 1;
		_budget = _budget - 1;
		if (!isNull _group) then {[_group] call GAIA_fnc_groupTick};
	};
};

//------------------------------- Group maintenance (server and HC) -------------------------------
if (_now < 120) exitWith {};

if (GAIA_PF_MIDX >= count GAIA_PF_MSNAP) then {
	if (_now >= GAIA_PF_NEXT_MPASS) then {
		GAIA_PF_NEXT_MPASS = _now + (missionNamespace getVariable ["GAIA_MAINT_PASS_MIN", 2]);
		GAIA_PF_MSNAP = if (isServer) then {+allGroups} else {allGroups select {local _x}};
		GAIA_PF_MIDX = 0;
	};
};
private _mBudget = missionNamespace getVariable ["GAIA_MAINT_BUDGET", 5];
while {_mBudget > 0 && {GAIA_PF_MIDX < count GAIA_PF_MSNAP}} do {
	private _group = GAIA_PF_MSNAP select GAIA_PF_MIDX;
	GAIA_PF_MIDX = GAIA_PF_MIDX + 1;
	_mBudget = _mBudget - 1;
	if (!isNull _group) then {[_group] call GAIA_fnc_groupMaintenance};
};
