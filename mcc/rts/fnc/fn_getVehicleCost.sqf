 /*=====================================================================  MCC_fnc_getVehicleCost ====================================================

    Return vehicle costs - part of the vehicle kiosk

    <IN>
       0:   STRING: vehicle class
       1:   INTEGER :Basic cost

    <OUT>
        INTEGER: Cost
 ===================================================================================================================================================
 */
 params [
        ["_class","",[""]],
        ["_cost",1,[0]]
    ];

#define    MCC_costFactor  0.7

private ["_cfg","_value","_baseCost"];

_cfg = configfile >> "CfgVehicles" >> _class;
_baseCost = _cost;

//Accuracy
_value = (1-((getNumber( _cfg >> "accuracy")) min 3)) max 0.1;
_cost = _cost * (2-_value);

//Armor
_value = getNumber( _cfg >> "armor");
_cost = _cost + (_value * (_baseCost * 0.005));

//Transport
_value = getNumber( _cfg >> "transportSoldier");
_cost = _cost + (_value * (_baseCost * 0.03));

//Laser
_value = if (getNumber( _cfg >> "laserScanner")>0) then {1.15} else {1};
_cost = _cost * _value;

//nightVision
_value = if (getNumber( _cfg >> "nightVision")>0) then {1.05} else {1};
_cost = _cost * _value;

//nvScanner
_value = if (getNumber( _cfg >> "nvScanner")>0) then {1.05} else {1};
_cost = _cost * _value;

//radarType
_value = (getNumber( _cfg >> "radarType") max 1) * (_baseCost * 0.08);
_cost = _cost + _value;

//transportMaxMagazines
_value = (getNumber( _cfg >> "transportMaxMagazines") max 1) * (_baseCost * 0.005);
_cost = _cost + _value;

//maxSpeed
_value = (getNumber( _cfg >> "maxSpeed") max 1) * (_baseCost * 0.005);
_cost = _cost + _value;

//Count turrets
_turretsCount = count (getArray ( _cfg >> "weapons"));

for "_i" from 0 to (count ( _cfg >> "Turrets") -1) step 1 do
{
    _turretsCount = _turretsCount + count (getArray ( (( _cfg >> "Turrets") select _i) >> "weapons"));
};

_value = _turretsCount * (_baseCost * 0.15);
_cost = _cost + _value;

floor (_cost * MCC_costFactor)