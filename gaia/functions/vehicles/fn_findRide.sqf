/*
	GAIA_fnc_findRide
	Looks for an empty friendly vehicle near the group leader that fits the whole group, claims it and orders
	the group in. A non-leader unit drives, so the leader is free to get out with his men later.
	Params:
		0: GROUP
		1: ARRAY - objective position (remembered for the dismount)
	Returns: BOOL - true if a ride was found
*/
params [["_group", grpNull, [grpNull]], ["_objective", [], [[]]]];

private _leader = leader _group;
private _units = (units _group) select {alive _x && {vehicle _x == _x}};
if (count _units == 0) exitWith {false};

private _radius = missionNamespace getVariable ["MCC_GAIA_rideSearchRadius", 300];
private _sideNum = [east, west, independent, civilian] find (side _group);

private _candidates = (_leader nearEntities [["Car", "Tank"], _radius]) apply {[_leader distance _x, _x]};
_candidates sort true;

private _ride = objNull;
{
	private _v = _x;
	private _claim = _v getVariable ["GAIA_claimedBy", grpNull];
	if (
		alive _v
		&& {canMove _v}
		&& {fuel _v > 0.1}
		&& {locked _v < 2}
		&& {({alive _x} count crew _v) == 0}
		&& {isNull _claim || {_claim isEqualTo _group} || {({alive _x} count units _claim) == 0}}
		&& {(_v emptyPositions "") >= count _units}
		&& {(getNumber (configFile >> "CfgVehicles" >> typeOf _v >> "side")) in [_sideNum, 3]}
		&& {!(_v getVariable ["GAIA_noRide", false])}
	) exitWith {_ride = _v};
} forEach (_candidates apply {_x select 1});

if (isNull _ride) exitWith {false};

_ride setVariable ["GAIA_claimedBy", _group, true];
_group setVariable ["GAIA_groupVehicle", _ride];
_group setVariable ["GAIA_isRide", true];
_group setVariable ["GAIA_rideObjective", _objective];
_group setVariable ["GAIA_dismounted", false];

_group addVehicle _ride;
_units allowGetIn true;

// Driver is anyone but the leader when possible
private _driver = (_units - [_leader]) param [0, _leader];
_driver assignAsDriver _ride;
{
	if (_x != _driver) then {_x assignAsCargo _ride};
} forEach _units;
_units orderGetIn true;

if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
	diag_log format ["GAIA vehicles: %1 takes %2 to %3 (%4 m)", _group, typeOf _ride, _objective, round (_leader distance2D _objective)];
};
true
