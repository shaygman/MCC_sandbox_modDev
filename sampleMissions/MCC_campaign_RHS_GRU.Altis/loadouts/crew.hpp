class crew : rifleman
{
	name    = "Crewman";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\Crew.paa");
	minPlayersForKit = 0;
	maxKitsInGroup = 99;
	maxKitsInSide = 999;
	allowMg = 0;
	allowAT = 0;
	allowSniper = 0;
	allowPilot = 0;
	allowCrew = 1;

	class west : west
	{
		class primary
		{
			class rhs_weap_m4a1
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_m4a1";
				magazines[]= {"rhs_mag_30Rnd_556x45_M855A1_Stanag",9,"rhs_mag_30Rnd_556x45_M855A1_Stanag_Tracer_Red",2};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"}};
				attachments2[]= {};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {};
			};

			class rhsusf_weap_MP7A2
			{
				unlockLevel = 13;
				cfgname = "rhsusf_weap_MP7A2";
				magazines[]= {"rhsusf_mag_40Rnd_46x30_FMJ",9};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"}};
				attachments2[]= {};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {};
			};
		};

		class secondary
		{
		};

		headgear[]= {{0,"rhsusf_cvc_green_helmet"},{1,"rhsusf_cvc_green_ess"},{4,"rhsusf_cvc_helmet"},{9,"rhsusf_cvc_alt_helmet"},{12,"rhsusf_cvc_ess"}};
		vests[]= {{0,"rhsusf_spcs_ocp_crewman"},{1,"rhsusf_spcs_ucp_crewman"},{9,"rhsusf_spc_crewman"},{13,"rhsusf_mbav"},{19,"rhsusf_iotv_ocp"},{21,"rhsusf_iotv_ucp"}};
		backpacks[]= {};
	};

	class east : east
	{
		class primary
		{
			class rhs_acc_pgs64_74un
			{
				unlockLevel = 0;
				cfgname = "rhs_acc_pgs64_74un";
				magazines[]= {"rhs_30Rnd_545x39_7N6M_AK",6};
				attachments1[]= {{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_pp2000
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_pp2000";
				magazines[]= {"rhs_mag_9x19mm_7n21_20",6};
				attachments1[]= {{3,"rhs_acc_1p87"},{4,"rhs_acc_rakursPM"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		class secondary
		{
		};

		backpacks[]= {};
		headgear[]= {{0,"rhs_tsh4"},{1,"rhs_tsh4_bala"},{4,"rhs_tsh4_ess"},{9,"rhs_tsh4_ess_bala"}};
		vests[]= {{0,"rhs_6b13_Flora"},{1,"rhs_6b23_crew"},{9,"rhs_6b23_digi_crew"},{13,"rhs_6b23_digi_crewofficer"},{19,"rhs_6b23_ML_crew"},{21,"rhs_6b23_ML_crewofficer"}};
		uniforms[]= {{0,"rhs_uniform_m88_patchless"}};
	};

	class guer : guer
	{
		class primary
		{
			class rhs_weap_m3a1
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_m3a1";
				magazines[]= {"rhsgref_30rnd_1143x23_M1911B_SMG",6};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_m92
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_m92";
				magazines[]= {"rhssaf_30Rnd_762x39mm_M67",6};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		class secondary
		{
		};

		backpacks[]= {};
		headgear[]= {{0,"rhs_tsh4"},{1,"rhs_tsh4_bala"},{4,"rhs_tsh4_ess"},{9,"rhs_tsh4_ess_bala"}};
		uniforms[]= {{0,"rhsgref_uniform_olive"}};
	};
};