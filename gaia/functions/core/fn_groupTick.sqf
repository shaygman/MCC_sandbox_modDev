/* ----------------------------------------------------------------------------
Function: GAIA_fnc_groupTick

Description:
	Cheap per group work, called by the GAIA per-frame handler (server,
	unscheduled) for a fixed budget of groups per frame, round robin over the
	GAIA registry plus all groups flagged "mcc_gaia_cache".
	Replaces the old GAIA cache loop (fn_startGaiaCache: sleep 0.1 + spawn per group).

	Caching (only groups with "mcc_gaia_cache" = true):
		Stage 1: engine Dynamic Simulation for the whole group. Enabled when the
		         group is not in COMBAT, is not a mortar/artillery group and has
		         no "moving" order (GAIA_DS_EXCLUDED_ORDERS, default
		         DoAttack/DoClear/DoTransport/DoSupport), disabled otherwise.
		         Wake distance = "Group" dynamic simulation distance, set from the
		         cache distance setting GAIA_CACHE_STAGE_1 (see GAIA_fnc_dsSetup).
		         Groups still cached by the old custom stage 1 are uncached.
		Stage 2: no player within GAIA_CACHE_STAGE_2 -> GAIA_fnc_cacheFar
		         (serialize and delete, restored by GAIA_fnc_cacheRestoreTick).
	Vehicles:
		GAIA groups (with a GAIA_ZONE_INTEND) are passed to GAIA_fnc_vehicleTick
		when that function exists.

Parameters:
	0: GROUP

Returns:
	nothing
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]]];

if (isNull _group) exitWith {};
if ((units _group) isEqualTo []) exitWith {};
private _leader = leader _group;
if (!alive _leader) exitWith {};

//------------------------------- Caching -------------------------------
if (_group getVariable ["mcc_gaia_cache", false]) then {

	//Legacy stage 1 cache (custom freeze) -> restore, dynamic simulation does the job now
	if (_group getVariable ["GAIA_CACHED_STAGE_1", false]) then {_group call GAIA_fnc_uncache};

	//Stage 1: dynamic simulation
	private _intend = _group getVariable ["GAIA_zone_intend", []];
	private _portfolio = _group getVariable ["GAIA_Portfolio", []];
	private _eligible = (
		((count _intend > 1) && {!("DoMortar" in _portfolio)} && {!("DoArtillery" in _portfolio)})
		||
		{count _intend == 0}
	);
	private _wantDS = (
		_eligible
		&& {(behaviour _leader) != "COMBAT"}
		&& {!((_group getVariable ["GAIA_Order", ""]) in (missionNamespace getVariable ["GAIA_DS_EXCLUDED_ORDERS", ["DoAttack","DoClear","DoTransport","DoSupport"]]))}
	);

	if ((_group getVariable ["GAIA_DS", false]) isNotEqualTo _wantDS) then {
		if (_wantDS) then {[] call GAIA_fnc_dsSetup};
		_group enableDynamicSimulation _wantDS;
		_group setVariable ["GAIA_DS", _wantDS];
	};

	//Stage 2: far from every player -> serialize and delete
	if !([getPosATL _leader, missionNamespace getVariable ["GAIA_CACHE_STAGE_2", 2000]] call GAIA_fnc_isNearPlayer) then {
		[_group] call GAIA_fnc_cacheFar;
	};
};

//------------------------------- Vehicles -------------------------------
if (
	!isNil "GAIA_fnc_vehicleTick"
	&& {!isNull _group}
	&& {(units _group) isNotEqualTo []}
	&& {(_group getVariable ["GAIA_ZONE_INTEND", []]) isNotEqualTo []}
) then {
	[_group] call GAIA_fnc_vehicleTick;
};
