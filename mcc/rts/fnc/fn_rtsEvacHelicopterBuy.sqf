/*============================================= MCC_fnc_rtsEvacHelicopterBuy
	Spawn evac helicopter of not available
=================================================================================*/
private ["_ctrl","_res","_side","_varName","_evacHeliArray"];
disableSerialization;
_ctrl = _this select 0;
_res = param [1, [], [[]]];
_side = playerSide;

//Do we have an evac down
_varName = format ["MCC_campaignEvac_%1", _side];
_evacHeliArray = missionNamespace getVariable [_varName,[]];

//Exit if evac heli is not available
if (count _evacHeliArray <= 0) exitWith {

	[9989,"Evac helicopter is not available",5,true] spawn MCC_fnc_setIDCText;
};

_evacHeliArray params [
		["_heliObject",objNull,[objNull]],
		["_heliClass","",[""]],
		["_pos",[0,0,0],[[]]],
		["_dir",0,[0]]
	];

//Exit if evac heli is available and functional
if (alive _heliObject && canMove _heliObject && alive driver _heliObject) exitWith {
	[9989,"Evac helicopter is still alive can't spawn a new one",5,true] spawn MCC_fnc_setIDCText;
};

//If evac is alive but not functional delete it first
if (alive _heliObject && !(canMove _heliObject && alive driver _heliObject)) then {

	//Let it go in flame
	{
		if !(isplayer leader _heliObject) then {deleteVehicle _heliObject};
	} forEach crew _heliObject;

	deleteVehicle _heliObject;
};


//remove resources
[_res] spawn MCC_fnc_baseResourceReduce;

waitUntil {isNull _heliObject};
sleep 1;

[_heliClass, _pos, true, _dir] remoteExec ["MCC_fnc_evacSpawn",2];

[9989,"Evac helicopter spawned",5,true] spawn MCC_fnc_setIDCText;