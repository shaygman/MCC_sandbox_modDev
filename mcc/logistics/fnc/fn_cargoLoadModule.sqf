/*================================================ MCC_fnc_cargoLoadModule ==========================================================

Load object from 3den or curator to MCC/ACE logistic system
*/

private ["_module","_object"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {};

//3den
if (isNull curatorCamera) exitWith {

	if (!isServer) exitWith {};

	//Find all objects
    private _synced = [];
	{
        //Find the vehicle
		if (_x isKindOf "logic") then {
            {
                if !(_x isKindOf "logic") then {_synced pushBack _x};
            } forEach (synchronizedObjects _x);

		} else {
             if !(_x isKindOf "MiscUnlock_F") then {_object = _x};
        };
	} forEach (synchronizedObjects _module);

    if (isNil "_object") exitWith {diag_log "Error MCC_fnc_cargoLoadModule: can't find cargo vehicle"};

    [_synced,_object] spawn {
        params ["_synced","_object"];

        waitUntil {time>0};
        {
            if (isClass (configFile >> "CfgPatches" >> "ace_cargo")) then {
                //ACE
                [_x, _object, true] call ACE_cargo_fnc_loadItem;
            } else {
                [_x, _object, true] call MCC_fnc_logisticsCargoLoad;
            };

        } forEach _synced;
    };

    diag_log format ["MCC_fnc_cargoLoadModule: %1 %2", _object , _synced];
};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

deleteVehicle _module;
_object = missionNamespace getVariable ["MCC_curatorMouseOver",[]];

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
        	[_object, _availableVehicle, true] call ACE_cargo_fnc_loadItem;
        } else {
        	[_object, _availableVehicle, true] call MCC_fnc_logisticsCargoLoad;
        };
    },
    localize "STR_DISP_CURATOR_VEHICLECARGOLOAD",
    "a3\ui_f\data\IGUI\Cfg\Actions\loadVehicle_ca.paa"
] call MCC_fnc_curatorDrawLine;

