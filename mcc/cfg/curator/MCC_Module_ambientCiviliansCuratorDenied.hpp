class MCC_Module_ambientCiviliansCuratorDenied : MCC_Module_Base
{
	scope = 2;
	isGlobal = 1;
	scopeCurator = 2;
	category = "MCC_AI";
	displayName = "Ambient units(Restrict)";
	function = "MCC_fnc_ambientDenied";
	portrait = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\default_ca.paa";
	icon = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\default_ca.paa";
	picture = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\default_ca.paa";


	class Attributes: AttributesBase
	{
		class radius : Edit
		{
			displayName = "Radius";
			typeName = "NUMBER";
			defaultValue = 500;
			property = "radius";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Server side: deny ambient AI spawn in this area";
	};
};