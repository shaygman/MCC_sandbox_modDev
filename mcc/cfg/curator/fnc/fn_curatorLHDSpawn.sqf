/*============================================================MCC_fnc_curatorLHDSpawn==================================================================================
// Spawn LHD Curator Menu
//================================================================================================================================================================*/
private ["_pos","_module","_resualt","_dir","_side","_hq","_lhdType","_displayName","_shipsTypes","_store","_rearm"];
_module = param [0,objNull,[objNull]];
if (isNull _module) exitWith {};

_pos = getPosASLW _module;
_dir = getDir _module;

//did we get here from the 2d editor?
if (typeName (_module getVariable ["side",""]) == typeName 0) exitWith {

	if (isServer) then {

		_side = [(_module getVariable ["side",1])] call BIS_fnc_sideType;
		_hq = _module getVariable ["hq",true];
		_lhdType = _module getVariable ["lhdType",2];
		_displayName = _module getVariable ["displayName",""];
		_store = _module getVariable ["store",true];
		_rearm = _module getVariable ["rearm",true];
		_pos set [2,0];

		//Start LHD
		[_pos,_dir,_side,_hq,_lhdType,_displayName, _store, _rearm] spawn MCC_fnc_LHDspawn;

		deleteVehicle _module;
	};
};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_shipsTypes = ["Destroyer","Aircraft Carrier","Submarine"];
if (isClass (configFile >> "CfgVehicles" >> "CUP_LHD_BASE")) then {_shipsTypes pushBack "LHD"};

_resualt = ["Spawn Static Ship",[
				["Ship Side",["East","West","Resistance"]],
				["Respawn Position",false],
				["Ship Type",_shipsTypes],
				["Ship Name",""],
				["Vehicles Purchasing",true],
				["Rearm and Refuel",true]
 			]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

_side = [ _resualt param [0,1]] call BIS_fnc_sideType;
_hq = _resualt param [1,false];
_lhdType = _resualt param [2,2];
_displayName = _resualt param [3,""];
_store = _resualt param [4,true];
_rearm = _resualt param [5,true];

[_pos, _dir, _side, _hq, _lhdType, _displayName, _store, _rearm] remoteExec ["MCC_fnc_LHDspawn",2];

deleteVehicle _module;