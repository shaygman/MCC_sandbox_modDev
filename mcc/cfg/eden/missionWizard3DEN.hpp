// MCC 5 Mission Wizard (editor-time generator) scenario attributes.
// Contains ONLY the section class: include it INSIDE
// config.cpp >> class Cfg3DEN >> class Mission { ... }. Opened by the Eden menu MCC 5 > Mission Wizard...
// (edit3DENMissionAttributes 'MCC5_MW'); read by MCC_fnc_edenWizardOptions. The values are only used in the editor
// (expression is empty), the generated entities carry everything the mission needs at runtime.
// The faction controls MCC5MW_FactionComboMil / MCC5MW_FactionComboCiv are defined in mcc\cfg\eden\attributesControls.hpp.
class MCC5_MW
{
	displayName = "MCC 5 Mission Wizard";
	class AttributeCategories
	{
		class MCC5MW_CatArea
		{
			displayName = "Mission area and size";
			collapsed = 0;
			class Attributes
			{
				class MCC5MW_areaMode
				{
					displayName = "Mission Area";
					tooltip = "Where the mission is built when you press MCC 5 > Generate Mission.\nSelection: the area of the ONE selected trigger or area marker; if nothing is selected, the point the editor camera looks at.\nCamera: always the point in the center of the screen.\nWhole map: a random town/location of the terrain (the old 'whole map' wizard mode).";
					property = "MCC5MW_areaMode";
					control = "Combo";
					expression = "";
					defaultValue = "0";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "Selected trigger/marker, else camera view"; value = 0;};
						class V1 {name = "Camera view (center of screen)"; value = 1;};
						class V2 {name = "Whole map (random location)"; value = 2;};
					};
				};
				class MCC5MW_areaRadius
				{
					displayName = "Area Radius (m)";
					tooltip = "Radius of the mission area. 0 = automatic (from players, objectives and mission size, like the old wizard). Ignored when a selected trigger/marker gives the area.";
					property = "MCC5MW_areaRadius";
					control = "EditShort";
					expression = "";
					defaultValue = "0";
					typeName = "NUMBER";
					validate = "number";
				};
				class MCC5MW_players
				{
					displayName = "Expected Players";
					tooltip = "Number of players the mission is built for. Enemy count = players x difficulty (min 20), x mission size.";
					property = "MCC5MW_players";
					control = "EditShort";
					expression = "";
					defaultValue = "10";
					typeName = "NUMBER";
					validate = "number";
				};
				class MCC5MW_difficulty
				{
					displayName = "Difficulty";
					tooltip = "Enemies per player.";
					property = "MCC5MW_difficulty";
					control = "Combo";
					expression = "";
					defaultValue = "4";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "Easy (2 per player)"; value = 2;};
						class V1 {name = "Medium (4 per player)"; value = 4;};
						class V2 {name = "Hard (6 per player)"; value = 6;};
					};
				};
				class MCC5MW_missionSize
				{
					displayName = "Mission Size";
					tooltip = "Multiplier on the number of enemies and on the size of the area.";
					property = "MCC5MW_missionSize";
					control = "Combo";
					expression = "";
					defaultValue = "1";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "Small"; value = 0.5;};
						class V1 {name = "Normal"; value = 1;};
						class V2 {name = "Large"; value = 1.75;};
						class V3 {name = "Huge"; value = 2.5;};
					};
				};
				class MCC5MW_maxUnits
				{
					displayName = "Max AI Units";
					tooltip = "Hard cap (performance) on the AI units the wizard places (enemies, civilians, crews).";
					property = "MCC5MW_maxUnits";
					control = "EditShort";
					expression = "";
					defaultValue = "200";
					typeName = "NUMBER";
					validate = "number";
				};
			};
		};
		class MCC5MW_CatFactions
		{
			displayName = "Factions";
			collapsed = 0;
			class Attributes
			{
				class MCC5MW_enemyFaction
				{
					displayName = "Enemy Faction";
					tooltip = "Faction the players fight (the enemy side comes from the faction). Groups come from CfgGroups, single units and vehicles from CfgVehicles.";
					property = "MCC5MW_enemyFaction";
					control = "MCC5MW_FactionComboMil";
					expression = "";
					defaultValue = "'OPF_F'";
					typeName = "STRING";
				};
				class MCC5MW_playerFaction
				{
					displayName = "Player Faction";
					tooltip = "Faction of the players: decides who gets the tasks and briefing, the hostage faction and who triggers IEDs.";
					property = "MCC5MW_playerFaction";
					control = "MCC5MW_FactionComboMil";
					expression = "";
					defaultValue = "'BLU_F'";
					typeName = "STRING";
				};
				class MCC5MW_civFaction
				{
					displayName = "Civilian Faction";
					tooltip = "Civilians (CQB with civilians, hostages, suicide bombers, armed civilians).";
					property = "MCC5MW_civFaction";
					control = "MCC5MW_FactionComboCiv";
					expression = "";
					defaultValue = "'CIV_F'";
					typeName = "STRING";
				};
			};
		};
		class MCC5MW_CatObjectives
		{
			displayName = "Objectives";
			collapsed = 0;
			class Attributes
			{
				class MCC5MW_objectivesCount
				{
					displayName = "Number of Objectives";
					tooltip = "How many of the objective slots below are used (max 8). Slots set to None are skipped.";
					property = "MCC5MW_objectivesCount";
					control = "Combo";
					expression = "";
					defaultValue = "3";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "1"; value = 1;};
						class V1 {name = "2"; value = 2;};
						class V2 {name = "3"; value = 3;};
						class V3 {name = "4"; value = 4;};
						class V4 {name = "5"; value = 5;};
						class V5 {name = "6"; value = 6;};
						class V6 {name = "7"; value = 7;};
						class V7 {name = "8"; value = 8;};
					};
				};
				class MCC5MW_objective1
				{
					displayName = "Objective 1";
					tooltip = "Objective type. Random: a type not used yet in this mission.";
					property = "MCC5MW_objective1";
					control = "Combo";
					expression = "";
					defaultValue = "'Random'";
					typeName = "STRING";
					class Values
					{
						class V0 {name = "None"; value = "None";};
						class V1 {name = "Random"; value = "Random";};
						class V2 {name = "Secure HVT (hostage rescue)"; value = "Secure HVT";};
						class V3 {name = "Kill HVT"; value = "Kill HVT";};
						class V4 {name = "Destroy Vehicle"; value = "Destroy Vehicle";};
						class V5 {name = "Destroy AA"; value = "Destroy AA";};
						class V6 {name = "Destroy Artillery"; value = "Destroy Artillery";};
						class V7 {name = "Destroy Weapon Cache"; value = "Destroy Weapon Cache";};
						class V8 {name = "Destroy Fuel Depot"; value = "Destroy Fuel Depot";};
						class V9 {name = "Destroy Radar/Radio"; value = "Destroy Radar/Radio";};
						class V10 {name = "Acquire Intel"; value = "Acquire Intel";};
						class V11 {name = "Download Intel"; value = "Download Intel";};
						class V12 {name = "Capture Area"; value = "Capture Area";};
						class V13 {name = "Disarm IED"; value = "Disarm IED";};
					};
				};
				class MCC5MW_objective2
				{
					displayName = "Objective 2";
					tooltip = "Objective type. Random: a type not used yet in this mission.";
					property = "MCC5MW_objective2";
					control = "Combo";
					expression = "";
					defaultValue = "'Random'";
					typeName = "STRING";
					class Values
					{
						class V0 {name = "None"; value = "None";};
						class V1 {name = "Random"; value = "Random";};
						class V2 {name = "Secure HVT (hostage rescue)"; value = "Secure HVT";};
						class V3 {name = "Kill HVT"; value = "Kill HVT";};
						class V4 {name = "Destroy Vehicle"; value = "Destroy Vehicle";};
						class V5 {name = "Destroy AA"; value = "Destroy AA";};
						class V6 {name = "Destroy Artillery"; value = "Destroy Artillery";};
						class V7 {name = "Destroy Weapon Cache"; value = "Destroy Weapon Cache";};
						class V8 {name = "Destroy Fuel Depot"; value = "Destroy Fuel Depot";};
						class V9 {name = "Destroy Radar/Radio"; value = "Destroy Radar/Radio";};
						class V10 {name = "Acquire Intel"; value = "Acquire Intel";};
						class V11 {name = "Download Intel"; value = "Download Intel";};
						class V12 {name = "Capture Area"; value = "Capture Area";};
						class V13 {name = "Disarm IED"; value = "Disarm IED";};
					};
				};
				class MCC5MW_objective3
				{
					displayName = "Objective 3";
					tooltip = "Objective type. Random: a type not used yet in this mission.";
					property = "MCC5MW_objective3";
					control = "Combo";
					expression = "";
					defaultValue = "'Random'";
					typeName = "STRING";
					class Values
					{
						class V0 {name = "None"; value = "None";};
						class V1 {name = "Random"; value = "Random";};
						class V2 {name = "Secure HVT (hostage rescue)"; value = "Secure HVT";};
						class V3 {name = "Kill HVT"; value = "Kill HVT";};
						class V4 {name = "Destroy Vehicle"; value = "Destroy Vehicle";};
						class V5 {name = "Destroy AA"; value = "Destroy AA";};
						class V6 {name = "Destroy Artillery"; value = "Destroy Artillery";};
						class V7 {name = "Destroy Weapon Cache"; value = "Destroy Weapon Cache";};
						class V8 {name = "Destroy Fuel Depot"; value = "Destroy Fuel Depot";};
						class V9 {name = "Destroy Radar/Radio"; value = "Destroy Radar/Radio";};
						class V10 {name = "Acquire Intel"; value = "Acquire Intel";};
						class V11 {name = "Download Intel"; value = "Download Intel";};
						class V12 {name = "Capture Area"; value = "Capture Area";};
						class V13 {name = "Disarm IED"; value = "Disarm IED";};
					};
				};
				class MCC5MW_objective4
				{
					displayName = "Objective 4";
					tooltip = "Objective type. Random: a type not used yet in this mission.";
					property = "MCC5MW_objective4";
					control = "Combo";
					expression = "";
					defaultValue = "'Random'";
					typeName = "STRING";
					class Values
					{
						class V0 {name = "None"; value = "None";};
						class V1 {name = "Random"; value = "Random";};
						class V2 {name = "Secure HVT (hostage rescue)"; value = "Secure HVT";};
						class V3 {name = "Kill HVT"; value = "Kill HVT";};
						class V4 {name = "Destroy Vehicle"; value = "Destroy Vehicle";};
						class V5 {name = "Destroy AA"; value = "Destroy AA";};
						class V6 {name = "Destroy Artillery"; value = "Destroy Artillery";};
						class V7 {name = "Destroy Weapon Cache"; value = "Destroy Weapon Cache";};
						class V8 {name = "Destroy Fuel Depot"; value = "Destroy Fuel Depot";};
						class V9 {name = "Destroy Radar/Radio"; value = "Destroy Radar/Radio";};
						class V10 {name = "Acquire Intel"; value = "Acquire Intel";};
						class V11 {name = "Download Intel"; value = "Download Intel";};
						class V12 {name = "Capture Area"; value = "Capture Area";};
						class V13 {name = "Disarm IED"; value = "Disarm IED";};
					};
				};
				class MCC5MW_objective5
				{
					displayName = "Objective 5";
					tooltip = "Objective type. Random: a type not used yet in this mission.";
					property = "MCC5MW_objective5";
					control = "Combo";
					expression = "";
					defaultValue = "'Random'";
					typeName = "STRING";
					class Values
					{
						class V0 {name = "None"; value = "None";};
						class V1 {name = "Random"; value = "Random";};
						class V2 {name = "Secure HVT (hostage rescue)"; value = "Secure HVT";};
						class V3 {name = "Kill HVT"; value = "Kill HVT";};
						class V4 {name = "Destroy Vehicle"; value = "Destroy Vehicle";};
						class V5 {name = "Destroy AA"; value = "Destroy AA";};
						class V6 {name = "Destroy Artillery"; value = "Destroy Artillery";};
						class V7 {name = "Destroy Weapon Cache"; value = "Destroy Weapon Cache";};
						class V8 {name = "Destroy Fuel Depot"; value = "Destroy Fuel Depot";};
						class V9 {name = "Destroy Radar/Radio"; value = "Destroy Radar/Radio";};
						class V10 {name = "Acquire Intel"; value = "Acquire Intel";};
						class V11 {name = "Download Intel"; value = "Download Intel";};
						class V12 {name = "Capture Area"; value = "Capture Area";};
						class V13 {name = "Disarm IED"; value = "Disarm IED";};
					};
				};
				class MCC5MW_objective6
				{
					displayName = "Objective 6";
					tooltip = "Objective type. Random: a type not used yet in this mission.";
					property = "MCC5MW_objective6";
					control = "Combo";
					expression = "";
					defaultValue = "'Random'";
					typeName = "STRING";
					class Values
					{
						class V0 {name = "None"; value = "None";};
						class V1 {name = "Random"; value = "Random";};
						class V2 {name = "Secure HVT (hostage rescue)"; value = "Secure HVT";};
						class V3 {name = "Kill HVT"; value = "Kill HVT";};
						class V4 {name = "Destroy Vehicle"; value = "Destroy Vehicle";};
						class V5 {name = "Destroy AA"; value = "Destroy AA";};
						class V6 {name = "Destroy Artillery"; value = "Destroy Artillery";};
						class V7 {name = "Destroy Weapon Cache"; value = "Destroy Weapon Cache";};
						class V8 {name = "Destroy Fuel Depot"; value = "Destroy Fuel Depot";};
						class V9 {name = "Destroy Radar/Radio"; value = "Destroy Radar/Radio";};
						class V10 {name = "Acquire Intel"; value = "Acquire Intel";};
						class V11 {name = "Download Intel"; value = "Download Intel";};
						class V12 {name = "Capture Area"; value = "Capture Area";};
						class V13 {name = "Disarm IED"; value = "Disarm IED";};
					};
				};
				class MCC5MW_objective7
				{
					displayName = "Objective 7";
					tooltip = "Objective type. Random: a type not used yet in this mission.";
					property = "MCC5MW_objective7";
					control = "Combo";
					expression = "";
					defaultValue = "'Random'";
					typeName = "STRING";
					class Values
					{
						class V0 {name = "None"; value = "None";};
						class V1 {name = "Random"; value = "Random";};
						class V2 {name = "Secure HVT (hostage rescue)"; value = "Secure HVT";};
						class V3 {name = "Kill HVT"; value = "Kill HVT";};
						class V4 {name = "Destroy Vehicle"; value = "Destroy Vehicle";};
						class V5 {name = "Destroy AA"; value = "Destroy AA";};
						class V6 {name = "Destroy Artillery"; value = "Destroy Artillery";};
						class V7 {name = "Destroy Weapon Cache"; value = "Destroy Weapon Cache";};
						class V8 {name = "Destroy Fuel Depot"; value = "Destroy Fuel Depot";};
						class V9 {name = "Destroy Radar/Radio"; value = "Destroy Radar/Radio";};
						class V10 {name = "Acquire Intel"; value = "Acquire Intel";};
						class V11 {name = "Download Intel"; value = "Download Intel";};
						class V12 {name = "Capture Area"; value = "Capture Area";};
						class V13 {name = "Disarm IED"; value = "Disarm IED";};
					};
				};
				class MCC5MW_objective8
				{
					displayName = "Objective 8";
					tooltip = "Objective type. Random: a type not used yet in this mission.";
					property = "MCC5MW_objective8";
					control = "Combo";
					expression = "";
					defaultValue = "'Random'";
					typeName = "STRING";
					class Values
					{
						class V0 {name = "None"; value = "None";};
						class V1 {name = "Random"; value = "Random";};
						class V2 {name = "Secure HVT (hostage rescue)"; value = "Secure HVT";};
						class V3 {name = "Kill HVT"; value = "Kill HVT";};
						class V4 {name = "Destroy Vehicle"; value = "Destroy Vehicle";};
						class V5 {name = "Destroy AA"; value = "Destroy AA";};
						class V6 {name = "Destroy Artillery"; value = "Destroy Artillery";};
						class V7 {name = "Destroy Weapon Cache"; value = "Destroy Weapon Cache";};
						class V8 {name = "Destroy Fuel Depot"; value = "Destroy Fuel Depot";};
						class V9 {name = "Destroy Radar/Radio"; value = "Destroy Radar/Radio";};
						class V10 {name = "Acquire Intel"; value = "Acquire Intel";};
						class V11 {name = "Download Intel"; value = "Download Intel";};
						class V12 {name = "Capture Area"; value = "Capture Area";};
						class V13 {name = "Disarm IED"; value = "Disarm IED";};
					};
				};
			};
		};
		class MCC5MW_CatForces
		{
			displayName = "Enemy forces and threats";
			collapsed = 0;
			class Attributes
			{
				class MCC5MW_cqb
				{
					displayName = "CQB";
					tooltip = "Urban mission: enemies garrison buildings and objectives are placed in buildings. With civilians: civilians in the buildings too.";
					property = "MCC5MW_cqb";
					control = "Combo";
					expression = "";
					defaultValue = "3";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes - without civilians"; value = 1;};
						class V2 {name = "Yes - with civilians"; value = 2;};
						class V3 {name = "Random"; value = 3;};
					};
				};
				class MCC5MW_vehicles
				{
					displayName = "Enemy Vehicles";
					tooltip = "Light/motorized enemy vehicles patrolling the area.";
					property = "MCC5MW_vehicles";
					control = "Combo";
					expression = "";
					defaultValue = "2";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes"; value = 1;};
						class V2 {name = "Random"; value = 2;};
					};
				};
				class MCC5MW_armor
				{
					displayName = "Enemy Armor";
					tooltip = "Armored/mechanized enemy groups.";
					property = "MCC5MW_armor";
					control = "Combo";
					expression = "";
					defaultValue = "2";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes"; value = 1;};
						class V2 {name = "Random"; value = 2;};
					};
				};
				class MCC5MW_stealth
				{
					displayName = "Stealth";
					tooltip = "Black ops: enemies start relaxed (SAFE) and, if the weather/time option changes the time, the mission takes place at night.";
					property = "MCC5MW_stealth";
					control = "Combo";
					expression = "";
					defaultValue = "2";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes"; value = 1;};
						class V2 {name = "Random"; value = 2;};
					};
				};
				class MCC5MW_ied
				{
					displayName = "IEDs";
					tooltip = "IEDs (MCC IED modules) on the roads in the area.";
					property = "MCC5MW_ied";
					control = "Combo";
					expression = "";
					defaultValue = "2";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes"; value = 1;};
						class V2 {name = "Random"; value = 2;};
					};
				};
				class MCC5MW_suicideBombers
				{
					displayName = "Suicide Bombers";
					tooltip = "Civilian suicide bombers (MCC IED module synced to a civilian).";
					property = "MCC5MW_suicideBombers";
					control = "Combo";
					expression = "";
					defaultValue = "2";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes"; value = 1;};
						class V2 {name = "Random"; value = 2;};
					};
				};
				class MCC5MW_armedCivilians
				{
					displayName = "Armed Civilians";
					tooltip = "Civilians that draw weapons on the players (MCC Armed Civilian module).";
					property = "MCC5MW_armedCivilians";
					control = "Combo";
					expression = "";
					defaultValue = "2";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes"; value = 1;};
						class V2 {name = "Random"; value = 2;};
					};
				};
				class MCC5MW_roadblocks
				{
					displayName = "Roadblocks";
					tooltip = "Manned checkpoints on the roads leading into the area.";
					property = "MCC5MW_roadblocks";
					control = "Combo";
					expression = "";
					defaultValue = "2";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes"; value = 1;};
						class V2 {name = "Random"; value = 2;};
					};
				};
				class MCC5MW_animals
				{
					displayName = "Animals";
					tooltip = "Ambient animals (vanilla animal modules).";
					property = "MCC5MW_animals";
					control = "Combo";
					expression = "";
					defaultValue = "2";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Yes"; value = 1;};
						class V2 {name = "Random"; value = 2;};
					};
				};
				class MCC5MW_reinforcement
				{
					displayName = "Reinforcements";
					tooltip = "Turns on GAIA AI reinforcement requests (MCC 5 Mission Settings). Motorized also stages a motorized QRF group outside the area.";
					property = "MCC5MW_reinforcement";
					control = "Combo";
					expression = "";
					defaultValue = "3";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Aerial"; value = 1;};
						class V2 {name = "Motorized"; value = 2;};
						class V3 {name = "Random"; value = 3;};
					};
				};
				class MCC5MW_artillery
				{
					displayName = "Enemy Artillery";
					tooltip = "Mortar or self propelled artillery groups inside the area; also turns on GAIA AI artillery requests.";
					property = "MCC5MW_artillery";
					control = "Combo";
					expression = "";
					defaultValue = "3";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "No"; value = 0;};
						class V1 {name = "Mortars"; value = 1;};
						class V2 {name = "Self propelled artillery"; value = 2;};
						class V3 {name = "Random"; value = 3;};
					};
				};
			};
		};
		class MCC5MW_CatMission
		{
			displayName = "Weather, briefing and markers";
			collapsed = 0;
			class Attributes
			{
				class MCC5MW_weather
				{
					displayName = "Weather / Time";
					tooltip = "Change the scenario date, time and weather (Attributes > Environment). Sandstorm/Blizzard/Snow also add the MCC effect at mission start.";
					property = "MCC5MW_weather";
					control = "Combo";
					expression = "";
					defaultValue = "0";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "Don't change"; value = 0;};
						class V1 {name = "Random"; value = 1;};
						class V2 {name = "Sandstorm"; value = 2;};
						class V3 {name = "Blizzard"; value = 3;};
						class V4 {name = "Snow"; value = 4;};
					};
				};
				class MCC5MW_intro
				{
					displayName = "Intro";
					tooltip = "Mission start: music and operation title, title only, or nothing.";
					property = "MCC5MW_intro";
					control = "Combo";
					expression = "";
					defaultValue = "0";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "Cinematic (music + title)"; value = 0;};
						class V1 {name = "Pop-up title"; value = 1;};
						class V2 {name = "None"; value = 2;};
					};
				};
				class MCC5MW_preciseMarkers
				{
					displayName = "Precise Objective Markers";
					tooltip = "Checked: task markers on the exact objective. Unchecked: the task points somewhere within 300 m of it.";
					property = "MCC5MW_preciseMarkers";
					control = "Checkbox";
					expression = "";
					defaultValue = "true";
					typeName = "BOOL";
				};
				class MCC5MW_generalMarkers
				{
					displayName = "General Markers";
					tooltip = "Also place map markers for the objective zones, roadblocks and enemy positions (visible to players).";
					property = "MCC5MW_generalMarkers";
					control = "Checkbox";
					expression = "";
					defaultValue = "false";
					typeName = "BOOL";
				};
				class MCC5MW_briefing
				{
					displayName = "Briefing";
					tooltip = "Add the generated briefing to the players' map (Diary).";
					property = "MCC5MW_briefing";
					control = "Checkbox";
					expression = "";
					defaultValue = "true";
					typeName = "BOOL";
				};
				class MCC5MW_playerStart
				{
					displayName = "Player Start";
					tooltip = "Respawn position for the player side, placed outside the area.";
					property = "MCC5MW_playerStart";
					control = "Combo";
					expression = "";
					defaultValue = "0";
					typeName = "NUMBER";
					class Values
					{
						class V0 {name = "None (place your own)"; value = 0;};
						class V1 {name = "Respawn marker outside the area"; value = 1;};
					};
				};
				class MCC5MW_endMission
				{
					displayName = "End Mission When Done";
					tooltip = "When every objective is completed the scenario ends (END1).";
					property = "MCC5MW_endMission";
					control = "Checkbox";
					expression = "";
					defaultValue = "false";
					typeName = "BOOL";
				};
			};
		};
	};
};
