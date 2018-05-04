//=================================================================MCC_fnc_addVirtualItemCargo==================================================================================
//  Parameter(s):
//     0: OBJECT - objct to which items will be added
//     1: STRING or ARRAY of STRINGs - item class(es) to be added
//==============================================================================================================================================================================
private ["_object","_classes","_type","_cargo","_cargoArray"];
_object     = param [0,missionnamespace,[missionnamespace,objnull]];
_classes    = param [1,[],["",true,[]]];
_add        = param [2,1,[1]];
_type       = param [3,0,[0]];

//--- Get cargo list
if (_object getVariable ["MCC_objectFirstInteraction",true]) then {
    _null = [_object,(_object getVariable ["MCC_virtualBoxSaveName",nil])] remoteExec ["MCC_fnc_saveCargoBox",2];
    _object setVariable ["MCC_objectFirstInteraction",false,true];
};

waitUntil {count (_object getvariable ["MCC_virtual_cargo",[]]) > 0};

_cargo = _object getvariable ["MCC_virtual_cargo",[[],[],[],[]]];
_cargoArray = _cargo select _type;
if (_add == 0) exitwith {_cargoArray};

//Modify cargo
if (typename _classes != typename []) then {_classes = [_classes]};

{
    _class = _x;
    if (_add > 0) then {
        _cargoArray pushBack _class;
    } else {
        for [{_i=0},{_i<(count _cargoArray)},{_i=_i+1}] do {
            if ((_cargoArray select _i) == _class) then {
                _cargoArray set [_i, -1];
                _i = count _cargoArray;
            };
        };
        _cargoArray = _cargoArray - [-1];
    };
    _save = true;
} foreach _classes;

//Set cargo
_cargo set [_type,_cargoArray];
_object setvariable ["MCC_virtual_cargo",_cargo,true];

//save cargo if inidb is running and it is a side box
if (_object getVariable ["MCC_virtualBox",false]) then {
    [_object,(_object getVariable ["MCC_virtualBoxSaveName",nil])] remoteExec ["MCC_fnc_saveCargoBox",2];
};