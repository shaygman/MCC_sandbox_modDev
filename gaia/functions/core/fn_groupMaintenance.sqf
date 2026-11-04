/* ----------------------------------------------------------------------------
Function: GAIA_fnc_groupMaintenance

Description:
	Respawn bookkeeping and empty group deletion for ONE group. Replaces the
	"Delete Groups" loop of init.sqf (sleep 0.1 per group over allGroups).
	Called by the GAIA per-frame handler for a fixed budget of groups per frame.

	Server (all groups):
		- stores the original setup of every group once (GAIA_fnc_cacheOriginalGroup)
		- when every unit is dead (and it is not a CP group / logic) for at least
		  GAIA_EMPTY_GRACE seconds (default 10):
			respawns it when it has respawn data and respawns left
			(GAIA_fnc_uncacheOriginalGroup), clears the respawn data,
			deletes the group when it is local, otherwise flags it
			"GAIA_DEAD_PROCESSED" (public) so its owner (HC) deletes it.
		  Groups emptied by GAIA_fnc_cacheFar ("GAIA_CACHED_FAR") are not respawned.
	Headless client (local groups only):
		- deletes dead local groups once the server has processed their respawn,
		  or right away when they have no respawn configured.

Parameters:
	0: GROUP

Returns:
	nothing
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]]];

if (isNull _group) exitWith {};

private _isDead = (
	(({alive _x} count (units _group)) == 0)
	&& {!(_group getVariable ["MCC_CPGroup", false])}
	&& {!((leader _group) isKindOf "logic")}
);

//Grace period: a group must be seen dead/empty for GAIA_EMPTY_GRACE seconds (default 10)
//before it is respawned/deleted, so scripts that create a group and add units a bit later are safe.
if (_isDead) then {
	private _since = _group getVariable ["GAIA_EMPTY_SINCE", -1];
	if (_since < 0) then {
		_group setVariable ["GAIA_EMPTY_SINCE", time];
		_isDead = false;
	} else {
		_isDead = (time - _since) >= (missionNamespace getVariable ["GAIA_EMPTY_GRACE", 10]);
	};
} else {
	if (!isNil {_group getVariable "GAIA_EMPTY_SINCE"}) then {_group setVariable ["GAIA_EMPTY_SINCE", nil]};
};

//------------------------------- Headless client -------------------------------
if (!isServer) exitWith {
	if (local _group && {_isDead}) then {
		if (
			((_group getVariable ["MCC_GAIA_RESPAWN", -1]) < 0)
			|| {_group getVariable ["GAIA_DEAD_PROCESSED", false]}
			|| {_group getVariable ["GAIA_CACHED_FAR", false]}
		) then {
			deleteGroup _group;
		};
	};
};

//------------------------------- Server -------------------------------
//Remote dead group already handled, waiting for its owner to delete it
if (_group getVariable ["GAIA_DEAD_PROCESSED", false]) exitWith {};

private _respawnVar = "GAIA_RESPAWN_" + str _group;
private _gaiaRespawn = missionNamespace getVariable [_respawnVar, []];

//Store ALL original group setups
if (count _gaiaRespawn == 0) then {[_group] call GAIA_fnc_cacheOriginalGroup};

if (_isDead) then {
	if !(_group getVariable ["GAIA_CACHED_FAR", false]) then {
		//Before we send him to heaven check if he should be reincarnated - respawn groups
		if (count _gaiaRespawn == 2) then {
			[
				_gaiaRespawn,
				(_group getVariable ["MCC_GAIA_RESPAWN", -1]),
				(_group getVariable ["MCC_GAIA_CACHE", false]),
				(_group getVariable ["GAIA_zone_intend", []])
			] call GAIA_fnc_uncacheOriginalGroup;
		};

		//Remove the respawn group content before the group is re-used
		missionNamespace setVariable [_respawnVar, nil];
	};

	[_group] call GAIA_fnc_unregisterGroup;

	if (local _group) then {
		deleteGroup _group;
	} else {
		_group setVariable ["GAIA_DEAD_PROCESSED", true, true];
	};
};
