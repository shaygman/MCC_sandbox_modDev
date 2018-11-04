class pilot : rifleman
{
	name    = "Pilot";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\Pilot.paa");
	minPlayersForKit = 0;
	maxKitsInGroup = 99;
	maxKitsInSide = 999;
	allowMg = 0;
	allowAT = 0;
	allowSniper = 0;
	allowPilot = 1;
	allowCrew = 0;

	class west : west
	{
		class primary
		{

		};

		class secondary
		{

		};

		class handgun
		{
			class none
			{
				unlockLevel = 0;
				cfgname = "";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhsusf_weap_m1911a1
			{
				unlockLevel = 4;
				cfgname = "rhsusf_weap_m1911a1";
				magazines[]= {"rhsusf_mag_7x45acp_MHP",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhsusf_weap_m9
			{
				unlockLevel = 8;
				cfgname = "rhsusf_weap_m9";
				magazines[]= {"rhsusf_mag_15Rnd_9x19_JHP",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhsusf_weap_glock17g4
			{
				unlockLevel = 12;
				cfgname = "rhsusf_weap_glock17g4";
				magazines[]= {"rhsusf_mag_17Rnd_9x19_JHP",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{5,"rhsusf_acc_omega9k"}};
				attachments3[]= {{0,""},{2,"acc_flashlight_pistol"}};
				attachments4[]= {};
			};
		};


		items1[]={{0,""},{20,"Binocular", {}},{40,"Rangefinder", {}}};
		items2[]={{0,"SmokeShell", 2},{3,"MiniGrenade", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"MiniGrenade", 2},{3,"SmokeShell", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2}};
		nightVision[]= {{0,""},{0,"NVGoggles"}};
		headgear[]= {{0,"rhsusf_hgu56p_green"},{5,"rhsusf_hgu56p_visor_green"},{9,"rhsusf_hgu56p_visor_mask_green"},{11,"rhsusf_hgu56p_usa"},{15,"RHS_jetpilot_usaf"}};
		vests[]= {};
		backpacks[]= {};
		uniforms[]= {{0,"U_B_PilotCoveralls"}};
	};

	class east : east
	{
		class primary
		{

		};

		class secondary
		{

		};

		class handgun
		{
			class none
			{
				unlockLevel = 0;
				cfgname = "";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_makarov_pm
			{
				unlockLevel = 4;
				cfgname = "rhs_weap_makarov_pm";
				magazines[]= {"rhs_mag_9x18_8_57N181S",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_L"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_pb_6p9
			{
				unlockLevel = 8;
				cfgname = "rhs_weap_pb_6p9";
				magazines[]= {"rhs_mag_9x18_8_57N181S",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_pya
			{
				unlockLevel = 12;
				cfgname = "rhs_weap_pya";
				magazines[]= {"rhs_mag_9x19_17",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_pp2000_folded
			{
				unlockLevel = 16;
				cfgname = "rhs_weap_pp2000_folded";
				magazines[]= {"rhs_mag_9x19mm_7n21_20",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};


		items1[]={{0,""},{20,"Binocular", {}},{40,"Rangefinder", {}}};
		items2[]={{0,"SmokeShell", 2},{3,"MiniGrenade", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"MiniGrenade", 2},{3,"SmokeShell", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2}};
		nightVision[]= {{0,""},{0,"NVGoggles"}};
		headgear[]= {{0,"rhs_zsh7a_mike"},{5,"rhs_zsh7a_mike_alt"},{9,"rhs_zsh7a_mike_green"},{11,"rhs_zsh7a_mike_green_alt"},{15,"rhs_zsh7a_alt"}};
		googles[]= {{0,""},{0,"G_Combat"},{6,"G_Tactical_Black"},{13,"G_Sport_Blackred"}};
		vests[]= {};
		backpacks[]= {};
		uniforms[]= {{0,"U_O_PilotCoveralls"}};
	};

	class guer : guer
	{
		class primary
		{
		};

		class secondary
		{

		};

		class handgun
		{
			class none
			{
				unlockLevel = 0;
				cfgname = "";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_makarov_pm
			{
				unlockLevel = 4;
				cfgname = "rhs_weap_makarov_pm";
				magazines[]= {"rhs_mag_9x18_8_57N181S",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_L"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_type94_new
			{
				unlockLevel = 8;
				cfgname = "rhs_weap_type94_new";
				magazines[]= {"rhs_mag_6x8mm_mhp",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_tt33
			{
				unlockLevel = 12;
				cfgname = "rhs_weap_tt33";
				magazines[]= {"rhs_mag_762x25_8",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_savz61_folded
			{
				unlockLevel = 16;
				cfgname = "rhs_weap_savz61_folded";
				magazines[]= {"rhsgref_20rnd_765x17_vz61",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		items1[]={{0,""},{20,"Binocular", {}},{40,"Rangefinder", {}}};
		items2[]={{0,"SmokeShell", 2},{3,"MiniGrenade", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"MiniGrenade", 2},{3,"SmokeShell", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2}};
		nightVision[]= {{0,""},{0,"NVGoggles"}};
		headgear[]= {{0,"rhs_zsh7a_mike"},{5,"rhs_zsh7a_mike_alt"},{9,"rhs_zsh7a_mike_green"},{11,"rhs_zsh7a_mike_green_alt"},{15,"rhs_zsh7a_alt"}};
		googles[]= {{0,""},{0,"G_Combat"},{6,"G_Tactical_Black"},{13,"G_Sport_Blackred"}};
		vests[]= {};
		backpacks[]= {};
		uniforms[]= {{0,"U_I_pilotCoveralls"}};
		insigna[]= {{0,""},{0,"TFAegis"},{0,"BI"},{0,"Curator"},{0,"MANW"}};
	};
};