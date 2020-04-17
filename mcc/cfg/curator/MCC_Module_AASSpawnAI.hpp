class MCC_Module_AASSpawnAI : MCC_Module_Base
{
	scope = 2;
	isGlobal = 1;
	scopeCurator = 2;
	category = "MCC_PvP";
	displayName = "$STR_Module__AASSpawnAI_displayName";
	function = "MCC_fnc_aas_AIspawn";
	portrait = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa";
	icon = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa";
	picture = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa";

	class Attributes: AttributesBase
	{
		class faction1 : Edit
		{
			displayName = "$STR_Module__AASSpawnAI_faction1_displayName";
			description = "$STR_Module__AASSpawnAI_faction1_description";
			defaultValue = """BLU_F""";
			property = "faction1";
		};

		class enemySide : Combo
		{
			displayName = "$STR_Module__AASSpawnAI_enemySide_displayName";
			typeName = "NUMBER";
			property = "enemySide";

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

		class autoBalance : Checkbox
		{
			displayName = "$STR_Module__AASSpawnAI_autoBalance_description";
			description = "$STR_Module__AASSpawnAI_autoBalance_description";
			property = "autoBalance";
		};

		class minAI : Edit
		{
			displayName = "$STR_Module__AASSpawnAI_minAI_displayName";
			description = "$STR_Module__AASSpawnAI_minAI_description";
			typeName = "NUMBER";
			defaultValue = 10;
			property = "minAI";
		};

		class spawnAIDefensive : Checkbox
		{
			displayName = "$STR_Module__AASSpawnAI_spawnAIDefensive_displayName";
			description = "$STR_Module__AASSpawnAI_spawnAIDefensive_description";
			typeName = "BOOL";
			property = "spawnAIDefensive";
		};

		class searchRadius : Edit
		{
			displayName = "$STR_Module__AASSpawnAI_searchRadius_displayName";
			description = "$STR_Module__AASSpawnAI_searchRadius_description";
			typeName = "NUMBER";
			defaultValue = 300;
			property = "searchRadius";
		};

		class useRoles : Checkbox
		{
			displayName = "$STR_Module__AASSpawnAI_useRoles_displayName";
			description = "$STR_Module__AASSpawnAI_useRoles_description";
			typeName = "BOOL";
			property = "useRoles";
		};

		class spawnVehicles : Checkbox
		{
			displayName = "$STR_Module__AASSpawnAI_spawnVehicles_displayName";
			description = "$STR_Module__AASSpawnAI_spawnVehicles_description";
			typeName = "BOOL";
			property = "spawnVehicles";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "$STR_Module__AASSpawnAI_ModuleDescription_description";
		position = 1;
	};
};