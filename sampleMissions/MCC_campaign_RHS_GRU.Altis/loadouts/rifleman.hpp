class rifleman
{
	name    = "Rifleman";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\Rifleman.paa");
	minPlayersForKit = 0;
	maxKitsInGroup = 99;
	maxKitsInSide = 999;
	allowMg = 0;
	allowAT = 0;
	allowSniper = 0;
	allowPilot = 0;
	allowCrew = 0;

	class west
	{
		class primary
		{
			class rhs_weap_m4a1
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_m4a1";
				magazines[]= {"rhs_mag_30Rnd_556x45_M855A1_Stanag",9,"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_ACOG_RMR"},{8,"rhsusf_acc_g33_T1"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_grip2"},{4,"rhsusf_acc_grip1"},{6,"rhsusf_acc_harris_bipod"}};
			};

			class rh_sweap_mk18
			{
				unlockLevel = 13;
				cfgname = "rh_sweap_mk18";
				magazines[]= {"rhs_mag_30Rnd_556x45_M855A1_Stanag",9,"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_ACOG_RMR"},{8,"rhsusf_acc_g33_T1"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_grip2"},{4,"rhsusf_acc_grip1"},{6,"rhsusf_acc_harris_bipod"}};
			};

			class rhs_weap_hk416d10
			{
				unlockLevel = 23;
				cfgname = "rhs_weap_hk416d10";
				magazines[]= {"rhs_mag_30Rnd_556x45_M855A1_Stanag",9,"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_ACOG_RMR"},{8,"rhsusf_acc_g33_T1"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_grip2"},{4,"rhsusf_acc_grip1"},{6,"rhsusf_acc_harris_bipod"}};
			};
		};

		class secondary
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

			class rhs_weap_m72a7
			{
				unlockLevel = 10;
				cfgname = "rhs_weap_m72a7";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class CUP_launch_Mk153Mod0
			{
				unlockLevel = 20;
				cfgname = "rhs_weap_M136";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
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

		items1[]={{0,""},{20,"rhsusf_bino_m24_ARD", {}},{40,"rhsusf_bino_lrf_Vector21", {}}};
		items2[]={{0,"rhs_mag_an_m8hc", 2},{3,"rhs_mag_m18_green", 2},{7,"rhs_mag_m18_purple", 2},{11,"rhs_mag_m18_red", 2},{13,"rhs_mag_m18_yellow", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"rhs_mag_m67", 2},{3,"rhs_mag_an_m14_th3", 2},{7,"rhs_mag_m7a3_cs", 2},{11,"rhs_mag_mk84", 2},{13,"rhs_mag_mk3a2", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2}};
		nightVision[]= {{0,""},{0,"rhsusf_ANPVS_14"},{6,"rhsusf_ANPVS_15"}};
		headgear[]= {{0,"rhsusf_ach_helmet_ESS_ucp"},{1,"rhsusf_lwh_helmet_marpatwd_headset_blk2"},{4,"rhsusf_opscore_aor1_pelt_nsw"},{9,"rhsusf_opscore_aor2"},{12,"rhsusf_ach_helmet_ESS_ucp"},{18,"rhsusf_ach_helmet_headset_ocp"},{24,"rhsusf_opscore_bk_pelt"}};
		googles[]= {{0,""},{0,"rhs_ess_black"},{7,"rhsusf_shemagh_grn"},{9,"rhsusf_shemagh2_od"},{11,"rhsusf_shemagh_gogg_od"},{13,"G_Balaclava_blk"}};
		vests[]= {{0,"rhsusf_spcs_ocp_rifleman"},{1,"rhsusf_spcs_ucp_rifleman"},{9,"rhsusf_spc_rifleman"},{13,"rhsusf_mbav_rifleman"},{19,"rhsusf_iotv_ocp_Rifleman"},{21,"rhsusf_iotv_ucp_Rifleman"}};
		backpacks[]= {{0,"rhsusf_assault_eagleaiii_ucp"},{2,"rhsusf_assault_eagleaiii_ocp"},{6,"rhsusf_falconii_mc"},{10,"RHS_M2_Tripod_Bag"},{12,"RHS_M2_Gun_Bag"},{14,"RHS_Mk19_Tripod_Bag"},{16,"RHS_Mk19_Gun_Bag"},{18,"rhsusf_falconii"}};
		uniforms[]= {{0,"rhs_uniform_cu_ucp"},{8,"rhs_uniform_cu_ocp"},{15,"rhs_uniform_g3_mc"}};
		insigna[]= {{0,""},{0,"111thID"},{0,"BI"},{0,"Curator"},{0,"MANW"}};
	};

	class east
	{
		class primary
		{
			class rhs_weap_akmn
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_akmn";
				magazines[]= {"rhs_30Rnd_762x39mm_bakelite",9,"rhs_30Rnd_762x39mm_bakelite_tracer",2};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhs_acc_pbs1"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_ak104
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_ak104";
				magazines[]= {"rhs_30Rnd_762x39mm_polymer",9,"rhs_30Rnd_762x39mm_polymer_tracer",2};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhs_acc_pbs1"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_ak105_zenitco01
			{
				unlockLevel = 23;
				cfgname = "rhs_weap_ak105_zenitco01";
				magazines[]= {"rhs_30Rnd_545x39_7N10_AK",9,"rhs_30Rnd_545x39_AK_plum_green",2};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_ACOG_RMR"},{8,"rhsusf_acc_g33_T1"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhs_acc_dtk4short"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_grip2"},{4,"rhsusf_acc_grip1"},{6,"rhsusf_acc_harris_bipod"}};
			};
		};

		class secondary
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

			class rhs_weap_rpg26
			{
				unlockLevel = 10;
				cfgname = "rhs_weap_rpg26";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_rshg2
			{
				unlockLevel = 20;
				cfgname = "rhs_weap_rshg2";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
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

		items1[]={{0,""},{20,"rhssaf_zrak_rd7j", {}},{40,"rhs_pdu4", {}}};
		items2[]={{0,"rhs_mag_nspd", 2},{3,"rhs_mag_nspn_green", 2},{7,"rhs_mag_nspn_red", 2},{11,"rhs_mag_nspn_yellow", 2},{13,"rhs_mag_plamyam", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"rhs_mag_rgd5", 2},{3,"rhs_mag_rgn", 2},{7,"rhs_mag_rgo", 2},{11,"rhs_mag_zarya2", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2}};
		nightVision[]= {{0,""},{0,"rhs_1PN138"}};
		headgear[]= {{0,"rhs_6b27m_green"},{1,"rhs_6b26"},{4,"rhs_6b27m_idgi_bala"},{9,"rhs_6b27m_ml_ess"},{12,"rhs_6b28_green"},{18,"rhs_6b7_1m_olive"},{24,"rhs_altyn"}};
		googles[]= {{0,""},{0,"rhs_ess_black"},{7,"rhsusf_shemagh_grn"},{9,"rhsusf_shemagh2_od"},{11,"rhsusf_shemagh_gogg_od"},{13,"G_Balaclava_blk"}};
		vests[]= {{0,"rhs_6b23_ML_rifleman"},{1,"rhs_6b23_rifleman"},{9,"rhs_6b13_Flora_6sh92_radio"},{13,"rhs_6b13_6sh92"},{19,"rhs_6b23_6sh92_vog"},{21,"rhs_6sh92_digi"}};
		backpacks[]= {{0,"rhs_sidor"},{2,"rhs_assault_umbts"}};
		uniforms[]= {{0,"rhs_uniform_emr_des_patchless"},{8,"rhs_uniform_flora_patchless"},{15,"rhs_uniform_mflora_patchless"}};
		insigna[]= {{0,""},{0,"111thID"},{0,"BI"},{0,"Curator"},{0,"MANW"}};
	};

	class guer
	{
		class primary
		{
			class rhs_weap_m76
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_m76";
				magazines[]= {"rhsgref_10Rnd_792x57_m76",9,"rhssaf_10Rnd_792x57_m76_tracer",2};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhs_acc_pbs1"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_m21a
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_m21a";
				magazines[]= {"rhsgref_30rnd_556x45_m21",9,"rhsgref_30rnd_556x45_m21_t",2};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhs_acc_2dpZenit"},{5,"rhs_acc_perst1ik"}};
				attachments4[]= {};
			};

			class rhs_weap_m70b1n
			{
				unlockLevel = 23;
				cfgname = "rhs_weap_m70b1n";
				magazines[]= {"rhssaf_30Rnd_762x39mm_M67",9,"rhssaf_30Rnd_762x39mm_M78_tracer",2};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhs_acc_pbs1"}};
				attachments3[]= {{0,""},{1,"rhs_acc_2dpZenit"},{5,"rhs_acc_perst1ik"}};
				attachments4[]= {};
			};
		};

		class secondary
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

			class rhs_weap_panzerfaust60
			{
				unlockLevel = 10;
				cfgname = "rhs_weap_panzerfaust60";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_rpg75
			{
				unlockLevel = 20;
				cfgname = "rhs_weap_rpg75";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
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

		items1[]={{0,""},{20,"rhssaf_zrak_rd7j", {}},{40,"rhs_pdu4", {}}};
		items2[]={{0,"rhs_mag_nspd", 2},{3,"rhs_mag_nspn_green", 2},{7,"rhs_mag_nspn_red", 2},{11,"rhs_mag_nspn_yellow", 2},{13,"rhs_mag_plamyam", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		items3[]={{0,"rhs_mag_rgd5", 2},{3,"rhs_mag_rgn", 2},{7,"rhs_mag_rgo", 2},{11,"rhs_mag_zarya2", 2},{21,"Chemlight_green", 2},{22,"Chemlight_red", 2},{23,"Chemlight_yellow", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2}};
		nightVision[]= {{0,""},{0,"rhs_1PN138"}};
		headgear[]= {{0,"rhsgref_helmet_pasgt_altis_lizard"},{1,"rhsgref_ssh68_ttsko_forest"},{4,"rhsgref_helmet_pasgt_erdl_rhino"},{9,"rhsgref_helmet_pasgt_3color_desert"},{12,"rhsgref_6b27m_ttsko_forest"},{18,"rhsgref_6b27m_ttsko_digi"},{24,"rhsgref_helmet_pasgt_olive"}};
		googles[]= {{0,""},{0,"rhs_ess_black"},{7,"rhsusf_shemagh_grn"},{9,"rhsusf_shemagh2_od"},{11,"rhsusf_shemagh_gogg_od"},{13,"G_Balaclava_blk"}};
		vests[]= {{0,"rhssaf_vest_md98_rifleman"},{1,"rhssaf_vest_md99_md2camo_rifleman_radio"},{9,"rhssaf_vest_md12_digital"},{13,"rhssaf_vest_md12_digital_desert"},{19,"rhssaf_vest_md99_digital_rifleman"},{21,"rhs_6sh92_digi"}};
		backpacks[]= {{0,"rhs_sidor"},{2,"rhssaf_kitbag_smb"}};
		uniforms[]= {{0,"rhsgref_uniform_altis_lizard_olive"},{8,"rhsgref_uniform_woodland"},{15,"rhsgref_uniform_tigerstripe"}};
		insigna[]= {{0,""},{0,"111thID"},{0,"BI"},{0,"Curator"},{0,"MANW"}};
	};
};