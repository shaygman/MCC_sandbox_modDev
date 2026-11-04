//by Bon_Inf*

#define BON_ARTY_DIALOG 999900
#define BON_ARTY_SHELLSLEFT 999901
#define BON_ARTY_XRAY 999902
#define BON_ARTY_YANKEE 999903
#define BON_ARTY_CANNONLIST 999904
#define BON_ARTY_XRAYEDIT 999905
#define BON_ARTY_YANKEEEDIT 999906
#define BON_ARTY_DIRECTION 999907
#define BON_ARTY_DISTANCE 999908
#define BON_ARTY_HEIGHT 999909
#define BON_ARTY_HEIGHTINDEX 999910
#define BON_ARTY_DELAYEDIT 999911
#define BON_ARTY_SUMMARY 999913
#define BON_ARTY_REQUESTBUTTON 999914
#define BON_ARTY_TYPE 999915
#define BON_ARTY_NRSHELLS 999916
#define BON_ARTY_SPREAD 999917
#define BON_ARTY_XCORRECTION 999918
#define BON_ARTY_YCORRECTION 999919
#define BON_ARTY_ADJUSTBUTTON 999920
#define BON_ARTY_MISSIONTYPE 999921

#define MCC_MINIMAP 9120
#define MCC_ConsoleMapRulerButton 9163
#define MCC_ConsoleMapRulerDir 9164
#define MCC_ConsoleMapRulerDis 9165

class ArtilleryDialog
{
	idd = BON_ARTY_DIALOG;
	movingEnable = true;
	onLoad = "[] spawn MCC_fnc_s_bon_initartillery";

	class controlsBackground
	{
		class mcc_ConsolePic: MCC_RscPicture {
			idc = -1;
			text =  __EVAL(MCCPATH +"data\console.paa");
			x = -0.0446875 * safezoneW + safezoneX;
			y = 0.0939094 * safezoneH + safezoneY;
			w = 1.00406 * safezoneW;
			h = 0.840187 * safezoneH;
		};

		class mcc_ConsoleBackground: MCC_RscText {
			idc = -1;
			text = "";
			colorBackground[] = { 0, 0, 0, 1};
			x = 0.204688 * safezoneW + safezoneX;
			y = 0.2025 * safezoneH + safezoneY;
			w = 0.590625 * safezoneW;
			h = 0.595 * safezoneH;
		};

		class HW_ArtiListBckgrnd : MCC_RscText {
			idc = -1;
			moving = true;
			colorBackground[] = { 0, 0, 0, 0.6 };
			colorText[] = { 1, 1, 1, 0 };
			x = 0.213542 * safezoneW + safezoneX;
			y = 0.588 * safezoneH + safezoneY;
			w = 0.126042 * safezoneW;
			h = 0.209 * safezoneH;
			text = "";
		};
	};

