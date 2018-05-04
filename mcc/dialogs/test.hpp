class mcc_test
{
	idd = 9999999;
	movingEnable = true;
	onLoad ="";

	controlsBackground[] =
	{
	};


	//---------------------------------------------
	objects[] =
	{ 	//(0.671875 * safezoneW + safezoneX) / safezoneW -X
	};	//(0.478009 * safezoneH + safezoneY) / safezoneH - Y

	class Controls
	{
		class  frame : MCC_RscText
		{
			idc = -1;
			colorBackground[] = {0,0,0,0.6};
			moving = 1;
			w = 0.401042 * safezoneW;
			h = 0.505803 * safezoneH;
			text = "";
		};

		class allGearBackground : MCC_RscText
		{
			idc = -1;
			colorBackground[] = { 0, 0, 0, 0.9 };
			colorText[] = { 1, 1, 1, 0 };
			text = "";
			moving = 1;
			x = 0.00572965 * safezoneW;
			y = 0.0769698 * safezoneH;
			w = 0.171875 * safezoneW;
			h = 0.38485 * safezoneH;
		};

		class boxGearBackground : MCC_RscText
		{
			idc = -1;
			colorBackground[] = { 0, 0, 0, 0.9 };
			colorText[] = { 1, 1, 1, 0 };
			x = 0.217709 * safezoneW;
			y = 0.0769698 * safezoneH;
			w = 0.177604 * safezoneW;
			h = 0.38485 * safezoneH;
			text = "";
		};

	 //========================================= Controls========================================
		class allGearList: MCC_RscListBox
		{
			idc = 0;
			sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

			x = 0.00572965 * safezoneW;
			y = 0.0769698 * safezoneH;
			w = 0.171875 * safezoneW;
			h = 0.38485 * safezoneH;
		};

		class boxGearList: MCC_RscListBox
		{
			idc = 1;
			sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

			x = 0.217709 * safezoneW;
			y = 0.0769698 * safezoneH;
			w = 0.177604 * safezoneW;
			h = 0.38485 * safezoneH;
		};

		class playerGearClasCombo: MCC_RscCombo
		{
			idc = 2;
			sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			style = MCCST_LEFT;
			colorText[] = { 1, 1, 1, 1 };
			colorSelect[] = { 1.0, 0.35, 0.3, 1 };
			colorBackground[]={0,0,0,1};
			colorSelectBackground[] = { 0, 0, 0, 1 };
			onLBSelChanged = __EVAL("[0,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

			x = 0.0458336 * safezoneW;
			y = 0.0439828 * safezoneH;
			w = 0.0973958 * safezoneW;
			h = 0.0219914 * safezoneH;
		};

		//Tittles
		class Tittle: MCC_RscText
		{
			idc = -1;
			text = "Cargo:";
			sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			colorText[] = {0,1,1,1};
			colorBackground[] = {1,1,1,0};

			x = 0.00572965 * safezoneW;
			y = 0.0109958 * safezoneH;
			w = 0.1375 * safezoneW;
			h = 0.0226897 * safezoneH;
		};

		class playerClassTitle: MCC_RscText
		{
			idc = -1;
			text = "Yours:";
			sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,0};

			x = 0.00572965 * safezoneW;
			y = 0.0439828 * safezoneH;
			w = 0.0362846 * safezoneW;
			h = 0.0226897 * safezoneH;
		};

		class MainClassTitle: MCC_RscText
		{
			idc = -1;
			text = "Cargo:";
			sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,0};

			x = 0.217709 * safezoneW;
			y = 0.0439828 * safezoneH;
			w = 0.0362846 * safezoneW;
			h = 0.0226897 * safezoneH;
		};

		//Buttons
		class putButton: MCC_RscButton
		{
			idc = -1;
			text = ">";
			onButtonClick = __EVAL("[2,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");
			tooltip = "Give current weapon";

			x = 0.183334 * safezoneW;
			y = 0.186927 * safezoneH;
			w = 0.0286458 * safezoneW;
			h = 0.0274893 * safezoneH;
		};

		class addOneButton: MCC_RscButton
		{
			idc = -1;
			text = "<";
			onButtonClick = __EVAL("[3,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");
			tooltip = "Take current weapon";

			x = 0.183334 * safezoneW;
			y = 0.23091 * safezoneH;
			w = 0.0286458 * safezoneW;
			h = 0.0274893 * safezoneH;
		};

		class ValorIcon: MCC_RscPicture
		{
			idc = -1;
			text = __EVAL(MCCPATH +"mcc\rts\data\valorIcon.paa");
			tooltip = "Fame";
			x = 0.335156 * safezoneW;
			y = 0.011 * safezoneH;
			w = 0.020625 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class ValorValue: MCC_RscText
		{
			idc = 4;
			text = "0";
			x = 0.360938 * safezoneW;
			y = 0.011 * safezoneH;
			w = 0.0309375 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class generateBoxButton: MCC_RscButton
		{
			idc = -1;
			text = "Close";
			onButtonClick = "closedialog 0";

			x = 0.332292 * safezoneW;
			y = 0.472816 * safezoneH;
			w = 0.0572917 * safezoneW;
			h = 0.0274893 * safezoneH;
		};
	};
};
