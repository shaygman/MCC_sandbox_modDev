class MCC_Module_music : Module_F
{
	scope = 2;
	isGlobal = 0;
	isTriggerActivated = 1;
	isDisposable = 0;
	category = "MCC_Environment";
	author = "shay_gman";
	displayName = "Music / Sound";
	icon = "\a3\ui_f\data\igui\cfg\simpleTasks\types\listen_ca.paa";
	picture = "\a3\ui_f\data\igui\cfg\simpleTasks\types\listen_ca.paa";
	vehicleClass = "Modules";
	function = "MCC_fnc_moduleMusic";
	functionPriority = 5;

	class Attributes : AttributesBase
	{
		class track : Edit
		{
			displayName = "Track / Sound";
			description = "CfgMusic class (e.g. LeadTrack01_F) or CfgSounds class (e.g. AlarmSfx). Mission CfgMusic / CfgSounds classes work too.";
			typeName = "STRING";
			defaultValue = """LeadTrack01_F""";
			property = "MCC_ModuleMusic_track";
		};

		class trackType : Combo
		{
			displayName = "Type";
			description = "Music (playMusic), Sound (playSound) or stop the music.";
			typeName = "NUMBER";
			property = "MCC_ModuleMusic_trackType";
			class values
			{
				class Music	{name = "Music"; value = 0; default = 1;};
				class Sound	{name = "Sound"; value = 1;};
				class Stop	{name = "Stop music"; value = 2;};
			};
		};

		class ModuleDescription : ModuleDescription{};
	};

	class ModuleDescription : ModuleDescription
	{
		description[] = {
			"Plays music or a sound for every player.",
			"Sync a trigger to play when it activates (again on every activation of a repeatable trigger); without a trigger it plays at mission start."
		};
		sync[] = {"EmptyDetector"};
	};
};
