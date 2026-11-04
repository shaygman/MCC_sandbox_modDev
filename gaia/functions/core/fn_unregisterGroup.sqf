/* ----------------------------------------------------------------------------
Function: GAIA_fnc_unregisterGroup

Description:
	Removes a group from the GAIA group registry (server only).
	Null groups are removed by the registry sweep, so passing grpNull is a no-op.

Parameters:
	0: GROUP

Returns:
	BOOL - true when the group was registered and has been removed

Example:
	[_group] call GAIA_fnc_unregisterGroup;
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]]];

if (!isServer || {isNull _group} || {isNil "GAIA_REGISTRY"}) exitWith {false};

private _removed = false;
private _registeredKey = _group getVariable ["GAIA_REG_SIDE", ""];

//Fast path: the side it was registered under
if (_registeredKey != "") then {
	private _arr = GAIA_REGISTRY getOrDefault [_registeredKey, []];
	private _idx = _arr find _group;
	if (_idx > -1) then {_arr deleteAt _idx; _removed = true};
};

//Safety net: make sure it is in no other side list either
if (!_removed) then {
	{
		private _idx = _y find _group;
		if (_idx > -1) then {_y deleteAt _idx; _removed = true};
	} forEach GAIA_REGISTRY;
};

_group setVariable ["GAIA_REG_SIDE", nil];

_removed
