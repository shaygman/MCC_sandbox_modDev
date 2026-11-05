/*
	MCC_fnc_gaiaNearestZone
	Nearest MCC zone to a position.
	Params:
		0: ARRAY  - position
		1: NUMBER - (optional) max distance from the zone center, default 1e10
	Returns: NUMBER - zone number, 0 if none
*/
params [["_pos", [0,0,0], [[]]], ["_max", 1e10, [0]]];
private _best = 0;
private _bestDist = _max;
private _zonePos = missionNamespace getVariable ["mcc_zone_pos", []];
{
	private _p = _zonePos param [_x, []];
	if (_p isEqualType [] && {count _p >= 2}) then {
		private _d = _pos distance2D _p;
		if (_d < _bestDist) then {_best = _x; _bestDist = _d};
	};
} forEach ((missionNamespace getVariable ["MCC_zones_numbers", []]) select {_x isEqualType 0 && {_x > 0}});
_best
