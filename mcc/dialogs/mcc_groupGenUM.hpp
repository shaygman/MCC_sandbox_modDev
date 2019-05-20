#define MCC_UM_LIST 3069
#define MCC_UM_PIC 3070
#define MCC_UM_KICK 3076
#define MCC_UM_BAN 3077

class MCC_UMDialogControls:MCC_RscControlsGroup
{
	idc = 519;
	x = 0.471354 * safezoneW + safezoneX;
	y = 0.620953 * safezoneH + safezoneY;
	w = 0.469792 * safezoneW;
	h = 0.164936 * safezoneH;

	class Controls
	{
		class MCC_UMDialogControlsFrame: MCC_RscText
		{
			idc = -1;
			text = "";
			colorBackground[] = { 0.120, 0.120, 0.120,1};
			
			w = 0.469792 * safezoneW;
			h = 0.164936 * safezoneH;
		};
		
		class MCC_UMList: MCC_RscListbox
		{
			idc = MCC_UM_LIST;
			rowHeight = 0.022;
			style = MCCLB_MULTI;
			colorBackground[] = { 0, 0, 0,1};
			onSetFocus = "MCC_UMFocus = true";	
			onKillFocus = "MCC_UMFocus = false";	
			onLBSelChanged = __EVAL("[4] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");
			onMouseButtonUp = __EVAL("[8,_this] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";

			x = 0.00572965 * safezoneW;
			y = 0.0439828 * safezoneH;
			w = 0.160417 * safezoneW;
			h = 0.109957 * safezoneH;
		};
		class MCC_UMUnits: MCC_RscToolbox
		{
			idc = -1;
			strings[] = {$STR_Units,$STR_Groups};
			rows = 1;
			columns = 2;
			values[] = {0,1};
			onToolBoxSelChanged = "MCC_UMUnit = (_this select 1);";

			x = 0.00572965 * safezoneW;
			y = 0.0109958 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Units_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMTeleport: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL ("[0] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Teleport; //--- ToDo: Localize;
			x = 0.171875 * safezoneW;
			y = 0.0329868 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Menu_Teleport_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMHijak: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL ("[2] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Hijack; //--- ToDo: Localize;
			x = 0.171875 * safezoneW;
			y = 0.0989618 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Hijack_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMMark: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL ("[3] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Track; //--- ToDo: Localize;
			x = 0.171875 * safezoneW;
			y = 0.131949 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Track_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMbroadcast: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL ("[11] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Broadcast; //--- ToDo: Localize;
			x = 0.171875 * safezoneW;
			y = 0.0659738 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Broadcast_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMDelete: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL ("[12] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Delete; //--- ToDo: Localize;
			x = 0.234896 * safezoneW;
			y = 0.0659738 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Delete_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMJoin: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL ("[13] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Join; //--- ToDo: Localize;
			x = 0.234896 * safezoneW;
			y = 0.0329868 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Join_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMHALO: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL ("[9] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_HALO; //--- ToDo: Localize;
			x = 0.234896 * safezoneW;
			y = 0.131949 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_HALO_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMParachute: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL ("[10] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Parachute; //--- ToDo: Localize;
			x = 0.234896 * safezoneW;
			y = 0.0989618 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Parachute_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMKick: MCC_RscButton
		{
			idc = MCC_UM_KICK;
			onButtonClick = __EVAL ("[15] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Kick; //--- ToDo: Localize;
			x = 0.171875 * safezoneW;
			y = 1.63913e-008 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Kick_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMBan: MCC_RscButton
		{
			idc = MCC_UM_BAN;
			onButtonClick = __EVAL ("[16] execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um.sqf'");

			text = $STR_Ban; //--- ToDo: Localize;
			x = 0.234896 * safezoneW;
			y = 1.63913e-008 * safezoneH;
			w = 0.0515625 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = $STR_Ban_Tip; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
		class MCC_UMListFrame: MCC_RscFrame
		{
			idc = -1;

			x = 0.00572965 * safezoneW;
			y = 0.0439828 * safezoneH;
			w = 0.160417 * safezoneW;
			h = 0.109957 * safezoneH;
		};
		class MCC_UMhint: MCC_RscText
		{
			idc = -1;

			text = $STR_Group_Tip; //--- ToDo: Localize;
			x = 0.0791667 * safezoneW;
			y = 0.0109958 * safezoneH;
			w = 0.0916667 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.55)";
		};
		class MCC_PIPUm: MCC_RscPicture
		{
			idc = MCC_UM_PIC;
			colorBackground[] = { 0, 0, 0,1};
			
			text = "#(argb,256,256,1)r2t(rendertarget10,1.0);"; //--- ToDo: Localize;
			x = 0.292188 * safezoneW;
			y = 0.0109958 * safezoneH;
			w = 0.171875 * safezoneW;
			h = 0.120953 * safezoneH;
		};
		class MCC_PIPUmFrame: MCC_RscFrame
		{
			idc = -1;

			x = 0.292188 * safezoneW;
			y = 0.0109958 * safezoneH;
			w = 0.171875 * safezoneW;
			h = 0.120953 * safezoneH;
		};
		class MCC_PIPviewMod: MCC_RscToolbox
		{
			idc = -1;
			strings[] = {$STR_Vision_Regular,$STR_Vision_NV,$STR_Vision_Thermal};
			rows = 1;
			columns = 3;
			values[] = {0,1,3};
			onToolBoxSelChanged = __EVAL("_this execVM '"+MCCPATH+"mcc\general_scripts\unitManage\um_camView.sqf'");

			x = 0.292188 * safezoneW;
			y = 0.134808 * safezoneH;
			w = 0.171875 * safezoneW;
			h = 0.0219914 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
		};
	};
};
