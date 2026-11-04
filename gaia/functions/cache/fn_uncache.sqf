/*
	GAIA_fnc_uncache
	In: GROUP (as _this)
	Touches units (enableSimulation / enableAI are local commands), so it runs
	where the group is local: when called on the server for a remote group it is
	forwarded to the group owner (needs GAIA_fnc_uncache in CfgRemoteExec when the
	whitelist is enforced).
*/
if (isNull _this) exitWith {};
if (!local _this) exitWith {
	if (isServer) then {_this remoteExecCall ["GAIA_fnc_uncache", groupOwner _this]};
};
private ["_count"];
_count = 0;
{
        if(_x != leader _this && !("Driver" in assignedVehicleRole _x)) then {
		if (vehicle _x == _x) then {
	                _x setPos [(formationPosition _x )select 0,(formationPosition _x )select 1];
		};
                _x allowDamage true;
                _x enableSimulation true;
                
                _x enableAI "TARGET";
                _x enableAI "AUTOTARGET";
                _x enableAI "MOVE";
                _x enableAI "ANIM";
                _x enableAI "FSM";
                
        
 				        //_x hideObject false;
        				//if (vehicle _x != _x) then {(vehicle _x) hideObject false};
                
                _count = _count + 1;
        };
} forEach units _this;

_this setVariable ["GAIA_CACHED_STAGE_1",false, false];