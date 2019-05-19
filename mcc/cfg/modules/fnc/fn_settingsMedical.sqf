//===================================================MCC_fnc_settingsMedical===============================================================================================
// module
// Medical system settings
//===========================================================================================================================================================================
private ["_module","_pos"];

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

//if ACE enabled exit
if (missionNamespace getVariable ["MCC_isACE",false]) exitWith {};

//did we get here from the 2d editor?
if (typeName (_module getVariable ["medicComplex",true]) == typeName 0) exitWith {

	//Enable system
	MCC_medicSystemEnabled = true;

	//Complex
	MCC_medicComplex = ((_module getvariable ["medicComplex",1])==1);

	//bleeding
	MCC_medicBleedingEnabled = ((_module getvariable ["medicBleedingEnabled",1])==1);

	//BleedingTime
	MCC_medicBleedingTime = (_module getvariable ["BleedingTime",200]);

	//DamageCoef
	MCC_medicDamageCoef = (_module getvariable ["DamageCoef",1]);

	//XPmesseges
	MCC_medicXPmesseges = ((_module getvariable ["medicXPmesseges",1])==1);

	//PunishTK
	MCC_medicPunishTK = ((_module getvariable ["medicPunishTK",1])==1);

	//Medic HuD
	MCC_medicShowWounded = ((_module getvariable ["MCC_medicShowWounded",1])==1);

	//Only Medic Heals
	MCC_medicOnlyMedicHeals = ((_module getvariable ["onlyMedicsCanHeal",1])==1);
};

//Not curator exit
if !(local _module) exitWith {};

_pos = getpos _module;

_resualt = ["Medical System",[
 						["Complex System",(missionNamespace getVariable ["MCC_medicComplex",true])],
 						["Bleeding",(missionNamespace getVariable ["MCC_medicBleedingEnabled",true])],
 						["Bleeding Time (Sec)",300],
 						["Kill Messages",(missionNamespace getVariable ["MCC_medicXPmesseges",true])],
 						["Punish Team Kill",(missionNamespace getVariable ["MCC_medicPunishTK",false])],
 						["Medic HUD",(missionNamespace getVariable ["MCC_medicShowWounded",true])],
 						["Only Medic Can Heal",(missionNamespace getVariable ["MCC_medicOnlyMedicHeals",true])]
 					  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

missionNamespace setVariable ["MCC_medicSystemEnabled",true];
publicvariable "MCC_medicSystemEnabled";

{
	missionNamespace setVariable [_x,_resualt select _foreachindex];
	publicvariable _x;
} forEach ["MCC_medicComplex",
		   "MCC_medicBleedingEnabled",
		   "MCC_medicBleedingTime",
		   "MCC_medicXPmesseges",
		   "MCC_medicPunishTK",
		   "MCC_medicShowWounded",
		   "MCC_medicOnlyMedicHeals"
		  ];

deleteVehicle _module;