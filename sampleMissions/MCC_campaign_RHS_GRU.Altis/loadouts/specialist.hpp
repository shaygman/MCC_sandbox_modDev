class specialist : rifleman
{
	name    = "Specialist";
	picture =  __EVAL(MCCPATH +"mcc\roleSelection\data\Specialist.paa");
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
		items1[]={{0,"MineDetector", {}},{10,"MCC_videoProbe", {}},{15,"Binocular", {}},{20,"Rangefinder", {}}};
		items2[]={{0,"ClaymoreDirectionalMine_Remote_Mag", 2},{3,"APERSMine_Range_Mag", 2},{7,"APERSBoundingMine_Range_Mag", 2},{11,"SLAMDirectionalMine_Wire_Mag", 2},{13,"ATMine_Range_Mag", 2},{21,"SatchelCharge_Remote_Mag", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"MCC_multiTool",1},{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"DemoCharge_Remote_Mag",2}};
	};

	class east : east
	{
		items1[]={{0,"MineDetector", {}},{10,"MCC_videoProbe", {}},{15,"Binocular", {}},{20,"Rangefinder", {}}};
		items2[]={{0,"ClaymoreDirectionalMine_Remote_Mag", 2},{3,"APERSMine_Range_Mag", 2},{7,"APERSBoundingMine_Range_Mag", 2},{11,"SLAMDirectionalMine_Wire_Mag", 2},{13,"ATMine_Range_Mag", 2},{21,"SatchelCharge_Remote_Mag", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"MCC_multiTool",1},{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"DemoCharge_Remote_Mag",2}};
		backpacks[]= {{0,"rhs_assault_umbts_engineer_empty"}};
	};

	class guer : guer
	{
		items1[]={{0,"MineDetector", {}},{10,"MCC_videoProbe", {}},{15,"Binocular", {}},{20,"Rangefinder", {}}};
		items2[]={{0,"ClaymoreDirectionalMine_Remote_Mag", 2},{3,"APERSMine_Range_Mag", 2},{7,"APERSBoundingMine_Range_Mag", 2},{11,"SLAMDirectionalMine_Wire_Mag", 2},{13,"ATMine_Range_Mag", 2},{21,"SatchelCharge_Remote_Mag", 2},{25,"B_IR_Grenade", 2}};
		generalItems[]= {{0,"MCC_multiTool",1},{0,"ItemMap",1},{0,"ItemCompass",1},{0,"ItemWatch",1},{0,"ItemRadio",1},{0,"FirstAidKit",2},{0,"DemoCharge_Remote_Mag",2}};
	};
};