class ai
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\ai\fnc";
	#else
	file = "mcc\ai\fnc";
	#endif

	class garrisonBehavior	{description = "Contorol units under garrison behavior.";};
	class paratroops		{description = "Contorol the paratroop reinforcement spawn.";};
	class reinforcement		{description = "Contorol the motorized reinforcement spawn.";};
	class setUnitPos		{description = "Sets units pos.";};
	class populateVehicle	{description = "Populate a not empty vehicle with antoher group contains units acording to its faction and cargo space.";};
	class disarmUnit		{description = "Disarm a unit and create a weapon holder";};
	class setUnitAnim		{description = "Sets units Animation - and return it to default after a while";};
	class stunBehav			{description = "Play unit stun behavior";};
	class canHaltAI			{description = "Can an AI unit be halted by a player";};
	class doHaltAI			{description = "Can an AI unit be halted by a player";};
	class enemyCAS			{description = "Can an AI unit be halted by a player";};
	class AI_assignToZone	{description = "Assign AI unit/group to a specific zone";};
};