class MCC_Module_missionWizard : Module_F
{
	scope = 2;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 1;
	category = "MCC";
	author = "shay_gman";
	displayName = "Mission Wizard";
	icon = "\mcc_sandbox_mod\data\mccModule.paa";
	picture = "\mcc_sandbox_mod\data\mccModule.paa";
	vehicleClass = "Modules";
	function = "MCC_fnc_moduleMissionWizard";
	functionPriority = 10;
	canSetArea = 1;
	canSetAreaShape = 1;
	canSetAreaHeight = 0;

	class AttributeValues
	{
		size3[] = {750,750,-1};
		isRectangle = 0;
	};

	class Attributes : AttributesBase
	{
		class areaMode : Combo
		{
			displayName = "Mission Area";
			description = "Area: a random spot inside the synced trigger area or the module area. Exact: objectives around the module position. Whole map: anywhere on the map.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_areaMode";
			class values
			{
				class V0
				{
					name = "Area (synced trigger or module area)";
					value = 0;
					default = 1;
				};
				class V1
				{
					name = "Exact (around the module)";
					value = 1;
				};
				class V2
				{
					name = "Whole map";
					value = 2;
				};
			};
		};

		class startDelay : Edit
		{
			displayName = "Start Delay (s)";
			description = "Seconds after mission start before the mission is generated.";
			typeName = "NUMBER";
			defaultValue = "5";
			property = "MCC_ModuleMW_startDelay";
		};

		class missionId : Edit
		{
			displayName = "Mission ID";
			description = "Optional. While the mission runs missionNamespace variable MCC_MWMissionRuning_<ID> is true (use it in triggers). Empty: edenMW_1, edenMW_2...";
			typeName = "STRING";
			defaultValue = """""";
			property = "MCC_ModuleMW_missionId";
		};

		class playersNumber : Edit
		{
			displayName = "Expected Players";
			description = "Number of players the mission is built for (enemy count = players x difficulty, min 20).";
			typeName = "NUMBER";
			defaultValue = "10";
			property = "MCC_ModuleMW_playersNumber";
		};

		class difficulty : Combo
		{
			displayName = "Difficulty";
			description = "Enemies per player.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_difficulty";
			class values
			{
				class V0
				{
					name = "Easy";
					value = 2;
				};
				class V1
				{
					name = "Medium";
					value = 4;
					default = 1;
				};
				class V2
				{
					name = "Hard";
					value = 6;
				};
			};
		};

		class objectivesCount : Combo
		{
			displayName = "Objectives";
			description = "Number of objectives. Objectives above 3 are random. Mission size and unit cap come from the MCC Mission Wizard settings.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_objectivesCount";
			class values
			{
				class V0
				{
					name = "Use MCC setting";
					value = 0;
					default = 1;
				};
				class V1
				{
					name = "1";
					value = 1;
				};
				class V2
				{
					name = "2";
					value = 2;
				};
				class V3
				{
					name = "3";
					value = 3;
				};
				class V4
				{
					name = "4";
					value = 4;
				};
				class V5
				{
					name = "5";
					value = 5;
				};
				class V6
				{
					name = "6";
					value = 6;
				};
				class V7
				{
					name = "7";
					value = 7;
				};
				class V8
				{
					name = "8";
					value = 8;
				};
			};
		};

		class objective1 : Combo
		{
			displayName = "Objective 1";
			description = "Objective type.";
			typeName = "STRING";
			property = "MCC_ModuleMW_objective1";
			class values
			{
				class V0
				{
					name = "None";
					value = "None";
				};
				class V1
				{
					name = "Random";
					value = "Random";
					default = 1;
				};
				class V2
				{
					name = "Secure HVT";
					value = "Secure HVT";
				};
				class V3
				{
					name = "Kill HVT";
					value = "Kill HVT";
				};
				class V4
				{
					name = "Destroy Vehicle";
					value = "Destroy Vehicle";
				};
				class V5
				{
					name = "Destroy AA";
					value = "Destroy AA";
				};
				class V6
				{
					name = "Destroy Artillery";
					value = "Destroy Artillery";
				};
				class V7
				{
					name = "Destroy Weapon Cache";
					value = "Destroy Weapon Cahce";
				};
				class V8
				{
					name = "Destroy Fuel Depot";
					value = "Destroy Fuel Depot";
				};
				class V9
				{
					name = "Destroy Radar/Radio";
					value = "Destroy Radar/Radio";
				};
				class V10
				{
					name = "Acquire Intel";
					value = "Acquire Intel";
				};
				class V11
				{
					name = "Download Intel";
					value = "Download Intel";
				};
				class V12
				{
					name = "Capture Area";
					value = "Capture Area";
				};
				class V13
				{
					name = "Disarm IED";
					value = "Disarm IED";
				};
			};
		};

