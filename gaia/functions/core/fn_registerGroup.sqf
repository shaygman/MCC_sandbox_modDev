/* ----------------------------------------------------------------------------
Function: GAIA_fnc_registerGroup

Description:
	Adds a group to the GAIA group registry (server only, idempotent).
	The registry is a server-local hashMap GAIA_REGISTRY:
		key   = str side of the group ("WEST","EAST","GUER","CIV")
		value = array of groups
	Groups that get a GAIA_ZONE_INTEND anywhere else are picked up by the
	registry sweep (GAIA_fnc_registrySweep) within ~10 seconds, so calling this
	is an optimisation, not a requirement. Calling it on a client does nothing.
	Set GAIA_ZONE_INTEND on the group before (or right after) registering it:
	the sweep drops registered groups that have no units or no GAIA_ZONE_INTEND.

Parameters:
	0: GROUP

Returns:
	BOOL - true when the group is (now) registered

Example:
	[_group] call GAIA_fnc_registerGroup;
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]]];

if (!isServer || {isNull _group}) exitWith {false};

if (isNil "GAIA_REGISTRY") then {GAIA_REGISTRY = createHashMap};

private _key = str (side _group);
private _registeredKey = _group getVariable ["GAIA_REG_SIDE", ""];

//Already registered under the right side: nothing to do
if (_registeredKey isEqualTo _key) exitWith {true};

//Registered under another side (side changed): move it
if (_registeredKey != "") then {
	private _old = GAIA_REGISTRY getOrDefault [_registeredKey, []];
	private _idx = _old find _group;
	if (_idx > -1) then {_old deleteAt _idx};
};

(GAIA_REGISTRY getOrDefault [_key, [], true]) pushBackUnique _group;
_group setVariable ["GAIA_REG_SIDE", _key];

true
