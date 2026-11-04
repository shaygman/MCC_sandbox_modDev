// Network security helpers and small named functions that replaced code sent over the network.
class security
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\security";
	#else
	file = "mcc\fnc\security";
	#endif

	class networkSecurity {description = "Returns the mission's MCC network security level (0 Normal, 1 Strict)";};
	class isAuthorizedOwner {description = "Server only: may this owner id use MCC";};
	class remoteAllowed {description = "Guard for remote-executed functions in Strict mode";};
	class setAuthorizedOwners {description = "Clients: store authorized owners sent by the server";};
	class securityInit {postInit = 1; description = "Server: publish owners allowed to use MCC";};
};

class remote
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\remote";
	#else
	file = "mcc\fnc\remote";
	#endif

	class rxAddCatapultAction {};
	class rxApplyFatigue {};
	class rxAddIntel {};
	class rxAddShipControlAction {};
	class rxCuratorAddEditable {};
	class rxEjectUnconscious {};
	class rxHaltStop {};
	class rxPlaceSatchel {};
	class rxSideRating {};
	class rxUndoLastSpawn {};
};