		class objective2 : Combo
		{
			displayName = "Objective 2";
			description = "Objective type.";
			typeName = "STRING";
			property = "MCC_ModuleMW_objective2";
			class values
			{
				class V0
				{
					name = "None";
					value = "None";
				};
				class V1
				{
					name = "Random";
					value = "Random";
					default = 1;
				};
				class V2
				{
					name = "Secure HVT";
					value = "Secure HVT";
				};
				class V3
				{
					name = "Kill HVT";
					value = "Kill HVT";
				};
				class V4
				{
					name = "Destroy Vehicle";
					value = "Destroy Vehicle";
				};
				class V5
				{
					name = "Destroy AA";
					value = "Destroy AA";
				};
				class V6
				{
					name = "Destroy Artillery";
					value = "Destroy Artillery";
				};
				class V7
				{
					name = "Destroy Weapon Cache";
					value = "Destroy Weapon Cahce";
				};
				class V8
				{
					name = "Destroy Fuel Depot";
					value = "Destroy Fuel Depot";
				};
				class V9
				{
					name = "Destroy Radar/Radio";
					value = "Destroy Radar/Radio";
				};
				class V10
				{
					name = "Acquire Intel";
					value = "Acquire Intel";
				};
				class V11
				{
					name = "Download Intel";
					value = "Download Intel";
				};
				class V12
				{
					name = "Capture Area";
					value = "Capture Area";
				};
				class V13
				{
					name = "Disarm IED";
					value = "Disarm IED";
				};
			};
		};

		class objective3 : Combo
		{
			displayName = "Objective 3";
			description = "Objective type.";
			typeName = "STRING";
			property = "MCC_ModuleMW_objective3";
			class values
			{
				class V0
				{
					name = "None";
					value = "None";
					default = 1;
				};
				class V1
				{
					name = "Random";
					value = "Random";
				};
				class V2
				{
					name = "Secure HVT";
					value = "Secure HVT";
				};
				class V3
				{
					name = "Kill HVT";
					value = "Kill HVT";
				};
				class V4
				{
					name = "Destroy Vehicle";
					value = "Destroy Vehicle";
				};
				class V5
				{
					name = "Destroy AA";
					value = "Destroy AA";
				};
				class V6
				{
					name = "Destroy Artillery";
					value = "Destroy Artillery";
				};
				class V7
				{
					name = "Destroy Weapon Cache";
					value = "Destroy Weapon Cahce";
				};
				class V8
				{
					name = "Destroy Fuel Depot";
					value = "Destroy Fuel Depot";
				};
				class V9
				{
					name = "Destroy Radar/Radio";
					value = "Destroy Radar/Radio";
				};
				class V10
				{
					name = "Acquire Intel";
					value = "Acquire Intel";
				};
				class V11
				{
					name = "Download Intel";
					value = "Download Intel";
				};
				class V12
				{
					name = "Capture Area";
					value = "Capture Area";
				};
				class V13
				{
					name = "Disarm IED";
					value = "Disarm IED";
				};
			};
		};

		class enemyFaction : Edit
		{
			displayName = "Enemy Faction";
			description = "CfgFactionClasses class name, e.g. OPF_F, IND_F, OPF_T_F. The enemy side is taken from the faction.";
			typeName = "STRING";
			defaultValue = """OPF_F""";
			property = "MCC_ModuleMW_enemyFaction";
		};

		class playerFaction : Edit
		{
			displayName = "Player Faction";
			description = "CfgFactionClasses class name of the players, e.g. BLU_F. The players' side is taken from the faction.";
			typeName = "STRING";
			defaultValue = """BLU_F""";
			property = "MCC_ModuleMW_playerFaction";
		};

		class civFaction : Edit
		{
			displayName = "Civilian Faction";
			description = "CfgFactionClasses class name of the civilians, e.g. CIV_F.";
			typeName = "STRING";
			defaultValue = """CIV_F""";
			property = "MCC_ModuleMW_civFaction";
		};

