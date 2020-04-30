#define MCC_MINIMAP 9000
#define MCCFrontLineDialog_IDD 29891

#define FACTIONCOMBO 1001
#define MCC_MWATMinesIDC 6002
#define MCC_MWAPMinesIDC 6003
#define MCC_MWReinforcementIDC 6005
#define MCC_MWDifficultyIDC 6006
#define MCC_MWVehiclesIDC 6010
#define MCC_MWArmorIDC 6011
#define MCC_MWRoadBlocksIDC 6016
#define MCC_MWDebugComboIDC 6019
#define MCC_MWArtilleryIDC 6021

class MCCFrontLineDialog
{
	idd = MCCFrontLineDialog_IDD;
	movingEnable = true;
	onLoad = __EVAL("_this execVM '"+MCCPATH+"mcc\dialogs\MCCFrontLineDialog_init.sqf'");

	controlsBackground[] =
	{
	};


	//---------------------------------------------
	objects[] =
	{
	};

	class controls
	{
		class MCCMWDialogFrame: MCC_RscText
		{
			idc = -1;
			colorBackground[] = { 0.051, 0.051, 0.051,1};

			x = 0.225 * safezoneW + safezoneX;
			y = 0.11515 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.76 * safezoneH;
		};

		class MCCMWDialoghelptext: MCC_RscStructuredText
		{
			idc = 0;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.6)";

			x = 0.230729 * safezoneW + safezoneX;
			y = 0.445021 * safezoneH + safezoneY;
			w = 0.303646 * safezoneW;
			h = 0.0549786 * safezoneH;
		};

		class MCCMWDialogClose: MCC_RscButtonMenu
		{
			idc = -1;
			text = "Close"; //--- ToDo: Localize;
			action = "MCC_mcc_screen = 2;closeDialog 0;";

			x = 0.694792 * safezoneW + safezoneX;
			y = 0.83 * safezoneH + safezoneY;
			w = 0.0744792 * safezoneW;
			h = 0.0329871 * safezoneH;
		};


		//Generate
		class MCC_MWGenerate: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[0] execVM '"+MCCPATH+"mcc\missionWizard\scripts\missionWizardInit.sqf'");
			text = "Generate Mission"; //--- ToDo: Localize;

			x = 0.45 * safezoneW + safezoneX;
			y = 0.83 * safezoneH + safezoneY;
			w = 0.085 * safezoneW;
			h = 0.0329871 * safezoneH;
			tooltip = "Generate a mission "; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_mapBackground : MCC_RscText
		{
			idc = -1;

			x = 0.230729 * safezoneW + safezoneX;
			y = 0.126146 * safezoneH + safezoneY;
			w = 0.540625 * safezoneW;
			h = 0.318876 * safezoneH;

			colorBackground[] = { 1, 1, 1, 1};
			colorText[] = { 1, 1, 1, 0};
			text = "";
		};

		class MCC_map : MCC_RscMapControl
		{
			idc = MCC_MINIMAP;

			x = 0.230729 * safezoneW + safezoneX;
			y = 0.126146 * safezoneH + safezoneY;
			w = 0.540625 * safezoneW;
			h = 0.318876 * safezoneH;

			text = "";
			onMouseButtonDown = __EVAL("[_this] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\mouseDown.sqf'");
			onMouseButtonUp = __EVAL("[_this] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\mouseUp.sqf'");
			onMouseButtonDblClick = __EVAL("[_this] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\mouseDblClick.sqf'");
			onMouseMoving = __EVAL("[_this] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\mouseMoving.sqf'");
		};

		class MCCMWZoneTittle: MCC_RscText
		{
			idc = -1;
			text = "$STR_UI_ZONE";
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

