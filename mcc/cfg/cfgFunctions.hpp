class general
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\general";
	class pre_init
	{
		preInit = 1;
		description = "Pre init mod only";
	};
	#else
	file = "mcc\fnc\general";
	#endif

	class login {};
	class activateAddons {preInit = 1; description = "Pre init addon";};
	class gear	{preInit = 1; description = "Assign gear by roles";};

	class mobileRespawn	{description = "will move the respawn marker to the current position of the unit while the unit is alive, if the unit dead will move the marker to the prvious location.";};
	class buildingPosCount	{description = "return the ammount of indexed positions in a building.";};
	class makeUnitsArray	{description = "returns a unit array consist of all the units from the given function and simulation in format [_cfgclass,_vehicleDisplayName].";};
	class countGroup	{description = "Count the number of infantry, vehicles, tank, air, ships in a group.";};
	class PiPOpen	{description = "Do the transmitting feed animation.";};
	class time2String	{description = "convert time to string.";};
	class time	{description = "convert time to hh:mm:ss.";};
	class setVehicleInit	{description = "Sets vehicle init.";};
	class setVehicleName	{description = "Sets vehicle name.";};
	class setTime	{description = "Setstime on all clients.";};
	class setWeather	{description = "Sets weather  on all clients  - skip time by one hour to make the weather change.";};
	class globalSay3D	{description = "Say sound on 3d on all clients.";};
	class globalHint	{description = "Broadcast a meesege on all clients.";};
	class globalExecute	{description = "Global execute a command on selected clients or server.";};
	class groupChat	{description = "Send chat across MP.";};
	class moveToPos		{description = "move an object to a new location.";};
	class pickItem	{description = "Make a vehicle class item pickable and add variable to it.";};
	class broadcast	{description = "Create a virtual camera and broadcast a short PiP video to all clients for 15 seconds.";};
	class paradrop	{description = "Create a HALO or regular parachute jump for the given unit.";};
	class realParadrop	{description = "Create a HALO or regular parachute jump for the given units with simulation of runing out of an airplane.";};
	class realParadropPlayer	{description = "Handle the paradrop from the unit side.";};
	class countGroupHC	{description = "Count the number of infantry, vehicles, tank, air, ships in a group expand.";};
	class manageWp	{description = "Create and control AI WP on map.";};
	class sync	{description = "Sync the player with the server.";};
	class objectMapper	{description = "Takes an array of data about a dynamic object template and creates the objects.";};
	class findRoadsLeadingZone	{description = "Find Road segments leading to an area.";};
	class nearestRoad	{description = "Return a Road segments array near positions";};
	class garrison	{description = "Populate soldiers inside empty houses";};
	class saveToSQM	{description = "Save MCC's placments in SQM file format and copy it to clipboard";};
	class saveToMCC	{description = "prepare the mcc_output variable";};
	class loadFromMCC	{description = "Load the mcc_output variable";};
	class saveToComp	{description = "Save MCC's 3D editor placments in composition format";};
	class replaceString	{description = "Filter a string and removes certain characters ( _filter)";};
	class dirToString	{description = "Get direction integer and return it as a strin North, east exc";};
	class startLocations	{description = "Teleport the player when start location has been found";};
	class spawnGroup	{description = "MCC Custom group spawning";};
	class keyToName		{description = "get idkKey and return string with his name";};
	class makeBriefing	{description = "Server Only - create a Logic based briefing";};
	class handleAddaction	{description = "Handle addactions after respawn - init";};
	class ppEffects	{description = "Create effects to all players";};
	class SetPitchBankYaw	{};
	class openArtillery {};
	class deleteBrush{};
	class crewCount {description = "return empty seats of a specific vehicle with or without FFV (firing From Vehicles)";};
	class addVelocity {description = "adds velocity to object depends on its current velocity";};
	class makeTask {description = "Handles tasks on the server using BI setTask fnc";};
	class halt {description = "halt all function in game";};
};

class ied
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\ied";
	#else
	file = "mcc\fnc\ied";
	#endif

	class IedFakeExplosion	{description = "Create a fake explosion.";};
	class IedDeadlyExplosion	{description = "Create a deadly explosion.";};
	class IedDisablingExplosion	{description = "Create a disabling explosion.";};
	class ACSingle	{description = "Create an armed civilian at the given position.";};
	class trapSingle	{description = "Create an IED at the given position.";};
	class iedHit		{description = "Determine what will happened when an IED got hit.";};
	class ambushSingle	{description = "Create an ambush group.";};
	class createIED		{description = "Create the IED mechanic.";};
	class manageAmbush	{description = "Manage ambush behavior in a group.";};
	class manageAC		{description = "Manage armed civilian behavior.";};
	class SBSingle		{description = "Place suicide bomber.";};
	class manageSB		{description = "Manage SB bomber behavior.";};
	class mineSingle	{description = "Create a mine field.";};
	class iedSync {};
};

