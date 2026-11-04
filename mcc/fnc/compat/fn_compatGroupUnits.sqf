/*
	MCC_fnc_compatGroupUnits
	Returns the unit/vehicle classes of a cfgMCCRtsGroups entry for a side, using the RHS or CUP variant
	(units<Side>RHS[] / units<Side>CUP[]) when that mod is loaded and every class in the variant exists.
	Falls back to the plain units<Side>[] array.
	Params:
		0: CONFIG - the cfgMCCRtsGroups class (e.g. configFile >> "cfgMCCRtsGroups" >> "MCC_rtsGroup_Transport")
		1: SIDE   - west / east / resistance
	Returns: ARRAY of STRING - class names
	Example:
		_groupArray = [_cfg, _side] call MCC_fnc_compatGroupUnits;
*/
params [["_cfg", configNull, [configNull]], ["_side", west, [west]]];

if (isNil "MCC_compat_detected") then {call MCC_fnc_detectMods};

private _base = format ["units%1", _side];
private _result = getArray (_cfg >> _base);

{
	_x params ["_flag", "_suffix"];
	private _variant = if (_flag) then {getArray (_cfg >> (_base + _suffix))} else {[]};
	if (_variant isNotEqualTo [] && {(_variant findIf {!isClass (configFile >> "CfgVehicles" >> _x)}) < 0}) exitWith {
		_result = _variant;
	};
} forEach [[MCC_isRHS, "RHS"], [MCC_isCUP, "CUP"]];

_result
