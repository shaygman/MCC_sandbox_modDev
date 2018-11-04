class marksman : rifleman
{
	name    = "marksman";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\Marksman.paa");
	minPlayersForKit = 4;
	maxKitsInGroup = 1;
	maxKitsInSide = 999;
	allowMg = 0;
	allowAT = 0;
	allowSniper = 1;
	allowPilot = 0;
	allowCrew = 0;

	class west : west
	{
		class primary
		{
			class rhs_weap_m14ebrri
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_m14ebrri";
				magazines[]= {"rhsusf_20Rnd_762x51_m993_Mag",6,"rhsusf_20Rnd_762x51_m62_Mag",2};
				attachments1[]= {{0,"rhsusf_acc_ACOG_RMR"},{4,"rhsusf_acc_ACOG_MDO"},{6,"rhsusf_acc_M8541_low"},{8,"rhsusf_acc_LEUPOLDMK4"},{10,"rhsusf_acc_LEUPOLDMK4_2"}};
				attachments2[]= {};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_harris_bipod"}};
			};

			class rhs_weap_m24sws
			{
				unlockLevel = 6;
				cfgname = "rhs_weap_m24sws";
				magazines[]= {"rhsusf_5Rnd_762x51_m993_Mag",7,"rhsusf_5Rnd_762x51_m62_Mag",2};
				attachments1[]= {{0,"rhsusf_acc_ACOG_RMR"},{4,"rhsusf_acc_ACOG_MDO"},{6,"rhsusf_acc_M8541_low"},{8,"rhsusf_acc_LEUPOLDMK4"},{10,"rhsusf_acc_LEUPOLDMK4_2"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_m24_silencer_black"}};
				attachments3[]= {};
				attachments4[]= {{0,""},{2,"rhsusf_acc_harris_bipod"}};
			};

			class rhs_weap_m40a5
			{
				unlockLevel = 12;
				cfgname = "rhs_weap_m40a5";
				magazines[]= {"rhsusf_10Rnd_762x51_m993_Mag",6,"rhsusf_10Rnd_762x51_m62_Mag",2};
				attachments1[]= {{0,"rhsusf_acc_ACOG_RMR"},{4,"rhsusf_acc_ACOG_MDO"},{6,"rhsusf_acc_M8541_low"},{8,"rhsusf_acc_LEUPOLDMK4"},{10,"rhsusf_acc_LEUPOLDMK4_2"}};
				attachments2[]= {};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_harris_bipod"}};
			};

			class rhs_weap_sr25_ec
			{
				unlockLevel = 18;
				cfgname = "rhs_weap_sr25_ec";
				magazines[]= {"rhsusf_20Rnd_762x51_SR25_m993_Mag",6,"rhsusf_20Rnd_762x51_SR25_m62_Mag",2};
				attachments1[]= {{0,"rhsusf_acc_ACOG_RMR"},{4,"rhsusf_acc_ACOG_MDO"},{6,"rhsusf_acc_M8541_low"},{8,"rhsusf_acc_LEUPOLDMK4"},{10,"rhsusf_acc_LEUPOLDMK4_2"}};
				attachments2[]= {{0,""},{9,"rhsusf_cac_SR25S"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_harris_bipod"}};
			};

			class rhs_weap_XM2010
			{
				unlockLevel = 24;
				cfgname = "rhs_weap_XM2010";
				magazines[]= {"rhsusf_5Rnd_300winmag_xm2010",11};
				attachments1[]= {{0,"rhsusf_acc_M8541_low"},{4,"rhsusf_acc_LEUPOLDMK4"},{6,"rhsusf_acc_LEUPOLDMK4_2"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_M2010S_wd"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_harris_bipod"}};
			};

			class rhs_weap_M107
			{
				unlockLevel = 30;
				cfgname = "rhs_weap_M107";
				magazines[]= {"rhsusf_mag_10Rnd_STD_50BMG_M33",5};
				attachments1[]= {{0,"rhsusf_acc_M8541_low"},{4,"rhsusf_acc_LEUPOLDMK4"},{6,"rhsusf_acc_LEUPOLDMK4_2"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		class secondary
		{
		};


		items1[]={{0,"rhsgref_6b23_ttsko_mountain_nco", {}},{10,"Laserdesignator", {"Laserbatteries",2}}};
		vests[]= {{0,"rhsusf_spcs_ocp_sniper"},{1,"rhsusf_spcs_ucp_sniper"},{9,"rhsusf_spc_marksman"},{13,"rhsusf_mbav_light"},{19,"rhsusf_iotv_ucp"},{21,"rhsusf_iotv_ocp"}};
		uniforms[]= {{0,"rhs_uniform_cu_ucp"},{8,"rhs_uniform_cu_ocp"},{15,"rhs_uniform_g3_mc"},{18,"U_B_GhillieSuit"},{23,"U_B_FullGhillie_sard"},{29,"U_B_FullGhillie_lsh"},{31,"U_B_FullGhillie_ard"}};
	};

	class east : east
	{
		class primary
		{
			class rhs_weap_svdp
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_svdp";
				magazines[]= {"rhs_10Rnd_762x54mmR_7N1",9};
				attachments1[]= {{0,"rhs_acc_1pn93_1"},{4,"rhs_acc_pso1m2"},{8,"rhs_acc_pso1m21"}};
				attachments2[]= {{0,""},{9,"rhs_acc_tgpv2"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_t5000
			{
				unlockLevel = 6;
				cfgname = "rhs_weap_t5000";
				magazines[]= {"rhs_5Rnd_338lapua_t5000",9};
				attachments1[]= {{0,"rhs_acc_dh520x56"},{4,"rhs_acc_rakursPM"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {{0,""},{3,"rhs_acc_harris_swivel"}};
			};

			class rhs_weap_vss
			{
				unlockLevel = 12;
				cfgname = "rhs_weap_vss";
				magazines[]= {"rhs_10rnd_9x39mm_SP5",9};
				attachments1[]= {{0,"rhs_acc_1pn93_1"},{4,"rhs_acc_pso1m2"},{8,"rhs_acc_pso1m21"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		items1[]={{0,"rhs_pdu4", {}},{10,"Laserdesignator", {"Laserbatteries",2}}};
		uniforms[]= {{0,"rhs_uniform_gorka_r_g"},{8,"rhs_uniform_gorka_r_y"},{15,"rhs_uniform_mvd_izlom"},{18,"U_O_GhillieSuit"},{23,"U_O_FullGhillie_sard"},{29,"U_O_FullGhillie_lsh"},{31,"U_O_FullGhillie_ard"}};
		vests[]= {{0,"rhs_6b23_ML_sniper"},{1,"rhs_6b23_digi_sniper"},{9,"rhs_6b23_sniper"},{13,"rhs_6sh92_vsr_vog"},{19,"rhs_6sh92_vsr"},{21,"rhs_6sh92_digi"}};
	};

	class guer : guer
	{
		class primary
		{
			class rhs_weap_m38_rail
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_m38_rail";
				magazines[]= {"rhsgref_5Rnd_762x54_m38",9};
				attachments1[]= {{0,"rhsusf_acc_ACOG_RMR"},{4,"rhsusf_acc_ACOG_MDO"},{6,"rhsusf_acc_M8541_low"},{8,"rhsusf_acc_LEUPOLDMK4"},{10,"rhsusf_acc_LEUPOLDMK4_2"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_svdp
			{
				unlockLevel = 6;
				cfgname = "rhs_weap_svdp";
				magazines[]= {"rhs_10Rnd_762x54mmR_7N1",9};
				attachments1[]= {{0,"rhs_acc_1pn93_1"},{4,"rhs_acc_pso1m2"},{8,"rhs_acc_pso1m21"}};
				attachments2[]= {{0,""},{9,"rhs_acc_tgpv2"}};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_t5000
			{
				unlockLevel = 12;
				cfgname = "rhs_weap_t5000";
				magazines[]= {"rhs_5Rnd_338lapua_t5000",9};
				attachments1[]= {{0,"rhs_acc_dh520x56"},{4,"rhs_acc_rakursPM"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {{0,""},{3,"rhs_acc_harris_swivel"}};
			};
		};

		items1[]={{0,"rhs_pdu4", {}},{10,"Laserdesignator", {"Laserbatteries",2}}};
		uniforms[]= {{0,"rhssaf_uniform_m10_digital"},{8,"rhssaf_uniform_m10_digital_summer"},{15,"rhssaf_uniform_m93_oakleaf_summer"},{18,"U_I_GhillieSuit"},{23,"U_I_FullGhillie_sard"},{29,"U_I_FullGhillie_lsh"},{31,"U_I_FullGhillie_ard"}};
		vests[]= {{0,"rhsgref_6b23_khaki_sniper"},{1,"rhsgref_6b23_ttsko_digi_sniper"},{9,"rhsgref_6b23_ttsko_mountain_sniper"},{13,"rhs_6b5_sniper_khaki"},{19,"rhs_6b5_sniper"},{21,"rhs_6b5_sniper_ttsko"}};
	};
};