/* ----------------------------------------------------------------------------
Function: GAIA_fnc_dsSetup

Description:
	Makes sure the engine Dynamic Simulation system is enabled and that the
	"Group" dynamic simulation distance follows the GAIA cache distance setting
	(GAIA_CACHE_STAGE_1). Server only. Cheap: only touches the engine when the
	system is off or the setting changed since the last call.
	Called by GAIA_fnc_groupTick before a group is put under dynamic simulation
	and once per round by the GAIA scheduler.

Parameters:
	0: BOOL (optional, default false) - only update the distance when dynamic
	   simulation was already enabled by GAIA (do not switch the system on)

Returns:
	nothing
---------------------------------------------------------------------------- */
params [["_onlyUpdate", false, [false]]];

if (!isServer) exitWith {};
if (_onlyUpdate && {isNil "GAIA_DS_DISTANCE"}) exitWith {};

if (!dynamicSimulationSystemEnabled) then {
	enableDynamicSimulationSystem true;
};

private _distance = missionNamespace getVariable ["GAIA_CACHE_STAGE_1", 1000];
if ((missionNamespace getVariable ["GAIA_DS_DISTANCE", -1]) != _distance) then {
	"Group" setDynamicSimulationDistance _distance;
	GAIA_DS_DISTANCE = _distance;
};
