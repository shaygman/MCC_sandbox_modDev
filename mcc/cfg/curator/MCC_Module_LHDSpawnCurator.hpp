class MCC_Module_LHDSpawnCurator : MCC_Module_Base
{
	scope = 2;
	isGlobal = 1;
	scopeCurator = 2;
	category = "MCC_Carrier";
	displayName = "Spawn Ship";
	function = "MCC_fnc_curatorLHDSpawn";
	icon = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\boat_ca.paa";
	portrait = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\boat_ca.paa";
	picture = "a3\ui_f\data\IGUI\Cfg\simpleTasks\types\boat_ca.paa";


	class Attributes : AttributesBase
	{
		class side : Combo
		{
			displayName = "Side";
			description = "Which side the carrier belong to";
			typeName = "NUMBER";
			property = "side";

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

		class hq : Checkbox
		{
			displayName = "Respawn Position";
			description = "The carrier will act as a respawn position";
			typeName = "BOOL";
			property = "hq";
		};

		class store : Checkbox
		{
			displayName = "Vehicles Purchasing";
			description = "Enable player's purchasing vehicles from main deck";
			typeName = "BOOL";
			property = "store";
		};

		class rearm : Checkbox
		{
			displayName = "Rearm and Refuel";
			description = "Enable rearming, refueling and reparing vehicles from main deck";
			typeName = "BOOL";
			property = "rearm";
		};

		class lhdType : Combo
		{
			displayName = "Ship type";
			description = "LHD Requires CUP addon";
			typeName = "NUMBER";
			property = "lhdType";

			class values
			{
				class Independent
				{
					name = "Destroyer";
					value = 0;
					default = 1;
				};

				class carrier
				{
					name = "Aircraft Carrier";
					value = 1;
				};

				class submarine
				{
					name = "Submarine";
					value = 2;
				};

				class lhd
				{
					name = "CUP LHD";
					value = 3;
				};
			};
		};

		class displayName : Edit
		{
			displayName = "Ship Name";
			description = "Display Name";
			typeName = "STRING";
			property = "displayName";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Spawn static ship that will act as a base";
		sync[] = {"AnyVehicle"};

		class AnyVehicle
		{
			description = "Any vehicle. No persons or static objects.";
			displayName = "Any vehicle";
			icon = "iconCar";
			side = 4;
			position = 1;
			direction = 1;
			optional = 0;
			duplicate = 1;
		};
	};
};
