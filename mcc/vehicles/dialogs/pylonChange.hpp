class MCC_displayPylonChange
{
	idd = 1031981;
	movingEnable = true;
	class controls
	{
		class Background: MCC_RscText
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.6};
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.203 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.583 * safezoneH;
		};

		class frame: MCC_RscFrame
		{
			idc = -1;
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.203 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.583 * safezoneH;
		};

		class pictureUIBckg: MCC_RscText
		{
			idc = -1;
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.27 * safezoneH + safezoneY;
			w = 0.391875 * safezoneW;
			h = 0.35 * safezoneH;
			colorBackground[] = {0.4,0.4,0.4,0.8};
		};

		class pictureUI: MCC_RscPicture
		{
			idc = 1200;
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.27 * safezoneH + safezoneY;
			w = 0.391875 * safezoneW;
			h = 0.35 * safezoneH;
		};

		class mirrorText: MCC_RscText
		{
			idc = -1;
			text = "$STR_DISP_VEHICLESPYLON_MIRROR";
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.236 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class mirrorCheckBox: MCC_RscCheckbox
		{
			idc = 2800;
			x = 0.340156 * safezoneW + safezoneX;
			y = 0.236 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class RepairText: MCC_RscText
		{
			idc = 1001;
			text = "$STR_DISP_VEHICLESPYLON_REPAIR";
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.709 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class rearmText: MCC_RscText
		{
			idc = 1002;
			text = "$STR_DISP_VEHICLESPYLON_REARM";
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class RefuelText: MCC_RscText
		{
			idc = 1003;
			text = "$STR_DISP_VEHICLESPYLON_REFUEL";
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class presetsCombo: MCC_RscCombo
		{
			idc = 2100;
			x = 0.371094 * safezoneW + safezoneX;
			y = 0.236 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class rearmCheck: MCC_RscCheckbox
		{
			idc = 2801;
			x = 0.340156 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class RefuelCheck: MCC_RscCheckbox
		{
			idc = 2802;
			x = 0.340156 * safezoneW + safezoneX;
			y = 0.665 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class repairCheck: MCC_RscCheckbox
		{
			idc = 2803;
			x = 0.340156 * safezoneW + safezoneX;
			y = 0.709 * safezoneH + safezoneY;
			w = 0.0257812 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class displayHeader: MCC_RscText
		{
			idc = 1004;
			text = "$STR_DISP_VEHICLESPYLON_HEADER";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.203 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.192])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.192])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.192])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
		};

		class Cancel: MCC_RscButtonMenu
		{
			idc = 2400;
			text = "$STR_DISP_VEHICLESPYLON_CANCEL";
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.742 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
		};
		class confirm: MCC_RscButtonMenu
		{
			idc = 2401;
			text = "$STR_DISP_VEHICLESPYLON_CONFIRM";
			x = 0.62375 * safezoneW + safezoneX;
			y = 0.742 * safezoneH + safezoneY;
			w = 0.0773437 * safezoneW;
			h = 0.033 * safezoneH;
		};
	};
};