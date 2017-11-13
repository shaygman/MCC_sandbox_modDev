//============================================================MCC_fnc_curatorAmbientCivilians====================================================================================
// handles the add ambient civilians module
//===========================================================================================================================================================================
private ["_pos","_module","_factionArray","_resualt","_civRelations","_civRelationsIgnore"];
_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

//did we get here from the 2d editor?
if (typeName (_module getVariable ["isCiv",true]) == typeName 0) exitWith {
	private ["_isCiv","_isCar","_isParkedCar","_isLocked","_civSpawnDistance","_maxCivSpawn","_factionCiv","_factionCivCar"];

	_isCiv = (_module getVariable ["isCiv",1])==1;
	_isCar = (_module getVariable ["isCar",1])==1;
	_isParkedCar = (_module getVariable ["isParkedCar",1])==1;
	_isLocked  = (_module getVariable ["isLocked",1])==1;
	_civSpawnDistance = 250;
	_maxCivSpawn = 4;
	_factionCiv	= _module getVariable ["factionCiv","CIV_F"];
	_factionCivCar = _module getVariable ["factionCivCar","CIV_F"];
	_civRelations = _module getVariable ["civRelations",0.5];
	_civRelationsIgnore = missionNamespace setVariable ["MCC_civRelationsIgnore",((_module getVariable ["civRelationsIgnore",0])==1)];
	publicVariable "MCC_civRelationsIgnore";

	//Start ambient civilians
	[[_isCiv,_isCar,_isParkedCar,_isLocked,_civSpawnDistance,_maxCivSpawn,_factionCiv,_factionCivCar,_civRelations],"MCC_fnc_ambientInit",false,false] spawn BIS_fnc_MP;
};

//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

_pos = getpos _module;

_factionArray = [];
{
	_factionArray pushBack (_x select 0);
} forEach U_FACTIONS;

 _resualt = ["Ambient Civilians - runs on the server per player (CPU demanding)",[
 						["Ambient Civilians",true],
 						["Ambient Driving Cars",true],
 						["Ambient Parked Cars",true],
 						["Parked cars will always be locked ",false],
 						["Spawn distance around the players",500],
 						["max units spawned around the player",8],
 						["Faction",_factionArray],
 						["Car's Faction",_factionArray],
 						["Civilians Reaction to players",["bad (IED & Suicide Bombers)","average","above average","good"]],
 						["Civilians Always Friendly ",false]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

_resualt set [6,(U_FACTIONS select (_resualt select 6)) select 2];
_resualt set [7,(U_FACTIONS select (_resualt select 7)) select 2];
_resualt set [8,[0.2,0.5,0.7,0.95] select (_resualt select 8)];

missionNamespace setVariable ["MCC_civRelationsIgnore",(_resualt select 9)];
publicVariable "MCC_civRelationsIgnore";

//Start ambient civilians
[_resualt,"MCC_fnc_ambientInit",false,false] spawn BIS_fnc_MP;
deleteVehicle _module;