/* ----------------------------------------------------------------------------
Function: GAIA_fnc_startGaia

Description:
	The GAIA strategic scheduler. ONE scheduled server loop for all sides
	(it used to be one loop per side). Idempotent: extra calls do nothing, the
	(legacy) side parameter is ignored.

	Every round, for each side (west, east, independent, civilian):
		- a side wakes up when the registry holds a live GAIA group of that side
		  (alive leader, GAIA_ZONE_INTEND with zone and intend), and goes back to
		  sleep when that side has no units left at all;
		- an awake side runs one GAIA cycle (GAIA_fnc_sideCycle: analyzeTargets,
		  getConflictAreas, analyzeForces, classifySide, issueOrders) and sets
		  MCC_GAIA_OPERATIONAL_<SIDE>.
	A round lasts (5 + MCC_GAIA_SHARETARGET_DELAY) seconds (same per side period
	as before: 5 x 1 s phase sleeps + the share target delay), never less than
	1 s of sleep between rounds. Nothing in here sleeps per group.

	Per group cheap work (caching, vehicle tick, empty group deletion, respawn)
	is done by the CBA per-frame handler, see GAIA_fnc_startGaiaCache.

Parameters:
	none (old: [side], ignored)

Returns:
	nothing
---------------------------------------------------------------------------- */
if (!isServer) exitWith {};
if (!isNil "GAIA_SCHEDULER_STARTED") exitWith {};
GAIA_SCHEDULER_STARTED = true;

//GAIA is down
MCC_GAIA_OPERATIONAL_WEST	= FALSE;
MCC_GAIA_OPERATIONAL_EAST	= FALSE;
MCC_GAIA_OPERATIONAL_INDEP	= FALSE;
MCC_GAIA_OPERATIONAL_CIV	= FALSE;

private _sides		= [west, east, independent, civilian];
private _awake		= createHashMap;
private _mklists	= createHashMap;

if (MCC_GAIA_DEBUG) then {diag_log "GAIA: Waking up GAIA scheduler (one loop for all sides)"};
sleep 2;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									GAIA never dies, even if all her units are destroyed. All HAIL GAIA!
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
while {true} do
{
	private _roundStart = time;
	private _roundTick = diag_tickTime;

	//Local counter only (it is no longer broadcast, nobody reads it on clients)
	MCC_GAIA_CYCLE = MCC_GAIA_CYCLE + 1;

	GAIA_CACHE_STAGE_2 = (2*(missionNamespace getVariable ["GAIA_CACHE_STAGE_1",1000]));
	//Follow the cache distance setting (only once GAIA uses dynamic simulation)
	[true] call GAIA_fnc_dsSetup;

	{
		private _side	= _x;
		private _key	= str _side;
		private _opVar	= "MCC_GAIA_OPERATIONAL_" + ([_side] call GAIA_fnc_sideSuffix);

		//Wake up: are there GAIA units for this side?
		if !(_awake getOrDefault [_key, false]) then {
			if ((([_side] call GAIA_fnc_getGroups) findIf {
					((units _x) isNotEqualTo [])
					&& {alive (leader _x)}
					&& {count (_x getVariable ["GAIA_zone_intend",[]]) > 1}
				}) > -1) then {
				_awake set [_key, true];
				if (MCC_GAIA_DEBUG) then {diag_log format ["GAIA: GAIA %1 wakes up and looks around the place.", _side]};
			};
		};

		if (_awake getOrDefault [_key, false]) then {
			if ((allUnits findIf {side _x == _side}) > -1) then {
				private _mklist = [_side, _mklists getOrDefault [_key, []]] call GAIA_fnc_sideCycle;
				if (isNil "_mklist") then {_mklist = []};
				_mklists set [_key, _mklist];
				//Operational!
				missionNamespace setVariable [_opVar, TRUE];
			} else {
				//GAIA is down
				_awake set [_key, false];
				missionNamespace setVariable [_opVar, FALSE];
				if (MCC_GAIA_DEBUG) then {diag_log format ["GAIA: GAIA %1 has no units left, going to sleep.", _side]};
			};
			sleep 0.5;
		};
	} forEach _sides;

	if (MCC_GAIA_DEBUG) then {
		diag_log format ["GAIA: round %1 done in %2 s (wall), registered groups %3, cache groups %4",
			MCC_GAIA_CYCLE,
			(diag_tickTime - _roundTick) toFixed 2,
			count ([] call GAIA_fnc_getGroups),
			count (missionNamespace getVariable ["GAIA_CACHE_GROUPS", []])
		];
	};

	// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	//									Phase: Sleep
	// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	private _period = 5 + (missionNamespace getVariable ["MCC_GAIA_SHARETARGET_DELAY", 10]);
	sleep ((_period - (time - _roundStart)) max 1);
};
