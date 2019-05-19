class MCC_Module_captureZone : Module_F
{
	scope = 2;
	isGlobal = 0;
	category = "MCC_PvP";
	displayName = "Capture Point";
	function = "MCC_fnc_moduleCapturePoint";

	portrait = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\defend_ca.paa";
	icon = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\defend_ca.paa";
	picture = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\defend_ca.paa";


	class Attributes: AttributesBase
	{
		class type : Combo
		{
			displayName = "Type";
			typeName = "NUMBER";
			property = "type";

			class values
			{
				class Ammo
				{
					name = "Ammo";
					value = 0;
					default = 1;
				};
				class Supply
				{
					name = "Supply";
					value = 1;
				};
				class Fuel
				{
					name = "Fuel";
					value = 2;
				};
				class Tickets
				{
					name = "Tickets";
					value = 3;
				};
			};
		};

		class ScoreReward : Edit
		{
			displayName = "Score Reward";
			typeName = "NUMBER";
			defaultValue = 50;
			property = "ScoreReward";
		};

		class flag : Checkbox
		{
			displayName = "Flag";
			typeName = "BOOL";
			property = "faction1";
		};

		class respawn : Checkbox
		{
			displayName = "Respawn";
			description = "Owner side can respawn on sector";
			typeName = "BOOL";
			property = "respawn";
		};

		class enableHUD  : Checkbox
		{
			displayName = "HUD";
			typeName = "BOOL";
			property = "enableHUD";
		};

		class sectorName : Edit
		{
			displayName = "Designation";
			typeName = "STRING";
			property = "sectorName";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Create a capture zone that yield resources over time, sync the module with a trigger to set the are of capturing and a flagpole (optional)";
		position = 1;
		direction = 1;
		optional = 0;
		sync[] = {"LocationArea_F","MiscUnlock_F","FlagPole_F"};

		class LocationArea_F
		{
			description = "";
			duplicate = 1;
			sync[] = {"TriggerArea"};
		};

		class TriggerArea
		{
			description[] = {
				"Sync at least one trigger",
				"With the area - will act as the capture zone"
			};
			area = 1;
			position = 1;
			direction = 1;
			optional = 0;
			duplicate = 0;
			vehicle = "EmptyDetector";
		};

		class MiscUnlock_F
		{
			description = "";
			duplicate = 1;
			optional = 1;
			sync[] = {"TriggerUnlock"};
		};

		class TriggerUnlock
		{
			description = "This trigger have to be activated to enable the capture point.";
			duplicate = 1;
			optional = 1;
			vehicle = "EmptyDetector";
		};

		class FlagPole_F
		{
			description[] = {
				"change the flag texture if it inside the trigger",
				""
			};
			position = 1;
			direction = 1;
			optional = 0;
			duplicate = 0;
			vehicle = "FlagPole_F";
		};
	};
};