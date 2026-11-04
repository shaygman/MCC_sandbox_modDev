#include "BIS_AddonInfo.hpp"
class CfgPatches
{

	class mcc_sandbox
	{
		units[] = {"mcc_sandbox_module", "mcc_sandbox_moduleSF", "mcc_sandbox_moduleRestrictedZone", "mcc_sandbox_moduleILS", "mcc_sandbox_moduleStartLocations", "MCC_Module_settings", "mcc_sandbox_moduleGAIASettings", "MCC_Module_settingsMechanics", "MCC_Module_settingsRadio", "MCC_Module_settingsMedicSystem", "mcc_sandbox_modulevehicleSpawner", "MCC_Module_createEvac", "MCC_Module_createIED", "MCC_Module_createArmedCivilian", "MCC_Module_campaignInit", "MCC_Module_captureZone", "MCC_module_vehicleRespawn", "MCC_Module_inGameUI", "mcc_Module_createZones", "MCC_Module_settingsRS", "MCC_Module_createIntel", "MCC_Module_addValor", "MCC_Module_settingsMissionWizard", "MCC_Module_missionWizard", "MCC_Module_convoy", "MCC_Module_fireMission", "MCC_Module_music"};
		weapons[] = {};
		requiredVersion = 1.00;
		requiredAddons[] = {"A3_Modules_F",
								"A3_Data_F_Tank_Loadorder",
					            "cba_ui",
					            "cba_xeh",
					            "cba_jr"
					        };
		author = "shay_gman";
		name = "MCC Sandbox";
		versionDesc = "MCC Sandbox 5";
		version = "5.33";
	};

	class mcc_sandbox_curatorExp
	{
		units[] = {"MCC_Module_Base","MCC_ModuleObjective_FCurator","MCC_ammoBox","MCC_crateAmmo","MCC_crateSupply","MCC_crateFuel", "MCC_Module_addUnitsToZeusCurator", "MCC_Module_ambientCiviliansCurator", "MCC_Module_MCCCASCurator", "MCC_Module_createEvacCurator", "MCC_Module_createIEDCurator", "MCC_Module_createArmedCivilianCurator", "MCC_Module_nightEffectsCurator", "MCC_Module_lockDoorsCurator", "MCC_Module_atmosphereCurator", "MCC_Module_warZoneCurator", "MCC_Module_garrisonBuildingsCurator", "MCC_Module_damagePartCurator", "MCC_Module_vehicleSpawnerCurator", "MCC_Module_campaignInitCurator", "MCC_Module_setResourcesCurator", "MCC_Module_underCoverCurator", "MCC_Module_CapturePointCurator", "MCC_Module_ambientCiviliansCuratorDenied", "MCC_Module_settingsInGameUICurator", "MCC_Module_settingsMedicSystemCurator", "MCC_Module_settingsCurator", "MCC_Module_settingsMechanicsCurator", "MCC_Module_settingsRSCurator", "MCC_Module_ambientBirdsCurator", "MCC_module_ambientFireCurator", "MCC_module_survivalSpawnCratesCurator", "MCC_Module_settingsGAIACurator", "MCC_Module_createIntelCurator", "MCC_Module_LHDSpawnCurator", "MCC_Module_LHDSpawnMenuCurator", "MCC_Module_GAIARespawnsCurator", "MCC_Module_RTSBuildingsCurator", "MCC_Module_PylonsChange", "MCC_Module_medicSetStateCurator", "MCC_Module_createShopCurator", "MCC_Module_addValorCurator", "MCC_Module_cargoLoad", "MCC_Module_AI_assignToZone", "MCC_Module_AAS", "MCC_Module_AASSpawnAI", "MCC_Module_missionWizardCurator", "MCC_Module_artilleryCurator", "MCC_Module_convoyCurator", "MCC_Module_convoyStartCurator", "MCC_Module_airDropCurator", "MCC_Module_reinforcementCurator", "MCC_Module_paradropCurator", "MCC_Module_deleteBrushCurator", "MCC_Module_jukeboxCurator", "MCC_Module_hostageCurator", "MCC_Module_briefingCurator", "MCC_Module_broadcastCurator", "MCC_Module_saveLoadCurator", "MCC_Module_startLocationCurator", "MCC_Module_missionStartCurator", "MCC_Module_arsenalCurator", "MCC_Module_casConsoleCurator"};
		weapons[] = {};
		requiredVersion = 1.00;
		author = "shay_gman";
		versionDesc = "MCC Sandbox 5 curator expansion";
		version = "1";
	};
};

