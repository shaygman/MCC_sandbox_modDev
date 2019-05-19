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
			class rhs_weap_m4_m203S
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_m4_m203S";
				magazines[]= {"rhs_mag_30Rnd_556x45_M855A1_Stanag",9,"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2,"rhs_mag_M433_HEDP",6,"rhs_mag_m4009",1,"1Rnd_SmokeRed_Grenade_shell",1,"1Rnd_SmokeGreen_Grenade_shell",1};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_ACOG_RMR"},{8,"rhsusf_acc_g33_T1"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {};
			};

			class rhs_weap_mk18_m320
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_mk18_m320";
				magazines[]= {"rhs_mag_30Rnd_556x45_M855A1_Stanag",9,"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2,"rhs_mag_M433_HEDP",6,"rhs_mag_m4009",1,"1Rnd_SmokeRed_Grenade_shell",1,"1Rnd_SmokeGreen_Grenade_shell",1};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_ACOG_RMR"},{8,"rhsusf_acc_g33_T1"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {};
			};

			class rhs_weap_hk416d10_m320
			{
				unlockLevel = 23;
				cfgname = "rhs_weap_hk416d10_m320";
				magazines[]= {"rhs_mag_30Rnd_556x45_M855A1_Stanag",9,"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2,"rhs_mag_M433_HEDP",6,"rhs_mag_m4009",1,"1Rnd_SmokeRed_Grenade_shell",1,"1Rnd_SmokeGreen_Grenade_shell",1};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_ACOG_RMR"},{8,"rhsusf_acc_g33_T1"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
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

			class MCC_TentDome
			{
				unlockLevel = 0;
				cfgname = "MCC_TentDome";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};


		items1[]={{0,"rhsusf_bino_m24_ARD"},{5,"rhsusf_bino_lerca_1200_black", {}},{10,"Laserdesignator", {"Laserbatteries",2}}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"ItemGPS",1}};
		vests[]= {{0,"rhsusf_spcs_ocp_teamleader"},{1,"rhsusf_spcs_ucp_teamleader"},{9,"rhsusf_spc_teamleader"},{13,"rhsusf_mbav_grenadier"},{19,"rhsusf_iotv_ocp_Teamleader"},{21,"rhsusf_iotv_ucp_Teamleader"}};
	};

	class east : east
	{
		class primary
		{
			class rhs_weap_akmn_gp25
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_akmn_gp25";
				magazines[]= {"rhs_30Rnd_762x39mm_bakelite",9,"rhs_30Rnd_762x39mm_bakelite_tracer",2,"rhs_VOG25",6,"rhs_VG40SZ",1,"rhs_GRD40_Red",1,"rhs_GRD40_Green",1};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhs_acc_pbs1"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_ak103_gp25
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_ak103_gp25";
				magazines[]= {"rhs_30Rnd_762x39mm_polymer",9,"rhs_30Rnd_762x39mm_polymer_tracer",2,"rhs_VOG25",6,"rhs_VG40SZ",1,"rhs_GRD40_Red",1,"rhs_GRD40_Green",1};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhs_acc_pbs1"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_ak74m_gp25
			{
				unlockLevel = 23;
				cfgname = "rhs_weap_ak74m_gp25";
				magazines[]= {"rhs_30Rnd_545x39_7N10_AK",9,"rhs_30Rnd_545x39_7N10_AK",2,"rhs_VOG25",6,"rhs_VG40SZ",1,"rhs_GRD40_Red",1,"rhs_GRD40_Green",1};
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

			class MCC_TentA
			{
				unlockLevel = 0;
				cfgname = "MCC_TentA";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		items1[]={{0,"rhssaf_zrak_rd7j"},{5,"rhs_pdu4", {}},{10,"Laserdesignator", {"Laserbatteries",2}}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"ItemGPS",1}};
		vests[]= {{0,"rhs_6b23_ML_6sh92_headset_mapcase"},{1,"rhs_6b13_EMR_6sh92_headset_mapcase"},{9,"rhs_6b13_Flora_6sh92_radio"},{13,"rhs_6b23_6sh92_headset_mapcase"},{19,"rhs_6b13_6sh92_headset_mapcase"},{21,"rhs_6b23_digi_6sh92_headset_mapcase"}};
	};

	class guer : guer
	{
		class primary
		{
			class rhs_weap_akmn_gp25
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_akmn_gp25";
				magazines[]= {"rhs_30Rnd_762x39mm_bakelite",9,"rhs_30Rnd_762x39mm_bakelite_tracer",2,"rhs_VOG25",6,"rhs_VG40SZ",1,"rhs_GRD40_Red",1,"rhs_GRD40_Green",1};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhs_acc_pbs1"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_ak103_gp25
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_ak103_gp25";
				magazines[]= {"rhs_30Rnd_762x39mm_polymer",9,"rhs_30Rnd_762x39mm_polymer_tracer",2,"rhs_VOG25",6,"rhs_VG40SZ",1,"rhs_GRD40_Red",1,"rhs_GRD40_Green",1};
				attachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"rhs_acc_pbs1"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_ak74m_gp25
			{
				unlockLevel = 23;
				cfgname = "rhs_weap_ak74m_gp25";
				magazines[]= {"rhs_30Rnd_545x39_7N10_AK",9,"rhs_30Rnd_545x39_7N10_AK",2,"rhs_VOG25",6,"rhs_VG40SZ",1,"rhs_GRD40_Red",1,"rhs_GRD40_Green",1};
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

			class MCC_TentA
			{
				unlockLevel = 0;
				cfgname = "MCC_TentA";
				magazines[]= {};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		items1[]={{0,"rhssaf_zrak_rd7j"},{5,"rhs_pdu4", {}},{10,"Laserdesignator", {"Laserbatteries",2}}};
		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"ItemGPS",1}};
		vests[]= {{0,"rhsgref_6b23_khaki_officer"},{1,"rhsgref_6b23_ttsko_digi_officer"},{9,"rhsgref_6b23_ttsko_mountain_officer"},{13,"rhs_6b5_officer_khaki"},{19,"rhs_6b5_officer"},{21,"rhs_6b5_officer_ttsko"}};
	};
};