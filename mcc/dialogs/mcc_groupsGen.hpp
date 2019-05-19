// By: Shay_gman
// Version: 1.1 (April 2012)
#define groupGen_IDD 2994
#define MCC_MINIMAP 9000
#define MCC_MINIMAPBACK 9001
#define MCC_BACK 9002
#define MCC_FACTION 8008

#define MCCMISSIONMAKERNAME 1020
#define MCCCLIENTFPS 1021
#define MCCSERVERFPS 1022

#define MCCSTOPCAPTURE 1014

//-----------------------------------------------------------------------------
// Main dialog
//-----------------------------------------------------------------------------
class mcc_groupGen
{
	idd = groupGen_IDD;
	movingEnable = true;
	onLoad = __EVAL("_this execVM '"+MCCPATH+"mcc\dialogs\mcc_groupGen_init.sqf'");

	controlsBackground[] =
	{
		mcc_groupGenPic,
		MCC_mapBackground,
		MCC_map,
		MCC_Logo,
		MCC_fram1
	};


	//---------------------------------------------
	objects[] =
	{
	};

	class controls
	{
		//========================================= Controls========================================
		//Tittle
		class MCC_Help: MCC_RscStructuredText
		{
			idc = -1;
			text = "(?)";
			colorBackground[] = { 0, 0, 0, 0.7};
			onMouseEnter = "[_this, true,[13,13],'mccmain'] spawn MCC_fnc_help";

			x = 0.195 * safezoneW + safezoneX;
			y = 0.095 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.033 * safezoneH;
		};

		//Faction
		class mcc_groupGen_factionTittle: MCC_RscText
		{
			idc = -1;

			text = $STR_Faction;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";

