/*=================================================== MCC_fnc_edenWizardGarrison ===================================================
	Editor-time Mission Wizard: puts units into building positions (Eden mirror of MCC_fnc_garrison). Units are placed in
	groups of up to 4, each unit stays where it is (doStop, stance UP) at mission start. Military groups are put under
	GAIA control (FORTIFY by default) in the given zone. Building positions already used by the wizard are skipped.

	Params:
		0: ARRAY   - center (ATL)
		1: NUMBER  - radius (m)
		2: NUMBER  - number of units
		3: ARRAY   - unit classes to pick from
		4: HASHMAP - (optional) zone, empty = no GAIA (civilians)
		5: STRING  - (optional) GAIA behaviour (default "FORTIFY")
		6: BOOL    - (optional) civilians (default false): no stance change, no GAIA
	Returns: NUMBER - units placed
	Example: [_pos, 60, 6, _enemy get "men", _zone] call MCC_fnc_edenWizardGarrison;
*/
params [
	["_center", [0, 0, 0], [[]]],
	["_radius", 50, [0]],
	["_count", 4, [0]],
	["_classes", [], [[]]],
	["_zone", createHashMap, [createHashMap]],
	["_intend", "FORTIFY", [""]],
	["_isCiv", false, [false]]
];

private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
_count = round _count;
if (_count < 1 || {_classes isEqualTo []}) exitWith {0};

private _used = _ctx getOrDefault ["usedBuildingPos", []];
private _positions = [];
{
	_positions append ((_x select 1) select {private _p = _x; (_used findIf {(_x distance _p) < 1.5}) < 0});
} forEach (["buildings", _center, _radius, 2] call MCC_fnc_edenWizardFindPos);

if (_positions isEqualTo []) exitWith {0};
_positions = _positions call BIS_fnc_arrayShuffle;

private _maxUnits = _ctx getOrDefault ["maxUnits", 200];
private _init = if (_isCiv) then {
	"if (local this) then {doStop this};"
} else {
	"if (local this) then {doStop this; this setUnitPos 'UP'};"
};

private _placed = 0;
private _group = grpNull;
private _inGroup = 0;
{
	if (_placed >= _count || {(_ctx getOrDefault ["units", 0]) >= _maxUnits}) exitWith {
		if (_placed < _count) then {_ctx set ["capped", true]};
	};
	private _unit = ["Object", selectRandom _classes, _x, [["Init", _init], ["rotation", [0, 0, random 360]]], false, _group] call MCC_fnc_edenWizardCreate;
	if (!isNull _unit) then {
		//Keep the exact building position (upper floors)
		_unit set3DENAttribute ["position", _x];
		_used pushBack _x;
		_placed = _placed + 1;
		_inGroup = _inGroup + 1;
		if (isNull _group) then {
			_group = group _unit;
			_ctx set ["groups", (_ctx getOrDefault ["groups", 0]) + 1];
			if (!_isCiv && {count _zone > 0}) then {[_group, _zone, _intend] call MCC_fnc_edenWizardAssign};
		};
		if (_inGroup >= 4) then {_group = grpNull; _inGroup = 0};
	};
} forEach _positions;

_ctx set ["usedBuildingPos", _used];
_placed
