/*=============================================================MCC_fnc_vehicleSpawnerInit==================================================================================
//  [_this,"vehicle"] spawn MCC_fnc_vehicleSpawnerInit
//  Init an object as a vehicle spawner and add an add action to it
//  Parameter(s):
//     0: OBJECT - objct to which items will be added
//     1: ARRAY of STRINGS - first argument type "tank","vehicle","heli","jet","ship"
//                           secon argument - helipad spawn name - string
//===============================================================================================================================================================*/
#define    MCC_billboard    "Land_Noticeboard_F"
#define    MCC_helipad    "Land_HelipadEmpty_F"

private ["_object","_vars","_null","_syncItems","_syncedObjects","_billboard","_helipad","_type"];

params [
    ["_object",objNull],
    ["_vars",[]],
    ["_action","init"]
];

waitUntil {time > 1};

//We came here from a moudle
if (_object isKindOf "mcc_sandbox_modulevehicleSpawner" || _object isKindOf "MCC_Module_vehicleSpawnerCurator") exitWith {
    _syncedObjects = synchronizedObjects _object;

    //No synced Objects?
    if (count _syncedObjects <2) then {
        _billboard = MCC_billboard createVehicle (_object modelToWorld [0,5,0]);
        _helipad = MCC_helipad createVehicle (_object modelToWorld [0,15,0]);
    } else {
        _billboard = _syncedObjects select 0;
        _helipad = _syncedObjects select 1;
    };

    _type = _object getVariable ["type","vehicle"];
    missionNamespace setVariable ["MCC_vehicleKioskBySide",(_object getVariable ["spawnFrom",0]) isEqualTo 1];

    //Add the objects to curator
    [_billboard,_helipad,_type] spawn {
        private ["_billboard","_helipad","_type"];
        _billboard = _this select 0;
        _helipad = _this select 1;
        _type = _this select 2;

        waitUntil {!isNil "MCC_curator"};
        {
            [[[_x], {MCC_curator addCuratorEditableObjects [[_this select 0],false];}], "BIS_fnc_spawn", false, false, false] call BIS_fnc_MP;
        } forEach [_billboard,_helipad];

        [_billboard,[_type,_helipad],"init"] remoteExec ["MCC_fnc_vehicleSpawnerInit",0,_billboard];
    };
};

switch (_action) do
{
    case "init":
    {
        //If already initilize just quiet
        if (_object getVariable ["MCC_fnc_vehicleSpawnerInit",false]) exitWith {};
        _object setVariable ["MCC_fnc_vehicleSpawnerInit",true];

        //We got here from the object
        if (local _object) then {_object allowDamage false; _object enableSimulation false};
        _textue =  switch (tolower (_vars select 0)) do {
                                    case "vehicle": {"\A3\Soft_F\MRAP_01\Data\UI\MRAP_01_Base_ca.paa"};
                                    case "tank": {"\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa"};
                                    case "heli": {"\A3\Air_F_Beta\Heli_Attack_01\Data\UI\Heli_Attack_01_CA.paa"};
                                    case "jet": {"\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Plane_CAS_01_CA.paa"};
                                    case "ship": {"\A3\boat_f\Boat_Armed_01\data\ui\Boat_Armed_01_minigun.paa"};
                                    case "units": {format ["%1data\IconMen.paa",MCC_path]};
                                    default {"\A3\Soft_F\MRAP_01\Data\UI\MRAP_01_Base_ca.paa"};
                                };

        _object setObjectTexture [0,_textue];
        _object setObjectTexture [1,'#(rgb,8,8,3)color(0.5,0.5,0.5,0.1)'];
        _object setObjectTexture [2,'#(rgb,8,8,3)color(0.5,0.5,0.5,0.1)'];
        //_null = _object addAction [format ["<t color=""#ff1111"">Purchase %1</t>",_vars select 0], {call MCC_fnc_vehicleSpawnerInit}, _vars,10,true,true];

        _action = [
                _object,
                format ["Purchase %1",_vars select 0],
                _textue,
                _textue,
                "(alive _target) && (_target distance _this < 5)",
                "(alive _target) && (_target distance _this < 5)",
                {},
                {},
                {[player, (_this select 3),"dialog"] spawn MCC_fnc_vehicleSpawnerInit},
                {},
                _vars,
                1,
                3,
                false,
                false
                ] call bis_fnc_holdActionAdd;
    };

    case "dialog":
    {
        //We got here from the addaction
        params [
            ["_caller",objNull],
            ["_vars",[]]
        ];

        if (isNull _caller) exitWith {};
        [_caller, _vars] spawn MCC_fnc_vehicleSpawnerInitDialog;
    };
};