class MCC_module_ambientFireCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC_Environment";
	displayName = "$STR_Module__ambientFire_displayName";
	function = "MCC_fnc_ambientFireInit";
	portrait = "a3\ui_f\data\Map\LocationTypes\vegetationBroadleaf_CA.paa";
	scope = 2;
	isGlobal = 0;

	class Attributes: AttributesBase
	{
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "$STR_Module__ambientFire_description";
	};
};