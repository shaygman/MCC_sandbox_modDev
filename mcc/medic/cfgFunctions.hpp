class medic
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\medic\fnc";
	#else
	file = "mcc\medic\fnc";
	#endif

	class initMedic		{description = "Init Medic System";};
	class handleDamage	{description = "Handle damage on players and AI";};
	class unconscious	{description = "Handle unconscious behavior";};
	class medicEffects	{description = "Handle clients medic effects";};
	class medicProgressBar	{description = "Handle medic progress";};
	class medicUseItem	{description = "Handle medic uses item";};
	class medicDragCarry {description = "Handle drag and carry units";};
	class loadWounded 	{description = "Unload wounded from a vehicle";};
	class medicArea		{description = "create a building as a medic area";};
	class setUnconscious {description = "Set AI unit unconscious from 3den or Curator";};
	class AIHeal {description = "Handles AI heal - for internal use, move AI to another unit and heal it";};
	class initMedicXEH {};
	class wakeUp {};
};