			x = 0.184896 * safezoneW + safezoneX;
			y = 0.0601715 * safezoneH + safezoneY;
			w = 0.0458333 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class mcc_groupGen_factionComboBox: MCC_RscCombo
		{
			idc = MCC_FACTION;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			onLBSelChanged = __EVAL("[2] execVM '"+MCCPATH+"mcc\pop_menu\faction.sqf'");

			x = 0.236458 * safezoneW + safezoneX;
			y = 0.0601715 * safezoneH + safezoneY;
			w = 0.114583 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class closeGeneratorButton: MCC_RscButtonMenu
		{
			idc = -1;

			text = $STR_Close;
			action = "closeDialog 0;";

			x = 0.84375 * safezoneW + safezoneX;
			y = 0.796884 * safezoneH + safezoneY;
			w = 0.0916667 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		//Map
		class mcc_groupGen_WestButton: MCC_RscButton
		{
			idc = -1;
			tooltip = $STR_Faction_West_Tip;
			text = $STR_Faction_West;
			colorText[] = {0,0,1,1};
			onButtonClick = __EVAL("[west] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\group_manage.sqf'");

			x = 0.654688 * safezoneW + safezoneX;
			y = 0.565974 * safezoneH + safezoneY;
			w = 0.0458333 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class mcc_groupGen_EastButton: MCC_RscButton
		{
			idc = -1;
			tooltip = $STR_Faction_East_Tip;
			text = $STR_Faction_East;
			colorText[] = {1,0,0,1};
			onButtonClick = __EVAL("[east] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\group_manage.sqf'");

			x = 0.70625 * safezoneW + safezoneX;
			y = 0.565974 * safezoneH + safezoneY;
			w = 0.0458333 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class mcc_groupGen_GuerButton: MCC_RscButton
		{
			idc = -1;
			tooltip = $STR_Faction_Guer_Tip;
			text = $STR_Faction_Guer;
			colorText[] = {0,1,0,1};
			onButtonClick = __EVAL("[resistance] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\group_manage.sqf'");

			x = 0.757813 * safezoneW + safezoneX;
			y = 0.565974 * safezoneH + safezoneY;
			w = 0.0458333 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class mcc_groupGen_CivButton: MCC_RscButton
		{
			idc = -1;
			tooltip = $STR_Faction_Civ_Tip;
			text = $STR_Faction_Civ;
			onButtonClick = __EVAL("[civilian] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\group_manage.sqf'");

			x = 0.809375 * safezoneW + safezoneX;
			y = 0.565974 * safezoneH + safezoneY;
			w = 0.0458333 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class mcc_groupGen_PlayersButton: MCC_RscButton
		{
			idc = -1;
			tooltip = $STR_Faction_Players_Tip;
			onButtonClick = __EVAL("['players'] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\group_manage.sqf'");

			text = $STR_Faction_Players; //--- ToDo: Localize;
			x = 0.603125 * safezoneW + safezoneX;
			y = 0.565974 * safezoneH + safezoneY;
			w = 0.0458333 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class mcc_groupGen_AllButton: MCC_RscButton
		{
			idc = -1;
			tooltip = $STR_Faction_All_Tip;
			onButtonClick = __EVAL("[west,east,resistance,civilian,'players'] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\group_manage.sqf'");

			text = $STR_Faction_All; //--- ToDo: Localize;
			x = 0.551562 * safezoneW + safezoneX;
			y = 0.565974 * safezoneH + safezoneY;
			w = 0.0458333 * safezoneW;
			h = 0.0329871 * safezoneH;
		};



	//---------------------- ZONES --------------------------------
		#include "mcc_groupGenZones.hpp"

	//---------------------------------------- BENCHMARK ----------------------------------------
		class MCC_MissionMakerTittle: MCC_RscText
		{
			idc = -1;
			text = $STR_MCC_Maker;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.3625 * safezoneW + safezoneX;
			y = 0.0161887 * safezoneH + safezoneY;
			w = 0.056 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCC_MissionMakerName: MCC_RscText
		{
			idc = MCCMISSIONMAKERNAME;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.419792 * safezoneW + safezoneX;
			y = 0.0161887 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCC_clientFPSTittle: MCC_RscText
		{
			idc = -1;
			text = $STR_Client_FPS;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.488542 * safezoneW + safezoneX;
			y = 0.0161887 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCC_ServerFPSTittle: MCC_RscText
		{
			idc = -1;
			text = $STR_Server_FPS;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.585938 * safezoneW + safezoneX;
			y = 0.0161887 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCC_clientFPS: MCC_RscText
		{
			idc = MCCCLIENTFPS;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.540104 * safezoneW + safezoneX;
			y = 0.0161887 * safezoneH + safezoneY;
			w = 0.034375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCC_ServerFPS: MCC_RscText
		{
			idc = MCCSERVERFPS;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.6375 * safezoneW + safezoneX;
			y = 0.0161887 * safezoneH + safezoneY;
			w = 0.034375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		//---------------------------------------- BUTTONS ------------------------------------------
		class MCC_stopCapture: MCC_RscButton
		{
			idc = MCCSTOPCAPTURE;
			text = $STR_Trigger_Stop;
			tooltip = $STR_Trigger_Stop_Tip;
			onButtonClick = "ctrlEnable [1014,false];MCC_capture_state=false;";
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";

			x = 0.391146 * safezoneW + safezoneX;
			y = 0.73 * safezoneH + safezoneY;
			w = 0.0744792 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_cacheButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = "if (!isnil 'MCC_GroupGenGroupSelected') then {if (count MCC_GroupGenGroupSelected > 0) then {{_x setVariable ['mcc_gaia_cache', !(_x getVariable ['mcc_gaia_cache',false]),true];}foreach MCC_GroupGenGroupSelected}};";
			tooltip = $STR_Cache_Tip;
			text = $STR_Cache; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.391146 * safezoneW + safezoneX;
			y = 0.631949 * safezoneH + safezoneY;
			w = 0.0744792 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCC_occupyButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = "if (str (getmarkerpos str mcc_active_zone) != str [0,0,0]) then {[str mcc_active_zone] spawn GAIA_fnc_occupy} else {systemchat 'Create a zone first'}";
			tooltip = $STR_Occupy_Tip;
			text = $STR_Occupy; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.391146 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.0744792 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCC_ambientBFButton: MCC_RscButton
		{
			idc = 1015;
			onButtonClick = "_ctrl = _this select 0; if (ctrlText _ctrl == 'Ambient Warzone(on)') then {_ctrl ctrlSetText 'Ambient Warzone(off)';MCC_GAIA_AC = false;} else {_ctrl ctrlSetText 'Ambient Warzone(on)';MCC_GAIA_AC = true}; publicVariable 'MCC_GAIA_AC';";
			tooltip = $STR_Warzone_Tip;
			text = "Ambient Warzone(off)"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.391146 * safezoneW + safezoneX;
			y = 0.698051 * safezoneH + safezoneY;
			w = 0.0744792 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCC_saveLoad: MCC_RscButtonMenu
		{
			idc = -1;
			text = $STR_Save_Load;
			x = 0.746354 * safezoneW + safezoneX;
			y = 0.796884 * safezoneH + safezoneY;
			w = 0.0916667 * safezoneW;
			h = 0.0329871 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			onButtonClick = "if (mcc_missionmaker == (name player)) then {createDialog 'MCC_SaveLoadScreen';} else {player globalchat 'Access Denied'};";
		};

		class MCC_login: MCC_RscButtonMenu
		{
			idc = -1;
			text = $STR_Logout;
			x = 0.648958 * safezoneW + safezoneX;
			y = 0.796884 * safezoneH + safezoneY;
			w = 0.0916667 * safezoneW;
			h = 0.0329871 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			tooltip = $STR_Logout_Tip;
			onButtonClick = "_null = [] spawn MCC_fnc_loginDialog";
		};

		class MCC_ghostMode: MCC_RscButton
		{
			idc = -1;
			text = $STR_Ghost;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			tooltip = $STR_Ghost_Tip;
			onButtonClick = "if (mcc_missionmaker == (name player)) then {if (captive player) then {player setcaptive false;if (MCC_Chat) then {[['Mission maker is no longer cheating'],'MCC_fnc_globalHint',true,false] call BIS_fnc_MP;};} else {player setcaptive true; if (MCC_Chat) then {[['Mission maker is cheating'],'MCC_fnc_globalHint',true,false] spawn BIS_fnc_MP;}};} else {player globalchat 'Access Denied'};";
			x = 0.448438 * safezoneW + safezoneX;
			y = 0.0491758 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_spectator: MCC_RscButton
		{
			idc = -1;
			text = $STR_Spectator;
			tooltip = $STR_Spectator_Tip;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			onButtonClick = __EVAL("[4] execVM '"+MCCPATH+"mcc\Pop_menu\mission_settings.sqf'");

			x = 0.505729 * safezoneW + safezoneX;
			y = 0.0491758 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_Teleport: MCC_RscButton
		{
			idc = -1;
			text = $STR_Teleport;
			tooltip = $STR_Teleport_Tip;
			onButtonClick = "if (mcc_missionmaker == (name player)) then {hint 'Click on the map';onMapSingleClick 'vehicle player setPos _pos;onMapSingleClick '''';true;'} else {player globalchat 'Access Denied'};";

			x = 0.563021 * safezoneW + safezoneX;
			y = 0.0491758 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_MissionWIn: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[5] execVM '"+MCCPATH+"mcc\pop_menu\tasks_req.sqf'");
			text = $STR_Mission_Won; //--- ToDo: Localize;
			colorText[] = {0,1,0,0.8};
			tooltip = STR_Mission_Won_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.3625 * safezoneW + safezoneX;
			y = 0.0491758 * safezoneH + safezoneY;
			w = 0.0630208 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_MissionLost: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[6] execVM '"+MCCPATH+"mcc\pop_menu\tasks_req.sqf'");
			text = $STR_Mission_Fail; //--- ToDo: Localize;
			colorText[] = {1,0,0,0.8};
			tooltip = $STR_Mission_Fail_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.6375 * safezoneW + safezoneX;
			y = 0.0491758 * safezoneH + safezoneY;
			w = 0.0630208 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_openMWButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = "createDialog 'MCCMWDialog'";
			text = $STR_MW_Button;
			tooltip = $STR_MW_Button_Tip;

			x = 0.43125 * safezoneW + safezoneX;
			y = 0.565974 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.0329871 * safezoneH;

		};

		class MCC_toolTipControls:MCC_RscControlsGroup
		{
			idc = -1;
			x = 0.190625 * safezoneW + safezoneX;
			y = 0.697923 * safezoneH + safezoneY;
			w = 0.194792 * safezoneW;
			h = 0.120953 * safezoneH;

			class Controls
			{
				class MCC_toolTip: MCC_RscStructuredText
				{
					idc = 303;
					w = 0.194792 * safezoneW;
					h = 0.5 * safezoneH;
				};
			};
		};

		//Left
		#include "mcc_groupGenLeftButtons.hpp"
		#include "mcc_groupGenSpawn.hpp"
		#include "mcc_groupGenCAS.hpp"
		#include "mcc_groupGenArtillery.hpp"
		#include "mcc_groupGenEvac.hpp"
		#include "mcc_groupGenIED.hpp"
		#include "mcc_groupGenConvoy.hpp"
		#include "mcc_groupGenAirdrop.hpp"
		#include "mcc_groupGenDelete.hpp"

		//Right
		#include "mcc_groupGenRightButtons.hpp"
		#include "mcc_groupGenWeather.hpp"
		#include "mcc_groupGenTime.hpp"
		#include "mcc_groupGenRespawn.hpp"
		#include "mcc_groupGenDebug.hpp"
		#include "mcc_groupGenMarkers.hpp"
		#include "mcc_groupGenBriefings.hpp"
		#include "mcc_groupGenTasks.hpp"
		#include "mcc_groupGenJukebox.hpp"
		#include "mcc_groupGenTriggers.hpp"
		#include "mcc_groupGenCS.hpp"

		#include "mcc_groupGenUM.hpp"
		#include "mcc_groupGenWaypoints.hpp"
		#include "MCC_GroupGenInfo.hpp"
	};

 //========================================= Background========================================
	class mcc_groupGenPic: MCC_RscText
	{
		idc = MCC_BACK;
		text = "";
		colorBackground[] = { 0.051, 0.051, 0.051,1};

		x = 0.0989583 * safezoneW + safezoneX;
		y = 0.0161887 * safezoneH + safezoneY;
		w = 0.845 * safezoneW;
		h = 0.824678 * safezoneH;
	};

//===========================================Map==============================================
	class MCC_mapBackground : MCC_RscText
	{
		idc = MCC_MINIMAPBACK;

		x = 0.190625 * safezoneW + safezoneX;
		y = 0.0931586 * safezoneH + safezoneY;
		w = 0.664583 * safezoneW;
		h = 0.46182 * safezoneH;

		colorBackground[] = { 1, 1, 1, 1};
		colorText[] = { 1, 1, 1, 0};
		text = "";
	};

	class MCC_map : MCC_RscMapControl
	{
		idc = MCC_MINIMAP;

		x = 0.190625 * safezoneW + safezoneX;
		y = 0.0931586 * safezoneH + safezoneY;
		w = 0.664583 * safezoneW;
		h = 0.46182 * safezoneH;

		text = "";
		onMouseButtonDown = __EVAL("[_this] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\mouseDown.sqf'");
		onMouseButtonUp = __EVAL("[_this] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\mouseUp.sqf'");
		onMouseButtonDblClick = __EVAL("[_this] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\mouseDblClick.sqf'");
		onMouseMoving = __EVAL("[_this] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\mouseMoving.sqf'");
	};

	class MCC_Logo: MCC_RscPicture
	{
		idc = -1;
		text = __EVAL(MCCPATH +"data\mccLogo.paa");
		x = 0.104687 * safezoneW + safezoneX;
		y = 0.72 * safezoneH + safezoneY;
		w = 0.0859375 * safezoneW;
		h = 0.109957 * safezoneH;
	};

	class MCC_fram1: MCC_RscText
	{
		idc = -1;
		colorBackground[] = { 0.150, 0.150, 0.150,1};

		x = 0.435833 * safezoneW + safezoneX;
		y = 0.043458 * safezoneH + safezoneY;
		w = 0.189063 * safezoneW;
		h = 0.0439828 * safezoneH;
	};
};

