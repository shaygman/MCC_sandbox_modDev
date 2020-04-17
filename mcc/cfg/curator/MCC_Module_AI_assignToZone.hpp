class MCC_Module_AI_assignToZone : MCC_Module_Base
{
	scope = 2;
	isGlobal = 1;
	scopeCurator = 2;
	category = "MCC_AI";
	displayName = "$STR_CURATOR_Module_AI_assignToZoneText";
	function = "MCC_fnc_AI_assignToZone";
	portrait = "a3\ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa";
	icon = "a3\ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa";
	picture = "a3\ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa";

	class Attributes : AttributesBase
	{
		class behavior : Combo
		{
			displayName = "Behavior";
			typeName = "NUMBER";
			property = "behavior";

			class values
			{
				class aggressive
				{
					name = "aggressive";
					value = 0;
					default = 1;
				};
				class defensive
				{
					name = "defensive";
					value = 1;
				};
				class fortify
				{
					name = "fortify";
					value = 2;
				};
			};
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] = {"$STR_CURATOR_Module_AI_assignToZoneDescription1",
						"$STR_CURATOR_Module_AI_assignToZoneDescription2"};
		sync[] = {"mcc_Module_createZones"};

		class mcc_Module_createZones
		{
			description = "$STR_CURATOR_Module_AI_assignToZoneDescription3";
			displayName = "$STR_CURATOR_Module_AI_assignToZoneDescription3";
			side = 4;
			position = 1;
			direction = 1;
			optional = 0;
			duplicate = 1;
		};
	};
};