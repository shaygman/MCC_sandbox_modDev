class MCC_Module_AAS : MCC_Module_Base
{
	scope = 2;
	isGlobal = 0;
	scopeCurator = 1;
	category = "MCC_PvP";
	displayName = "$STR_Module__AAS_displayName";
	function = "MCC_fnc_aasInit";
	portrait = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\attack_ca.paa";
	icon = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\attack_ca.paa";
	picture = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\attack_ca.paa";

	class Attributes: AttributesBase
	{
		class side1 : Combo
		{
			displayName = "$STR_Module__AAS_side1_displayName";
			typeName = "NUMBER";
			property = "side1";
			defaultValue = "1";
			class values
			{
				class BLUFOR
				{
					name = "$STR_WEST";
					value = 1;
					default = 1;
				};
				class OPFOR
				{
					name = "$STR_EAST";
					value = 0;
				};
				class Independent
				{
					name = "$STR_GUERRILA";
					value = 2;
				};
			};
		};

		class side2 : Combo
		{
			displayName = "$STR_Module__AAS_side2_displayName";
			typeName = "NUMBER";
			property = "side2";
			class values
			{
				class BLUFOR
				{
					name = "$STR_WEST";
					value = 1;
				};
				class OPFOR
				{
					name = "$STR_EAST";
					value = 0;
					default = 1;
				};
				class Independent
				{
					name = "$STR_GUERRILA";
					value = 2;
				};
			};
		};

		class bleedTickets : Edit
		{
			displayName = "$STR_Module__AAS_bleedTickets_displayName";
			description = "$STR_Module__AAS_bleedTickets_description";
			typeName = "NUMBER";
			defaultValue = 2;
			property = "bleedTickets";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "$STR_Module__AAS_ModuleDescription_description";
		optional = 0;
		sync[] = {"MCC_Module_captureZone"};

		class MCC_Module_captureZone
		{
			description[] = {
				"$STR_Module__AAS_ModuleDescription_description2"
			};
			position = 0;
			direction = 0;
			optional = 0;
			duplicate = 1;
			synced[] = {"AnyVehicle"};
		};
	};
};