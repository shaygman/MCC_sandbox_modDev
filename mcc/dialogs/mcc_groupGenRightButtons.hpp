#define MCC_buttonsSpace 0.0769695
class MCC_rightButtonsControls: MCC_RscControlsGroup
{
	idc = -1;
	x = 0.860938 * safezoneW + safezoneX;
	y = 0.0711672 * safezoneH + safezoneY;
	w = 0.0802083 * safezoneW;
	h = 0.53879 * safezoneH;

	class Controls
	{	
		class MCC_rightButtonsControlsFrame: MCC_RscText
		{
			idc = -1;
			text = "";
			w = 0.0802083 * safezoneW;
			h = 0.53879 * safezoneH;
			colorBackground[] = { 0.150, 0.150, 0.150,1};
		};
		
		class MCC_MissionSettings: MCC_RscButton
		{
			idc = -1;
			text = "$STR_UI_MISSIONSETTINGS";
			tooltip = "$STR_UI_MISSIONSETTINGSDESC"; //--- ToDo: Localize;
			onButtonClick = "if (mcc_missionmaker == (name player)) then {createDialog 'missionSettings';} else {player globalchat 'Access Denied'};";
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.0109958271253347 * safezoneH;	
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};
		class MCC_StartDisableRespawn: MCC_RscButton
		{
			idc = 2;
			text = "$STR_UI_DISRESPAWN"; 
			colorText[] = {1,1,1,1};
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			tooltip = "$STR_UI_DISRESPAWNDESC"; 
			action = __EVAL("[4] execVM '"+MCCPATH+"mcc\general_scripts\mcc_start_location.sqf'");
			
			x = 0.0057 * safezoneW;
			y = 0.054978585840815 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};
				
		class MCC_setWeatherButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[0] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_SETWEATH"; //--- ToDo: Localize;
			tooltip = "$STR_UI_SETWEATHDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.0989620042993254 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_setTimeButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[1] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_SETTIME"; //--- ToDo: Localize;
			tooltip = "$STR_UI_SETTIMEDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.1429437734002606 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_StartLocation: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[2] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_STARTLOC"; //--- ToDo: Localize;
			tooltip = "$STR_UI_STARTLOCDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.1869266420729126 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;		
		};

		class MCC_debugButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[3] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_DEBUG"; //--- ToDo: Localize;
			tooltip = "$STR_UI_DEBUGDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.2309084111738478 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_markersCallButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[10] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_MARKERS"; //--- ToDo: Localize;
			tooltip = "$STR_UI_MARKERSDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.274890180274783 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_briefingCallButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[11] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_BRIEFING"; //--- ToDo: Localize;
			tooltip = "$STR_UI_BRIEFINGDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.3188719493757182 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};

		class MCC_tasksCallButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[12] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_TASKS"; //--- ToDo: Localize;
			tooltip = "$STR_UI_TASKSDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.3628537184766534 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};
		
		class MCC_triggersCallButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[14] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_TRIGGERS"; //--- ToDo: Localize;
			tooltip = "$STR_UI_TRIGGERSDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.4068354875775886 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};
		
		class MCC_jukeBoxCallButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[13] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_JUKEBOX"; //--- ToDo: Localize;
			tooltip = "$STR_UI_JUKEBOXDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
			
			x = 0.0057 * safezoneW;
			y = 0.4508172566785238 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};
		
		class MCC_clientSideCallButton: MCC_RscButton
		{
			idc = -1;
			onButtonClick = __EVAL("[15] execVM '"+MCCPATH+"mcc\general_scripts\groupGen\controlsHandle.sqf'");
			text = "$STR_UI_CLIENTSIDE"; //--- ToDo: Localize;
			tooltip = "$STR_UI_CLIENTSIDEDESC"; //--- ToDo: Localize;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
			
			x = 0.0057 * safezoneW;
			y = 0.494799025779459 * safezoneH;
			w = 0.06875 * safezoneW;
			h = 0.0329871 * safezoneH;
		};
	};
};