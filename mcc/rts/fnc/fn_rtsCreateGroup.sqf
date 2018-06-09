/*=================================================================MCC_fnc_rtsCreateGroup==============================================================================
//	Spawn group
//  Parameter(s):
//     	_ctrl: CONTROL
//		_res: resources Needed
//===================================================================================================================================================================*/
private ["_res","_side","_groupArray","_group","_obj","_startPos","_units","_emptyPos","_pos","_ehID","_vehicles","_cfg"];
disableSerialization;

params [
	["_ctrl",controlNull,[controlNull]],
	["_cfgName","",[""]],
	["_playerside","",[""]],
	["_vars",[],[[]]]
];

_side = switch (tolower _playerside) do
				{
					case "west":{west};
					case "east":{east};
					case "guer":{resistance};
					default	{civilian};
				};


_cfg =  if (isClass (missionconfigFile >> "cfgMCCRtsGroups")) then {missionConfigFile >> "cfgMCCRtsGroups" >> _cfgName} else {configFile >> "cfgMCCRtsGroups" >> _cfgName};
_res = getArray (_cfg >> "resources");

_groupArray =getArray (_cfg >> format ["units%1",_side]);


if (count MCC_ConsoleGroupSelected <=0) exitWith {};
_obj = MCC_ConsoleGroupSelected select 0;
_pos = getpos _obj findEmptyPosition [10,50];

_startPos = call compile format ["MCC_START_%1",_side];


//Get the ammount of units
([["units"],_side,true] call MCC_fnc_rtsCalculateResourceTreshold) params [
									["_unitsSpace",0,[0]],
									["_buildings",[],[[]]]
								   ];

_units = {side _x == _side && (isPlayer _x || _x getVariable ["MCC_isRTSunit",false] || group _x getVariable ["MCC_canbecontrolled",false])} count allUnits;
_emptyPos = count _groupArray;

//Not enough houses
if ((_units + _emptyPos)> _unitsSpace) exitWith {
	[9989,"Not Enough Manpower. Build More Sleeping Bunks",5,true] call MCC_fnc_setIDCText;
};

//Start building time
if !([_obj,_res] call MCC_fnc_rtsBuildingProgress) exitWith {};

player globalRadio "CuratorWaypointPlaced";

//Make the group
if (isNil "_pos") then {_pos = getpos (MCC_ConsoleGroupSelected select 0)};
_group = [_pos,_side,_groupArray] call bis_fnc_spawnGroup;

//Set as RTS unit
_group setVariable ["MCC_canbecontrolled",true,true];
_group setVariable ["MCC_rtsGroupCfg",_cfgName,true];

_vehicles = [];
{
	_ehID = _x addMPEventHandler ["mpkilled", {
												_unit = name (_this select 0);
												_killer = name (_this select 1);
												[["MCCNotificationBad",["Unit Down",format ["%1 was killed by %2",_unit,_killer],""]], "bis_fnc_showNotification", _sidePlayer, false] spawn BIS_fnc_MP;
											  }];
	_unit = _x;
	{_x addCuratorEditableObjects [[_unit],true]} forEach allCurators;
	_x setVariable ["MCC_isRTSunit",true,true];
	_x setVariable ["mcc_delete",false,true];

	if !(vehicle _x in _vehicles) then {
		(vehicle _x) setVariable ["mcc_delete",false,true];
		_vehicles pushBack (vehicle _x);
	};
} forEach units _group;
