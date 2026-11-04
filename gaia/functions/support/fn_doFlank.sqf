/* ----------------------------------------------------------------------------
Function: GAIA_fnc_doFlank

Description:
	Flank role (GAIA_fnc_assignRoles): the group approaches the conflict area
	from a different bearing than the main attack. It moves to a staging point
	at the flank bearing (main attack bearing +- GAIA_FLANK_ANGLE, default 75
	degrees), going around the CA through a detour point when it starts on the
	far side, then assaults the CA (building waypoints for infantry, SAD for
	vehicle groups). Vehicle groups stage just inside the dismount distance, so
	GAIA_fnc_vehicleTick dismounts the infantry at the staging point.
	The order is a "DoAttack" on the CA (GAIA_OrderPosition = CA).

Parameters:
	0: GROUP
	1: ARRAY  - CA position
	2: NUMBER - bearing from the CA to the main attack group
	3: NUMBER - side of the flank: 1 or -1

Returns:
	BOOL - false when the group is too close to flank or no dry staging point
	       was found (caller falls back to doAttack)
---------------------------------------------------------------------------- */
params [["_group", grpNull, [grpNull]], ["_caPos", [], [[]]], ["_mainBearing", 0, [0]], ["_sign", 1, [0]]];

private _leader = leader _group;
if (isNull _group || {!alive _leader} || {count _caPos < 2}) exitWith {false};

private _dist = _leader distance2D _caPos;
if (_dist < 300) exitWith {false};

private _class		= _group getVariable ["GAIA_class", ""];
private _isFoot		= _class in ["Infantry", "ReconInfantry"];
private _stageDist	= if (_isFoot) then {250} else {((missionNamespace getVariable ["MCC_GAIA_dismountDistance", 400]) * 0.9) max 250};
private _angle		= missionNamespace getVariable ["GAIA_FLANK_ANGLE", 75];
private _ca2D		= [_caPos select 0, _caPos select 1, 0];

//Staging point on the requested flank, else the other one
private _stage = [];
private _flankBearing = 0;
{
	private _b = _mainBearing + (_x * _angle);
	private _p = _ca2D getPos [_stageDist, _b];
	if (!(surfaceIsWater _p) && {[_p] call GAIA_fnc_isValidPos}) exitWith {
		_stage = _p;
		_flankBearing = _b;
		_sign = _x;
	};
} forEach [_sign, -_sign];
if (_stage isEqualTo []) exitWith {false};

//Use cover for the staging point (infantry) or open, fairly flat ground (vehicles)
if (_isFoot) then {
	private _cover = selectBestPlaces [_stage, 50, "forest+trees+houses-(10*sea)", 5, 1];
	if (_cover isNotEqualTo []) then {
		private _c = (_cover select 0) select 0;
		if (!(surfaceIsWater _c) && {[_c] call GAIA_fnc_isValidPos}) then {_stage = _c};
	};
} else {
	_stage = [_stage, 0, 60, 6, 0, 0.3, 0, _stage] call GAIA_fnc_safePos;
};

[_group] call GAIA_fnc_removeWaypoints;

//Starting on the far side: go around through a detour point, never through the CA
private _leaderBearing	= _ca2D getDir _leader;
private _diff			= (((_flankBearing - _leaderBearing) + 540) mod 360) - 180;
if (abs _diff > 100) then {
	private _detour = _ca2D getPos [((_dist max 600) min 1200), _leaderBearing + (_diff / 2)];
	if (!(surfaceIsWater _detour) && {[_detour] call GAIA_fnc_isValidPos}) then {
		[_group, _detour, "MOVE"] call GAIA_fnc_addAttackWaypoint;
	};
};

[_group, _stage, "MOVE"] call GAIA_fnc_addAttackWaypoint;

//Assault
private _nrBuildingWp = 0;
if (_isFoot) then {
	_nrBuildingWp = [_group, _caPos] call GAIA_fnc_generateBuildingPatrolWaypoints;
	if (isNil "_nrBuildingWp") then {_nrBuildingWp = 0};
};
if (_nrBuildingWp == 0) then {
	[_group, _caPos, "SAD"] call GAIA_fnc_addAttackWaypoint;
};

_group setVariable ["GAIA_Order", "DoAttack", false];
_group setVariable ["GAIA_OrderTime", time, false];
_group setVariable ["GAIA_OrderPosition", _caPos, false];
_group setVariable ["GAIA_Role", "flank", false];
_group setVariable ["GAIA_FlankSign", _sign, false];

if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
	diag_log format ["GAIA roles: %1 flanks CA %2 from bearing %3 (main attack %4), staging %5", _group, _caPos, round _flankBearing, round _mainBearing, _stage];
};

true
