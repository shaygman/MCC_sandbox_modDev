class MCC_Module_convoy : Module_F
{
	scope = 2;
	isGlobal = 0;
	isTriggerActivated = 1;
	isDisposable = 1;
	category = "MCC_AI";
	author = "shay_gman";
	displayName = "Convoy";
	icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
	picture = "\a3\ui_f\data\igui\cfg\simpleTasks\types\car_ca.paa";
	vehicleClass = "Modules";
	function = "MCC_fnc_moduleConvoy";
	functionPriority = 5;

	class Attributes : AttributesBase
	{
		class destinationMarker : Edit
		{
			displayName = "Destination Marker";
			description = "Marker name of the destination. Leave empty to use a synced object (Game Logic, helipad...) or the waypoints of the lead vehicle's group.";
			typeName = "STRING";
			defaultValue = """""";
			property = "MCC_ModuleConvoy_destinationMarker";
		};

		class startDelay : Edit
		{
			displayName = "Start Delay (s)";
			description = "Seconds to wait after the trigger activation (or the mission start) before the convoy moves.";
			typeName = "NUMBER";
			defaultValue = "0";
			property = "MCC_ModuleConvoy_startDelay";
		};

		class maxSpeed : Edit
		{
			displayName = "Lead Speed (km/h)";
			description = "Speed of the lead vehicle, 0 = no limit. The other vehicles keep the separation.";
			typeName = "NUMBER";
			defaultValue = "40";
			property = "MCC_ModuleConvoy_maxSpeed";
		};

		class separation : Edit
		{
			displayName = "Separation (m)";
			description = "Distance between the vehicles.";
			typeName = "NUMBER";
			defaultValue = "30";
			property = "MCC_ModuleConvoy_separation";
		};

		class hvtClass : Edit
		{
			displayName = "HVT Class";
			description = "Optional unit class (e.g. C_Nikos, O_officer_F). The HVT rides captive and disarmed in the middle vehicle. Module variable MCC_convoyHVT holds the unit.";
			typeName = "STRING";
			defaultValue = """""";
			property = "MCC_ModuleConvoy_hvtClass";
		};

		class fillCargo : Checkbox
		{
			displayName = "Escort Infantry";
			description = "Fill the free cargo seats with infantry of each vehicle's faction.";
			typeName = "BOOL";
			defaultValue = "false";
			property = "MCC_ModuleConvoy_fillCargo";
		};

		class onArrival : Combo
		{
			displayName = "On Arrival";
			description = "What the convoy does at the destination.";
			typeName = "NUMBER";
			property = "MCC_ModuleConvoy_onArrival";
			class values
			{
				class Hold		{name = "Stop and hold"; value = 0; default = 1;};
				class Dismount	{name = "Dismount passengers"; value = 1;};
				class Delete	{name = "Delete the convoy"; value = 2;};
			};
		};

		class ModuleDescription : ModuleDescription{};
	};

	class ModuleDescription : ModuleDescription
	{
		description[] = {
			"Sync crewed land vehicles (or their crew). They form one convoy (column, safe, follow roads) and drive to the destination.",
			"Destination: the Destination Marker, else a synced empty object (Game Logic, invisible helipad), else the Eden waypoints of the lead vehicle's group.",
			"Sync a trigger to start the convoy when it activates; without a trigger the convoy starts at mission start.",
			"Module variables: MCC_convoyState (waiting, moving, arrived, destroyed), MCC_convoyVehicles, MCC_convoyHVT."
		};
		sync[] = {"ConvoyVehicle", "EmptyDetector"};

		class ConvoyVehicle
		{
			description = "Crewed land vehicles of the convoy.";
			displayName = "Convoy vehicle";
			icon = "iconCar";
			side = 4;
			position = 0;
			direction = 0;
			optional = 0;
			duplicate = 1;
		};
	};
};
