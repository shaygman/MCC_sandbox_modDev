/*=================================================================MCC_fnc_buildFort==============================================================================
//  Parameter(s):
//     	_ctrl: CONTROL
//		_res: resources Needed
//===============================================================================================================================================================*/
private ["_class","_res","_cfg"];
params [
	["_ctrl",controlNull,[controlNull]],
	["_cfgName","",[""]],
	["_playerside","",[""]],
	["_vars",[],[[]]]
];

_cfg =  if (isClass (missionconfigFile >> "cfgRtsActions" >> _cfgName)) then {
			missionConfigFile >> "cfgRtsActions" >> _cfgName;
		} else {
			configFile >> "cfgRtsActions" >> _cfgName
		};

_res = getArray (_cfg >> "resources");

_class = getText (_cfg >> "class" + _playerside);

MCC_CONST_PLACEHOLDER = _class createVehicleLocal [0,0,100];
MCC_CONST_PLACEHOLDER setdir (missionNamespace getVariable ["MCC_rtsFortDir",0]);
MCC_CONST_PLACEHOLDER setVariable ["MCC_baseBuildingToBuild",_class];
MCC_CONST_PLACEHOLDER setVariable ["MCC_baseBuildingIsFort",true];
MCC_CONST_PLACEHOLDER setVariable ["MCC_baseBuildingRes",_res];