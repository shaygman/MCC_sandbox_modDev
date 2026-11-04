/* ----------------------------------------------------------------------------
Function: GAIA_fnc_fireMission

Description:
	Fires one salvo of a GAIA mortar or artillery group. addMagazine and the
	artillery fire commands need the units to be local, so when the group is
	owned by a headless client the server forwards the call to that machine
	(remoteExecCall to groupOwner). Only the server may remote execute it.

	Mortar mode (default, same as the old GAIA_fnc_doMortar loop): every alive
	unit gets the magazine added to its vehicle and commandArtilleryFire.
	Vehicle mode: every artillery vehicle of the group (artilleryScanner = 1)
	fires with doArtilleryFire, using the given magazine when that vehicle can
	fire it, else its first artillery magazine; a magazine is only added when
	the vehicle has none of that type left.

Parameters:
	0: GROUP
	1: ARRAY  - impact position
	2: STRING - magazine class
	3: NUMBER - rounds per gun
	4: BOOL   - (optional) vehicle mode, default false

Returns:
	BOOL - true when fired here or forwarded to the owner

Example:
	[_group, _pos, _ammo, 3] call GAIA_fnc_fireMission;
---------------------------------------------------------------------------- */
params [
	["_group", grpNull, [grpNull]],
	["_pos", [], [[]]],
	["_ammo", "", [""]],
	["_rounds", 1, [0]],
	["_vehicleMode", false, [false]]
];

//Only the server may ask for a fire mission over the network
if (isRemoteExecuted && {remoteExecutedOwner != 2}) exitWith {false};
if (isNull _group || {count _pos < 2} || {_rounds < 1}) exitWith {false};

//Not local here: the server forwards it to the machine that owns the group (headless client)
if (!local _group) exitWith {
	if (isServer && {!isRemoteExecuted}) then {
		[_group, _pos, _ammo, _rounds, _vehicleMode] remoteExecCall ["GAIA_fnc_fireMission", groupOwner _group];
		true
	} else {
		false
	};
};

private _fired = false;

if (_vehicleMode) then {
	private _done = [];
	{
		private _veh = vehicle _x;
		if (
			alive _x
			&& {_veh != _x}
			&& {alive _veh}
			&& {!(_veh in _done)}
			&& {local _veh}
			&& {getNumber (configOf _veh >> "artilleryScanner") == 1}
		) then {
			_done pushBack _veh;
			private _list = getArtilleryAmmo [_veh];
			private _mag = if (_ammo in _list) then {_ammo} else {_list param [0, ""]};
			if (_mag != "") then {
				if ((magazinesAllTurrets _veh) findIf {(_x select 0) == _mag && {(_x select 2) > 0}} < 0) then {
					_veh addMagazine _mag;
				};
				_veh doArtilleryFire [_pos, _mag, _rounds];
				_fired = true;
			};
		};
	} forEach (units _group);
} else {
	if (_ammo != "") then {
		{
			if (alive _x) then {
				(vehicle _x) addMagazine _ammo;
				_x commandArtilleryFire [_pos, _ammo, _rounds];
				_fired = true;
			};
		} forEach (units _group);
	};
};

_fired
