class MCC_Module_settings : Module_F
{
	category = "MCC";
	author = "shay_gman";
	displayName = "(Settings) General";
	icon = "\mcc_sandbox_mod\data\mccModule.paa";
	picture = "\mcc_sandbox_mod\data\mccModule.paa";
	vehicleClass = "Modules";
	function = "MCC_fnc_missionSettings";
	scope = 2;
	isGlobal = 1;

	class Attributes : AttributesBase
	{
		class t2t : Combo
		{
			displayName = "Teleport 2 Team";
			description = "When players willbe able to teleport to the squad leader via the Squad Dialog or key bind";
			typeName = "NUMBER";
			property = "t2t";
			class values
			{
				class disabled
				{
					name = "Disabled";
					value = 0;
				};
				class jip
				{
					name = "JIP Only";
					value = 1;
					default = 1;
				};
				class respawn
				{
					name = "After Respawn";
					value = 2;
				};
				class always
				{
					name = "Always";
					value = 3;
				};
			};
		};
		class saveGear : Combo
		{
			displayName = "Save Gear";
			description = "Respawn with the same gear the player had when they player died";
			typeName = "NUMBER";
			property = "saveGear";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};
		class messages : Combo
		{
			displayName = "MCC Messages";
			description = "Show MCC messages";
			typeName = "NUMBER";
			property = "messages";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class sync : Combo
		{
			displayName = "Sync JIP";
			description = "Sync join in progress players with the server";
			typeName = "NUMBER";
			property = "sync";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class artilleryComputer : Combo
		{
			displayName = "Artilery Computer";
			description = "Enable/Disable the default BI artillery computer";
			typeName = "NUMBER";
			property = "artilleryComputer";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class timeAccel : Combo
		{
			displayName = "Time Acceleration";
			description = "Shorten day/night cycle";
			typeName = "NUMBER";
			property = "timeAccel";

			class values
			{
				class disabled
				{
					name = "Disabled";
					value = 0;
					default = 1;
				};
				class tx5
				{
					name = "x5";
					value = 5;
				};
				class tx10
				{
					name = "x10";
					value = 2;
				};
				class tx15
				{
					name = "x15";
					value = 15;
				};
				class tx20
				{
					name = "x20";
					value = 20;
				};
			};
		};

		class deleteBody : Combo
		{
			displayName = "Delete Players' Bodies";
			description = "Delete dead player body after respawn";
			typeName = "NUMBER";
			property = "deleteBody";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class respawnMenu : Combo
		{
			displayName = "Respawn Menu";
			description = "Allow start location dialog on JIP or after respawn";
			typeName = "NUMBER";
			property = "respawnMenu";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class respawnOnGroupLeader : Combo
		{
			displayName = "Respawn On Leader";
			description = "Allow Respawn On Group Leader If Respawn Menu Is Enabled";
			typeName = "NUMBER";
			property = "respawnOnGroupLeader";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class respawnCinematic : Combo
		{
			displayName = "Respawn Cinematic";
			description = "Show cinematic when a player spawn";
			typeName = "NUMBER";
			property = "respawnCinematic";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class sqlPDA : Combo
		{
			displayName = "Squad Leader PDA";
			description = "Allow Squad Leader PDA";
			typeName = "NUMBER";
			property = "sqlPDA";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class commanderConsole : Combo
		{
			displayName = "Commander Console";
			description = "Allow Commander Console";
			typeName = "NUMBER";
			property = "commanderConsole";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class commanderConsoleShowGPS : Combo
		{
			displayName = "Commander Console: Show groups with GPS only";
			description = "Show groups with GPS only";
			typeName = "NUMBER";
			property = "commanderConsoleShowGPS";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class commanderConsoleWP : Combo
		{
			displayName = "Commander Console: Show friendly WP";
			description = "Show friendly WP";
			typeName = "NUMBER";
			property = "commanderConsoleWP";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class commanderConsoleAI : Combo
		{
			displayName = "Commander Console: Can command AI";
			description = "Can command AI";
			typeName = "NUMBER";
			property = "commanderConsoleAI";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class squadDialog : Combo
		{
			displayName = "Squad Dialog";
			description = "Players can open the squad dialog and form/change squads - requires key binding";
			typeName = "NUMBER";
			property = "squadDialog";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class logistics : Combo
		{
			displayName = "Logistics";
			description = "Enables MCC logistics";
			typeName = "NUMBER";
			property = "logistics";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class allowRTS : Combo
		{
			displayName = "Real Time Strategy";
			description = "Enable RTS interface in the commander console";
			typeName = "NUMBER";
			property = "allowRTS";

			class values
			{
				class Enabled
				{
					name = "Yes";
					value = 1;
					default = 1;
				};
				class Disabled
				{
					name = "No";
					value = 0;
				};
			};
		};

		class defaultSupplyDropsEnabled : Checkbox
		{
			displayName = "Purchasable Supply Drops";
			description = "The commander can buy supply drops from the commanding menu using resources as defined in CfgMCCRtsAirdrops";
			typeName = "BOOL";
			property = "defaultSupplyDropsEnabled";
		};

		class defaultCASEnabled : Checkbox
		{
			displayName = "Purchasable CAS";
			description = "The commander can buy default close air support from the commanding menu using resources as defined in CfgMCCRtsAirdrops";
			typeName = "BOOL";
			property = "defaultCASEnabled";
		};

		class CuratorEditDisabled : Checkbox
		{
			displayName = "Disable Zeus Edit";
			description = "Disable MCC default edit screen in Zeus";
			typeName = "BOOL";
			property = "CuratorEditDisabled";
		};

		class armedCiviliansWeapons : Edit
		{
			displayName = "Armed Civilians Weapons";
			description = "Define the default armed civilians weapons - must be an array of strings";
			typeName = "STRING";
			defaultValue = "[""hgun_P07_F"",""hgun_Rook40_F"",""hgun_ACPC2_F"",""hgun_Pistol_heavy_01_F"",""hgun_Pistol_heavy_02_F"",""SMG_01_F"",""SMG_02_F"",""hgun_PDW2000_F""]";
			property = "armedCiviliansWeapons";
		};
	};

	class ModuleDescription: ModuleDescription
	{
		description = "Define MCC settings";
	};
};