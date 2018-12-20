// By: Shay_gman

class MCC_VEHICLESPAWNER
{
	idd = -1;
	movingEnable = 1;
	onLoad = "uiNamespace setVariable [""MCC_VEHICLESPAWNER_IDD"", _this select 0]";

	class controls
	{
		class vehicleShopCtrl: MCC_RscControlsGroup
		{
			idc = 2300;
			movingEnable = 1;
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.214 * safezoneH + safezoneY;
			w = 0.407344 * safezoneW;
			h = 0.5 * safezoneH;
			class Controls
			{
				class RscFrame_1: MCC_RscText
				{
					idc = -1;

					x = 2.26276e-007 * safezoneW;
					y = 6.14673e-009 * safezoneH;
					w = 0.407344 * safezoneW;
					h = 0.341 * safezoneH;
					colorBackground[] = {0,0,0,0.8};
				};
				class RscFrame_2: MCC_RscFrame
				{
					idc = -1;

					x = 2.26276e-007 * safezoneW;
					y = 6.14673e-009 * safezoneH;
					w = 0.293906 * safezoneW;
					h = 0.341 * safezoneH;
				};
				class RscFrame_3: MCC_RscFrame
				{
					idc = -1;

					x = 0.293906 * safezoneW;
					y = 6.14673e-009 * safezoneH;
					w = 0.113437 * safezoneW;
					h = 0.341 * safezoneH;
				};
				class vehicleClass: MCC_RscCombo
				{
					idc = 101;
					onLBSelChanged = "[0] spawn MCC_fnc_vehicleSpawner";

					x = 0.0103125 * safezoneW;
					y = 0.099 * safezoneH; //y = 0.198 * safezoneH;
					w = 0.273281 * safezoneW;
					h = 0.044 * safezoneH;
				};
				class SpawnButton: MCC_RscButton
				{
					idc = 102;
					onButtonClick = "[1] spawn MCC_fnc_vehicleSpawner";

					text = "Purchase"; //--- ToDo: Localize;
					x = 0.0773438 * safezoneW;
					y = 0.275 * safezoneH;
					w = 0.139219 * safezoneW;
					h = 0.055 * safezoneH;
				};
				class close: MCC_RscButton
				{
					idc = -1;
					onButtonClick = "closeDialog 0;";

					text = "X"; //--- ToDo: Localize;
					x = 0.391875 * safezoneW;
					y = 6.14673e-009 * safezoneH;
					w = 0.0154689 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class ammoPic: MCC_RscPicture
				{
					idc = 1100;

					text = "\mcc_sandbox_mod\data\IconAmmo.paa"; //--- ToDo: Localize;
					x = 0.0103125 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.0257812 * safezoneW;
					h = 0.044 * safezoneH;
					colorText[] = {0.9,0,0,1};
					tooltip = "Ammo"; //--- ToDo: Localize;
				};
				class repairPic: MCC_RscPicture
				{
					idc = 1101;

					text = "\mcc_sandbox_mod\data\IconRepair.paa"; //--- ToDo: Localize;
					x = 0.113438 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.0257812 * safezoneW;
					h = 0.044 * safezoneH;
					colorText[] = {0,0.5,0.9,10};
					tooltip = "Materials"; //--- ToDo: Localize;
				};
				class fuelPic: MCC_RscPicture
				{
					idc = 1102;

					text = "\mcc_sandbox_mod\data\IconFuel.paa"; //--- ToDo: Localize;
					x = 0.216563 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.0257812 * safezoneW;
					h = 0.044 * safezoneH;
					colorText[] = {0,0.9,0.5,1};
					tooltip = "Fuel"; //--- ToDo: Localize;
				};
				class ValorPic: MCC_RscPicture
				{
					idc = 1103;

					text = "\mcc_sandbox_mod\mcc\rts\data\valorIcon.paa"; //--- ToDo: Localize;
					x = 0.113438 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.0257812 * safezoneW;
					h = 0.044 * safezoneH;
					tooltip = "Credits"; //--- ToDo: Localize;
				};
				class ammoText: MCC_RscText
				{
					idc = 1000;

					x = 0.0360938 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.044 * safezoneH;
				};
				class repairText: MCC_RscText
				{
					idc = 1001;

					x = 0.139219 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.044 * safezoneH;
				};
				class fuelText: MCC_RscText
				{
					idc = 1002;

					x = 0.242344 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.044 * safezoneH;
				};
				class ValorText: MCC_RscText
				{
					idc = 1003;