class CfgMods
{
	class mcc_sandbox
	{
		dir = "@mcc_sandbox_a3";
		name = "MCC Sandbox";
		action = "https://mccsandbox.fandom.com/wiki/MCCSandbox_Wiki";
		actionName = "Website";
		tooltip = "MCC Sandbox";
		overview = "Mission Control Center is a powerful game mode that let the ArmA player complete freedom as a mission maker. <br />With MCC you can build complected missions the way you wanted in few minutes and save them as a mission file or in your profile to share with friends. <br />MCC have a dynamic AI system that called GAIA that gives AI more human like tactics while they flank, support and use CAS or artillery.  MCC holds unique mission generator so if you can just push in some variables and MCC will generate a complete random mission set to your play-style and the amount of players and objectives needed. MCC holds much more as unique: IED, CAS, Evac Helicopters aproch, air drops, 3D editor, persistence database for players levels and achievements and many many more.";
		picture = "mcc_sandbox_mod\data\mod.paa";
		logo = "mcc_sandbox_mod\data\mod.paa";
		logoOver = "mcc_sandbox_mod\data\mod.paa";
		logoSmall = "mcc_sandbox_mod\data\mod.paa";
	};
};

//CBA
// NOTE: CBA recommends registering settings in PreInit. MCC still registers them in PostInit because
// several setting callbacks touch the player, UI layers and remoteExec, which are not ready in PreInit.
// Moving this needs in-game testing first.
class Extended_PostInit_EventHandlers {
	class MCC_PostInits {
        init = call compile preprocessFileLineNumbers "mcc_sandbox_mod\XEH_preInit.sqf";
    };
};

class CfgScriptPaths {
	MCC_curatorPath = "\mcc_sandbox_mod\mcc\cfg\curator\scripts\";
};

class CfgFactionClasses
{
	class MCC
	{
		displayName = "(MCC) General";
		priority = 8;
		side = 7;
	};

	class MCC_AI
	{
		displayName = "(MCC) AI";
		priority = 8;
		side = 7;
	};

	class MCC_Ordnance
	{
		displayName = "(MCC) Ordnance";
		priority = 8;
		side = 7;
	};

	class MCC_Vehicles
	{
		displayName = "(MCC) Utility";
		priority = 8;
		side = 7;
	};

	class MCC_Carrier
	{
		displayName = "(MCC) Ships Static";
		priority = 8;
		side = 7;
	};

	class MCC_RTS
	{
		displayName = "(MCC) RTS";
		priority = 8;
		side = 7;
	};

	class MCC_Environment
	{
		displayName = "(MCC) Environment";
		priority = 8;
		side = 7;
	};

	class MCC_PvP
	{
		displayName = "(MCC) PvP";
		priority = 8;
		side = 7;
	};
};

class CfgMissions
{

	class MPMissions
	{
		//Altis
		class MCC_CAMPAIGN_ALTIS
		{
			briefingName = "(MCC) Campaign";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign.Altis";
		};

		class MCC_CAMPAIGN_ALTIS_CSAT
		{
			briefingName = "(MCC) Campaign CSAT";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_CSAT.Altis";
		};

		class MCC_CAMPAIGN_ALTIS_RHS_US
		{
			briefingName = "(MCC RHS) Campaign USA vs RU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_RHS.Altis";
		};

		class MCC_CAMPAIGN_ALTIS_RHS_GRU
		{
			briefingName = "(MCC RHS) Campaign CHDKZ vs USA";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_RHS_GRU.Altis";
		};

		class MCC_CAMPAIGN_ALTIS_RHS_RU
		{
			briefingName = "(MCC RHS) Campaign RU vs USA";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_RHS_RU.Altis";
		};

		//Tanoa
		class MCC_CAMPAIGN_TANOA
		{
			briefingName = "(MCC) Campaign";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign.Tanoa";
		};