	class controls
	{
		//============================================Buttons==========================================
		class mcc_consoleF1: MCC_RscButton
		{
			idc = 0;
			x = 0.310937 * safezoneW + safezoneX;
			y = 0.829871 * safezoneH + safezoneY;
			w = 0.0229167 * safezoneW;
			h = 0.0329871 * safezoneH;
			text = "F1";
			onButtonClick = "closedialog 0;createDialog 'MCC_playerConsole';";
			tooltip = "Main Menu";
		};
		class mcc_consoleF2: MCC_RscButton
		{
			idc = 1;
			x = 0.339583 * safezoneW + safezoneX;
			y = 0.829871 * safezoneH + safezoneY;
			w = 0.0229167 * safezoneW;
			h = 0.0329871 * safezoneH;
			text = "F2";
			onButtonClick = "closedialog 0;createDialog 'MCC_playerConsole2';";
			tooltip = "UAV Control";
		};
		class mcc_consoleF3: MCC_RscButton
		{
			idc = 2;
			x = 0.368229 * safezoneW + safezoneX;
			y = 0.829871 * safezoneH + safezoneY;
			w = 0.0229167 * safezoneW;
			h = 0.0329871 * safezoneH;
			text = "F3";
			onButtonClick = "closedialog 0;createDialog 'MCC_playerConsole3';";
			tooltip = "AC-130 Control";
		};
		class mcc_consoleF4: MCC_RscButton
		{
			idc = 3;
			x = 0.396875 * safezoneW + safezoneX;
			y = 0.829871 * safezoneH + safezoneY;
			w = 0.0229167 * safezoneW;
			h = 0.0329871 * safezoneH;
			text = "F4";
			tooltip = "Forward observer artillery's interface";
			onButtonClick = "nul=[0,0,0,[1]] spawn MCC_fnc_s_conoleOpenMenu";
		};
		class mcc_consoleF5: MCC_RscButton
		{
			idc = 4;
			x = 0.425521 * safezoneW + safezoneX;
			y = 0.829871 * safezoneH + safezoneY;
			w = 0.0229167 * safezoneW;
			h = 0.0329871 * safezoneH;
			text = "F5";
			tooltip = "Open RTS interface";
			onButtonClick ="while {dialog} do {closeDialog 0}; createDialog 'MCC_LOGISTICS_BASE_BUILD'";
		};
		class mcc_consoleF6: MCC_RscButton
		{
			idc = -1;
			x = 0.454167 * safezoneW + safezoneX;
			y = 0.829871 * safezoneH + safezoneY;
			w = 0.0229167 * safezoneW;
			h = 0.0329871 * safezoneH;
			text = "F6";
			tooltip = "Fleet Management";
			onButtonClick ="while {dialog} do {closeDialog 0}; [0,0,0] spawn MCC_fnc_LHDspawnMenuInit";
		};
		class MCC_ConsoleExitButton: MCC_RscButton {
		idc = -1;
		text = "";
		x = 0.480312 * safezoneW + safezoneX;
		y = 0.822072 * safezoneH + safezoneY;
		w = 0.0328125 * safezoneW;
		h = 0.0420094 * safezoneH;
		colorBackground[] = {0,0,0,0};
		colorFocused[] = {1,1,1,0.2};
		colorShadow[] = { 0, 0, 0, 0};
		colorBorder[] = { 0, 0, 0, 0 };
		colorBackgroundActive[] = {0,0,0,0};
		colorDisabled[] = {0,0,0,0};
		colorBackgroundDisabled[] = {0,0,0,0};
		tooltip = "Close the conosle";
		onButtonClick = "closedialog 0;";
		};
		class HW_ArtiTextField : MCC_RscText {
			idc = -1;
			style = MCCST_LEFT;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = { 1, 1, 1, 1 };
			x = 0.351042 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0275 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "";
		};
		class HW_ArtiInstructions : HW_ArtiTextField {
			idc = BON_ARTY_SUMMARY;
			style = MCCST_MULTI;
			linespacing = 1.00000;
			x = 0.213542 * safezoneW + safezoneX;
			y = 0.214 * safezoneH + safezoneY;
			w = 0.131771 * safezoneW;
			h = 0.21395 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "Always use 'Cancel' to unregister without actually executing a fire mission.\n\n\n\n\n\n\n\n\n\n\n\n\n\nWritten by Bon_Inf*.";
		};
		class HW_ArtiShellsLeft : HW_ArtiTextField
		{
			idc = BON_ARTY_SHELLSLEFT;
			text = "Shells left: 0815";
		};
		class HW_Articoord : HW_ArtiTextField
		{
			x = 0.351042 * safezoneW + safezoneX;
			y = 0.28 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.022 * safezoneH;
			text = "Your current position:";
		};
		class HW_ArtiXcoord : HW_ArtiTextField
		{
			idc = BON_ARTY_XRAY;
			style = MCCST_RIGHT;
			x = 0.351042 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.0802083 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class HW_ArtiYcoord : HW_ArtiTextField
		{
			idc = BON_ARTY_YANKEE;
			style = MCCST_RIGHT;
			x = 0.351042 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.0802083 * safezoneW;
			h = 0.0275 * safezoneH;
		};