					x = 0.139219 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.044 * safezoneH;
				};
				class infoText: MCC_RscPicture
				{
					idc = 111100;

					x = 0.299063 * safezoneW;
					y = 0.033 * safezoneH;
					w = 0.103125 * safezoneW;
					h = 0.132 * safezoneH;
				};
				class availableResourcesTittle: MCC_RscText
				{
					idc = 80;

					text = "Resources"; //--- ToDo: Localize;
					x = 0.309375 * safezoneW;
					y = 0.165 * safezoneH;
					w = 0.08 * safezoneW;
					h = 0.033 * safezoneH;
					sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
				};
				class MCC_AmmoText: MCC_RscText
				{
					idc = 81;

					x = 0.33 * safezoneW;
					y = 0.209 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_RepairText: MCC_RscText
				{
					idc = 82;

					x = 0.33 * safezoneW;
					y = 0.253 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_FuelText: MCC_RscText
				{
					idc = 83;

					x = 0.33 * safezoneW;
					y = 0.297 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_ValorText: MCC_RscText
				{
					idc = 84;

					x = 0.33 * safezoneW;
					y = 0.253 * safezoneH;
					w = 0.04125 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class MCC_Ammo: MCC_RscPicture
				{
					idc = 91;

					text = "\mcc_sandbox_mod\data\IconAmmo.paa"; //--- ToDo: Localize;
					x = 0.309375 * safezoneW;
					y = 0.209 * safezoneH;
					w = 0.0154689 * safezoneW;
					h = 0.033 * safezoneH;
					colorText[] = {0.9,0,0,1};
					tooltip = "Ammo"; //--- ToDo: Localize;
				};
				class MCC_Repair: MCC_RscPicture
				{
					idc = 92;

					text = "\mcc_sandbox_mod\data\IconRepair.paa"; //--- ToDo: Localize;
					x = 0.309375 * safezoneW;
					y = 0.253 * safezoneH;
					w = 0.0154689 * safezoneW;
					h = 0.033 * safezoneH;
					colorText[] = {0,0.5,0.9,10};
					tooltip = "Materials"; //--- ToDo: Localize;
				};
				class MCC_Fuel: MCC_RscPicture
				{
					idc = 93;

					text = "\mcc_sandbox_mod\data\IconFuel.paa"; //--- ToDo: Localize;
					x = 0.309375 * safezoneW;
					y = 0.297 * safezoneH;
					w = 0.0154689 * safezoneW;
					h = 0.033 * safezoneH;
					colorText[] = {0,0.9,0.5,1};
					tooltip = "Fuel"; //--- ToDo: Localize;
				};
				class MCC_ValorPic: MCC_RscPicture
				{
					idc = 94;

					text = "\mcc_sandbox_mod\mcc\rts\data\valorIcon.paa"; //--- ToDo: Localize;
					x = 0.309375 * safezoneW;
					y = 0.253 * safezoneH;
					w = 0.0154689 * safezoneW;
					h = 0.033 * safezoneH;
					colorText[] = {0.9,0.9,0,1};
					tooltip = "Credits"; //--- ToDo: Localize;
				};
				/*
				class factionTxt: MCC_RscText
				{
					idc = 3000;

					text = "Faction"; //--- ToDo: Localize;
					x = 0.0103125 * safezoneW;
					y = 0.099 * safezoneH;
					w = 0.061875 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class factionCombo: MCC_RscCombo
				{
					idc = 3001;
					onLBSelChanged = "[2] spawn MCC_fnc_vehicleSpawner";

					x = 0.0103125 * safezoneW;
					y = 0.132 * safezoneH;
					w = 0.12375 * safezoneW;
					h = 0.044 * safezoneH;
				};
				class classCombo: MCC_RscCombo
				{
					idc = 3002;
					onLBSelChanged = "[3] spawn MCC_fnc_vehicleSpawner";

					x = 0.159844 * safezoneW;
					y = 0.132 * safezoneH;
					w = 0.12375 * safezoneW;
					h = 0.044 * safezoneH;
				};

				class ClassTxt: MCC_RscText
				{
					idc = 3003;

					text = "Class"; //--- ToDo: Localize;
					x = 0.159844 * safezoneW;
					y = 0.099 * safezoneH;
					w = 0.061875 * safezoneW;
					h = 0.033 * safezoneH;
				};
				*/
			};
		};
	};
};