class cas
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\cas";
	#else
	file = "mcc\fnc\cas";
	#endif

	class CreateAmmoDrop	{description = "drop an object from a plane and attach paracute to it, thanks to BIS.";};
	class createPlane		{description = "create a flying plane from the given type and return the plane , pilot and group.";};
	class deletePlane		{description = "set a plane to move to a location and delete it once it come closer then 800 meters.";};
	class airDrop		{description = "Handles CAS and airdrop requests on the server";};
	class uavDetect {};
	class cas {description = "Simulate Zeus CAS with moded vehicles";};
};

class artillery
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\artillery";
	#else
	file = "mcc\fnc\artillery";
	#endif

	class CBU	{description = "drop a bomb that explode to some skeets with paracute the explode to some kind of CBU.";};
	class SADARM	{description = "drop a bomb that explode to some skeets that will search and destroy near by armor.";};
	class artyBomb	{description = "Create artillery strike with sounds on given spot.";};
	class artyFlare	{description = "Create a flare.";};
	class artyDPICM	{description = "Create DPICM artillery barage.";};
	class amb_Art	{description = "Create ambient artillery barage.";};
	class calcSolution	{description = "calculate artillery solution high or low";};
	class artyGetSolution	{description = "Broadcast artillery solution high or low";};
	class consoleFireArtillery	{description = "Broadcast artillery to artillery units";};
	class artillery {};
};

class groupGen
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\groupGen";
	#else
	file = "mcc\fnc\groupGen";
	#endif

	class groupGenRefresh	{description = "Refresh the group gen markers";};
	class groupSpawn		{description = "Create a group on the server";};
	class groupGenUMRefresh	{description = "Refresh the group gen units lists";};
};

class console
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\console";
	#else
	file = "mcc\fnc\console";
	#endif

	class consoleClickGroupIcon	{description = "Define icon behaviot when clicked on the MCC Console";};
};

class mp
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\mp";
	#else
	file = "mcc\fnc\mp";
	#endif

	class vote	{description = "Start a voting process.";};
	class getActiveSides	{description = "Return an array of the active sides in a role selection game.";};
	class PDAcreatemarker	{description = "Creates markers on mp per side and delete them after a period of time";};
	class construction		{description = "Constract a tactical building on the server side";};
	class construct_base	{description = "Constract a building in base";};
	class addRating			{description = "Adds rating to a specific player";};
	class radioSupport		{description = "Broadcast radio support to all elements not including the broadcaster group";};
	class inidbGet	{};
	class inidbSet 	{};
	class handleDB {};
	class saveServer {description = "Save persistent data about the server to the server";};
	class loadServer {description = "Load persistent data about the server from the server";};
	class savePlayer {description = "Save persistent data about the player to the server";};
	class loadPlayer {description = "Load persistent data about the player from the server";};
	class clearPersistentData {description = "Clear all data from saved files";};
};

class actions
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\actions";
	#else
	file = "mcc\fnc\actions";
	#endif

	class ilsChilds		{description = "Handles ILS childs";};
	class dragObject	{description = "Start a dragging animation must be run local on the dragging unit";};
	class releaseObject	{description = "stop a dragging animation must be run local on the dragging unit";};
	class releasePod	{description = "Release a pod from Taru helicopter";};
	class attachPod		{description = "Attach a pod to Taru helicopter";};
	class vault			{description = "Vault over an obstacle";};
	class cover			{description = "Manage cover mechanics";};
	class coverInit		{preInit = 1; description = "Init Cover System";};
	class weaponSelect	{description = "Change weapons and throw utility";};
	class utilityUse	{description = "use utility";};
	class grenadeThrow	{description = "Throw grenades";};
	class pickKit		{description = "pick up dead unit kit";};
	class canAttachPod	{description = "check if can attach pod";};
	class addILSChildrenACE {description = "Add ILS actions to ACE ui";};
	class spotEnemy {description = "spot an enmey from ACE menu";};
	class callSupport {description = "Call support from ACE menu";};
	class callConstruct {description = "Call construct from ACE menu";};
	class resupply {description = "Resupply ammo from an ammo box";};
	class breakdown {description = "Breakdown MCC crate into supplies";};
	class ACEdropAmmobox {description = "Drop MCC ammbox in ACE";};
};

class evac
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\evac";
	#else
	file = "mcc\fnc\evac";
	#endif

	class evacDelete {description = "Delete the given vehicle or it's driver";};
	class evacMove {description = "Move a vehicle to selected WP";};
	class evacSpawn {description = "Spawn a vehicle with crew and gunners, mark it as an evac vehicle";};
	class repairEvac {description = "Repair evac helicopter";};
	class setEvac {description = "Sets an empty ot AI vehicle into an ecav for a specific side";};
	class fastRopeLocal {description = "handles fast rope on clients";};
};

class dynamicDialog
{
	#ifdef MCCMODE
	file = "\mcc_sandbox_mod\mcc\fnc\dynamicDialog";
	#else
	file = "mcc\fnc\dynamicDialog";
	#endif

	class initDynamicDialog {description = "init the dynamic dialog";};
};