		class HW_ArtiCannonList : MCC_RscListbox
		{
			idc = BON_ARTY_CANNONLIST;
			style = MCCLB_MULTI;
			default = 1;
			x = 0.213542 * safezoneW + safezoneX;
			y = 0.58536 * safezoneH + safezoneY;
			w = 0.126042 * safezoneW;
			h = 0.209 * safezoneH;
			onLBSelChanged = "_this call arti_dlgUpdate";
			onLBDblClick = "";
			rowHeight = 0.04;
			maxHistoryDelay = 10;
			canDrag = 0;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			xcolumn1 = "0.1f";
			xcolumn2 = "0.25f";
			xcolumn3 = "0.85f";
		};


		class HW_ArtiXcoordunit : MCC_RscText
		{
			idc = BON_ARTY_XRAYEDIT;
			type = MCCCT_EDIT;
			style = MCCST_LEFT;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = { 1, 1, 1, 1 };
			colorSelection[] = { 1, 1, 1, 1 };
			colorBorder[] = { 1, 1, 1, 1 };
			BorderSize = 0.01;
			autocomplete = false;
			x = 0.585938 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.0401042 * safezoneW;
			h = 0.022 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "";
		};
		class HW_ArtiYcoordunit : HW_ArtiXCoordunit
		{
			idc = BON_ARTY_YANKEEEDIT;
			x = 0.585938 * safezoneW + safezoneX;
			y = 0.28 * safezoneH + safezoneY;
			w = 0.0401042 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class HW_ArtiDirection : HW_ArtiXCoordunit
		{
			idc = BON_ARTY_DIRECTION;
			x = 0.585938 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.0401042 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class HW_ArtiDistance : HW_ArtiXCoordunit
		{
			idc = BON_ARTY_DISTANCE;
			x = 0.585938 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.0401042 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class HW_ArtiXCoordUnitDescr : HW_ArtiXcoordunit
		{
			idc = -1;
			type = MCCCT_STATIC;
			x = 0.511458 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.022 * safezoneH;
			text = "x-ray";
		};
		class HW_ArtiYCoordUnitDescr : HW_ArtiXCoordUnitDescr
		{
			x = 0.511458 * safezoneW + safezoneX;
			y = 0.28 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.022 * safezoneH;
			text = "yankee";
		};
		class HW_ArtiDirDescr : HW_ArtiXCoordUnitDescr
		{
			x = 0.511458 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.022 * safezoneH;
			text = "direction";
		};
		class HW_ArtiDistDescr : HW_ArtiXCoordUnitDescr
		{
			x = 0.511458 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.06875 * safezoneW;
			h = 0.022 * safezoneH;
			text = "distance";
		};

		class HW_ArtiHeightSlider : MCC_RscSlider
		{
			style = MCCCT_SL_VERT;
			idc = BON_ARTY_HEIGHT;
			x = 0.660417 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.0160417 * safezoneW;
			h = 0.165 * safezoneH;
		};
		class HW_ArtiSliderTitle : MCC_RscText
		{
			idc = -1;
			style = MCCST_MULTI;
			linespacing = 1.00000;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = { 1, 1, 1, 1 };
			x = 0.643229 * safezoneW + safezoneX;
			y = 0.258 * safezoneH + safezoneY;
			w = 0.01375 * safezoneW;
			h = 0.099 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "Height";
		};
		class HW_ArtiSliderDescr : MCC_RscText
		{
			idc = BON_ARTY_HEIGHTINDEX;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = { 1, 1, 1, 1 };

			x = 0.6375 * safezoneW + safezoneX;
			y = 0.368 * safezoneH + safezoneY;
			w = 0.020625 * safezoneW;
			h = 0.0275 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "";
		};

		class HW_ArtiType : MCC_RscCombo
		{
			idc = BON_ARTY_TYPE;
			style = MCCST_LEFT;
			colorText[] = { 1, 1, 1, 1 };
			colorSelect[] = { 1.0, 0.35, 0.3, 1 };
			colorSelectBackground[] = { 0, 0, 0, 1 };
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			onLBSelChanged = "_this call arti_dlgUpdate";
			x = 0.27 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.08 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class HW_ArtiNrShells : HW_ArtiType
		{
			idc = BON_ARTY_NRSHELLS;
			x = 0.27 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.08 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class HW_ArtiSpread : HW_ArtiType
		{
			idc = BON_ARTY_SPREAD;
			x = 0.27 * safezoneW + safezoneX;
			y = 0.511 * safezoneH + safezoneY;
			w = 0.08 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class HW_ArtiMission : HW_ArtiType
		{
			idc = BON_ARTY_MISSIONTYPE;
			x = 0.27 * safezoneW + safezoneX;
			y = 0.544 * safezoneH + safezoneY;
			w = 0.08 * safezoneW;
			h = 0.022 * safezoneH;
		};

		class HW_ArtiTypeTitle : MCC_RscText
		{
			idc = -1;
			style = MCCST_LEFT;
			colorBackground[] = { 1, 1, 1, 0 };
			colorText[] = { 1, 1, 1, 1 };
			x = 0.219271 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.022 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "Type:";
		};
		class HW_ArtiNrShellsTitle : HW_ArtiTypeTitle
		{
			x = 0.219271 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.022 * safezoneH;
			text = "Nr. Shells:";
		};
		class HW_ArtiSpreadTitle : HW_ArtiTypeTitle
		{
			x = 0.219271 * safezoneW + safezoneX;
			y = 0.511 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.022 * safezoneH;
			text = "Spread:";
		};
		class HW_ArtiMissionTitle : HW_ArtiTypeTitle
		{
			x = 0.219271 * safezoneW + safezoneX;
			y = 0.544 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.022 * safezoneH;
			text = "Fire:";
		};



		class HW_ArtiDelayDescr : HW_ArtiTextField
		{
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.022 * safezoneH;
			text = "delay in sec.";
		};
		class HW_ArtiDelayunit : HW_ArtiXCoordunit
		{
			idc = BON_ARTY_DELAYEDIT;
			x = 0.454167 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class HW_ArtiConfirmButton : MCC_RscButton
		{
			idc = -1;
			colorDisabled[] = {1, 0.4, 0.3, 0.8};
			x = 0.442708 * safezoneW + safezoneX;
			y = 0.555 * safezoneH + safezoneY;
			w = 0.0630208 * safezoneW;
			h = 0.022 * safezoneH;
			size = 0.02821;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "Confirm";
			onButtonClick = "[] spawn MCC_fnc_s_bon_arti_setup";
		};
		class HW_ArtiClearButton : HW_ArtiConfirmButton
		{
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.555 * safezoneH + safezoneY;
			w = 0.0630208 * safezoneW;
			h = 0.022 * safezoneH;
			text = "Reset";
			onButtonClick = "[] spawn MCC_fnc_s_bon_arti_clearcannons";
		};
		class HW_artiCoordApplyButton : MCC_RscButton
		{
			idc = -1;
			x = 0.436979 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.066 * safezoneH;
			text = "Copy Position";
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
			onButtonClick = "[] spawn MCC_fnc_s_apply_pos";
		};

		class HW_RequestButton : MCC_RscButton
		{
			idc = BON_ARTY_REQUESTBUTTON;
			colorDisabled[] = {1, 0.4, 0.3, 0.8};
			x = 0.442708 * safezoneW + safezoneX;
			y = 0.742 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.055 * safezoneH;
			text = "Execute";
			onButtonClick = "player spawn MCC_fnc_s_bon_arti_request";
		};
		class HW_CancelButton : HW_RequestButton
		{
			idc = -1;
			x = 0.345313 * safezoneW + safezoneX;
			y = 0.742 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.055 * safezoneH;
			text = "Cancel";
			onButtonClick = "player spawn MCC_fnc_s_bon_arti_cancle";
		};


		class HW_ArtiXCorrTitle : HW_ArtiTextField
		{
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.511 * safezoneH + safezoneY;
			w = 0.0916667 * safezoneW;
			h = 0.0275 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "Corr. left-right";
		};
		class HW_ArtiRightCorrection : MCC_RscButton
		{
			idc = -1;
			x = 0.494271 * safezoneW + safezoneX;
			y = 0.511 * safezoneH + safezoneY;
			w = 0.0114583 * safezoneW;
			h = 0.022 * safezoneH;
			text = ">";
			onButtonClick = "'Right' spawn MCC_fnc_s_bon_arti_correction";
		};
		class HW_ArtiXCorrectionunit : HW_ArtiXCoordunit
		{
			idc = BON_ARTY_XCORRECTION;
			style = MCCST_CENTER;
			x = 0.465625 * safezoneW + safezoneX;
			y = 0.511 * safezoneH + safezoneY;
			w = 0.0286458 * safezoneW;
			h = 0.022 * safezoneH;
			text = "0";
		};
		class HW_ArtiLeftCorrection : HW_ArtiRightCorrection
		{
			x = 0.454167 * safezoneW + safezoneX;
			y = 0.511 * safezoneH + safezoneY;
			w = 0.0114583 * safezoneW;
			h = 0.022 * safezoneH;
			text = "<";
			onButtonClick = "'Left' spawn MCC_fnc_s_bon_arti_correction";
		};

		class HW_ArtiYCorrTitle : HW_ArtiTextField
		{
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0916667 * safezoneW;
			h = 0.0275 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			text = "Corr. distance";
		};
		class HW_ArtiUpCorrection : HW_ArtiRightCorrection
		{
			x = 0.494271 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0114583 * safezoneW;
			h = 0.022 * safezoneH;
			text = "+";
			onButtonClick = "'Up' spawn MCC_fnc_s_bon_arti_correction";
		};
		class HW_ArtiYCorrectionunit : HW_ArtiXCoordunit
		{
			idc = BON_ARTY_YCORRECTION;
			style = MCCST_CENTER;
			x = 0.465625 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0286458 * safezoneW;
			h = 0.022 * safezoneH;
			text = "0";
		};
		class HW_ArtiDownCorrection : HW_ArtiRightCorrection
		{
			x = 0.454167 * safezoneW + safezoneX;
			y = 0.478 * safezoneH + safezoneY;
			w = 0.0114583 * safezoneW;
			h = 0.022 * safezoneH;
			text = "-";
			onButtonClick = "'Down' spawn MCC_fnc_s_bon_arti_correction";
		};

		class MCC_mapBackground : MCC_RscPicture
		{
			idc = -1;
			x = 0.517188 * safezoneW + safezoneX;
			y = 0.412 * safezoneH + safezoneY;
			w = 0.275 * safezoneW;
			h = 0.352 * safezoneH;
		};

		class MCC_mapConsole : MCC_RscMapControl
		{
			idc = MCC_MINIMAP;
			moving = true;
			colorBackground[] = { 1, 1, 1, 1};
			colorText[] = { 1, 1, 1, 0};
			x = 0.517188 * safezoneW + safezoneX;
			y = 0.412 * safezoneH + safezoneY;
			w = 0.275 * safezoneW;
			h = 0.352 * safezoneH;
			onMouseButtonDown = "[_this] spawn MCC_fnc_s_console_mouseDown";
			onMouseButtonUp = "[_this] spawn MCC_fnc_s_console_mouseUp";
			onMouseMoving = "[_this] spawn MCC_fnc_s_console_mouseMoving";
		};

		class MCC_ConsoleMapRulerButton: MCC_RscButton
		{
			idc = MCC_ConsoleMapRulerButton;
			text = "Ruler";
			tooltip = "Activate the map ruler - left click on the map and drag from one point to another to measure distance and direction";
			x = 0.626042 * safezoneW + safezoneX;
			y = 0.764 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.033 * safezoneH;
			onButtonClick =  "MCC_ConsoleRuler = true";
		};

		class MCC_ConsoleMapRulerDir: MCC_RscText
		{
			idc = MCC_ConsoleMapRulerDir;
			text = "Direction:";
			x = 0.517188 * safezoneW + safezoneX;
			y = 0.764 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class MCC_ConsoleMapRulerDis: MCC_RscText
		{
			idc = MCC_ConsoleMapRulerDis;
			text = "Distance:";
			x = 0.689063 * safezoneW + safezoneX;
			y = 0.764 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.033 * safezoneH;
		};
	};
};