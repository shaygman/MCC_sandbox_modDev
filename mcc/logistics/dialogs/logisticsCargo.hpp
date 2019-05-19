class MCC_logisticsCargo
{
	idd = 8888745412;
	onLoad = "uiNamespace setVariable ['MCC_logisticsCargo', (_this select 0)];";
	movingEnable = true;
	class controls
	{
		class bckground: MCC_RscText
		{
			idc = -1;
			x = 0.422655 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.363 * safezoneH;
			colorBackground[] = {0,0,0,0.7};
		};

		class cargoItems: MCC_RscListbox
		{
			idc = 1500;
			x = 0.432969 * safezoneW + safezoneX;
			y = 0.346 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.286 * safezoneH;
		};
		class frame: MCC_RscFrame
		{
			idc = -1;
			x = 0.422655 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.185625 * safezoneW;
			h = 0.363 * safezoneH;
		};
		class Text: MCC_RscText
		{
			idc = -1;
			text = "Cargo";
			x = 0.474219 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class CancelButton: MCC_RscButton
		{
			idc = -1;
			action = "closeDialog 0";

			text = "X"; //--- ToDo: Localize;
			x = 0.56 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.033 * safezoneW;
			h = 0.033 * safezoneH;
		};
	};
};