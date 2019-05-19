class vehicles
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\vehicles\fnc";
	#else
	file = "mcc\vehicles\fnc";
	#endif

	//class BISGarage {description = "Replace the BI Garage function for zeus all credits go to Zeus";};
	class pylonsChange {description = "Change pylons loadouts in available planes";};
	class spawnVehicle {description = "Replace BIS_fnc_spawnVehicle";};
	class vehicleRandomAnimation {description = "spawn random animations for vehicles";};
	class addComponentsACECondition {description = "check if components are available for this vehicle";};
	class addComponentsACE {description = "Add components childrens to ACE";};
	class vehicleTireChange {description = "Remove or install vehicle tire or truck";};
};