//==================================================================================================================================================================
// Zeus modules that replace the old MCC main menu (mcc_groupGen / Mission Wizard dialogs). All run their dialog on the Zeus
// player's machine (MCC_fnc_initDynamicDialog) and delete themselves.
//==================================================================================================================================================================
class MCC_Module_missionWizardCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Mission Wizard";
	function = "MCC_fnc_curatorMissionWizard";
	portrait = "\A3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa";
};

class MCC_Module_artilleryCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Artillery Fire Mission";
	function = "MCC_fnc_curatorArtillery";
	portrait = "\A3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa";
};

class MCC_Module_convoyCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Convoy - Spawn";
	function = "MCC_fnc_curatorConvoy";
};

class MCC_Module_convoyStartCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Convoy - Drive To";
	function = "MCC_fnc_curatorConvoyStart";
};

class MCC_Module_airDropCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Air Drop (Crates/Vehicles)";
	function = "MCC_fnc_curatorAirDrop";
};

class MCC_Module_reinforcementCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Reinforcements (Air/Motorized)";
	function = "MCC_fnc_curatorReinforcement";
};

class MCC_Module_paradropCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Paradrop Units/Players";
	function = "MCC_fnc_curatorParadrop";
};

class MCC_Module_deleteBrushCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Delete / Area Brush";
	function = "MCC_fnc_curatorDeleteBrush";
};

class MCC_Module_jukeboxCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Jukebox";
	function = "MCC_fnc_curatorJukebox";
};

class MCC_Module_hostageCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Make Hostage";
	function = "MCC_fnc_curatorHostage";
	portrait = "\A3\ui_f\data\igui\cfg\simpleTasks\types\help_ca.paa";
};

class MCC_Module_briefingCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Briefing";
	function = "MCC_fnc_curatorBriefing";
};

class MCC_Module_broadcastCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Broadcast Message";
	function = "MCC_fnc_curatorBroadcast";
};

class MCC_Module_saveLoadCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Save / Load Mission";
	function = "MCC_fnc_curatorSaveLoad";
};

class MCC_Module_startLocationCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Start Location / FOB";
	function = "MCC_fnc_curatorStartLocation";
};

class MCC_Module_missionStartCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Respawn / Mission Start";
	function = "MCC_fnc_curatorMissionStart";
};

class MCC_Module_arsenalCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "Arsenal (Zeus Player)";
	function = "MCC_fnc_curatorArsenal";
};

class MCC_Module_casConsoleCurator : MCC_Module_Base
{
	scopeCurator = 2;
	category = "MCC";
	displayName = "CAS for Commander Console";
	function = "MCC_fnc_curatorCASConsole";
};
