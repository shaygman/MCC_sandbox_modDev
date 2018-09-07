#define FACTIONCOMBO 1001
#define MCC_MWPlayersIDC 6001
#define MCC_MWATMinesIDC 6002
#define MCC_MWAPMinesIDC 6003
#define MCC_MWStealthIDC 6004
#define MCC_MWReinforcementIDC 6005
#define MCC_MWDifficultyIDC 6006
#define MCC_MWObjective1IDC 6007
#define MCC_MWObjective2IDC 6008
#define MCC_MWObjective3IDC 6009
#define MCC_MWVehiclesIDC 6010
#define MCC_MWArmorIDC 6011
#define MCC_MWIEDIDC 6012
#define MCC_MWSBIDC 6013
#define MCC_MWArmedCiviliansIDC 6014
#define MCC_MWCQBIDC 6015
#define MCC_MWRoadBlocksIDC 6016
#define MCC_MWWeatherComboIDC 6017
#define MCC_MCC_MWAreaComboIDC 6018
#define MCC_MWDebugComboIDC 6019
#define MCC_MWPreciseMarkersComboIDC 6020
#define MCC_MWArtilleryIDC 6021

#define CIVILIANFACTIONCOMBO 6022
#define MCC_MWAnimalsIDC 6023
#define MCC_MWBattleGroundIDC 6024
#define MCC_MCC_MWMusicIDC 6024

