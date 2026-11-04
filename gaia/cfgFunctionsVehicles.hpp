// GAIA vehicle behaviour: rides, dismount at objective (leader included), re-mount after contact,
// stuck / wrong-way detection, and safe position helpers.
class GAIA_vehicles
{
	tag = "GAIA";

	class vehicles
	{
		#ifdef MCCMODE
		file = "\mcc_sandbox_mod\gaia\functions\vehicles";
		#else
		file = "gaia\functions\vehicles";
		#endif

		class isValidPos {};
		class safePos {};
		class groupVehicle {};
		class groupObjective {};
		class findRide {};
		class dismount {};
		class remount {};
		class vehicleTick {};
	};
};
