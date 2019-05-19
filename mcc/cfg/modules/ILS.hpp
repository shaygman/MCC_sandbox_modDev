class mcc_sandbox_moduleILS : Module_F
{
	category = "MCC_Environment";
	author = "shay_gman";
	displayName = "$STR_Module__moduleILS_displayName";
	icon = "\mcc_sandbox_mod\data\mcc_ils.paa";
	picture = "\mcc_sandbox_mod\data\mcc_ils.paa";
	vehicleClass = "Modules";
	function = "";
	scope = 2;
	isGlobal = 1;

	class Attributes: AttributesBase
	{
		class MCC_runwayName : Edit
		{
			control = "Edit";
			displayName = "$STR_Module__moduleILS_runwayName_displayName";
			description = "$STR_Module__moduleILS_runwayName_description";
			defaultValue = """Runway""";
			property = "MCC_runwayName";
		};

		class MCC_runwayDis : Combo
		{
			displayName = "$STR_Module__moduleILS_runwayDis_displayName";
			description = "$STR_Module__moduleILS_runwayDis_description";
			typeName = "NUMBER";
			property = "MCC_runwayDis";
			class values
			{
				class L100
				{
					name = "100 meters";
					value = 100;
				};
				class L200
				{
					name = "200 meters";
					value = 200;
					default = 1;
				};
				class L300
				{
					name = "300 meters";
					value = 300;
				};
			};
		};

		class MCC_runwaySide : Combo
		{
			displayName = "$STR_Module__moduleILS_runwaySide_displayName";
			description = "$STR_Module__moduleILS_runwaySide_description";
			typeName = "NUMBER";
			property = "MCC_runwaySide";
			class values
			{
				class All
				{
					name = "$STR_GENERAL_ALL";
					value = -1;
					default = 1;
				};
				class BLUFOR
				{
					name = "$STR_WEST";
					value = 1;
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
				class Civilian
				{
					name = "$STR_CIVILIAN";
					value = 3;
				};
			};
		};

		class MCC_runwayCircles : Checkbox
		{
			displayName = "$STR_Module__moduleILS_runwayCircles_displayName";
			description = "$STR_Module__moduleILS_runwayCircles_description";
			property = "MCC_runwayCircles";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "$STR_Module__moduleILS_runwayCircles_ModuleDescription";
		position = 1;
		direction = 1;
	};
};