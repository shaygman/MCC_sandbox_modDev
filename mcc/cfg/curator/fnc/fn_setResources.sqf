//============================================================MCC_fnc_setResources====================================================================================
// Starts MCC Campaign
//===========================================================================================================================================================================
private ["_pos","_module","_side","_argName","_resualt"];
_module = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _module) exitWith {};

//did we get here from the 2d editor?
if (typeName (_module getVariable ["side",true]) == typeName 1) exitWith {

	_side = [_module getVariable ["side",7]] call BIS_fnc_sideType;
	//MCC_res<SIDE> order is [ammo, repair, fuel, food, meds]
	_res = [(_module getVariable ["ammo",0]),
	        (_module getVariable ["repair",0]),
	        (_module getVariable ["fuel",0]),
	        (_module getVariable ["food",0]),
	        (_module getVariable ["meds",0])
	        ];
	waitUntil {time > 1};
	//Server sets and broadcasts it (module init runs on every machine, only the server's write counts)
	if (isServer) then {[_side, "all", _res] call MCC_fnc_resChange};
};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_pos = getpos _module;

 _resualt = ["Set Resources",[
 						["Side",["East","West","Resistance"]],
 						["Materials",3000],
 						["Ammo",3000],
 						["Fuel",3000],
 						["Food",1000],
 						["Meds",1000]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

_side = [east,west,resistance] select (_resualt select 0);
//Dialog order is Materials(repair), Ammo, Fuel, Food, Meds - MCC_res<SIDE> order is [ammo, repair, fuel, food, meds]
_res = [(_resualt select 2),
        (_resualt select 1),
        (_resualt select 3),
        (_resualt select 4),
        (_resualt select 5)
        ];

//Server-authoritative write (forwarded to the server when the curator is a client)
[_side, "all", _res] call MCC_fnc_resChange;

deleteVehicle _module;