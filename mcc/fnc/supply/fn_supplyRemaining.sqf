/*
	MCC_fnc_supplyRemaining
	How full a supply object still is, for refunds when a crate is returned at base.
	Limited logistics tracks this type (fuel in mode 1, all in mode 2) and the object is registered: stock / capacity from ammoLeft/supplyLeft/fuelLeft.
	Otherwise the old behaviour: the engine cargo (getAmmoCargo/getRepairCargo/getFuelCargo) when
	MCC runs as a mod, else 1.
	Params:
		0: OBJECT - supply object
		1: NUMBER - 0 ammo, 1 repair, 2 fuel
	Returns: NUMBER - 0..1
*/
params [["_obj", objNull, [objNull]], ["_index", 0, [0]]];

if (isNull _obj || {_index < 0} || {_index > 2}) exitWith {0};

private _cap = _obj getVariable ["MCC_supplyCap", []];
private _mode = missionNamespace getVariable ["MCC_logisticsMode", 0];
if ((_mode > 1 || {_mode == 1 && _index == 2}) && {count _cap == 3} && {(_cap select _index) > 0}) exitWith {
	private _v = _obj getVariable [["ammoLeft", "supplyLeft", "fuelLeft"] select _index, 0];
	if !(_v isEqualType 0) then {_v = 0};
	((_v / (_cap select _index)) max 0) min 1
};

if (missionNamespace getVariable ["MCC_isMode", false]) exitWith {
	(([getAmmoCargo _obj, getRepairCargo _obj, getFuelCargo _obj] select _index) max 0) min 1
};
1
