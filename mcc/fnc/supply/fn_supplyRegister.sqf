/*
	MCC_fnc_supplyRegister
	Server: add a supply point (ammo/repair/fuel truck, MCC crate, any object with transport cargo) to the
	limited-logistics registry MCC_supplyRegistry. Gives it a finite stock in the object variables
	ammoLeft / supplyLeft / fuelLeft (resource units, same units as MCC_res<SIDE>) and a capacity
	MCC_supplyCap [ammo, repair, fuel]. Existing ammoLeft/supplyLeft/fuelLeft values are kept.
	Does nothing when MCC_logisticsMode is 0 (Off). Safe to call more than once.
	Can be called on a client: it forwards itself to the server.
	Params:
		0: OBJECT - supply object
		1: ARRAY - (optional) capacity override [ammo, repair, fuel]; -1 entries keep the default
	Returns: BOOL - true if the object is (now) registered
*/
params [["_obj", objNull, [objNull]], ["_capOverride", [], [[]]]];

if (isNull _obj || {!alive _obj}) exitWith {false};
if (!isServer) exitWith {[_obj, _capOverride] remoteExecCall ["MCC_fnc_supplyRegister", 2]; false};
if ((missionNamespace getVariable ["MCC_logisticsMode", 0]) isEqualTo 0) exitWith {false};
if (isNil "MCC_supplyRegistry") then {MCC_supplyRegistry = []};
if (_obj in MCC_supplyRegistry) exitWith {true};
if (_obj getVariable ["MCC_supplyIgnore", false]) exitWith {false};

private _types = [_obj] call MCC_fnc_supplyTypes;
if !(true in _types) exitWith {false};

private _class = typeOf _obj;
private _crateIndex = (missionNamespace getVariable ["MCC_logisticsCrates_TypesWest", []]) find _class;
if (_crateIndex < 0) then {_crateIndex = (missionNamespace getVariable ["MCC_logisticsCrates_TypesEast", []]) find _class};
private _isVehicle = _obj isKindOf "AllVehicles";

//Default capacity: MCC crates 200 (big 800), vehicles and anything else the truck capacity setting
private _default = switch (true) do {
	case (_crateIndex > 2): {800};
	case (_crateIndex >= 0): {200};
	case (_isVehicle): {missionNamespace getVariable ["MCC_logisticsTruckCapacity", 1000]};
	default {200};
};

private _vars = ["ammoLeft", "supplyLeft", "fuelLeft"];
private _cap = [0, 0, 0];
private _orig = [getAmmoCargo _obj, getRepairCargo _obj, getFuelCargo _obj];
{
	if (_x) then {
		private _c = _default;
		private _over = _capOverride param [_forEachIndex, -1];
		if (_over isEqualType 0 && {_over >= 0}) then {_c = _over};
		private _have = _obj getVariable [_vars select _forEachIndex, -1];
		if !(_have isEqualType 0) then {_have = -1};
		//Crates loaded by MCC already carry a smaller ammoLeft: keep it, capacity follows the bigger value
		if (_have < 0) then {_have = _c} else {_c = _c max _have};
		_cap set [_forEachIndex, _c];
		_obj setVariable [_vars select _forEachIndex, _have, true];
	};
} forEach _types;

_obj setVariable ["MCC_supplyTypes", _types];
_obj setVariable ["MCC_supplyCap", _cap, true];
_obj setVariable ["MCC_supplyOrigCargo", _orig];
_obj setVariable ["MCC_supplyCargoOn", [true, true, true]];
_obj setVariable ["MCC_supplyIsVehicle", _isVehicle];

//ACE (MCC_isACERearm / MCC_isACERefuel): push our stock into ACE's own counters (ammo = ACE supply points, fuel = liters)
if ((_types select 0) && {missionNamespace getVariable ["MCC_isACERearm", false]} && {!isNil "ace_rearm_fnc_setSupplyCount"}) then {
	private _v = _obj getVariable ["ammoLeft", 0];
	//ACE ignores transportAmmo: classes without ACE rearm config (e.g. MCC crates) must be made ACE sources first
	if (getNumber (configFile >> "CfgVehicles" >> _class >> "ace_rearm_defaultSupply") <= 0 && {!isNil "ace_rearm_fnc_makeSource"}) then {
		[_obj, _v] call ace_rearm_fnc_makeSource;
	};
	[_obj, _v] call ace_rearm_fnc_setSupplyCount;
	_obj setVariable ["MCC_supplyAcePrev0", _v];
};
if ((_types select 2) && {missionNamespace getVariable ["MCC_isACERefuel", false]} && {!isNil "ace_refuel_fnc_setFuel"}) then {
	private _l = (_obj getVariable ["fuelLeft", 0]) * (missionNamespace getVariable ["MCC_logisticsLitersPerUnit", 10]);
	//ACE ignores transportFuel: classes without ace_refuel_fuelCargo (e.g. MCC fuel crates) must be made ACE sources first
	if (getNumber (configFile >> "CfgVehicles" >> _class >> "ace_refuel_fuelCargo") <= 0 && {!isNil "ace_refuel_fnc_makeSource"}) then {
		[_obj, _l] call ace_refuel_fnc_makeSource;
	};
	[_obj, _l] call ace_refuel_fnc_setFuel;
	_obj setVariable ["MCC_supplyAcePrev2", _l];
};

MCC_supplyRegistry pushBackUnique _obj;
true
