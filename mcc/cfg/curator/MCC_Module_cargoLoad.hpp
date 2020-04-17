class MCC_Module_cargoLoad : MCC_Module_Base
{
	scope = 2;
	isGlobal = 1;
	scopeCurator = 2;
	category = "MCC_Vehicles";
	displayName = "Load to Cargo";
	function = "MCC_fnc_cargoLoadModule";
	portrait = "a3\ui_f\data\IGUI\Cfg\Actions\loadVehicle_ca.paa";
	icon = "a3\ui_f\data\IGUI\Cfg\Actions\loadVehicle_ca.paa";
	picture = "a3\ui_f\data\IGUI\Cfg\Actions\loadVehicle_ca.paa";

	class Attributes : AttributesBase
	{
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] = {"Load all objects to the vehicle cargo using MCC or ACE logistic system.",
						"Sync module with a vehicle or a container and one unlock game logic.",
						"Synce the unlock game logic the selected objects"};
		sync[] = {"Anything","MiscUnlock_F"};

		class Anything
		{
			description = "Object";
			displayName = "Object";
			side = 4;
			position = 1;
			direction = 1;
			optional = 0;
			duplicate = 1;
		};

		class MiscUnlock_F
		{
			description = "Unlock Logic";
			displayName = "Unlock Logic";
			duplicate = 1;
			optional = 1;
			sync[] = {"TriggerUnlock"};
		};
	};
};