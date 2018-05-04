class MCC_Module_medicSetState : Module_F
{
	category = "MCC";
	author = "shay_gman";
	displayName = "Set Unconscious";
	vehicleClass = "Modules";
	function = "MCC_fnc_setUnconscious";
	scope = 2;
	isGlobal = 0;

	class Attributes: AttributesBase
	{
		class enableBleeding : Checkbox
		{
			displayName = "Disable Bleeding";
			description = "Unit will not die from bleeding over time ";
			typeName = "BOOL";
			property = "enableBleeding";
		};

		class forceUnconscious : Checkbox
		{
			displayName = "Force Unconscious";
			description = "Unit will not wake up even after a medical treatment";
			typeName = "BOOL";
			property = "forceUnconscious";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Sync to any AI man unit to force unconscious state, need MCC medics system on";
		sync[] = {"BLUFORunit"};

		class BLUFORunit
		{
			description[] = {
				"Sync with any player's role"
			};
			displayName = "Unconscious unit";
			icon = "iconMan";
			optional = 1;
			duplicate = 1;
			synced[] = {"AnyBrain"};
		};
	};
};