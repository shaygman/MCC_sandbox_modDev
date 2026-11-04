/* ----------------------------------------------------------------------------
Function: GAIA_fnc_findOverwatch

Description:
	Finds a support-by-fire / overwatch position for a conflict area: a dry,
	valid position between min and max distance from the CA, on the side the
	group comes from (bearing CA -> group +-60 degrees), with terrain line of
	sight from eye height to the CA. Higher ground and positions closer to the
	group's own bearing score better. Vehicles only take fairly flat ground.
	At most 15 candidates (15 terrainIntersectASL checks).

Parameters:
	0: ARRAY  - CA position
	1: ARRAY  - position the group comes from (leader position)
	2: NUMBER - (optional) min distance, default 250
	3: NUMBER - (optional) max distance, default 500
	4: BOOL   - (optional) vehicle (needs flat ground, higher eye), default false

Returns:
	ARRAY - position (AGL), or [] when no candidate has line of sight

Example:
	_pos = [_caPos, getPosATL leader _grp, 300, 700, true] call GAIA_fnc_findOverwatch;
---------------------------------------------------------------------------- */
params [
	["_caPos", [], [[]]],
	["_from", [], [[]]],
	["_minD", 250, [0]],
	["_maxD", 500, [0]],
	["_isVehicle", false, [false]]
];

if (count _caPos < 2 || {count _from < 2}) exitWith {[]};

private _ca2D		= [_caPos select 0, _caPos select 1, 0];
private _bearing	= _ca2D getDir _from;
private _caEye		= (AGLToASL _ca2D) vectorAdd [0, 0, 1.5];
private _eyeH		= [1.6, 2.8] select _isVehicle;
private _midD		= (_minD + _maxD) / 2;

private _best		= [];
private _bestScore	= -1e9;

{
	private _offset = _x;
	{
		private _dist = _x;
		private _cand = _ca2D getPos [_dist, _bearing + _offset];
		if (
			!(surfaceIsWater _cand)
			&& {[_cand] call GAIA_fnc_isValidPos}
			&& {!_isVehicle || {((surfaceNormal _cand) select 2) > 0.95}}
			&& {!(terrainIntersectASL [(AGLToASL _cand) vectorAdd [0, 0, _eyeH], _caEye])}
		) then {
			private _score = (getTerrainHeightASL _cand) - ((abs _offset) * 0.2) - ((abs (_dist - _midD)) * 0.02);
			if (_score > _bestScore) then {
				_bestScore = _score;
				_best = _cand;
			};
		};
	} forEach [_minD, _midD, _maxD];
} forEach [0, 30, -30, 60, -60];

_best
