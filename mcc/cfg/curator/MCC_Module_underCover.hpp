class MCC_Module_underCoverCurator : MCC_Module_Base
{
	scopeCurator = 2;
	scope = 2;
	isGlobal = 1;
	category = "MCC_AI";
	displayName = "Undercover Agents";
	icon = "a3\ui_f\data\IGUI\Cfg\Actions\talk_ca.paa";
	picture = "\mcc_sandbox_mod\data\mcc_sf.paa";
	portrait = "a3\ui_f\data\IGUI\Cfg\Actions\talk_ca.paa";
	function = "MCC_fnc_curatorunderCover";
	author = "shay_gman";

	class Attributes: AttributesBase
	{
		class removeGear : Combo
		{
			displayName = "Remove Weapons:";
			description = "Remove all weapons on game start";
			typeName = "NUMBER";
			property = "removeGear";

			class values
			{
				class yes
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class no
				{
					name = "No";
					value = 0;
				};
			};
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Sync to any player role to play as an Undercover agent. Undercover agents can move freely in near enemy units as long as they keep their gun concealed and are not acting suspicious";
		sync[] = {"BLUFORunit"};

		class BLUFORunit
		{
			description[] = {
				"Sync with any player's role"
			};
			displayName = "Undercover Agent";
			icon = "iconMan";
			optional = 1;
			duplicate = 1;
			synced[] = {"AnyBrain"};
		};
	};
};