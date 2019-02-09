// Made By: Shay_gman
// Version: 1 (June 2014)

//-----------------------------------------------------------------------------
// IDD's & IDC's
//-----------------------------------------------------------------------------
#define MCCCuratorInit_IDD 10000

#define MCC_NAMEBOX 8003
#define MCC_INITBOX 8004
#define MCC_PRESETS 8005

//-----------------------------------------------------------------------------
// Main dialog
//-----------------------------------------------------------------------------
class RscAttributeAreaSize;
class RscAttributeName;
class RscAttributeRank;
class RscAttributeUnitPos;
class RscAttributeSkill;
class RscAttributeDamage;
class RscAttributeFuel;
class RscAttributeLock;
class RscAttributeRespawnPosition;
class RscAttributeBehaviour;
class RscAttributeBootcampStage;
class RscAttributeCAS;
class RscAttributeCountdown;
class RscAttributeDiaryRecord;
class RscAttributeEndMission;
class RscAttributeExec;
class RscAttributeFog;
class RscAttributeRespawnVehicle;
class RscAttributeFormation;
class RscAttributeGroupID;
class RscAttributeOwners;
class RscAttributeOwners2;

class MCCCuratorInit_Dialog {
	idd = MCCCuratorInit_IDD;
	movingEnable = true;
	onLoad = "";

	controlsBackground[] =
	{
	};


	//---------------------------------------------
	objects[] =
	{
	};

	class controls
	{
		 //========================================= Controls========================================

		class Background: MCC_RscText
		{
			moving = 1;
			colorBackground[] = {0,0,0,0.7};
			idc = 10001;
			x = "6.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "9.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "27 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "6.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};

		class Title: MCC_RscText
		{
			moving = 1;
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
			idc = 10002;
			text = "Edit Init Line (MCC)";
			x = "6.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "8.4 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "27 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};

		class Content: MCC_RscControlsGroup
		{
			moving = 1;
			idc = 10003;
			x = "7 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "10 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "26 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "5.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			class controls	{};
		};

		class ButtonOK: RscButtonMenuOK
		{
			moving = 1;
			x = "28.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "16.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};

		class ButtonCancel: RscButtonMenuCancel
		{
			moving = 1;
			x = "6.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "16.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};

		class ButtonCustom: MCC_RscButtonMenu
		{
			moving = 1;
			idc = 10006;
			x = "23.4 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "16.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};

		class ButtonCustom2: MCC_RscButtonMenu
		{
			moving = 1;
			idc = 10007;
			x = "18.3 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "16.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};

		class ButtonCustom3: MCC_RscButtonMenu
		{
			moving = 1;
			idc = 10008;
			x = "13.2 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
			y = "16.1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
			w = "5 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
			h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};

		#include "mcc_boxGen.hpp"

	};
};

class MCC_RscDisplayAttributesMan: MCCCuratorInit_Dialog
{
	class Controls: Controls
	{
		class Background: Background{};
		class Title: Title{};
		class Content: Content
		{
			class Controls: controls
			{
				class name : RscAttributeName{};
				class Rank: RscAttributeRank{};
				class UnitPos: RscAttributeUnitPos{};
				class Damage: RscAttributeDamage{};
				class Skill: RscAttributeSkill{};
				class RespawnPosition: RscAttributeRespawnPosition{};
				class behav : RscAttributeBehaviour{};
				class Presets: MCC_RscInitPresets{};
				class InitNameBox: MCC_RscInitNameBox{};
				class exec : RscAttributeExec{};
			};
		};
		class ButtonOK: ButtonOK{};
		class ButtonCustom: ButtonCustom{};
		class ButtonCustom2: ButtonCustom2{};
		class ButtonCustom3: ButtonCustom3{};
		class ButtonCancel: ButtonCancel{};
	};
};
class MCC_RscDisplayAttributesVehicle: MCCCuratorInit_Dialog
{
	class Controls: Controls
	{
		class Background: Background{};
		class Title: Title{};
		class Content: Content
		{
			class Controls: controls
			{
				class name : RscAttributeName{};
				class InitNameBox: MCC_RscInitNameBox{};
				class Rank: RscAttributeRank{};
				class Damage: RscAttributeDamage{};
				class Fuel: RscAttributeFuel{};
				class ammo: MCC_RscAttributeAmmo{};
				class Skill: RscAttributeSkill{};
				class Lock: RscAttributeLock{};
				class lights: MCC_RscAttributeLights{};
				class engine: MCC_RscAttributeEngine{};
				class RespawnVehicle: RscAttributeRespawnVehicle{};
				class RespawnPosition: RscAttributeRespawnPosition{};
				class behav : RscAttributeBehaviour{};
				class cargoVirtual: MCC_RscAttributeVehicleCargo{};
				class Presets: MCC_RscInitPresets{};
				class exec : RscAttributeExec{};
			};
		};
		class ButtonOK: ButtonOK{};
		class ButtonCustom: ButtonCustom{};
		class ButtonCustom2: ButtonCustom2{};
		class ButtonCustom3: ButtonCustom3{};
		class ButtonCancel: ButtonCancel{};
		class cargo: MCC_3DCargoGenControls {};
	};
};

class MCC_RscDisplayAttributesVehicleEmpty: MCCCuratorInit_Dialog
{
	class Controls: Controls
	{
		class Background: Background{};
		class Title: Title{};
		class Content: Content
		{
			class Controls: controls
			{
				class InitNameBox: MCC_RscInitNameBox{};
				class Damage: RscAttributeDamage{};
				class Fuel: RscAttributeFuel{};
				class ammo: MCC_RscAttributeAmmo{};
				class Lock: RscAttributeLock{};
				class lights: MCC_RscAttributeLights{};
				class engine: MCC_RscAttributeEngine{};
				class RespawnVehicle: RscAttributeRespawnVehicle{};
				class RespawnPosition: RscAttributeRespawnPosition{};
				class cargoVirtual: MCC_RscAttributeVehicleCargo{};
				class Presets: MCC_RscInitPresets{};
				class exec : RscAttributeExec{};
			};
		};
		class ButtonOK: ButtonOK{};
		class ButtonCustom: ButtonCustom{};
		class ButtonCustom2: ButtonCustom2{};
		class ButtonCustom3: ButtonCustom3{};
		class ButtonCancel: ButtonCancel{};
		class cargo: MCC_3DCargoGenControls {};
	};
};

class MCC_RscDisplayAttributesObject: MCCCuratorInit_Dialog
{
	class Controls: Controls
	{
		class Background: Background{};
		class Title: Title{};
		class Content: Content
		{
			class Controls: controls
			{
				class Presets: MCC_RscInitPresets{};
				class InitNameBox: MCC_RscInitNameBox{};
				class exec : RscAttributeExec{};
			};
		};
		class ButtonOK: ButtonOK{};
		class ButtonCustom: ButtonCustom{};
		class ButtonCustom2: ButtonCustom2{};
		class ButtonCustom3: ButtonCustom3{};
		class ButtonCancel: ButtonCancel{};
		class cargo: MCC_3DCargoGenControls {};
	};
};