class at : rifleman
{
	name    = "Anti-Tank";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\AT.paa");
	minPlayersForKit = 2;
	maxKitsInGroup = 2;
	maxKitsInSide = 999;
	allowMg = 0;
	allowAT = 1;
	allowSniper = 0;
	allowPilot = 0;
	allowCrew = 0;

	class west : west
	{
		class secondary
		{
			class rhs_weap_maaws
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_maaws";
				magazines[]= {"rhs_mag_maaws_HEAT",2,"rhs_mag_maaws_HEDP",1};
				attachments1[]= {{0,""},{6,"rhs_optic_maaws"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_fim92
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_fim92";
				magazines[]= {"rhs_fim92_mag",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_smaw_green
			{
				unlockLevel = 15;
				cfgname = "rhs_weap_smaw_green";
				magazines[]= {"rhs_mag_smaw_HEAA",2,"rhs_mag_smaw_SR",2};
				attachments1[]= {{0,""},{3,"rhs_weap_optic_smaw"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_fgm148
			{
				unlockLevel = 25;
				cfgname = "rhs_weap_fgm148";
				magazines[]= {"rhs_fgm148_magazine_AT",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		backpacks[]= {{0,"rhsusf_assault_eagleaiii_ucp"},{2,"rhsusf_assault_eagleaiii_ocp"},{6,"B_Carryall_cbr"},{10,"B_Carryall_oli"}};
	};

	class east : east
	{
		class secondary
		{
			class rhs_weap_rpg7
			{
				unlockLevel = 15;
				cfgname = "rhs_weap_rpg7";
				magazines[]= {"rhs_rpg7_PG7VL_mag",2,"rhs_rpg7_PG7V_mag",2};
				attachments1[]= {{0,""},{3,"rhs_acc_pgo7v3"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_igla
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_igla";
				magazines[]= {"rhs_mag_9k38_rocket",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class launch_I_Titan_short_F
			{
				unlockLevel = 15;
				cfgname = "launch_I_Titan_short_F";
				magazines[]= {"Titan_AT",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class launch_O_Vorona_green_F
			{
				unlockLevel = 25;
				cfgname = "launch_O_Vorona_green_F";
				magazines[]= {"Vorona_HEAT",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		backpacks[]= {{0,"rhs_rpg_empty"}};
	};

	class guer : guer
	{
		class secondary
		{
			class rhs_weap_rpg7
			{
				unlockLevel = 15;
				cfgname = "rhs_weap_rpg7";
				magazines[]= {"rhs_rpg7_PG7VL_mag",2,"rhs_rpg7_PG7V_mag",2};
				attachments1[]= {{0,""},{3,"rhs_acc_pgo7v3"}};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class rhs_weap_igla
			{
				unlockLevel = 0;
				cfgname = "rhs_weap_igla";
				magazines[]= {"rhs_mag_9k38_rocket",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class launch_I_Titan_short_F
			{
				unlockLevel = 15;
				cfgname = "launch_I_Titan_short_F";
				magazines[]= {"Titan_AT",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};

			class launch_O_Vorona_green_F
			{
				unlockLevel = 25;
				cfgname = "launch_O_Vorona_green_F";
				magazines[]= {"Vorona_HEAT",2};
				attachments1[]= {};
				attachments2[]= {};
				attachments3[]= {};
				attachments4[]= {};
			};
		};

		backpacks[]= {{0,"rhs_rpg_empty"}};
	};
};