/*
	MCC_fnc_supplyTypes
	What a class can resupply (engine transportAmmo/Repair/Fuel, or the ACE rearm/refuel config when ACE is used).
	Result is cached per class in MCC_supplyClassCache (local hashMap).
	Params:
		0: STRING or OBJECT - class name or object
	Returns: ARRAY of BOOL - [ammo, repair, fuel]
*/
params [["_class", "", ["", objNull]]];

if (_class isEqualType objNull) then {_class = typeOf _class};
if (_class isEqualTo "") exitWith {[false, false, false]};

if (isNil "MCC_supplyClassCache") then {MCC_supplyClassCache = createHashMap};

private _key = toLowerANSI _class;
private _cached = MCC_supplyClassCache get _key;
if (!isNil "_cached") exitWith {_cached};

private _cfg = configFile >> "CfgVehicles" >> _class;
private _ammo = getNumber (_cfg >> "transportAmmo") > 0;
private _repair = getNumber (_cfg >> "transportRepair") > 0;
private _fuel = getNumber (_cfg >> "transportFuel") > 0;

if (missionNamespace getVariable ["MCC_isACERearm", false]) then {
	_ammo = _ammo || {getNumber (_cfg >> "ace_rearm_defaultSupply") > 0};
};
if (missionNamespace getVariable ["MCC_isACERefuel", false]) then {
	_fuel = _fuel || {getNumber (_cfg >> "ace_refuel_fuelCargo") > 0};
};

//Men and logic never count
if (_class isKindOf "CAManBase" || {_class isKindOf "Logic"}) then {_ammo = false; _repair = false; _fuel = false};

private _result = [_ammo, _repair, _fuel];
MCC_supplyClassCache set [_key, _result];
_result
