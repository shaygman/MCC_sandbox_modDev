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
				class bckground: MCC_RscText
				{
					idc = -1;
					x = 0 * safezoneW;
					y = 0 * safezoneH;
					w = 0.273281 * safezoneW;
					h = 0.154 * safezoneH;
					colorBackground[] = {0,0,0,0.7};
				};

				class bckframe: MCC_RscFrame
				{
					idc = -1;
					x = 0 * safezoneW;
					y = 0 * safezoneH;
					w = 0.273281 * safezoneW;
					h = 0.154 * safezoneH;
				};

				class factionText: MCC_RscText
				{
					idc = -1;
					text = "Faction:"; //--- ToDo: Localize;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
					x = 0.00515648 * safezoneW;
					y = 0.011 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.022 * safezoneH;
				};
				class factionListbox: MCC_RscCombo
				{
					idc = 8008;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
					onLBSelChanged = "['faction'] spawn MCC_fnc_LHDspawnVehicle;";

					x = 0.046406 * safezoneW;
					y = 0.011 * safezoneH;
					w = 0.12375 * safezoneW;
					h = 0.022 * safezoneH;
				};
				class typeListBox: MCC_RscCombo
				{
					idc = 1501;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";

					x = 0.005156 * safezoneW;
					y = 0.044 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.022 * safezoneH;
				};
				class classListBox: MCC_RscCombo
				{
					idc = 1502;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
					x = 0.046406 * safezoneW;
					y = 0.044 * safezoneH;
					w = 0.12375 * safezoneW;
					h = 0.022 * safezoneH;
				};
				class infoText: MCC_RscPicture
				{
					idc = 1100;
					x = 0.175313 * safezoneW;
					y = 0.011 * safezoneH;
					w = 0.0928125 * safezoneW;
					h = 0.132 * safezoneH;
				};
				class spawnButton: MCC_RscButton
				{
					idc = 2400;
					text = "Spawn"; //--- ToDo: Localize;
					x = 0.051563 * safezoneW;
					y = 0.077 * safezoneH;
					w = 0.0773437 * safezoneW;
					h = 0.055 * safezoneH;
				};
				class closeButton: MCC_RscButtonMenu
				{
					idc = 2401;
					text = "X"; //--- ToDo: Localize;
					action = "['close'] spawn MCC_fnc_LHDspawnVehicle;";
					x = 0.252656 * safezoneW;
					y = 0.011 * safezoneH;
					w = 0.0154688 * safezoneW;
					h = 0.033 * safezoneH;
				};
			};
};
