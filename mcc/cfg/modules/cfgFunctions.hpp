class MCCmodules
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\cfg\modules\fnc";
	#else
	file = "mcc\cfg\modules\fnc";
	#endif

	class moduleSector	{description = "Handles Sectors built on BIS Sector by  Karel Moricky.";};
	class accessRights	{description = "Handles access rights to MCC.";};
	class SF			{description = "Defines units as SF.";};
	class moduleObjectiveSectorMCC	{ext = ".fsm";};
	class createRestrictedZones		{description = "create restriction zone around a marker.";};
	class RestrictZoneEffect		{description = "Effect while inside a restricted zone.";};
	class missionSettings {description = "Mission settings";};
	class GAIASettings {description = "GAIA settings";};
	class settingsCover {description = "Cover settings";};
	class settingsMedical {description = "Medical system settings";};
	class moduleCapturePoint {description = "Sets a capture point";};
	class vehicleRespawn {description = "respawn empty vehicles";};
	class inGameUI {description = "Manage inGameUI";};
	class createZonesInit {description = "MCC Zones";};
	class missionSettingsRS {description = "Settings Role Selection";};
	class ModuleObjective_F {description = "Internal module for objectives";};
	class weaponShopInit {description = "init weaponshop";};
	class settingsMissionWizard {description = "Sets default variables for the mission wizard feature of MCC";};
	class moduleMissionWizard {description = "Eden module: generate a Mission Wizard mission at mission start (server)";};
	class moduleConvoy {description = "Eden module: synced vehicles drive as a convoy (server)";};
	class moduleFireMission {description = "Eden module: artillery fire mission on trigger (server)";};
	class moduleMusic {description = "Eden module: music or sound on trigger (server)";};
	class edenGroupGAIA {description = "Eden group attribute: GAIA zone control (server)";};
	class edenZeusEditable {description = "Eden object attribute: add to every curator (server)";};
};