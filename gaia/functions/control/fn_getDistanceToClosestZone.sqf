//  In: [side,position,(optional) exclude ambient zones (zone number >= 1000)]
// Out: Distance to Closest Zone (99999 when there is none or the closest zone marker no longer exists)
// Spirit 19-1-2014
// Single pass minimum search instead of sorting all zones on every call.

params ["_side", "_pos", ["_ExcludeAmbientZone", false]];

private _zones = missionNamespace getVariable ["MCC_GAIA_ZONES_" + ([_side] call GAIA_fnc_sideSuffix), []];

private _ClosestZone = "";
private _best = 1e10;
{
	if (!_ExcludeAmbientZone || {parseNumber _x < 1000}) then {
		private _d = _pos distance (getMarkerPos _x);
		if (_d < _best) then {_best = _d; _ClosestZone = _x;};
	};
} forEach _zones;

private _Distance = 99999;
if (_ClosestZone != "" && {getMarkerColor _ClosestZone != ""}) then {
	_Distance = ((getMarkerPos _ClosestZone) distance _pos);
};

_Distance
