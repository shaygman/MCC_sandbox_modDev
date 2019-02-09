/*================================================ MCC_fnc_cargoLoadModule ==========================================================

Load object from 3den or curator to MCC/ACE logistic system
*/

private ["_module","_object"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {};

//TODO EDEN
if (_module isKindOf "MCC_Module_addValor") exitWith {

	if (!isServer) exitWith {};

	_valor = _module getVariable ["valor",100];

	//Find all units
	{
		if (_x isKindOf "CAMANBASE") then {
			_x setVariable ["MCC_valorPoints",_valor,true];
		};
	} forEach (synchronizedObjects _module);

};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_object = missionNamespace getVariable ["MCC_curatorMouseOver",[]];

//if no object selected run it on all players
if (count _object <2) exitWith {};
_object = _object select 1;

[
    _object,
    {
    	params ["_success", "_object", "_mousePosASL", "_shift", "_ctrl", "_alt"];
    	private ["_availableVehicle","_objectMass"];

    	if (!_success || !alive _object) exitWith {};

    	//Get all nearby cargo
    	if (isClass (configFile >> "CfgPatches" >> "ace_cargo")) then {
    		//ACE
    		_availableVehicle = (nearestObjects [ASLToAGL _mousePosASL, (missionNamespace getVariable ["ace_cargo_cargoHolderTypes",[]]), 15, true]) param [0, objNull];
    	} else {
    		_objectMass = (getMass _object) max 5;
    		_availableVehicle = (((ASLToAGL _mousePosASL) nearObjects ["AllVehicles",15]) select {_x getVariable ["MCC_logisticsObjectMass",_x call MCC_fnc_logisticsCargoGetMass] >= _objectMass}) param [0, objNull];;
    	};

        if (isNull _availableVehicle || !alive _availableVehicle) exitWith { };

        if (isClass (configFile >> "CfgPatches" >> "ace_cargo")) then {
        	//ACE
        	[_object, _availableVehicle, true] call ACE_fnc_cargo_loadItem;
        } else {
        	[_object, _availableVehicle, true] call MCC_fnc_logisticsCargoLoad;
        };
    },
    localize "STR_DISP_CURATOR_VEHICLECARGOLOAD",
    "a3\ui_f\data\IGUI\Cfg\Actions\loadVehicle_ca.paa"
] call MCC_fnc_curatorDrawLine;

deleteVehicle _module;