		class MCC_CAMPAIGN_TANOA_CSAT
		{
			briefingName = "(MCC) Campaign CSAT";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_CSAT.Tanoa";
		};

		class MCC_PVP_TANOA
		{
			briefingName = "(MCC) PvP";
			directory = "mcc_sandbox_mod\sampleMissions\PvPmine.Tanoa";
		};

		//Malden
		class MCC_CAMPAIGN_NOE_abel
		{
			briefingName = "(MCC) Campaign BAF";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_BAF.abel";
		};

		class MCC_campaign_BAF_Malden
		{
			briefingName = "(MCC) Campaign BAF";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_BAF.Malden";
		};

		//noe
		class MCC_CAMPAIGN_NOE_BAF
		{
			briefingName = "(MCC) Campaign BAF";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_BAF.noe";
		};

		class MCC_CAMPAIGN_NOE_RU
		{
			briefingName = "(MCC) Campaign RU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_RU.noe";
		};

		class MCC_campaign_GU_noe
		{
			briefingName = "(MCC) Campaign GU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_GU.noe";
		};

		//Sara_dbe1
		class MCC_campaign_USMC_Sara_dbe1
		{
			briefingName = "(MCC) Campaign USMC";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_USMC.Sara_dbe1";
		};

		class MCC_campaign_RU_Sara_dbe1
		{
			briefingName = "(MCC) Campaign RU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_RU.Sara_dbe1";
		};

		class MCC_campaign_GU_Sara_dbe1
		{
			briefingName = "(MCC) Campaign GU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_GU.Sara_dbe1";
		};

		//Chernarus
		class MCC_campaign_USMC_Chernarus
		{
			briefingName = "(MCC) Campaign USMC";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_USMC.Chernarus";
		};

		class MCC_campaign_RU_Chernarus
		{
			briefingName = "(MCC) Campaign RU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_RU.Chernarus";
		};

		class MCC_campaign_GU_Chernarus
		{
			briefingName = "(MCC) Campaign GU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_GU.Chernarus";
		};

		//Chernarus summer
		class MCC_campaign_USA_Chernarus_Summer
		{
			briefingName = "(MCC) Campaign USA";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_USA.Chernarus_Summer";
		};

		class MCC_campaign_RU_Chernarus_Summer
		{
			briefingName = "(MCC) Campaign RU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_RU.Chernarus_Summer";
		};

		class MCC_campaign_GU_Chernarus_Summer
		{
			briefingName = "(MCC) Campaign GU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_GU.Chernarus_Summer";
		};

		//Chernarus winter
		class MCC_campaign_USA_Chernarus_Winter
		{
			briefingName = "(MCC) Campaign USA";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_USA.Chernarus_Winter";
		};

		class MCC_campaign_RU_Chernarus_Winter
		{
			briefingName = "(MCC) Campaign RU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_RU.Chernarus_Winter";
		};

		class MCC_campaign_GU_Chernarus_Winter
		{
			briefingName = "(MCC) Campaign GU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_GU.Chernarus_Winter";
		};

		//Takistan
		class MCC_campaign_USA_Takistan
		{
			briefingName = "(MCC) Campaign USA";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_USA.Takistan";
		};

		class MCC_campaign_TK_Takistan
		{
			briefingName = "(MCC) Campaign TK";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_TK.Takistan";
		};

		class MCC_campaign_GU_Takistan
		{
			briefingName = "(MCC) Campaign GU";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_campaign_GU.Takistan";
		};


		class MCC_TEMPLATE_ALTIS
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Altis";
		};

