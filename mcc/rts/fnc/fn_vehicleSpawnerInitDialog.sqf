//=================================================================MCC_fnc_vehicleSpawnerInitDialog====================================================================
//  Open vehicle spawner Dialog
//=======================================================================================================================================================================
 private ["_side","_comboBox","_mccdialog","_displayname","_index","_array","_rtsAnchor","_caller","_vehicleType","_spawnPad","_arguments","_commadner","_faction","_cost","_sideBuy"];


//We got here from the addaction
_caller = param [0, objNull, [objNull]];
_arguments = param [1, [], [[]]];
_commadner = param [2, false, [false]];
_vehicleType = _arguments select 0;
_spawnPad = _arguments select 1;

missionNamespace setVariable ["MCC_vehicleSpawner_IsCommadner",_commadner];

//If it is an RTS spawner and we don't have elec on
_rtsAnchor = if (MCC_isMode) then {
         getText (configFile >> "cfgRtsBuildings" >> "MCC_rts_workshop1" >> "anchorType");
    } else {
         getText (missionconfigFile >> "cfgRtsBuildings" >> "MCC_rts_workshop1" >> "anchorType");
    };

if ((attachedTo _spawnPad) isKindOf _rtsAnchor && !((missionNamespace getVariable [format ["MCC_rtsElecOn_%1", playerSide],false]) || (missionNamespace getVariable [format ["MCC_rtsAllowPlayersPurchase_%1", playerSide],false]))) exitWith {
   titleText ["Workshop Offline","PLAIN"];
};

createDialog "MCC_VEHICLESPAWNER";
waitUntil {!isnull (uiNamespace getVariable ["MCC_VEHICLESPAWNER_IDD", displayNull])};

//If it is from commander view use resources if it isn't use valor
if (_commadner) then {
    ctrlshow [1003,false];
    ctrlshow [1103,false];
    ctrlshow [84,false];
    ctrlshow [94,false];
} else {
    for "_i" from 1100 to 1102 step 1 do {ctrlshow [_i,false]};
    for "_i" from 1000 to 1002 step 1 do {ctrlshow [_i,false]};
    for "_i" from 81 to 83 step 1 do {ctrlshow [_i,false]};
    for "_i" from 91 to 93 step 1 do {ctrlshow [_i,false]};
};

_side = side _caller;
_faction = faction _caller;
_sideBuy = missionNamespace getVariable ["MCC_vehicleKioskBySide",false];
_vehicleArray = [_vehicleType, _side, _faction, _sideBuy] call MCC_fnc_vehicleSpawnerBuildCostTable;

missionNamespace setVariable ["MCC_private_vehicleArray",_vehicleArray];
missionNamespace setVariable ["MCC_private_spawnPad",_spawnPad];

disableSerialization;
_mccdialog = uiNamespace getVariable "MCC_VEHICLESPAWNER_IDD";

//Fill comboBox
_comboBox = _mccdialog displayCtrl 101;
lbClear _comboBox;
{
    _displayname = if (typeName (_x select 1) isEqualTo typeName []) then {(_x select 1) select 0} else {(_x select 1)};
    _index = _comboBox lbAdd _displayname;
    _comboBox lbSetPicture [_index,(gettext (configFile >> "CfgVehicles" >> (_x select 0) >> "picture"))];
} foreach _vehicleArray;
_comboBox lbSetCurSel 0;

while {(str (_mccdialog displayCtrl 101) != "No control")} do {
    //Load available resources
    _array = call compile format ["MCC_res%1",playerside];

    {_mccdialog displayCtrl _x ctrlSetText ([(_array select _forEachIndex)] call MCC_fnc_formatNumber)} foreach [81,82,83];
    _mccdialog displayCtrl 84 ctrlSetText ([(player getVariable ["MCC_valorPoints",50])] call MCC_fnc_formatNumber);
    sleep 1;
};