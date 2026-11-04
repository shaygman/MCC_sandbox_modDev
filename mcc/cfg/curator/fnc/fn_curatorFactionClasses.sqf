/*=================================================================MCC_fnc_curatorFactionClasses=====================================================================
	Returns the public CfgVehicles classes of a faction that are of one of the given kinds (Zeus module helper).
	Results are cached per faction/kinds in localNamespace.
	Params:
		0: STRING - faction class name (CfgFactionClasses), "" = any faction
		1: ARRAY  - kinds to match with isKindOf, e.g. ["Car","Tank"]
	Returns: ARRAY of [displayName, className], sorted by display name
	Example: ["BLU_F", ["Car"]] call MCC_fnc_curatorFactionClasses;
//==================================================================================================================================================================*/
params [
	["_faction", "", [""]],
	["_kinds", ["Car"], [[]]]
];

private _cache = localNamespace getVariable ["MCC_curatorClassCache", createHashMap];
localNamespace setVariable ["MCC_curatorClassCache", _cache];

private _key = _faction + "|" + str _kinds;
if (_key in _cache) exitWith {+(_cache get _key)};

private _condition = if (_faction isEqualTo "") then {
	"getNumber (_x >> 'scope') == 2"
} else {
	format ["getNumber (_x >> 'scope') == 2 && {getText (_x >> 'faction') == '%1'}", _faction]
};

private _result = [];
{
	private _cfg = _x;
	private _class = configName _cfg;
	if ((_kinds findIf {_class isKindOf _x}) >= 0) then {
		private _name = getText (_cfg >> "displayName");
		if (_name isEqualTo "") then {_name = _class};
		_result pushBack [_name, _class];
	};
} forEach (_condition configClasses (configFile >> "CfgVehicles"));

_result sort true;
_cache set [_key, _result];

+_result
