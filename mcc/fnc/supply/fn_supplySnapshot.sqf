/*
	MCC_fnc_supplySnapshot
	Current supply state of a vehicle, used to measure how much it took from a supply point.
	Params:
		0: OBJECT - vehicle
	Returns: ARRAY - [ammoFraction 0..1 (all turret magazines, 1 when it has none), health 0..1, fuel 0..1]
*/
params [["_veh", objNull, [objNull]]];

if (isNull _veh) exitWith {[1, 1, 1]};

private _have = 0;
private _max = 0;
{
	_x params ["_mag", "", "_count"];
	private _cap = getNumber (configFile >> "CfgMagazines" >> _mag >> "count");
	if (_cap > 0) then {
		_have = _have + (_count min _cap);
		_max = _max + _cap;
	};
} forEach (magazinesAllTurrets _veh);

private _ammo = if (_max > 0) then {_have / _max} else {1};

//Overall damage or the average hit point damage, whichever is worse
private _hit = (getAllHitPointsDamage _veh) param [2, []];
private _avg = if (count _hit > 0) then {
	private _sum = 0;
	{_sum = _sum + _x} forEach _hit;
	_sum / (count _hit)
} else {0};
private _health = 1 - ((damage _veh) max _avg);

[_ammo, _health, fuel _veh]
