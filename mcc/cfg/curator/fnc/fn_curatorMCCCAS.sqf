//============================================================MCC_fnc_curatorMCCCAS=================================================================================
// uses MCC CAS in Zeus
//==================================================================================================================================================================
private ["_pos","_module","_object","_displayNames","_resualt","_unitsArray","_casTypes","_casSelected","_casPlane"];
_module = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_pos = getpos _module;
_object = missionNamespace getVariable ["MCC_curatorMouseOver",objNull];
_module hideobject false;
_casTypes = missionNamespace getVariable ["MCC_CASBombs",[]];

_unitsArray = (missionNamespace getVariable ["MCC_vehicles_airplanes",[]]) + (missionNamespace getVariable ["MCC_vehicles_helicopters",[]]);

//Filter display names
_displayNames = [];
{
	_displayNames pushBack (_x select 1)
} forEach _unitsArray;

_resualt = ["Close Air Support",[
				["Plane",_displayNames],
				["CAS",_casTypes]
 			]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

sleep 5;
private ["_spawn","_away","_dir"];
_dir = getdir _module;
_pos = getpos _module;
_spawn = [_pos,3000,(_dir -180)] call BIS_fnc_relpos;
_away = [_pos,3500,_dir] call BIS_fnc_relpos;
_casSelected = _casTypes select (_resualt select 1);
_casPlane = (_unitsArray select (_resualt select 0)) select 0;

//If it is a cruise missile lunch it localy
if (toLower _casSelected isEqualTo "cruise missile") then {
	[6, [_casSelected] , _pos, [_casPlane], _spawn,_away] spawn MCC_fnc_airDrop;
} else {
	[6, [_casSelected] , _pos, [_casPlane], _spawn,_away] remoteExec ["MCC_fnc_airDrop",2];
};

deleteVehicle _module;