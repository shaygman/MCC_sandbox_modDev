class MCC_rtsMainBox
{
	idd = -1;
	movingEnable = false;
	onLoad = "uiNamespace setVariable ['MCC_rtsMainBox', (_this select 0)];";

	controlsBackground[] =
	{
	};


	//---------------------------------------------
	objects[] =
	{
	};

	class controls
	{
		class bckg: MCC_RscText
		{
			idc = -1;
			x = 0.695937 * safezoneW + safezoneX;
			y = 0.159 * safezoneH + safezoneY;
			w = 0.103125 * safezoneW;
			h = 0.627 * safezoneH;
			colorBackground[] = {0,0,0,0.6};
		};

		class MCC_ResourcesControlsGroup: MCC_RscControlsGroupNoScrollbars
		{
			idc = 80;
			x = 0.701094 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0928125 * safezoneW;
			h = 0.319 * safezoneH;
			class controls
			{
				class MCC_AmmoText: MCC_RscText
				{
					idc = 81;

					x = 0.0257812 * safezoneW;
					y = 0.011 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};

				class MCC_RepairText: MCC_RscText
				{
					idc = 82;

					x = 0.0257812 * safezoneW;
					y = 0.055 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};

				class MCC_FuelText: MCC_RscText
				{
					idc = 83;

					x = 0.0257812 * safezoneW;
					y = 0.099 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_FoodText: MCC_RscText
				{
					idc = 84;

					x = 0.0257812 * safezoneW;
					y = 0.143 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_MedText: MCC_RscText
				{
					idc = 85;

					x = 0.0257812 * safezoneW;
					y = 0.187 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_Ammo: MCC_RscPicture
				{
					idc = -1;

					text =  __EVAL(MCCPATH +"mcc\rts\data\IconAmmo.paa");
					tooltip = "Ammo";
					colorText[] = { 0.9, 0, 0, 1 };

					x = 0.00515625 * safezoneW;
					y = 0.011 * safezoneH;
					w = 0.0154688 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_Repair: MCC_RscPicture
				{
					idc = -1;

					text = __EVAL(MCCPATH +"mcc\rts\data\IconRepair.paa");
					tooltip = "Materials";
					colorText[] = { 0, 0.5, 0.9, 1 };

					x = 0.00515625 * safezoneW;
					y = 0.055 * safezoneH;
					w = 0.0154688 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_Fuel: MCC_RscPicture
				{
					idc = -1;

					text = __EVAL(MCCPATH +"mcc\rts\data\IconFuel.paa");
					tooltip = "Fuel";
					colorText[] = { 0, 0.9, 0.5, 1 };

					x = 0.00515625 * safezoneW;
					y = 0.099 * safezoneH;
					w = 0.0154688 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_FoodPic: MCC_RscPicture
				{
					idc = -1;

					text = __EVAL(MCCPATH +"mcc\rts\data\IconFood.paa");
					tooltip = "Food";
					colorText[] = { 0.9, 0.5, 0, 1 };

					x = 0.00515625 * safezoneW;
					y = 0.143 * safezoneH;
					w = 0.0154688 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_MedPic: MCC_RscPicture
				{
					idc = -1;

					text = __EVAL(MCCPATH +"mcc\rts\data\IconMed.paa");
					tooltip = "Meds";
					colorText[] = { 0, 0.9, 0.9, 1 };

					x = 0.00515625 * safezoneW;
					y = 0.187 * safezoneH;
					w = 0.0154688 * safezoneW;
					h = 0.033 * safezoneH;
				};
			};
		};

		class MCC_mainBoxCtrlGroup: MCC_RscControlsGroup
		{
			idc = -1;
			x = 0.237031 * safezoneW + safezoneX;
			y = 0.159 * safezoneH + safezoneY;
			w = 0.458906 * safezoneW;
			h = 0.627 * safezoneH;

			class Controls
			{
				class  frame : MCC_RscText
				{
					idc = -1;
					colorBackground[] = {0,0,0,0.5};
					moving = 1;
					w = 0.458906 * safezoneW;
					h = 0.627 * safezoneH;
					text = "";
				};

				class allGearList: MCC_RscListBox
				{
					idc = 0;
					sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

					x = 0.0464065 * safezoneW;
					y = 0.077 * safezoneH;
					w = 0.18 * safezoneW;
					h = 0.528 * safezoneH;
				};

				class boxGearList: MCC_RscListBox
				{
					idc = 1;
					sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";

					x = 0.257813 * safezoneW;
					y = 0.077 * safezoneH;
					w = 0.18 * safezoneW;
					h = 0.528 * safezoneH;
				};
				/*
				class all: MCC_RscActivePicture
				{
					idc = 1600;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_1_ca.paa";
					tooltip = "Primary";
					action = __EVAL("[1,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.077 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};
				*/

				class Rifles: MCC_RscActivePicture
				{
					idc = 1605;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_1_ca.paa";
					tooltip = "Primary";
					action = __EVAL("[1,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.077 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class Launchers: MCC_RscActivePicture
				{
					idc = 1604;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_4_ca.paa";
					tooltip = "Secondary";
					action = __EVAL("[2,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.121 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class Pistols: MCC_RscActivePicture
				{
					idc = 1606;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_5_ca.paa";
					tooltip = "Handguns";
					action = __EVAL("[3,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.165 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class magazines: MCC_RscActivePicture
				{
					idc = 1613;
					text =  __EVAL(MCCPATH +"mcc\roleSelection\data\ui\cargoMag_ca.paa");
					tooltip = "magazines";
					action = __EVAL("[4,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.209 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class miscWeapons: MCC_RscActivePicture
				{
					idc = 1608;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_6_ca.paa";
					tooltip = "Misc Weapon";
					action = __EVAL("[6,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.253 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class weaponAccessories: MCC_RscActivePicture
				{
					idc = 1609;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_7_ca.paa";
					tooltip = "Weapon Accessories";
					action = __EVAL("[7,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.297 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class uniforms: MCC_RscActivePicture
				{
					idc = 1610;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_8_ca.paa";
					tooltip = "Uniforms";
					action = __EVAL("[8,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.341 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class vests: MCC_RscActivePicture
				{
					idc = 1601;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_9_ca.paa";
					tooltip = "Vests";
					action = __EVAL("[9,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.385 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class backpacks: MCC_RscActivePicture
				{
					idc = 1603;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_10_ca.paa";
					tooltip = "Backpacks";
					action = __EVAL("[10,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.429 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class Headgear: MCC_RscActivePicture
				{
					idc = 1602;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_11_ca.paa";
					tooltip = "Headgear";
					action = __EVAL("[11,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.473 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class Items: MCC_RscActivePicture
				{
					idc = 1611;
					text = "\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_12_ca.paa";
					tooltip = "Items";
					action = __EVAL("[12,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");

					x = 0.015469 * safezoneW;
					y = 0.517 * safezoneH;
					w = 0.0309375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class playerClassTitle: MCC_RscText
				{
					idc = -1;
					text = "Player";
					sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
					style = MCCST_CENTER;

					x = 0.268125 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.139219 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class MainClassTitle: MCC_RscText
				{
					idc = -1;
					text = "Cargo";
					sizeEx ="(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
					style = MCCST_CENTER;

					x = 0.055 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.1 * safezoneW;
					h = 0.044 * safezoneH;
				};

				//Buttons
				class buy: MCC_RscButton
				{
					idc = -1;
					text = ">";
					onButtonClick = __EVAL("[20,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");
					tooltip = "Buy";

					x = 0.227 * safezoneW;
					y = 0.24 * safezoneH;
					w = 0.03 * safezoneW;
					h = 0.055 * safezoneH;
				};

				class sell: MCC_RscButton
				{
					idc = -1;
					text = "<";
					onButtonClick = __EVAL("[21,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");
					tooltip = "Sell";

					x = 0.227 * safezoneW;
					y = 0.3 * safezoneH;
					w = 0.03 * safezoneW;
					h = 0.055 * safezoneH;
				};
				/*
				class buyToBox: MCC_RscButton
				{
					idc = -1;
					text = ">>";
					onButtonClick = __EVAL("[22,_this] execVM '"+MCCPATH+"mcc\rts\scripts\rtsMainBox_change.sqf'");
					tooltip = "Buy to Box";

					x = 0.227 * safezoneW;
					y = 0.36 * safezoneH;
					w = 0.03 * safezoneW;
					h = 0.055 * safezoneH;
				};
				*/
				class ValorIcon: MCC_RscPicture
				{
					idc = -1;
					text = __EVAL(MCCPATH +"mcc\rts\data\valorIcon.paa");
					colorText[] = { 0.9, 0.9, 0, 1 };
					x = 0.16 * safezoneW;
					y = 0.022 * safezoneH;
					w = 0.03 * safezoneW;
					h = 0.05 * safezoneH;
				};

				class ValorValue: MCC_RscText
				{
					idc = 4;
					text = "0";

					x = 0.19 * safezoneW;
					y = 0.022 * safezoneH;
					w = 0.15 * safezoneW;
					h = 0.055 * safezoneH;
				};

				class Close: MCC_RscButton
				{
					idc = -1;
					text = "X";
					onButtonClick = "closedialog 0";

					x = 0.427969 * safezoneW;
					y = 0.022 * safezoneH;
					w = 0.0257812 * safezoneW;
					h = 0.044 * safezoneH;
				};
			};
		};
	};
};