class MCC_Module_ambientCiviliansCurator : MCC_Module_Base
{
	scope = 2;
	isGlobal = 1;
	scopeCurator = 2;
	category = "MCC_AI";
	displayName = "$STR_CURATOR_Module_ambientCiviliansCurator_displayName";
	function = "MCC_fnc_curatorAmbientCivilians";
	portrait = "a3\ui_f\data\Map\VehicleIcons\iconManVirtual_ca.paa";
	icon = "a3\ui_f\data\Map\VehicleIcons\iconManVirtual_ca.paa";
	picture = "a3\ui_f\data\Map\VehicleIcons\iconManVirtual_ca.paa";

	class Attributes: AttributesBase
	{
		class isCiv : Combo
		{
			displayName = "$STR_CURATOR_Module_ambientCiviliansCurator_isCiv_displayName";
			description = "$STR_CURATOR_Module_ambientCiviliansCurator_isCiv_description";
			typeName = "NUMBER";
			property = "isCiv";

			class values
			{
				class Enabled
				{
					name = "$STR_GENERAL_ENABLE";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "$STR_GENERAL_DISABLE";
					value = 0;
				};
			};
		};

		class isCar : Combo
		{
			displayName = "$STR_CURATOR_Module_ambientCiviliansCurator_isCar_displayName";
			description = "$STR_CURATOR_Module_ambientCiviliansCurator_isCar_description";
			typeName = "NUMBER";
			property = "isCar";

			class values
			{
				class Enabled
				{
					name = "$STR_GENERAL_ENABLE";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "$STR_GENERAL_DISABLE";
					value = 0;
				};
			};
		};

		class isParkedCar : Combo
		{
			displayName = "$STR_CURATOR_Module_ambientCiviliansCurator_isParkedCar_displayName";
			description = "$STR_CURATOR_Module_ambientCiviliansCurator_isParkedCar_description";
			typeName = "NUMBER";
			property = "isParkedCar";

			class values
			{
				class Enabled
				{
					name = "$STR_GENERAL_ENABLE";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "$STR_GENERAL_DISABLE";
					value = 0;
				};
			};
		};

		class isLocked : Combo
		{
			displayName = "$STR_CURATOR_Module_ambientCiviliansCurator_isLocked_displayName";
			description = "$STR_CURATOR_Module_ambientCiviliansCurator_isLocked_description";
			typeName = "NUMBER";
			property = "isLocked";

			class values
			{
				class Enabled
				{
					name = "$STR_GENERAL_ENABLE";
					value = 1;
				};
				class Disabled
				{
					name = "$STR_GENERAL_DISABLE";
					value = 0;
					default = 1;
				};
			};
		};

		class factionCiv : Edit
		{
			displayName = "$STR_CURATOR_Module_ambientCiviliansCurator_factionCiv_displayName";
			typeName = "STRING";
			description = "$STR_CURATOR_Module_ambientCiviliansCurator_factionCiv_description";
			defaultValue = """CIV_F""";
			property = "factionCiv";
		};

		class factionCivCar : Edit
		{
			displayName = "$STR_CURATOR_Module_ambientCiviliansCurator_factionCivCar_displayName";
			typeName = "STRING";
			description = "$STR_CURATOR_Module_ambientCiviliansCurator_factionCiv_description";
			defaultValue = """CIV_F""";
			property = "factionCivCar";
		};

		class civRelations : Combo
		{
			displayName = "$STR_CURATOR_Module_ambientCiviliansCurator_civRelations_displayName";
			description = "$STR_CURATOR_Module_ambientCiviliansCurator_civRelations_displayName";
			typeName = "NUMBER";
			property = "civRelations";

			class values
			{
				class bad
				{
					name = "$STR_CURATOR_Module_ambientCiviliansCurator_civRelations_bad";
					value = 0.2;
					default = 1;
				};
				class average
				{
					name = "$STR_CURATOR_Module_ambientCiviliansCurator_civRelations_average";
					value = 0.5;
				};
				class aboveAverage
				{
					name = "$STR_CURATOR_Module_ambientCiviliansCurator_civRelations_aboveAverage";
					value = 0.6;
				};
				class good
				{
					name = "$STR_CURATOR_Module_ambientCiviliansCurator_civRelations_good";
					value = 0.8;
				};
				class verygood
				{
					name = "$STR_CURATOR_Module_ambientCiviliansCurator_civRelations_Very Good";
					value = 0.9;
				};
			};
		};

		class civRelationsIgnore : Combo
		{
			displayName = "Civs Always Friendly";
			description = "Civilians will always be friendly to players";
			typeName = "NUMBER";
			property = "isParkedCar";

			class values
			{
				class Enabled
				{
					name = "$STR_GENERAL_ENABLE";
					value = 1;
				};
				class Disabled
				{
					name = "$STR_GENERAL_DISABLE";
					value = 0;
					default = 1;
				};
			};
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Server side: spawn AI around players when next to towns and despawn them when no player around";
		position = 0;
		direction = 0;
	};
};