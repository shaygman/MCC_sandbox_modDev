class MCC_Module_addValor : Module_F
{
	category = "MCC";
	displayName = "Add Credits/Valor Points";
	function = "MCC_fnc_curatorAddValor";
	scope = 2;
	isGlobal = 0;

	class Attributes : AttributesBase
	{
		class valor : Edit
		{
			displayName = "Credits";
			description = "How many credit to add";
			typeName = "NUMBER";
			property = "valor";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Sync it with one player unit or more to add valor/credits to this unit on mission init";
		sync[] = {"Anything"};

		class Anything
		{
			description = "Player unit";
			displayName = "Player unit";
			side = 4;
			position = 1;
			direction = 1;
			optional = 0;
			duplicate = 1;
		};
	};
};