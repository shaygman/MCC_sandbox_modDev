class corpsman : rifleman
{
	name    = "Corpsman";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\Corpsman.paa");
	minPlayersForKit = 0;
	maxKitsInGroup = 2;
	maxKitsInSide = 999;
	allowMg = 0;
	allowAT = 0;
	allowSniper = 0;
	allowPilot = 0;
	allowCrew = 0;

	class west : west
	{
		class secondary
		{
		};

		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"Medikit", 1},{0,"FirstAidKit",10}};
		vests[]= {{0,"rhsusf_spcs_ocp_medic"},{1,"rhsusf_spcs_ucp_medic"},{9,"rhsusf_spc_corpsman"},{13,"rhsusf_mbav_medic"},{19,"rhsusf_iotv_ocp_Medic"},{21,"rhsusf_iotv_ucp_Medic"}};
	};

	class east : east
	{
		class secondary
		{
		};

		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"Medikit", 1},{0,"FirstAidKit",10}};
		backpacks[]= {{0,"rhs_medic_bag"}};
	};

	class guer : guer
	{
		class secondary
		{
		};

		generalItems[]= {{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"Medikit", 1},{0,"FirstAidKit",10}};
		backpacks[]= {{0,"rhs_medic_bag"}};
	};
};