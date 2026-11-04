/* ----------------------------------------------------------------------------
Function: GAIA_fnc_startGaiaCache

Description:
	Installs the GAIA CBA per-frame handler (GAIA_fnc_perFrame). Idempotent.
	Runs on the server (per group tick: caching, vehicle tick, respawn
	bookkeeping, empty group deletion, registry sweep) and on headless clients
	(empty group deletion of their local groups only).

	This used to be a scheduled loop over allGroups (sleep 0.1 and a spawn per
	group) plus the "Delete Groups" loop in init.sqf; both are replaced by the
	per-frame handler which processes a fixed budget of groups per frame.

Parameters:
	none

Returns:
	NUMBER - per-frame handler id (-1 on clients with an interface)
---------------------------------------------------------------------------- */
if (!isServer && hasInterface) exitWith {-1};

if (!isNil "GAIA_PF_HANDLE") exitWith {GAIA_PF_HANDLE};

if (isServer) then {
	if (isNil "GAIA_REGISTRY") then {GAIA_REGISTRY = createHashMap};
	if (isNil "GAIA_CACHE_GROUPS") then {GAIA_CACHE_GROUPS = []};
	if (isNil "GAIA_PLAYER_LIST") then {GAIA_PLAYER_LIST = []};
};

GAIA_PF_SNAP		= [];
GAIA_PF_IDX			= 0;
GAIA_PF_NEXT_PASS	= 0;
GAIA_PF_MSNAP		= [];
GAIA_PF_MIDX		= 0;
GAIA_PF_NEXT_MPASS	= 0;
GAIA_PF_NEXT_SECOND	= 0;
GAIA_PF_NEXT_SWEEP	= 0;

GAIA_PF_HANDLE = [{_this call GAIA_fnc_perFrame}, 0, []] call CBA_fnc_addPerFrameHandler;

GAIA_PF_HANDLE
