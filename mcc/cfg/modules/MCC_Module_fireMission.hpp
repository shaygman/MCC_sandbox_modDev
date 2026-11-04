class MCC_Module_fireMission : Module_F
{
	scope = 2;
	isGlobal = 0;
	isTriggerActivated = 1;
	isDisposable = 0;
	category = "MCC_Ordnance";
	author = "shay_gman";
	displayName = "Fire Mission";
	icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa";
	picture = "\a3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa";
	vehicleClass = "Modules";
	function = "MCC_fnc_moduleFireMission";
	functionPriority = 5;

	class Attributes : AttributesBase
	{
		class shellType : Combo
		{
			displayName = "Shell (simulated)";
			description = "Shell used when no synced artillery gun can fire (MCC_artilleryTypeArray). Synced guns use their own ammunition.";
			typeName = "NUMBER";
			property = "MCC_ModuleFireMission_shellType";
			class values
			{
				class T0	{name = "DPICM"; value = 0;};
				class T1	{name = "HE 120mm"; value = 1; default = 1;};
				class T2	{name = "HE 155mm"; value = 2;};
				class T3	{name = "Cluster AP"; value = 3;};
				class T4	{name = "Mines 120mm"; value = 4;};
				class T5	{name = "HE Laser-guided (as plain bomb)"; value = 5;};
				class T6	{name = "HE 82mm"; value = 6;};
				class T7	{name = "Incendiary 82mm"; value = 7;};
				class T8	{name = "Smoke White 120mm"; value = 8;};
				class T9	{name = "Smoke White 82mm"; value = 9;};
				class T10	{name = "Smoke Green 40mm"; value = 10;};
				class T11	{name = "Smoke Red 40mm"; value = 11;};
				class T12	{name = "Flare White"; value = 12;};
				class T13	{name = "Flare Green"; value = 13;};
				class T14	{name = "Flare Red"; value = 14;};
			};
		};

		class spread : Combo
		{
			displayName = "Spread";
			description = "Dispersion around the target.";
			typeName = "NUMBER";
			property = "MCC_ModuleFireMission_spread";
			class values
			{
				class S0	{name = "On target"; value = 0;};
				class S1	{name = "Precise (100 m)"; value = 100; default = 1;};
				class S2	{name = "Tight (200 m)"; value = 200;};
				class S3	{name = "Wide (400 m)"; value = 400;};
			};
		};

		class rounds : Edit
		{
			displayName = "Rounds per Salvo";
			description = "Shells per salvo (per gun for synced guns).";
			typeName = "NUMBER";
			defaultValue = "4";
			property = "MCC_ModuleFireMission_rounds";
		};

		class salvos : Edit
		{
			displayName = "Salvos";
			description = "Number of salvos.";
			typeName = "NUMBER";
			defaultValue = "1";
			property = "MCC_ModuleFireMission_salvos";
		};

		class salvoDelay : Edit
		{
			displayName = "Time Between Salvos (s)";
			description = "Seconds between two salvos.";
			typeName = "NUMBER";
			defaultValue = "30";
			property = "MCC_ModuleFireMission_salvoDelay";
		};

		class shellDelay : Edit
		{
			displayName = "Time Between Shells (s)";
			description = "Simulated shells only: seconds between two shells of a salvo.";
			typeName = "NUMBER";
			defaultValue = "1";
			property = "MCC_ModuleFireMission_shellDelay";
		};

		class startDelay : Edit
		{
			displayName = "Delay (s)";
			description = "Seconds between the trigger activation (or mission start) and the first salvo.";
			typeName = "NUMBER";
			defaultValue = "0";
			property = "MCC_ModuleFireMission_startDelay";
		};

		class ModuleDescription : ModuleDescription{};
	};

	class ModuleDescription : ModuleDescription
	{
		description[] = {
			"Fires artillery at the module position, or at a synced object/unit (its position when the salvo fires).",
			"Sync a trigger to fire when it activates (again on every activation of a repeatable trigger); without a trigger it fires at mission start.",
			"Sync crewed artillery (mortars, howitzers, MLRS) to use real guns; they fire their first magazine that is in range. Without guns, or when none is in range, MCC simulated shells are used."
		};
		sync[] = {"ArtilleryGun", "EmptyDetector"};

		class ArtilleryGun
		{
			description = "Crewed artillery vehicle or static (optional).";
			displayName = "Artillery";
			icon = "iconStaticCannon";
			side = 4;
			position = 0;
			direction = 0;
			optional = 1;
			duplicate = 1;
		};
	};
};
