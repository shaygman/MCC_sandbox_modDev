/*=================================================================MCC_fnc_rtsRespawnUnits==============================================================================
//	Respawn dead units in a group
//  Parameter(s):
//     	_ctrl: CONTROL
//======================================================================================================================================================================*/

#define	PARACHUTE	"NonSteerable_Parachute_F"
#define	SOUNDJET	"BattlefieldJet1"

private ["_ctrl","_res","_target","_unitsArray","_groupCfg","_groupArray","_unitClass","_parents","_ehID","_unit"];
disableSerialization;
_ctrl = _this select 0;
_res = param [1, [], [[]]];

if (count MCC_ConsoleGroupSelected <=0) exitWith {};
_target = MCC_ConsoleGroupSelected select 0;

//remove resources
[_res] spawn MCC_fnc_baseResourceReduce;

_groupCfg = _target getVariable ["MCC_rtsGroupCfg",""];

if (isClass (missionconfigFile >> "cfgMCCRtsGroups")) then {
	_unitsArray = getArray (missionconfigFile >> "cfgMCCRtsGroups" >> _groupCfg >> format ["units%1",playerSide]);
} else {
	_unitsArray = getArray (configFile >> "cfgMCCRtsGroups" >> _groupCfg >> format ["units%1",playerSide]);
};

_groupArray = [];
{
	_groupArray pushBack typeof _x;
} forEach units _target;

_unitsArray = _unitsArray - _groupArray;

if (count _unitsArray > 0) then {
	_unitClass = _unitsArray select 0;
	_parents = [(configFile >> "cfgVehicles" >> _unitClass),true] call BIS_fnc_returnParents;

	if ("Man" in _parents) then {

		//Drop the unit
		player globalRadio "CuratorWaypointPlaced";
		playsound SOUNDJET;
		private _pos = position leader _target;
		_pos set [2,(_pos select 2) + 50];
		_unit = _target createUnit [_unitClass, _pos, [], 0, "FORM"];
		_chute = createVehicle [PARACHUTE, position _unit, [], getdir (leader _target), 'NONE'];
		_chute setPos (getPos _unit);
		_unit moveindriver _chute;

		_ehID = _unit addMPEventHandler ["mpkilled", {
												_unit = name (_this select 0);
												_killer = name (_this select 1);
												[["MCCNotificationBad",["Unit Down",format ["%1 was killed by %2",_unit,_killer],""]], "bis_fnc_showNotification", _sidePlayer, false] spawn BIS_fnc_MP;
											  }];
		{_x addCuratorEditableObjects [[_unit],true]} forEach allCurators;
		_unit setVariable ["MCC_isRTSunit",true,true];
	};
};