		class cqb : Combo
		{
			displayName = "CQB";
			description = "Urban mission and civilians.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_cqb";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes - without civilians";
					value = 1;
				};
				class V2
				{
					name = "Yes - with civilians";
					value = 2;
				};
				class V3
				{
					name = "Random";
					value = 3;
					default = 1;
				};
			};
		};

		class vehicles : Combo
		{
			displayName = "Enemy Vehicles";
			description = "Light enemy vehicles.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_vehicles";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes";
					value = 1;
				};
				class V2
				{
					name = "Random";
					value = 2;
					default = 1;
				};
			};
		};

		class armor : Combo
		{
			displayName = "Enemy Armor";
			description = "Enemy armored vehicles.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_armor";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes";
					value = 1;
				};
				class V2
				{
					name = "Random";
					value = 2;
					default = 1;
				};
			};
		};

		class stealth : Combo
		{
			displayName = "Stealth";
			description = "Enemies start unaware; alarms call reinforcements.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_stealth";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes";
					value = 1;
				};
				class V2
				{
					name = "Random";
					value = 2;
					default = 1;
				};
			};
		};

		class ied : Combo
		{
			displayName = "IEDs";
			description = "IEDs and mines around the area.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_ied";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes";
					value = 1;
				};
				class V2
				{
					name = "Random";
					value = 2;
					default = 1;
				};
			};
		};

		class suicideBombers : Combo
		{
			displayName = "Suicide Bombers";
			description = "Suicide bombers among civilians.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_suicideBombers";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes";
					value = 1;
				};
				class V2
				{
					name = "Random";
					value = 2;
					default = 1;
				};
			};
		};

		class armedCivilians : Combo
		{
			displayName = "Armed Civilians";
			description = "Armed civilians (insurgents) among civilians.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_armedCivilians";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes";
					value = 1;
				};
				class V2
				{
					name = "Random";
					value = 2;
					default = 1;
				};
			};
		};

		class roadblocks : Combo
		{
			displayName = "Roadblocks";
			description = "Enemy roadblocks on roads.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_roadblocks";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes";
					value = 1;
				};
				class V2
				{
					name = "Random";
					value = 2;
					default = 1;
				};
			};
		};

		class animals : Combo
		{
			displayName = "Animals";
			description = "Ambient animals.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_animals";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Yes";
					value = 1;
				};
				class V2
				{
					name = "Random";
					value = 2;
					default = 1;
				};
			};
		};

		class reinforcement : Combo
		{
			displayName = "Reinforcements";
			description = "Enemy reinforcements.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_reinforcement";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Aerial";
					value = 1;
				};
				class V2
				{
					name = "Motorized";
					value = 2;
				};
				class V3
				{
					name = "Random";
					value = 3;
					default = 1;
				};
			};
		};

		class artillery : Combo
		{
			displayName = "Enemy Artillery";
			description = "Enemy artillery support.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_artillery";
			class values
			{
				class V0
				{
					name = "No";
					value = 0;
				};
				class V1
				{
					name = "Mortars";
					value = 1;
				};
				class V2
				{
					name = "Self propelled artillery";
					value = 2;
				};
				class V3
				{
					name = "Random";
					value = 3;
					default = 1;
				};
			};
		};

		class weather : Combo
		{
			displayName = "Weather / Time";
			description = "Change weather and time of day.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_weather";
			class values
			{
				class V0
				{
					name = "Don't change";
					value = 0;
					default = 1;
				};
				class V1
				{
					name = "Random";
					value = 1;
				};
				class V2
				{
					name = "Sandstorm";
					value = 2;
				};
				class V3
				{
					name = "Blizzard";
					value = 3;
				};
				class V4
				{
					name = "Snow";
					value = 4;
				};
			};
		};

		class intro : Combo
		{
			displayName = "Intro";
			description = "Briefing intro.";
			typeName = "NUMBER";
			property = "MCC_ModuleMW_intro";
			class values
			{
				class V0
				{
					name = "Cinematic";
					value = 0;
					default = 1;
				};
				class V1
				{
					name = "Pop-up";
					value = 1;
				};
				class V2
				{
					name = "None";
					value = 2;
				};
			};
		};

		class preciseMarkers : Checkbox
		{
			displayName = "Precise Objective Markers";
			description = "Checked: objective markers on the exact spot. Unchecked: an area marker around it.";
			typeName = "BOOL";
			defaultValue = "true";
			property = "MCC_ModuleMW_preciseMarkers";
		};

		class generalMarkers : Checkbox
		{
			displayName = "General Markers";
			description = "Show the general enemy area markers.";
			typeName = "BOOL";
			defaultValue = "false";
			property = "MCC_ModuleMW_generalMarkers";
		};

		class ModuleDescription : ModuleDescription{};
	};

	class ModuleDescription : ModuleDescription
	{
		description[] = {
			"Generates a random Mission Wizard mission on the server at mission start (after Start Delay).",
			"Area mode: the mission is placed inside the area of a synced trigger, or inside the module area.",
			"No MCC zones are needed - the wizard creates its own zones. Only one mission is generated at a time; several modules queue.",
			"Mission makers can check missionNamespace getVariable ['MCC_MWMissionRuning_<Mission ID>',false] in triggers, and the module variable MCC_MWstate (waiting, generating, running, failed)."
		};
		sync[] = {"EmptyDetector"};
		position = 1;
		direction = 0;
		optional = 1;
		duplicate = 0;
	};
};