		class MCC_TEMPLATE_Chernarus
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Chernarus";
		};

		class MCC_TEMPLATE_ChernarusSummer
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Chernarus_Summer";
		};

		class MCC_Template_Chernarus_Winter
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\class MCC_Template.Chernarus_Winter";
		};

		class MCC_TEMPLATE_fallujah
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.fallujah";
		};

		class MCC_TEMPLATE_Kunduz
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Kunduz";
		};

		class MCC_TEMPLATE_lingor3
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.lingor3";
		};

		class MCC_TEMPLATE_Mountains_ACR
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Mountains_ACR";
		};

		class MCC_TEMPLATE_Panthera3
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Panthera3";
		};

		class MCC_TEMPLATE_Sara
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Sara";
		};

		class MCC_TEMPLATE_Sara_dbe1
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Sara_dbe1";
		};

		class MCC_TEMPLATE_SaraLite
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.SaraLite";
		};

		class MCC_TEMPLATE_STRATIS
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Stratis";
		};

		class MCC_TEMPLATE_Takistan
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Takistan";
		};

		class MCC_TEMPLATE_Tano
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Tanoa";
		};

		class MCC_TEMPLATE_utes
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.utes";
		};

		class MCC_TEMPLATE_Woodland_ACR
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Woodland_ACR";
		};

		class MCC_TEMPLATE_Zargabad
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Zargabad";
		};

		class MCC_TEMPLATE_Malden
		{
			briefingName = "(MCC) Template";
			directory = "mcc_sandbox_mod\sampleMissions\MCC_Template.Malden";
		};
	};
};

