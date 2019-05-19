class MCC_Module_setResourcesCurator : MCC_Module_Base
{
	scope = 2;
	isGlobal = 1;
	scopeCurator = 2;
	category = "MCC_RTS";
	displayName = "Set Resources";
	icon = "\mcc_sandbox_mod\mcc\rts\data\valorIcon.paa";
	picture = "\mcc_sandbox_mod\mcc\rts\data\valorIcon.paa";
	portrait = "\mcc_sandbox_mod\mcc\rts\data\valorIcon.paa";
	function = "MCC_fnc_setResources";

	class Arguments
	{
		class side
		{
			displayName = "Side";
			typeName = "NUMBER";
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

		class repair
		{
			displayName = "Materials";
			typeName = "NUMBER";
			defaultValue = 500;
		};

		class ammo
		{
			displayName = "Ammo";
			typeName = "NUMBER";
			defaultValue = 500;
		};

		class fuel
		{
			displayName = "Fuel";
			typeName = "NUMBER";
			defaultValue = 500;
		};

		class food
		{
			displayName = "Food";
			typeName = "NUMBER";
			defaultValue = 100;
		};

		class meds
		{
			displayName = "Meds";
			typeName = "NUMBER";
			defaultValue = 100;
		};
	};
};