class officer : rifleman
{
	name    = "Officer";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\Officer.paa");
	minPlayersForKit = 0;
	maxKitsInGroup = 1;
	maxKitsInSide = 999;
	allowMg = 0;
	allowAT = 0;
	allowSniper = 0;
	allowPilot = 0;
	allowCrew = 0;

	class west : west
	{
		class primary
		{
			class arifle_TRG21_GL_F
			{
				unlockLevel = 0;
				cfgname = "arifle_TRG21_GL_F";
				magazines[]= {"30Rnd_556x45_Stanag",9,"30Rnd_556x45_Stanag_Tracer_Red",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_M"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};

			class arifle_MX_GL_F
			{
				unlockLevel = 13;
				cfgname = "arifle_MX_GL_F";
				magazines[]= {"30Rnd_65x39_caseless_mag",9,"30Rnd_65x39_caseless_mag_Tracer",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_h"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};

			class arifle_MX_GL_Black_F
			{
				unlockLevel = 23;
				cfgname = "arifle_MX_GL_Black_F";
				magazines[]= {"30Rnd_65x39_caseless_mag",9,"30Rnd_65x39_caseless_mag_Tracer",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_h"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};
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

			class hgun_Rook40_F
			{
				unlockLevel = 4;
				cfgname = "hgun_Rook40_F";
				magazines[]= {"16Rnd_9x21_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_L"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_P07_F
			{
				unlockLevel = 8;
				cfgname = "hgun_P07_F";
				magazines[]= {"16Rnd_9x21_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_L"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_ACPC2_F
			{
				unlockLevel = 12;
				cfgname = "hgun_ACPC2_F";
				magazines[]= {"9Rnd_45ACP_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_acp"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_Pistol_heavy_02_F
			{
				unlockLevel = 16;
				cfgname = "hgun_Pistol_heavy_02_F";
				magazines[]= {"6Rnd_45ACP_Cylinder",2};
				attachments1[]= {{0,""},{2,"optic_Yorris"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_Pistol_heavy_01_F
			{
				unlockLevel = 16;
				cfgname = "hgun_Pistol_heavy_01_F";
				magazines[]= {"11Rnd_45ACP_Mag",2};
				attachments1[]= {{0,""},{4,"optic_MRD"}};
				attachments2[]= {{0,""},{2,"muzzle_snds_acp"}};
				attachments3[]= {};
				attachments4[]= {};
			};
		};


		items1[]={{0,"Binocular", {}},{10,"Rangefinder", {}},{15,"Laserdesignator", {"Laserbatteries",2}}};
		items2[]={{0,"1Rnd_Smoke_Grenade_shell", 2},{3,"1Rnd_SmokeRed_Grenade_shell", 2},{7,"1Rnd_SmokeGreen_Grenade_shell", 2},{11,"UGL_FlareWhite_F", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"MiniGrenade", 2},{3,"SmokeShell", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"ItemGPS",1}};
		nightVision[]= {{0,""},{0,"NVGoggles"}};
		headgear[]= {{0,"H_Cap_brn_SPECOPS"},{12,"H_Beret_grn_SF"},{18,"H_HelmetB_light_black"}};
		googles[]= {{0,""},{0,"G_Combat"},{6,"G_Tactical_Black"},{13,"G_Sport_Blackred"}};
		vests[]= {{0,"V_PlateCarrier1_rgr"},{9,"V_PlateCarrierGL_rgr"},{13,"V_TacVest_oli"},{19,"V_PlateCarrier1_blk"}};
		backpacks[]= {{0,"B_AssaultPack_mcamo"},{7,"B_Kitbag_mcamo"},{14,"B_Bergen_mcamo"},{18,"B_AssaultPack_blk"}};
		uniforms[]= {{0,"U_B_CombatUniform_mcam"},{8,"U_B_CombatUniform_mcam_tshirt"},{15,"U_B_CombatUniform_mcam_vest"}};
		insigna[]= {{0,""},{0,"111thID"},{0,"BI"},{0,"Curator"},{0,"MANW"}};
	};

	class east : east
	{
		class primary
		{
			class arifle_Mk20_GL_plain_F
			{
				unlockLevel = 0;
				cfgname = "arifle_Mk20_GL_plain_F";
				magazines[]= {"30Rnd_556x45_Stanag",9,"30Rnd_556x45_Stanag_Tracer_Red",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_M"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};

			class arifle_Katiba_GL_F
			{
				unlockLevel = 13;
				cfgname = "arifle_Katiba_GL_F";
				magazines[]= {"30Rnd_65x39_caseless_green",9,"30Rnd_65x39_caseless_green_mag_Tracer",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_h"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};

			class arifle_MX_GL_Black_F
			{
				unlockLevel = 23;
				cfgname = "arifle_MX_GL_Black_F";
				magazines[]= {"30Rnd_65x39_caseless_mag",9,"30Rnd_65x39_caseless_mag_Tracer",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_h"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};
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

			class hgun_Rook40_F
			{
				unlockLevel = 4;
				cfgname = "hgun_Rook40_F";
				magazines[]= {"16Rnd_9x21_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_L"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_P07_F
			{
				unlockLevel = 8;
				cfgname = "hgun_P07_F";
				magazines[]= {"16Rnd_9x21_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_L"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_ACPC2_F
			{
				unlockLevel = 12;
				cfgname = "hgun_ACPC2_F";
				magazines[]= {"9Rnd_45ACP_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_acp"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_Pistol_heavy_02_F
			{
				unlockLevel = 16;
				cfgname = "hgun_Pistol_heavy_02_F";
				magazines[]= {"6Rnd_45ACP_Cylinder",2};
				attachments1[]= {{0,""},{2,"optic_Yorris"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_Pistol_heavy_01_F
			{
				unlockLevel = 16;
				cfgname = "hgun_Pistol_heavy_01_F";
				magazines[]= {"11Rnd_45ACP_Mag",2};
				attachments1[]= {{0,""},{4,"optic_MRD"}};
				attachments2[]= {{0,""},{2,"muzzle_snds_acp"}};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		items1[]={{0,"Binocular", {}},{10,"Rangefinder", {}},{15,"Laserdesignator", {"Laserbatteries",2}}};
		items2[]={{0,"1Rnd_Smoke_Grenade_shell", 2},{3,"1Rnd_SmokeRed_Grenade_shell", 2},{7,"1Rnd_SmokeGreen_Grenade_shell", 2},{11,"UGL_FlareWhite_F", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"MiniGrenade", 2},{3,"SmokeShell", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"ItemGPS",1}};
		nightVision[]= {{0,""},{0,"NVGoggles"}};
		headgear[]= {{0,"H_MilCap_ocamo"},{12,"H_Cap_blk"},{18,"H_HelmetSpecO_blk"}};
		googles[]= {{0,""},{0,"G_Combat"},{6,"G_Tactical_Black"},{13,"G_Sport_Blackred"}};
		vests[]= {{0,"V_BandollierB_khk"},{9,"V_HarnessOGL_gry"},{13,"V_HarnessOSpec_gry"},{19,"V_TacVestIR_blk"}};
		backpacks[]= {{0,"B_AssaultPack_ocamo"},{7,"B_FieldPack_ocamo"},{14,"B_Carryall_ocamo"},{18,"B_FieldPack_blk"}};
		uniforms[]= {{0,"U_O_CombatUniform_ocamo"},{8,"U_O_CombatUniform_oucamo"},{15,"U_O_OfficerUniform_ocamo"}};
		insigna[]= {{0,""},{0,"GryffinRegiment"},{0,"BI"},{0,"Curator"},{0,"MANW"}};
	};

	class guer : guer
	{
		class primary
		{
			class arifle_Mk20_GL_F
			{
				unlockLevel = 0;
				cfgname = "arifle_Mk20_GL_F";
				magazines[]= {"30Rnd_556x45_Stanag",9,"30Rnd_556x45_Stanag_Tracer_Red",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_M"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};

			class arifle_MX_GL_F
			{
				unlockLevel = 13;
				cfgname = "arifle_MX_GL_F";
				magazines[]= {"30Rnd_65x39_caseless_mag",9,"30Rnd_65x39_caseless_mag_Tracer",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_h"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};

			class arifle_MX_GL_Black_F
			{
				unlockLevel = 23;
				cfgname = "arifle_MX_GL_Black_F";
				magazines[]= {"30Rnd_65x39_caseless_mag",9,"30Rnd_65x39_caseless_mag_Tracer",2,"1Rnd_HE_Grenade_shell",8};
				attachments1[]= {{0,"optic_Hamr"},{3,"optic_Aco"},{4,"optic_Holosight"},{6,"optic_MRCO"},{10,"optic_Arco"}};
				attachments2[]= {{0,""},{9,"muzzle_snds_h"}};
				attachments3[]= {{0,""},{1,"acc_flashlight"},{7,"acc_pointer_IR"}};
				attachments4[]= {};
			};
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

			class hgun_Rook40_F
			{
				unlockLevel = 4;
				cfgname = "hgun_Rook40_F";
				magazines[]= {"16Rnd_9x21_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_L"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_P07_F
			{
				unlockLevel = 8;
				cfgname = "hgun_P07_F";
				magazines[]= {"16Rnd_9x21_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_L"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_ACPC2_F
			{
				unlockLevel = 12;
				cfgname = "hgun_ACPC2_F";
				magazines[]= {"9Rnd_45ACP_Mag",2};
				attachments1[]= {};
				attachments2[]= {{0,""},{2,"muzzle_snds_acp"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_Pistol_heavy_02_F
			{
				unlockLevel = 16;
				cfgname = "hgun_Pistol_heavy_02_F";
				magazines[]= {"6Rnd_45ACP_Cylinder",2};
				attachments1[]= {{0,""},{2,"optic_Yorris"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class hgun_Pistol_heavy_01_F
			{
				unlockLevel = 16;
				cfgname = "hgun_Pistol_heavy_01_F";
				magazines[]= {"11Rnd_45ACP_Mag",2};
				attachments1[]= {{0,""},{4,"optic_MRD"}};
				attachments2[]= {{0,""},{2,"muzzle_snds_acp"}};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		items1[]={{0,"Binocular", {}},{10,"Rangefinder", {}},{15,"Laserdesignator", {"Laserbatteries",2}}};
		items2[]={{0,"1Rnd_Smoke_Grenade_shell", 2},{3,"1Rnd_SmokeRed_Grenade_shell", 2},{7,"1Rnd_SmokeGreen_Grenade_shell", 2},{11,"UGL_FlareWhite_F", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"MiniGrenade", 2},{3,"SmokeShell", 2},{7,"HandGrenade", 2},{11,"SmokeShellRed", 2},{13,"SmokeShellGreen", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"ItemGPS",1}};
		nightVision[]= {{0,""},{0,"NVGoggles"}};
		headgear[]= {{0,"H_Cap_grn"},{12,"H_Cap_blk"},{18,"H_HelmetIA_camo"}};
		googles[]= {{0,""},{0,"G_Combat"},{6,"G_Tactical_Black"},{13,"G_Sport_Blackred"}};
		vests[]= {{0,"V_PlateCarrier1_rgr"},{9,"V_PlateCarrierSpec_rgr"},{13,"V_TacVest_oli"},{19,"V_TacVestIR_blk"}};
		backpacks[]= {{0,"B_AssaultPack_mcamo"},{7,"B_Kitbag_mcamo"},{14,"B_Bergen_mcamo"},{18,"B_AssaultPack_blk"}};
		uniforms[]= {{0,"U_I_CombatUniform"},{8,"U_I_CombatUniform_tshirt"}};
		insigna[]= {{0,""},{0,"TFAegis"},{0,"BI"},{0,"Curator"},{0,"MANW"}};
	};
};