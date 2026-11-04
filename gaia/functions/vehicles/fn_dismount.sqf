/*
	GAIA_fnc_dismount
	Gets the group out of its vehicle at the objective. The leader always gets out with his men.
	- Ride (a vehicle the group borrowed): everyone gets out, the vehicle stays parked and remembered.
	- Own vehicle (mechanized/motorized group): passengers and the leader get out, the crew (driver/gunner)
	  stays to give fire support. If the leader was driving, a passenger takes over the driver seat.
	Params:
		0: GROUP
		1: OBJECT - the vehicle
	Returns: nothing
*/
params [["_group", grpNull, [grpNull]], ["_veh", objNull, [objNull]]];

private _leader = leader _group;
private _isRide = _group getVariable ["GAIA_isRide", false];
private _inVeh = (units _group) select {alive _x && {vehicle _x == _veh}};

private _out = [];
private _stay = [];
if (_isRide) then {
	_out = _inVeh;
} else {
	{
		private _role = toLower ((assignedVehicleRole _x) param [0, "cargo"]);
		if (_x == _leader || {_role == "cargo"}) then {_out pushBack _x} else {_stay pushBack _x};
	} forEach _inVeh;
};
if (count _out == 0) exitWith {};

// Leader was driving and the vehicle keeps a crew: a passenger takes the wheel
private _newDriver = objNull;
if (!_isRide && {driver _veh == _leader}) then {
	_newDriver = (_out - [_leader]) param [0, objNull];
	if (!isNull _newDriver) then {_out = _out - [_newDriver]; _stay pushBack _newDriver};
};

{unassignVehicle _x} forEach _out;
_out allowGetIn false;
_out orderGetIn false;
{
	if (vehicle _x != _x) then {doGetOut _x};
} forEach _out;

if (!isNull _newDriver) then {
	[_veh, _newDriver, _leader] spawn {
		params ["_veh", "_newDriver", "_leader"];
		private _t = time + 15;
		waitUntil {sleep 0.5; vehicle _leader != _veh || {time > _t}};
		if (alive _newDriver && {isNull driver _veh}) then {
			_newDriver assignAsDriver _veh;
			_newDriver action ["MoveToDriver", _veh];
		};
	};
};

_group setVariable ["GAIA_dismounted", true];
if (_isRide) then {_group leaveVehicle _veh};

if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
	diag_log format ["GAIA vehicles: %1 dismounts %2 (%3 out, %4 crew stay)", _group, typeOf _veh, count _out, count _stay];
};
