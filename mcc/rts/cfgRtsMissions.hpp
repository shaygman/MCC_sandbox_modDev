//Usless now maybe someday it will hold some value

class MCC_rts_missionsSupplyRun
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\data\missions\missionSupply.paa";
	#else
	picture = "mcc\rts\data\missions\missionSupply.paa";
	#endif

	displayName = "Supply Run";
	descriptionShort = "Deliver supply to the locals winning hearts and minds";
	condition =  "(missionNamespace getVariable [format ['MCC_rts_missionsSupplyRun_%1', playerSide],false])";
	requiredBuildings[] = {};
	needelectricity = 0;
	variables[] = {"supplyrun"};
	actionFNC = "MCC_fnc_RtsInitmission";
	dontShowDisabled = 1;
	resources[] = {{"time",10}};
};


class MCC_rts_missionPatrol
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\data\missions\missionPatrol.paa";
	#else
	picture = "mcc\rts\data\missions\missionPatrol.paa";
	#endif

	displayName = "Comabt Patrol";
	descriptionShort = "Patrol the certain area - elimate hostiles and clear IEDs";
	condition = "(missionNamespace getVariable [format ['MCC_rts_missionPatrol_%1', playerSide],false])";
	requiredBuildings[] = {};
	needelectricity = 0;
	variables[] = {"patrol"};
	actionFNC = "MCC_fnc_RtsInitmission";
	dontShowDisabled = 1;
	resources[] = {{"time",10}};
};

class MCC_rts_missionsIntel
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\data\missions\missionIntel.paa";
	#else
	picture = "mcc\rts\data\missions\missionIntel.paa";
	#endif

	displayName = "Gather Intel";
	descriptionShort = "Gather importent intel";
	condition = "(missionNamespace getVariable [format ['MCC_rts_missionsIntel_%1', playerSide],false])";
	requiredBuildings[] = {};
	needelectricity = 0;
	variables[] = {"intel"};
	actionFNC = "MCC_fnc_RtsInitmission";
	dontShowDisabled = 1;
	resources[] = {{"time",10}};
};