			x = 0.540104 * safezoneW + safezoneX;
			y = 0.456017 * safezoneH + safezoneY;
			w = 0.0458333 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCCMWZoneCombo: MCC_RscCombo
		{
			idc = 1023;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			onLBSelChanged = __EVAL("[0,0,0] execVM '"+MCCPATH+"mcc\pop_menu\zones.sqf'");

			x = 0.591667 * safezoneW + safezoneX;
			y = 0.456017 * safezoneH + safezoneY;
			w = 0.06 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		class MCCMWZoneUpdateButton: MCC_RscButton
		{
			idc = -1;
			text = "Update Zone";
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
			tooltip = "Click and drag on the minimap to make a zone";
			onButtonClick = "if (mcc_missionmaker == (name player)) then {MCC_zone_drawing= true;} else {player globalchat 'Access Denied'};";

			x = 0.700521 * safezoneW + safezoneX;
			y = 0.456017 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		//--> Controls
		class MCC_FLControls: MCC_RscControlsGroup
		{
			idc = -1;
			x = 0.230729 * safezoneW + safezoneX;
			y = 0.5 * safezoneH + safezoneY;
			w = 0.538542 * safezoneW;
			h = 0.33 * safezoneH;

			class Controls
			{
				class MCC_MWControlsFrame: MCC_RscText
				{
					idc = -1;
					text = "";
					colorBackground[] = { 0.150, 0.150, 0.150,1};

					w = 0.538542 * safezoneW;
					h = 0.32 * safezoneH;
				};

				class MCC_MWTittle: MCC_RscText
				{
					idc = -1;

					text = "Missions Wizard"; //--- ToDo: Localize;
					x = 0.189063 * safezoneW;
					y = 0.0109958 * safezoneH;
					w = 0.15 * safezoneW;
					h = 0.0329871 * safezoneH;
					colorText[] = {0,1,1,1};
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
				};

				//Faction
				class MCC_MWRivalFactionTittle: MCC_RscText
				{
					idc = -1;

					text = "Faction:"; //--- ToDo: Localize;
					x = 0.00572965 * safezoneW;
					y = 0.0549788 * safezoneH;
					w = 0.06875 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				class MCC_factionCombo: MCC_RscCombo
				{
					idc = FACTIONCOMBO;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
					onLBSelChanged = __EVAL("[0] execVM '"+MCCPATH+"mcc\pop_menu\mcc_guiTab1Change.sqf'");
					onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Who are we fighting here'";
					onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

					x = 0.0802087 * safezoneW;
					y = 0.0549788 * safezoneH;
					w = 0.0859375 * safezoneW;
					h = 0.0219914 * safezoneH;
				};

				//Difficulty
				class MCC_MWDifficultyTittle: MCC_RscText
				{
					idc = -1;

					text = "Difficulty:"; //--- ToDo: Localize;
					x = 0.00572965 * safezoneW;
					y = 0.0879658 * safezoneH;
					w = 0.06875 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				class MCC_MWDifficultyCombo: MCC_CheckBoxes
				{
					idc = MCC_MWDifficultyIDC;
					onCheckBoxesSelChanged = "[_this,3,'MCC_MWDifficultyIndex','profile'] spawn MCC_fnc_checkBox;";
					onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Harder difficulty means more enemies'";
					onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

					columns = 3;
					rows = 1;
					strings[] = {"Easy","Medium","Hard"};
					checked_strings[] = {"Easy","Medium","Hard"};

					x = 0.0802087 * safezoneW;
					y = 0.0879658 * safezoneH;
					w = 0.0859375 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};


				//Markers
				class MCC_MWDebugText: MCC_RscText
				{
					idc = -1;

					text = "Markers:"; //--- ToDo: Localize;
					x = 0.00572965 * safezoneW;
					y = 0.120953 * safezoneH;
					w = 0.06875 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};
				class MCC_MWDebugCombo: MCC_CheckBoxes
				{
					idc = MCC_MWDebugComboIDC;
					onCheckBoxesSelChanged = "[_this,3,'MCC_MWDebugIndex','profile'] spawn MCC_fnc_checkBox;";
					onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Front Lines will be marked on the map'";
					onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

					columns = 2;
					rows = 1;
					strings[] = {"Disabled","Enabled"};
					checked_strings[] = {"Disabled","Enabled"};

					x = 0.0802087 * safezoneW;
					y = 0.120953 * safezoneH;
					w = 0.0859375 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				//Cars
				class MCC_MWVehiclesTittle: MCC_RscText
				{
					idc = -1;

					text = "Vehicles:"; //--- ToDo: Localize;
					x = 0.00572965 * safezoneW;
					y = 0.15394 * safezoneH;
					w = 0.06875 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				class MCC_MWVehiclesCombo: MCC_CheckBoxes
				{
					idc = MCC_MWVehiclesIDC;
					onCheckBoxesSelChanged = "[_this,3,'MCC_MWVehiclesIndex','profile'] spawn MCC_fnc_checkBox;";
					onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Will there be vehicles patrolling the area'";
					onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

					columns = 3;
					rows = 1;
					strings[] = {"Disabled","Enabled","Random"};
					checked_strings[] = {"Disabled","Enabled","Random"};


					x = 0.0802087 * safezoneW;
					y = 0.15394 * safezoneH;
					w = 0.0859375 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};


				//Armor
				class MCC_MWArmorTittle: MCC_RscText
				{
					idc = -1;

					text = "Armor:"; //--- ToDo: Localize;
					x = 0.00572965 * safezoneW;
					y = 0.186927 * safezoneH;
					w = 0.06875 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				class MCC_MWArmorCombo: MCC_CheckBoxes
				{
					idc = MCC_MWArmorIDC;
					onCheckBoxesSelChanged = "[_this,3,'MCC_MWArmorIndex','profile'] spawn MCC_fnc_checkBox;";
					onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Will there be armored vehicles patrolling the area'";
					onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

					columns = 3;
					rows = 1;
					strings[] = {"Disabled","Enabled","Random"};
					checked_strings[] = {"Disabled","Enabled","Random"};

					x = 0.0802087 * safezoneW;
					y = 0.186927 * safezoneH;
					w = 0.0859375 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				//Artilllery
				class MCC_MWArtilleryTittle: MCC_RscText
				{
					idc = -1;

					text = "Artillery:"; //--- ToDo: Localize;
					x = 0.00572965 * safezoneW;
					y = 0.219914 * safezoneH;
					w = 0.06875 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				class MCC_MWArtilleryCombo: MCC_RscCombo
				{
					idc = MCC_MWArtilleryIDC;
					onLBSelChanged = "profileNamespace setVariable ['MCC_MWArtilleryIndex',_this select 1]";
					onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Will spawn artillery units to support the enemy units in the area'";
					onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

					x = 0.0802087 * safezoneW;
					y = 0.219914 * safezoneH;
					w = 0.0859375 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				//TODO - minefields
				//--------------------------------------------------- 3---------------------------------------------------------------------------
				//IED
				class MCC_MWIEDTittle: MCC_RscText
				{
					idc = -1;

					text = "minefields:"; //--- ToDo: Localize;
					x = 0.00572965 * safezoneW;
					y = 0.252902 * safezoneH;
					w = 0.06875 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				class MCC_MWIEDCombo: MCC_CheckBoxes
				{
					idc = MCC_MWIEDIDC;
					onCheckBoxesSelChanged = "[_this,3,'MCC_MWIEDIndex','profile'] spawn MCC_fnc_checkBox;";
					onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Spawn random IEDs charges and ambushes in the mission area'";
					onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

					columns = 3;
					rows = 1;
					strings[] = {"Disabled","Enabled","Random"};
					checked_strings[] = {"Disabled","Enabled","Random"};

					x = 0.0802087 * safezoneW;
					y = 0.252902 * safezoneH;
					w = 0.0859375 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				//Bunkers
				class MCC_MWRoadBlockTittle: MCC_RscText
				{
					idc = -1;

					text = "Roadblocks:"; //--- ToDo: Localize;
					x = 0.00572965 * safezoneW;
					y = 0.28589 * safezoneH;
					w = 0.06875 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

				class MCC_MWRoadBlockCombo: MCC_CheckBoxes
				{
					idc = MCC_MWRoadBlocksIDC;
					onCheckBoxesSelChanged = "[_this,3,'MCC_MWRoadBlockIndex','profile'] spawn MCC_fnc_checkBox;";
					onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Generates random roadblock on the way to the mission objectives'";
					onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

					columns = 3;
					rows = 1;
					strings[] = {"Disabled","Enabled","Random"};
					checked_strings[] = {"Disabled","Enabled","Random"};

					x = 0.0802087 * safezoneW;
					y = 0.28589 * safezoneH;
					w = 0.0859375 * safezoneW;
					h = 0.0219914 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
				};

			};
		};

	};
};
