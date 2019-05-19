class MCC_Module_settingsMissionWizard : Module_F
{
	category = "MCC";
	displayName = "(Settings) Mission Wizard";
	function = "MCC_fnc_settingsMissionWizard";
	scope = 2;
	isGlobal = 1;

	class Attributes : AttributesBase
	{
		class VariableName : Combo
		{
			displayName = "Objectives Variable";
			description = "Which variable will change";
			typeName = "NUMBER";
			property = "Variable";

			class values
			{
				class MCC_MWHVT
				{
					name = "HVT(man)";
					value = 0;
					default = 1;
				};
				class MCC_MWRadio
				{
					name = "Radio Tower(Land)";
					value = 1;
				};
				class MCC_MWFuelTanks
				{
					name = "Fuel Tanks(Land)";
					value = 2;
				};

				class MCC_MWTanks
				{
					name = "Armored Vehicles(Vehicle)";
					value = 3;
				};

				class MCC_MWAir
				{
					name = "Air Vehicles(Vehicle)";
					value = 4;
				};

				class MCC_MWcache
				{
					name = "Ammo cache (Box)";
					value = 5;
				};

				class MCC_MWradar
				{
					name = "Radar(Land)";
					value = 6;
				};

				class MCC_MWIntelObjects
				{
					name = "Intel Objects(Small Items)";
					value = 7;
				};

				class MCC_MWIED
				{
					name = "IED(Small Items)";
					value = 8;
				};

				class MCC_MWAA
				{
					name = "Anti-Air(Vehicle)";
					value = 9;
				};

				class MCC_MWArtillery
				{
					name = "Artillery(Vehicle)";
					value = 10;
				};
			};
		};

		class VariableClass : Edit
		{
			displayName = "Variable Class";
			description = "Array contains all the variable classes";
			typeName = "STRING";
			defaultValue = '["B_officer_F","O_officer_F","I_officer_F","C_Nikos"]';
			property = "displayName";
		};

		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description = 'Define classes for the mission wizard -Synced vehicles or array of strings typed in "Variable Class" will be used in the mission wizard';
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