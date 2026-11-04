/*
	MCC_fnc_supplyVehicleCost
	Resource price of a FULL rearm / repair / refuel of a vehicle, by vehicle kind,
	multiplied by the MCC_logisticsCostFactor setting. Used by the supply tracker and MCC_fnc_vehicleService.
	Params:
		0: OBJECT or STRING - vehicle or class name
	Returns: ARRAY - [ammo, repair, fuel] resource units for a full (0 to 100%) service
*/
params [["_veh", objNull, [objNull, ""]]];

private _class = if (_veh isEqualType "") then {_veh} else {typeOf _veh};

private _base = switch (true) do {
	case (_class isKindOf "Plane"): {[150, 150, 100]};
	case (_class isKindOf "Helicopter"): {[100, 100, 60]};
	case (_class isKindOf "Tank"): {[120, 120, 60]};
	case (_class isKindOf "Wheeled_APC_F"): {[80, 80, 40]};
	case (_class isKindOf "Ship"): {[40, 40, 30]};
	case (_class isKindOf "StaticWeapon"): {[20, 20, 0]};
	default {[30, 30, 20]};
};

private _factor = missionNamespace getVariable ["MCC_logisticsCostFactor", 1];
_base apply {_x * _factor}
