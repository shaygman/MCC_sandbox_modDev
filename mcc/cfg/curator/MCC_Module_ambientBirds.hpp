class MCC_Module_ambientBirdsCurator : MCC_Module_Base
{
	scope = 2;
	isGlobal = 1;
	scopeCurator = 2;
	category = "MCC_Environment";
	displayName = "$STR_CURATOR_Module_AI_ambientBirdsCurator_displayName";
	function = "MCC_fnc_ambientBirdsSpawnInit";
	portrait = "a3\ui_f\data\Map\VehicleIcons\iconAnimal_ca.paa";
	icon = "a3\ui_f\data\Map\VehicleIcons\iconAnimal_ca.paa";
	picture = "a3\ui_f\data\Map\VehicleIcons\iconAnimal_ca.paa";

	class Attributes: AttributesBase
	{
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "$STR_CURATOR_Module_ambientBirdsCurator_description";
	};
};