class curator
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\cfg\curator\fnc";
	#else
	file = "mcc\cfg\curator\fnc";
	#endif

	class addToZeus {description = "add units to zeus";};
	class curatorAmbientCivilians {description = "handles the add ambient civilians module";};
	class curatorMCCCAS {description = "MCC CAS in Zeus";};
	class curatorSetEvac {description = "Mark Vehicle as Evac Vehicle";};
	class curatorSetIED {description = "Make item/object/unit an IED";};
	class curatorSetArmedCivilian {description = "Make unit armed civilian";};
	class curatornightEffects {description = "Manage night effects";};
	class curatorDoorLock {description = "Manage doors status";};
	class curatorAtmoshphere {description = "Manage atmosphere";};
	class curatorWarZone {description = "Create war zone effect";};
	class curatorGarrisonUnits {description = "Garrison units in the selected buildings";};
	class curatorDamagePart {description = "Damage part of object/Unit";};
	class curatorVehicleSpawner {description = "Create a vhicles kiosk";};
	class curatorCampaignInit {description = "Starts MCC Campaign";};
	class setResources {description = "Sets resources for each side";};
	class curatorunderCover {description = "Sets player as undercover unit";};
	class curatorModuleCapturePoint {};
	class ambientDenied {};
	class inGameUICurator {description = "setting MCC's UI";};
	class curatorSetIntel {description = "set an item as pickable intel";};
	class curatorLHDSpawn {description = "Spawn LHD";};
	class curatorGAIARespawn {description = "Sets a group or unit to respawns certain number of times";};
	class curatorRTSBuilding {description = "Instantly construct RTS Building";};
	class curatorAddValor {description = "Add Valor/Credit to the selected units";};
	class RscAttributeVehicleCargo {description = "handle the cargo RSC in curator - can't run in uinamespace";};
	class curatorDrawLine {description = "based on the code by PabstMirror for ACE";};

	//Zeus replacements for the old MCC main menu
	class curatorFactionClasses {description = "Zeus helper: public vehicle classes of a faction by kind";};
	class curatorMissionWizard {description = "Zeus module: Mission Wizard";};
	class curatorArtillery {description = "Zeus module: artillery fire mission";};
	class curatorConvoy {description = "Zeus module: spawn a convoy";};
	class curatorConvoyServer {description = "Server: spawn the convoy for the Zeus convoy module";};
	class curatorConvoyStart {description = "Zeus module: send the convoy";};
	class curatorAirDrop {description = "Zeus module: air drop crates/vehicles";};
	class curatorReinforcement {description = "Zeus module: AI reinforcements";};
	class curatorParadrop {description = "Zeus module: paradrop a group or players";};
	class curatorDeleteBrush {description = "Zeus module: delete / area brush";};
	class curatorJukebox {description = "Zeus module: jukebox";};
	class curatorHostage {description = "Zeus module: make a unit a hostage";};
	class curatorMakeHostage {description = "Where the unit is local: make it a hostage";};
	class curatorBriefing {description = "Zeus module: briefing entry";};
	class curatorBriefingLocal {description = "Clients: add a briefing entry from the Zeus module";};
	class curatorBroadcast {description = "Zeus module: broadcast a message";};
	class curatorSaveLoad {description = "Zeus module: open the MCC save/load screen";};
	class curatorStartLocation {description = "Zeus module: start location / FOB";};
	class curatorMissionStart {description = "Zeus module: teleport to start, disable respawn, role selection";};
	class curatorArsenal {description = "Zeus module: arsenal for the Zeus player";};
	class curatorCASConsole {description = "Zeus module: add CAS to a side's commander console";};
	class curatorAutoAssign {postInit = 1; description = "Server: give Zeus to every player allowed to use MCC";};
	class curatorClientInit {postInit = 1; description = "Client: Open Zeus keybind and MCC curator event handlers";};
};