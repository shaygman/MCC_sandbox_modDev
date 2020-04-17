class MCC_Module_GAIARespawnsCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC_AI";
	displayName = "$STR_Module__groupRespawns_displayName";
	function = "MCC_fnc_curatorGAIARespawn";
	scope = 2;
	isGlobal = 1;

	class Attributes : AttributesBase
	{
		class Respawns : Edit
		{
			displayName = "$STR_Module__groupRespawns_Respawns_displayName";
			description = "$STR_Module__groupRespawns_Respawns_description";
			typeName = "NUMBER";
			defaultValue = 5;
			property = "Respawns";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "$STR_Module__groupRespawns_ModuleDescription_description";
		sync[] = {"Anything"};

		class Anything
		{
			description = "Any group/unit.";
			displayName = "Any group/unit";
			side = 4;
			position = 1;
			direction = 1;
			optional = 0;
			duplicate = 1;
		};
	};
};