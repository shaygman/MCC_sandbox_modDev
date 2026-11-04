/* ----------------------------------------------------------------------------
Function: GAIA_fnc_sideCycle

Description:
	Runs one GAIA strategic cycle for one side (scheduled, called by the GAIA
	scheduler GAIA_fnc_startGaia):
		analyzeTargets -> getConflictAreas -> analyzeForces -> classifySide -> issueOrders
	When the CBA setting MCC_GAIA_debug is on, the duration of every phase is
	written to the RPT (diag_tickTime deltas, wall time: includes the time the
	scheduler suspended the script), with the number of groups processed.

Parameters:
	0: SIDE
	1: ARRAY - debug marker list of this side (returned by analyzeTargets)

Returns:
	ARRAY - debug marker list to pass to the next cycle
---------------------------------------------------------------------------- */
params [["_side", sideEmpty, [sideEmpty]], ["_mklist", [], [[]]]];

private _t0 = diag_tickTime;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									Phase: Analyze Enemy
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
_mklist = [_side, _mklist] call GAIA_fnc_analyzeTargets;
private _t1 = diag_tickTime;
sleep 0.1;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									Phase: Organise Contact Area's (CA's)
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
private _t2 = diag_tickTime;
[_side] call GAIA_fnc_getConflictAreas;
private _t3 = diag_tickTime;
sleep 0.1;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									Phase: Analyze GAIA Forces and Zones
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
private _t4 = diag_tickTime;
[_side] call GAIA_fnc_analyzeForces;
private _t5 = diag_tickTime;
sleep 0.1;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									Phase: Classify GAIA controlled groups
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
private _t6 = diag_tickTime;
[_side] call GAIA_fnc_classifySide;
private _t7 = diag_tickTime;
sleep 0.1;

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//									Phase: Issue Orders
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
private _t8 = diag_tickTime;
[_side] call GAIA_fnc_issueOrders;
private _t9 = diag_tickTime;

if (MCC_GAIA_DEBUG) then {
	private _ms = {(((_this select 1) - (_this select 0)) * 1000) toFixed 1};
	private _classify = missionNamespace getVariable ["GAIA_DBG_CLASSIFY", [0,0]];
	diag_log format [
		"GAIA cycle %1 %2: groups side %3 / GAIA %4 / classified %5 (recomputed %6), CAs %7 | analyzeTargets %8 ms | getConflictAreas %9 ms | analyzeForces %10 ms | classifySide %11 ms | issueOrders %12 ms | total %13 ms",
		MCC_GAIA_CYCLE,
		_side,
		count (groups _side),
		count ([_side] call GAIA_fnc_getGroups),
		_classify select 0,
		_classify select 1,
		count (missionNamespace getVariable ["MCC_GAIA_CA_" + ([_side] call GAIA_fnc_sideSuffix), []]),
		[_t0,_t1] call _ms,
		[_t2,_t3] call _ms,
		[_t4,_t5] call _ms,
		[_t6,_t7] call _ms,
		[_t8,_t9] call _ms,
		[_t0,_t9] call _ms
	];
};

_mklist
