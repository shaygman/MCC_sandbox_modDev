/*
	GAIA_fnc_syncCachedGroup
	In: GROUP (as _this)
	Touches units (enableSimulation / enableAI are local commands), so it runs
	where the group is local: when called on the server for a remote group it is
	forwarded to the group owner (needs GAIA_fnc_syncCachedGroup in CfgRemoteExec when the
	whitelist is enforced).
*/
if (isNull _this) exitWith {};
if (!local _this) exitWith {
	if (isServer) then {_this remoteExecCall ["GAIA_fnc_syncCachedGroup", groupOwner _this]};
};
private ["_count"];

_count = 0;
if (!(simulationEnabled (leader _this))) then {
	private ["_x"];
	_x = leader _this;

        _x allowDamage true;
        _x enableSimulation true;
                
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        _x enableAI "MOVE";
        _x enableAI "ANIM";
        _x enableAI "FSM";
                
        _count = _count + 1;
};

