/*
	GAIA_fnc_cache
	In: GROUP (as _this)
	Touches units (enableSimulation / enableAI are local commands), so it runs
	where the group is local: when called on the server for a remote group it is
	forwarded to the group owner (needs GAIA_fnc_cache in CfgRemoteExec when the
	whitelist is enforced).
*/
if (isNull _this) exitWith {};
if (!local _this) exitWith {
	if (isServer) then {_this remoteExecCall ["GAIA_fnc_cache", groupOwner _this]};
};
private["_count"];
_count = 0;
{
        private["_pos"];
        if(_x != leader _this && !("Driver" in assignedVehicleRole _x)) then {
                _x disableAI "TARGET";
                _x disableAI "AUTOTARGET";
                _x disableAI "MOVE";
                _x disableAI "ANIM";
                _x disableAI "FSM";
                
                _x enableSimulation false;
                _x allowDamage false;
                
                
                //_x hideObject true;
                //if (vehicle _x != _x) then {(vehicle _x) hideObject true};
                
		if (vehicle _x == _x) then {
	                _pos = getPosATL _x;
        	        _pos set [2, -100];
	                _x setPosATL _pos;
		};
                _count = _count + 1;
	} else {
                _x allowDamage true;
                _x enableSimulation true;
                
                _x enableAI "TARGET";
                _x enableAI "AUTOTARGET";
                _x enableAI "MOVE";
                _x enableAI "ANIM";
                _x enableAI "FSM";
                
                        
        				//_x hideObject false;
        				//if (vehicle _x != _x) then {(vehicle _x) hideObject false};
        };
} forEach units _this;

_this setVariable ["GAIA_CACHED_STAGE_1",true, false];