// Limited logistics: server-authoritative side resources and finite supply points (MCC_logisticsMode).
class supply
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\supply";
	#else
	file = "mcc\fnc\supply";
	#endif
	class resChange {description = "Server-authoritative change of side resources MCC_res<SIDE>";};
	class supplyTypes {description = "What a class resupplies [ammo,repair,fuel] (cached)";};
	class supplyVehicleCost {description = "Resource price of a full rearm/repair/refuel of a vehicle";};
	class supplySnapshot {description = "Vehicle supply state [ammoFrac, health, fuel]";};
	class supplyNearBase {description = "Side whose base (MCC_START_<side> or RTS building) an object is at";};
	class supplyRegister {description = "Server: register a finite-stock supply point";};
	class supplyTick {description = "Server: track and refill one supply point";};
	class supplyLoop {description = "Server: limited logistics loop";};
	class supplyFuelCoef {description = "All machines: apply fuel consumption multiplier to local vehicles";};
	class supplyRemaining {description = "Remaining fraction 0..1 of a supply object's stock";};
	class supplyInit {postInit = 1; description = "Start limited logistics loops";};
};

class eden
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\eden";
	#else
	file = "mcc\fnc\eden";
	#endif
	class applyEdenAttributes {postInit = 1; description = "Server: apply MCC Eden scenario attributes over CBA settings";};
};
