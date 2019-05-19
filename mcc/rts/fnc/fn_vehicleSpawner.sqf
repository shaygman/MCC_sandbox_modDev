//===============================================================MCC_fnc_vehicleSpawner==================================================================================
//  manage the actull spawning
//====================================================================================================================================================================
private ["_vehicleArray","_action","_selectedVehicle","_cost","_cfgclass","_costAmmo","_costRepair","_costFuel","_ctrl","_array","_mccdialog","_disableCtrl","_costValor","_commander"];
#define    MCC_PRICESFACTOR    0.2

_vehicleArray = missionNamespace getVariable ["MCC_private_vehicleArray",[]];
_commander = missionNamespace getVariable ["MCC_vehicleSpawner_IsCommadner",false];

if (count _vehicleArray == 0 || (lbCurSel 101) == -1) exitWith {};

disableSerialization;
_mccdialog = uiNamespace getVariable "MCC_VEHICLESPAWNER_IDD";

_selectedVehicle = _vehicleArray select (lbCurSel 101);
_cfgclass = _selectedVehicle select 0;
_cost = _selectedVehicle select 2;
_costAmmo = floor (_cost * 0.3 * MCC_PRICESFACTOR);
_costRepair = floor (_cost * 0.5 * MCC_PRICESFACTOR);
_costFuel = floor (_cost * 0.2 * MCC_PRICESFACTOR);
_costValor = floor (_cost * 0.5 * MCC_PRICESFACTOR);

_array = call compile format ["MCC_res%1",playerside];

_action =  param [0, 0, [0]];

//Change value
switch (_action) do
{
    case 0: //Change vehicle class
    {
        _ctrl = 1000;
        _disableCtrl = true;

        if (_commander) then {
            //Do we have enough personal resources
            {
                ctrlSetText [_ctrl, [_x] call MCC_fnc_formatNumber];
                if (_x <= (_array select _foreachindex)) then {
                    (_mccdialog displayctrl _ctrl) ctrlSetTextColor [1,1,1,1];
                } else {
                    (_mccdialog displayctrl _ctrl) ctrlSetTextColor [1,0,0,1];
                    _disableCtrl = false;
                };
                _ctrl = _ctrl +1;
            } forEach [_costAmmo,_costRepair,_costFuel];
        } else {

             _ctrl = 1000;

            {
                ctrlSetText [_ctrl,[_x] call MCC_fnc_formatNumber];
                _ctrl = _ctrl +1;
            } forEach [0,0,0];

            //Do we have enough personal fame
            _ctrl = _mccdialog displayctrl 1003;
            _ctrl ctrlSetText ([_costValor] call MCC_fnc_formatNumber);

            if ((player getVariable ["MCC_valorPoints",50]) >= _costValor) then {
                _ctrl ctrlSetTextColor [1,1,1,1];
            } else {
                _ctrl ctrlSetTextColor [1,0,0,1];
                _disableCtrl = false;
            };
        };

        //Add picture
        _ctrl = _mccdialog displayCtrl 111100;
        _ctrl ctrlSetText (getText (configfile >> "CfgVehicles" >> _cfgclass >> "editorPreview"));
        _ctrl ctrlCommit 0;

        ctrlEnable [102,_disableCtrl];
    };

    case 1:
    {
        private ["_spawnPad","_spawnPadPos","_check","_vehicle"];

        _spawnPad = missionNamespace getVariable ["MCC_private_spawnPad",objNull];

        if (isNull _spawnPad) exitWith {};
        _spawnPadPos = getpos _spawnPad;

        //can we spawn?
        _check = _spawnPadPos nearObjects ["LandVehicle", 5];
        if (count _check > 0) exitWith {systemChat "Can't spawn. Spawn point isn't clear"};
        _check = _spawnPadPos nearObjects ["Ship", 5];
        if (count _check > 0) exitWith {systemChat "Can't spawn. Spawn point isn't clear"};
        _check = _spawnPadPos nearObjects ["Air", 5];
        if (count _check > 0) exitWith {systemChat "Can't spawn. Spawn point isn't clear"};

        //Reduce resources
        if (_commander) then {
            _array = [(_array select 0) -_costAmmo,(_array select 1) -_costRepair,(_array select 2) -_costFuel,(_array select 3),(_array select 4)];
            missionNamespace setVariable [format ["MCC_res%1",playerside],_array];
            publicVariable format ["MCC_res%1",playerside];
        } else {
             //Reduce valor
            player setVariable ["MCC_valorPoints",(player getVariable ["MCC_valorPoints",50])-_costValor,true];
        };

        if (tolower (getText(configfile >> "CfgVehicles" >>_cfgclass >> "simulation")) == "soldier") then {
            _vehicle = group player createUnit [_cfgclass, _spawnPadPos, [], 0, "FORM"];
        } else {
            _vehicle = _cfgclass createVehicle _spawnPadPos;

            _vehicle setpos _spawnPadPos;
            _vehicle setdir getdir _spawnPad;
            _vehicle setVariable ["mcc_delete",false,true];
            _vehicle setVariable ["MCC_rtsObject",true,true];
             if (missionNamespace getVariable ["CP_activated",false]) then {_vehicle disableTIEquipment true};

            //clear cargo
            clearMagazineCargoGlobal _vehicle;
            clearWeaponCargoGlobal _vehicle;
            clearBackpackCargoGlobal _vehicle;
            clearItemCargoGlobal _vehicle;
        };

        [[[_vehicle], {MCC_curator addCuratorEditableObjects [[_this select 0],false];}], "BIS_fnc_spawn", false, false, false] call BIS_fnc_MP;
        closeDialog 0;
    };
};