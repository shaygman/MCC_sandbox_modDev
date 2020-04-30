class mcc_Module_createZones : Module_F
{
	category = "MCC_AI";
	displayName = "$STR_UI_CREATEZONE";
	function = "MCC_fnc_createZonesInit";
	scopeCurator = 2;
	scope = 2;
	isGlobal = 0;

	class Attributes: AttributesBase
	{
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Sync with a trigger to create MCC zone";

		class TriggerArea
		{
			description[] = {
				"Sync with one trigger",
				"With the module to create zone"
			};
			area = 1;
			position = 1;
			direction = 1;
			optional = 0;
			duplicate = 0;
			vehicle = "EmptyDetector";
		};
	};
};