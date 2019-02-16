/* ====================================================== MCC_fnc_logisticsCargoLoad  ======================================================

	Load an object to vehicle

=========================================================================================================================================
*/

private ["_object","_vehicle","_objectMass","_cargoItems","_vehicleMass"];
_object = (param [0,"",["",objNull]]);
_vehicle = (param [1,"",["",objNull]]);

if (_object isEqualType "") then {_object = _object call BIS_fnc_objectFromNetId;};
if (_vehicle isEqualType "") then {_vehicle = _vehicle call BIS_fnc_objectFromNetId;};

if (isNull _object || isNull _vehicle) exitWith {};

_vehicleMass = _vehicle getVariable ["MCC_logisticsObjectMass",_vehicle call MCC_fnc_logisticsCargoGetMass];
_objectMass = (getMass _object) max 5;

if ( _vehicleMass >= _objectMass) then {
	_cargoItems = _vehicle getVariable ["MCC_logisticsCargo",[]];

	//If the object is a cargo container store the cargo too
	_cargoItems pushBack [typeOf _object,[getweaponCargo _object, getMagazineCargo  _object, getitemCargo _object],damage _object, fuel _object];

	_vehicle setVariable ["MCC_logisticsCargo",_cargoItems,true];
	_vehicle setVariable ["MCC_logisticsObjectMass",(_vehicleMass - _objectMass) max 0,true];
	deleteVehicle _object;
};