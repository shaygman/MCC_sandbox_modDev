/* ----------------------------------------------------------------------------
Function: GAIA_fnc_getClassInfo

Description:
	Returns config derived data of a CfgVehicles class, cached per class name
	in the local hashMap GAIA_CLASS_CACHE (config never changes during a
	mission, so the cache never needs invalidation).

Parameters:
	0: STRING - CfgVehicles class name (typeOf)

Returns:
	ARRAY - [vehicleClass (lower case), transportSoldier, simulation (lower case), armor]
	The returned array is shared by all callers: DO NOT modify it.

Example:
	(["B_MRAP_01_F"] call GAIA_fnc_getClassInfo) params ["_vehicleClass","_transportSoldier","_simulation","_armor"];
---------------------------------------------------------------------------- */
params [["_class", "", [""]]];

if (isNil "GAIA_CLASS_CACHE") then {GAIA_CLASS_CACHE = createHashMap};

private _key = toLower _class;
private _info = GAIA_CLASS_CACHE get _key;

if (isNil "_info") then {
	private _cfg = configFile >> "CfgVehicles" >> _class;
	_info = [
		toLower (getText (_cfg >> "vehicleClass")),
		getNumber (_cfg >> "transportSoldier"),
		toLower (getText (_cfg >> "simulation")),
		getNumber (_cfg >> "armor")
	];
	GAIA_CLASS_CACHE set [_key, _info];
};

_info
