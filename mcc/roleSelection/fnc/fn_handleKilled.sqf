/*================================================================MCC_fnc_handleKilled============================================================================
// Kill messeges
==============================================================================================================================================================*/
private ["_distance","_string","_xpFactor","_source"];

params ["_unit", ["_killer", objNull]];
if ((missionNamespace getVariable ["CP_activated",true]) && (typeOf _unit isKindOf "Man" ))then {

	//If we respawn
    if ((isNull _killer) || {_killer == _unit}) then {
        _killer = _unit getVariable ["ace_medical_lastDamageSource", objNull];
    };

    //No killer found so far break
    if (isNull _killer || (_killer isEqualTo _unit)) exitWith {};

    _distance =floor (_killer distance _unit);
	_xpFactor = if (vehicle player != player) then {0.5} else {(ceil(_distance/200) min 3)};

    // If killer is a vehicle get the vehicle crew
    if ((!isNull _killer) && {!(_killer isKindof "CAManBase")}) then {
    	_killer = crew vehicle _killer;
    };



	//GetXP
	if (missionNamespace getVariable ["MCC_medicXPmesseges",true]) then {


		_string = if (missionNamespace getVariable ["CP_activated",false]) then {
					if  (isPlayer _unit) then {
						format ["Incapacitating (lvl %1) %2 (Distance %3m)", (_unit getvariable ["CP_roleLevel",1]), name _unit, _distance];
					} else {
						format ["Incapacitating %1 (Distance %2m)", name _unit, _distance];
					}
				} else {
				format ["Incapacitating %1 (Distance %2m)", name _unit, _distance];
			};
	} else {
		_string = "";
	};

	if (typeName _killer isequalto typename []) then {
		{
			if (isPlayer _x && (side _x getFriend ([_unit,true] call BIS_fnc_objectSide) < 0.6)) then {
				[getplayeruid _x, (100*_xpFactor),_string] remoteExec ["MCC_fnc_addRating",_x];
			};
		} forEach _killer;

	} else {
		if (side _killer getFriend ([_unit,true] call BIS_fnc_objectSide) < 0.6) then {
			[getplayeruid _killer, (100*_xpFactor),_string] remoteExec ["MCC_fnc_addRating",_killer];
		};
	};
};