class MCC_MWControls: MCC_RscControlsGroup
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

			text = "Rival Faction:"; //--- ToDo: Localize;
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

		//Civilian
		class MCC_MWCivilianFactionTittle: MCC_RscText
		{
			idc = -1;

			text = "Civilians Faction:"; //--- ToDo: Localize;
			x = 0.00572965 * safezoneW;
			y = 0.0879658 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_CivilianfactionCombo: MCC_RscCombo
		{
			idc = CIVILIANFACTIONCOMBO;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'The civilian faction'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.0802087 * safezoneW;
			y = 0.0879658 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		//Players
		class MCC_MWPlayersTittle: MCC_RscText
		{
			idc = -1;

			text = "# Players:"; //--- ToDo: Localize;
			x = 0.00572965 * safezoneW;
			y = 0.120953 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		/*
		class MCC_MWPlayersCombo: MCC_RscCombo
		{
			idc = MCC_MWPlayersIDC;
			onLBSelChanged = "profileNamespace setVariable ['MCC_MWPlayersIndex',_this select 1]";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'More players = more enemies and larger mission area';";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.0802087 * safezoneW;
			y = 0.120953 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		*/

		class MCC_MWPlayersCombo: MCC_RscSlider
		{
			idc = MCC_MWPlayersIDC;
			onSliderPosChanged = "(_this select 0) ctrlSetTooltip str floor (_this select 1);(profileNamespace setVariable ['MCC_MWPlayersIndex',(_this select 1)]);";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'More players = more enemies and larger mission area';";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.0802087 * safezoneW;
			y = 0.120953 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//Difficulty
		class MCC_MWDifficultyTittle: MCC_RscText
		{
			idc = -1;

			text = "Difficulty:"; //--- ToDo: Localize;
			x = 0.00572965 * safezoneW;
			y = 0.15394 * safezoneH;
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
			y = 0.15394 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//CQB
		class MCC_MWCQBTittle: MCC_RscText
		{
			idc = -1;

			text = "CQB:"; //--- ToDo: Localize;
			x = 0.00572965 * safezoneW;
			y = 0.186927 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_MWCQBCombo: MCC_RscCombo
		{
			idc = MCC_MWCQBIDC;
			onLBSelChanged = "profileNamespace setVariable ['MCC_MWCQBIndex',_this select 1]";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Yes means more likely the mission will be set in an urban area with or without enemy units in buildings'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.0802087 * safezoneW;
			y = 0.186927 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//Stealth
		class MCC_MWStealthTittle: MCC_RscText
		{
			idc = -1;

			text = "Stealth:"; //--- ToDo: Localize;
			x = 0.00572965 * safezoneW;
			y = 0.219914 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_MWStealthCombo: MCC_CheckBoxes
		{
			idc = MCC_MWStealthIDC;
			onCheckBoxesSelChanged = "[_this,3,'MCC_MWStealthIndex','profile'] spawn MCC_fnc_checkBox;";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'If set to Yes and the change weather is also set to yes will generate a night time mission with alarms triggers'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			columns = 3;
			rows = 1;
			strings[] = {"Disabled","Enabled","Random"};
			checked_strings[] = {"Disabled","Enabled","Random"};

			x = 0.0802087 * safezoneW;
			y = 0.219914 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};


		//Precise Markers
		class MCC_MWPreciseMarkersText: MCC_RscText
		{
			idc = -1;

			text = "Objectives Markers:"; //--- ToDo: Localize;
			x = 0.00572965 * safezoneW;
			y = 0.252902 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_MWPreciseMarkersCombo: MCC_CheckBoxes
		{
			idc = MCC_MWPreciseMarkersComboIDC;
			onCheckBoxesSelChanged = "[_this,3,'MCC_MWPreciseMarkersIndex','profile'] spawn MCC_fnc_checkBox;";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Will the objectives markers spawn directly on the objective or in the vicinity'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			columns = 2;
			rows = 1;
			strings[] = {"Precise","Area"};
			checked_strings[] = {"Precise","Area"};

			x = 0.0802087 * safezoneW;
			y = 0.252902 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//Debug
		class MCC_MWDebugText: MCC_RscText
		{
			idc = -1;

			text = "General Markers:"; //--- ToDo: Localize;
			x = 0.00572965 * safezoneW;
			y = 0.28589 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_MWDebugCombo: MCC_CheckBoxes
		{
			idc = MCC_MWDebugComboIDC;
			onCheckBoxesSelChanged = "[_this,3,'MCC_MWDebugIndex','profile'] spawn MCC_fnc_checkBox;";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Enable general markers such as artillery markers'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			columns = 2;
			rows = 1;
			strings[] = {"Disabled","Enabled"};
			checked_strings[] = {"Disabled","Enabled"};

			x = 0.0802087 * safezoneW;
			y = 0.28589 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//-------------------------------------------------2 ------------------------------------------------

		//Objective 1
		class MCC_MWObjective1Tittle: MCC_RscText
		{
			idc = -1;

			text = "Objective 1:"; //--- ToDo: Localize;
			x = 0.189063 * safezoneW;
			y = 0.0549788 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_MWObjective1Combo: MCC_RscCombo
		{
			idc = MCC_MWObjective1IDC;
			onLBSelChanged = "profileNamespace setVariable ['MCC_MWObjective1Index',_this select 1]";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Create the 1st objective'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.263542 * safezoneW;
			y = 0.0549788 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};


		//Objective 2
		class MCC_MWObjective2Tittle: MCC_RscText
		{
			idc = -1;

			text = "Objective 2:"; //--- ToDo: Localize;
			x = 0.189063 * safezoneW;
			y = 0.0879658 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_MWObjective2Combo: MCC_RscCombo
		{
			idc = MCC_MWObjective2IDC;
			onLBSelChanged = "profileNamespace setVariable ['MCC_MWObjective2Index',_this select 1]";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Create the 2nd objective (If needed)'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.263542 * safezoneW;
			y = 0.0879658 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};


		//Objective 3
		class MCC_MWObjective3Tittle: MCC_RscText
		{
			idc = -1;

			text = "Objective 3:"; //--- ToDo: Localize;
			x = 0.189063 * safezoneW;
			y = 0.120953 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_MWObjective3Combo: MCC_RscCombo
		{
			idc = MCC_MWObjective3IDC;
			onLBSelChanged = "profileNamespace setVariable ['MCC_MWObjective3Index',_this select 1]";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Create the 2nd objective (If needed)'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.263542 * safezoneW;
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
			x = 0.189063 * safezoneW;
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


			x = 0.263542 * safezoneW;
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
			x = 0.189063 * safezoneW;
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

			x = 0.263542 * safezoneW;
			y = 0.186927 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};



		//Reonforcment
		class MCC_MWReinforcementTittle: MCC_RscText
		{
			idc = -1;

			text = "Reinforcement:"; //--- ToDo: Localize;
			x = 0.189063 * safezoneW;
			y = 0.219914 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_MWReinforcementCombo: MCC_RscCombo
		{
			idc = MCC_MWReinforcementIDC;
			onLBSelChanged = "profileNamespace setVariable ['MCC_MWReinforcementIndex',_this select 1]";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'After a certain amount of enemy units killed a reinforcement will come'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.263542 * safezoneW;
			y = 0.219914 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};



		//Artilllery
		class MCC_MWArtilleryTittle: MCC_RscText
		{
			idc = -1;

			text = "Artillery:"; //--- ToDo: Localize;
			x = 0.189063 * safezoneW;
			y = 0.252902 * safezoneH;
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

			x = 0.263542 * safezoneW;
			y = 0.252902 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//Music
		class MCC_MWMusicText: MCC_RscText
		{
			idc = -1;

			text = "Intro:"; //--- ToDo: Localize;
			x = 0.189063 * safezoneW;
			y = 0.28589 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_MWMusicCombo: MCC_CheckBoxes
		{
			idc = MCC_MCC_MWMusicIDC;
			onCheckBoxesSelChanged = "[_this,3,'MCC_MWMusicIndex','profile'] spawn MCC_fnc_checkBox;";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Play music on start'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			columns = 3;
			rows = 1;
			strings[] = {"Cinematic","Pop-Up","None"};
			checked_strings[] = {"Cinematic","Pop-Up","None"};

			x = 0.263542 * safezoneW;
			y = 0.28589 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//--------------------------------------------------- 3---------------------------------------------------------------------------
		//IED
		class MCC_MWIEDTittle: MCC_RscText
		{
			idc = -1;

			text = "IEDs:"; //--- ToDo: Localize;
			x = 0.372396 * safezoneW;
			y = 0.0549788 * safezoneH;
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

			x = 0.446875 * safezoneW;
			y = 0.0549788 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};


		//Suicide Bomber
		class MCC_MWSBTittle: MCC_RscText
		{
			idc = -1;

			text = "Suicide Bombers:"; //--- ToDo: Localize;
			x = 0.372396 * safezoneW;
			y = 0.0879658 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.65)";
		};

		class MCC_MWSBCombo: MCC_CheckBoxes
		{
			idc = MCC_MWSBIDC;
			onCheckBoxesSelChanged = "[_this,3,'MCC_MWSBIndex','profile'] spawn MCC_fnc_checkBox;";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Spawn some random suicide bombers in the mission area'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			columns = 3;
			rows = 1;
			strings[] = {"Disabled","Enabled","Random"};
			checked_strings[] = {"Disabled","Enabled","Random"};

			x = 0.446875 * safezoneW;
			y = 0.0879658 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//Armmed Civilian
		class MCC_MWArmedCiviliansTittle: MCC_RscText
		{
			idc = -1;

			text = "Armed Civilians:"; //--- ToDo: Localize;
			x = 0.372396 * safezoneW;
			y = 0.120953 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.65)";
		};

		class MCC_MWArmedCiviliansCombo: MCC_CheckBoxes
		{
			idc = MCC_MWArmedCiviliansIDC;
			onCheckBoxesSelChanged = "[_this,3,'MCC_MWArmedCiviliansIndex','profile'] spawn MCC_fnc_checkBox;";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Spawn some random hostile civilians in the mission area'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			columns = 3;
			rows = 1;
			strings[] = {"Disabled","Enabled","Random"};
			checked_strings[] = {"Disabled","Enabled","Random"};

			x = 0.446875 * safezoneW;
			y = 0.120953 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//RoadBlock
		class MCC_MWRoadBlockTittle: MCC_RscText
		{
			idc = -1;

			text = "Roadblocks:"; //--- ToDo: Localize;
			x = 0.372396 * safezoneW;
			y = 0.15394 * safezoneH;
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

			x = 0.446875 * safezoneW;
			y = 0.15394 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//Animals
		class MCC_MWAnimalsText: MCC_RscText
		{
			idc = -1;

			text = "Animals:"; //--- ToDo: Localize;
			x = 0.372396 * safezoneW;
			y = 0.186927 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		class MCC_MWAnimalsCombo: MCC_CheckBoxes
		{
			idc = MCC_MWAnimalsIDC;
			onCheckBoxesSelChanged = "[_this,3,'MCC_MWAnimalsIndex','profile'] spawn MCC_fnc_checkBox;";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Spawn animals on the battlefield'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			columns = 3;
			rows = 1;
			strings[] = {"Disabled","Enabled","Random"};
			checked_strings[] = {"Disabled","Enabled","Random"};

			x = 0.446875 * safezoneW;
			y = 0.186927 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//Weather
		class MCC_MWWeatherText: MCC_RscText
		{
			idc = -1;

			text = "Time/Weather:"; //--- ToDo: Localize;
			x = 0.372396 * safezoneW;
			y = 0.219914 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_MWWeatherCombo: MCC_RscCombo
		{
			idc = MCC_MWWeatherComboIDC;
			onLBSelChanged = "profileNamespace setVariable ['MCC_MWWeatherIndex',_this select 1]";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Will randomly change the weather acording to mission in hand'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			x = 0.446875 * safezoneW;
			y = 0.219914 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};

		//Area
		class MCC_MWAreaText: MCC_RscText
		{
			idc = -1;

			text = "Area:"; //--- ToDo: Localize;
			x = 0.372396 * safezoneW;
			y = 0.252902 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_MWAreaCombo: MCC_CheckBoxes
		{
			idc = MCC_MCC_MWAreaComboIDC;
			onCheckBoxesSelChanged = "[_this,3,'MCC_MWAreaIndex','profile'] spawn MCC_fnc_checkBox;";
			onSetFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText 'Will randomly generate the mission in the specific zone area or the entire map (Choose zone option for ArmA2 maps)'";
			onKillFocus = "((uiNamespace getVariable 'MCC_MWDialog') displayCtrl 0) ctrlSetText ''";

			columns = 2;
			rows = 1;
			strings[] = {"Whole map","Current zone"};
			checked_strings[] =  {"Whole map","Current zone"};

			x = 0.446875 * safezoneW;
			y = 0.252902 * safezoneH;
			w = 0.0859375 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
	};
};
