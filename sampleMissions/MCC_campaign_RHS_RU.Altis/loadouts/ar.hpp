class ar : rifleman
{
	name    = "Automatic Rifleman";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\AR.paa");
	minPlayersForKit = 2;
	maxKitsInGroup = 2;
	maxKitsInSide = 999;
	allowMg = 1;
	allowAT = 0;
	allowSniper = 0;
	allowPilot = 0;
	allowCrew = 0;

	class west : west
	{
		class primary
		{
			class rhs_weap_m249_pip_S_para
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_m249_pip_S_para";
				magazines[]= {"rhsusf_200rnd_556x45_mixed_box",3};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_su230a"},{8,"rhsusf_acc_ACOG_MDO"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {};
			};

			class rhs_weap_m27iar
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_m27iar";
				magazines[]= {"rhs_mag_100Rnd_556x45_M855A1_cmag_mixed",4};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_su230a"},{8,"rhsusf_acc_ACOG_MDO"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_nt4_black"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {{0,""},{2,"rhsusf_acc_harris_bipod"},{4,"rhsusf_acc_grip1"},{6,"rhsusf_acc_grip2"}};
			};

			class rhs_weap_m240B
			{
				unlockLevel = 23;
				cfgname = "rhs_weap_m240B";
				magazines[]= {"rhsusf_50Rnd_762x51",2,"rhsusf_100Rnd_762x51",2};
				attachments1[]= {{0,""},{3,"rhsusf_acc_eotech_552"},{4,"rhsusf_acc_T1_high"},{6,"rhsusf_acc_su230a"},{8,"rhsusf_acc_ACOG_MDO"},{10,"rhsusf_acc_anpas13gv1"}};
				attachments2[]= {{0,""},{9,"rhsusf_acc_ARDEC_M240"}};
				attachments3[]= {{0,""},{1,"rhsusf_acc_M952V"},{5,"rhsusf_acc_anpeq15A"},{7,"rhsusf_acc_anpeq15_bk_light"}};
				attachments4[]= {};
			};
		};

		class secondary
		{
		};

		vests[]= {{0,"rhsusf_spcs_ocp_machinegunner"},{1,"rhsusf_spcs_ucp_machinegunner"},{9,"rhsusf_spc_mg"},{13,"rhsusf_mbav_mg"},{19,"rhsusf_iotv_ocp_Rifleman"},{21,"rhsusf_iotv_ucp_Rifleman"}};
		backpacks[]= {{0,"rhsusf_assault_eagleaiii_ucp"},{2,"rhsusf_assault_eagleaiii_ocp"},{6,"B_Carryall_cbr"},{10,"B_Carryall_oli"}};
	};

	class east : east
	{
		class primary
		{
			class rhs_weap_pkm
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_pkm";
				magazines[]= {"rhs_100Rnd_762x54mmR",3};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_pkp
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_pkp";
				magazines[]= {"rhs_100Rnd_762x54mmR",3};
				aattachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"CUP_muzzle_PBS4"}};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		class secondary
		{
		};

	};

	class guer : guer
	{
		class primary
		{
			class rhs_weap_mg42
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_mg42";
				magazines[]= {"rhsgref_50Rnd_792x57_SmE_drum",6};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_pkp
			{
				unlockLevel = 13;
				cfgname = "rhs_weap_pkp";
				magazines[]= {"rhs_100Rnd_762x54mmR",3};
				aattachments1[]= {{0,""},{3,"rhs_acc_ekp1"},{4,"rhs_acc_ekp8_02"},{6,"rhs_acc_1p63"},{8,"rhs_acc_1p29"},{10,"rhs_acc_1p78"}};
				attachments2[]= {{0,""},{9,"CUP_muzzle_PBS4"}};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		class secondary
		{
		};

	};
};