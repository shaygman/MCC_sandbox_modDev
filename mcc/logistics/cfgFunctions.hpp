class logistics
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\logistics\fnc";
	#else
	file = "mcc\logistics\fnc";
	#endif

	class loadTruckUI		{description = "Open logistic truck UI";};
	class logTruckRefresh 	{description = "Refresh the logistics dialog";};
	class logTruckAdd		{description = "Add or remove crates from a log truck";};
	class logisticsCargoGetMass {description = "Calculate vehicle cargo mass";};
	class logisticsCargoUnload  {description = "Unload an item from the virtual cargo space of a vehicle";};
	class logisticsCargoInit {description = "Init the virtual logistics cargo dialog - internal use only";};
	class logisticsCargoLoad {description = "Load an object to vehicle";};
	class logisticsWithdrawBox {description = "withdraw a resource box from HQ and reduce the resources";};
	class logisticsBoxDeposit {description = "Deposit a resource box from HQ and add the resources";};
	class cargoLoadModule {description = "Load object from 3den or curator to MCC/ACE logistic system";};
};