#include "\mcc_sandbox_mod\definesMod.hpp"
// Eden: Attributes > General > MCC. Read at runtime with getMissionConfigValue "MCC_networkSecurity".
// Missions without the mod (mission version) can set MCC_networkSecurity = 1; in description.ext instead.
class Cfg3DEN
{
	class Mission
	{
		class Scenario
		{
			class AttributeCategories
			{
				class MCC_Attributes
				{
					displayName = "MCC";
					collapsed = 1;
					class Attributes
					{
						class MCC_logisticsMode
						{
							displayName = "Limited Logistics";
							tooltip = "Off: unlimited supply as before. Fuel only / Full: supply trucks, crates and vehicle service run out and refill at bases from side resources.";
							property = "MCC_logisticsMode";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Off"; value = 0;};
								class V2 {name = "Fuel only"; value = 1;};
								class V3 {name = "Full (fuel, ammo, repair)"; value = 2;};
							};
						};
						class MCC_MWmaxObjectives
						{
							displayName = "Mission Wizard: Max Objectives";
							tooltip = "Objectives per Mission Wizard mission (extra ones above 3 are random types).";
							property = "MCC_MWmaxObjectives";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "1"; value = 1;};
								class V2 {name = "2"; value = 2;};
								class V3 {name = "3"; value = 3;};
								class V4 {name = "4"; value = 4;};
								class V5 {name = "5"; value = 5;};
								class V6 {name = "6"; value = 6;};
								class V7 {name = "7"; value = 7;};
								class V8 {name = "8"; value = 8;};
							};
						};
						class MCC_MWmissionSize
						{
							displayName = "Mission Wizard: Mission Size";
							tooltip = "Multiplier on the number of enemies.";
							property = "MCC_MWmissionSize";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Small"; value = 0.5;};
								class V2 {name = "Normal"; value = 1;};
								class V3 {name = "Large"; value = 1.75;};
								class V4 {name = "Huge"; value = 2.5;};
							};
						};
						class MCC_MWmaxSpawnedUnits
						{
							displayName = "Mission Wizard: Max Spawned Units";
							tooltip = "Performance cap on units one mission or campaign AO may spawn.";
							property = "MCC_MWmaxSpawnedUnits";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "50"; value = 50;};
								class V2 {name = "100"; value = 100;};
								class V3 {name = "150"; value = 150;};
								class V4 {name = "200"; value = 200;};
								class V5 {name = "300"; value = 300;};
								class V6 {name = "400"; value = 400;};
								class V7 {name = "600"; value = 600;};
							};
						};
						class MCC_campaignMaxAOs
						{
							displayName = "Campaign: Simultaneous AOs";
							tooltip = "How many campaign areas of operation can be active at once.";
							property = "MCC_campaignMaxAOs";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "1"; value = 1;};
								class V2 {name = "2"; value = 2;};
								class V3 {name = "3"; value = 3;};
							};
						};
						class MCC_campaignAOSize
						{
							displayName = "Campaign: AO Size";
							tooltip = "Objective radius (m) of every campaign AO.";
							property = "MCC_campaignAOSize";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "150 m"; value = 150;};
								class V2 {name = "300 m"; value = 300;};
								class V3 {name = "500 m"; value = 500;};
								class V4 {name = "750 m"; value = 750;};
								class V5 {name = "1000 m"; value = 1000;};
								class V6 {name = "1500 m"; value = 1500;};
							};
						};
						class MCC_campaignAmbientCap
						{
							displayName = "Campaign: Ambient Groups Cap";
							tooltip = "Max ambient enemy groups kept around players.";
							property = "MCC_campaignAmbientCap";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "0"; value = 0;};
								class V2 {name = "6"; value = 6;};
								class V3 {name = "12"; value = 12;};
								class V4 {name = "18"; value = 18;};
								class V5 {name = "30"; value = 30;};
								class V6 {name = "45"; value = 45;};
								class V7 {name = "60"; value = 60;};
							};
						};
						class MCC_GAIA_SUPPORT_ENABLED
						{
							displayName = "GAIA: AI Support Requests";
							tooltip = "AI commanders call artillery, CAS and reinforcements on heavy contacts.";
							property = "MCC_GAIA_SUPPORT_ENABLED";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Off"; value = 0;};
								class V2 {name = "On"; value = 1;};
							};
						};
						class MCC_GAIA_SUPPORT_ARTY
						{
							displayName = "GAIA: AI Artillery";
							tooltip = "AI may call mortar/artillery fire missions.";
							property = "MCC_GAIA_SUPPORT_ARTY";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Off"; value = 0;};
								class V2 {name = "On"; value = 1;};
							};
						};
						class MCC_GAIA_SUPPORT_CAS
						{
							displayName = "GAIA: AI Close Air Support";
							tooltip = "AI may call CAS runs.";
							property = "MCC_GAIA_SUPPORT_CAS";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Off"; value = 0;};
								class V2 {name = "On"; value = 1;};
							};
						};
						class MCC_GAIA_SUPPORT_REINF
						{
							displayName = "GAIA: AI Reinforcements";
							tooltip = "AI may call reinforcements when outnumbered.";
							property = "MCC_GAIA_SUPPORT_REINF";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Off"; value = 0;};
								class V2 {name = "On"; value = 1;};
							};
						};
						class MCC_GAIA_COORDINATION
						{
							displayName = "GAIA: Coordinated Attacks";
							tooltip = "Groups split attack, flank, support-by-fire and reserve roles on the same contact.";
							property = "MCC_GAIA_COORDINATION";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Off"; value = 0;};
								class V2 {name = "On"; value = 1;};
							};
						};
						class MCC_GAIA_HC_BALANCE
						{
							displayName = "GAIA: Headless Client Balancing";
							tooltip = "Spread new GAIA groups across all headless clients.";
							property = "MCC_GAIA_HC_BALANCE";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Off"; value = 0;};
								class V2 {name = "On"; value = 1;};
							};
						};
						class MCC_zeusForMCCUsers
						{
							displayName = "Zeus for MCC Users";
							tooltip = "Players allowed to use MCC (MCC Access Rights module, admins, or everyone by default) get Zeus with all MCC modules. Zeus is how MCC is used in MCC5.";
							property = "MCC_zeusForMCCUsers";
							control = "Combo";
							expression = "";
							defaultValue = "-1";
							typeName = "NUMBER";
							class Values
							{
								class V0 {name = "Use addon setting"; value = -1;};
								class V1 {name = "Off"; value = 0;};
								class V2 {name = "On"; value = 1;};
							};
						};
						class MCC_networkSecurity
						{
							displayName = "Network Security";
							tooltip = "Normal: MCC accepts network requests from any player (old behaviour).\nStrict: in multiplayer, MCC ignores requests from players who are not allowed to use MCC (see the MCC Access Rights module). Has no effect in single player.";
							property = "MCC_networkSecurity";
							control = "Combo";
							expression = "";
							defaultValue = "0";
							typeName = "NUMBER";
							class Values
							{
								class Normal {name = "Normal"; value = 0;};
								class Strict {name = "Strict (recommended for public servers)"; value = 1;};
							};
						};
					};
				};
			};
		};
	};
	#include "\mcc_sandbox_mod\mcc\cfg\cfg3DEN.hpp"
};
