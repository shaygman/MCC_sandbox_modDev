class MCC_rts_fortSandbagLong
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\sandbagLong.paa";
	#else
	picture = "mcc\rts\forts\data\sandbagLong.paa";
	#endif

	displayName = "Sandbag Long";
	descriptionShort = "Build Sandbag Long";
	condition = "";
	requiredBuildings[] = {{"hq",1}};
	needelectricity = 0;
	classEast = "Land_BagFence_Long_F";
	classWest = "Land_BagFence_Long_F";
	classGuer = "Land_BagFence_Long_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",10}};
};

class MCC_rts_fortSandbagRound
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\sandbagRound.paa";
	#else
	picture = "mcc\rts\forts\data\sandbagRound.paa";
	#endif

	displayName = "Sandbag Round";
	descriptionShort = "Build Sandbag Round";
	condition = "";
	requiredBuildings[] = {{"hq",1}};
	needelectricity = 0;
	classEast = "Land_BagFence_Round_F";
	classWest = "Land_BagFence_Round_F";
	classGuer = "Land_BagFence_Round_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",10}};
};

class MCC_rts_fortRazorwire
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\razorwire.paa";
	#else
	picture = "mcc\rts\forts\data\razorwire.paa";
	#endif

	displayName = "Razorwire";
	descriptionShort = "Build Razorwire";
	condition = "";
	requiredBuildings[] = {{"hq",1}};
	needelectricity = 0;
	classEast = "Land_Razorwire_F";
	classWest = "Land_Razorwire_F";
	classGuer = "Land_Razorwire_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",10}};
};

class MCC_rts_fortSandbagTower
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\sandbagTower.paa";
	#else
	picture = "mcc\rts\forts\data\sandbagTower.paa";
	#endif

	displayName = "Sandbag Tower";
	descriptionShort = "Build Sandbag Tower";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "Land_BagBunker_Tower_F";
	classWest = "Land_BagBunker_Tower_F";
	classGuer = "Land_BagBunker_Tower_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",100}};
};

class MCC_rts_fortHBarrierSmall
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\hBarrierSmall.paa";
	#else
	picture = "mcc\rts\forts\data\hBarrierSmall.paa";
	#endif

	displayName = "H-Barrier Small";
	descriptionShort = "Build H-Barrier Small";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "Land_HBarrier_3_F";
	classWest = "Land_HBarrier_3_F";
	classGuer = "Land_HBarrier_3_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",15}};
};

class MCC_rts_fortHBarrierLong
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\hBarrierLong.paa";
	#else
	picture = "mcc\rts\forts\data\hBarrierLong.paa";
	#endif

	displayName = "H-Barrier Big";
	descriptionShort = "Build H-Barrier Big";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "Land_HBarrier_Big_F";
	classWest = "Land_HBarrier_Big_F";
	classGuer = "Land_HBarrier_Big_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",20}};
};

class MCC_rts_forthBarrierCatwalk
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\hBarrierCatwalk.paa";
	#else
	picture = "mcc\rts\forts\data\hBarrierCatwalk.paa";
	#endif

	displayName = "H-Barrier Catwalk";
	descriptionShort = "Build H-Barrier Catwalk";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "Land_HBarrierWall6_F";
	classWest = "Land_HBarrierWall6_F";
	classGuer = "Land_HBarrierWall6_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",30}};
};

class MCC_rts_forthBarrierCorner
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\hBarrierCorner.paa";
	#else
	picture = "mcc\rts\forts\data\hBarrierCorner.paa";
	#endif

	displayName = "H-Barrier Corner";
	descriptionShort = "Build H-Barrier Corner";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "Land_HBarrierWall_corner_F";
	classWest = "Land_HBarrierWall_corner_F";
	classGuer = "Land_HBarrierWall_corner_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",30}};
};

class MCC_rts_forthBarrierCorridor
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\hBarrierCorridor.paa";
	#else
	picture = "mcc\rts\forts\data\hBarrierCorridor.paa";
	#endif

	displayName = "H-Barrier Corridor";
	descriptionShort = "Build H-Barrier Corridor";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "Land_HBarrierWall_corridor_F";
	classWest = "Land_HBarrierWall_corridor_F";
	classGuer = "Land_HBarrierWall_corridor_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",30}};
};

class MCC_rts_forthBarrierTower
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\hBarrierTower.paa";
	#else
	picture = "mcc\rts\forts\data\hBarrierTower.paa";
	#endif

	displayName = "H-Barrier Tower";
	descriptionShort = "Build H-Barrier Tower";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "Land_HBarrierTower_F";
	classWest = "Land_HBarrierTower_F";
	classGuer = "Land_HBarrierTower_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",80}};
};

class MCC_rts_fortAA
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\aa.paa";
	#else
	picture = "mcc\rts\forts\data\aa.paa";
	#endif

	displayName = "Anti-Air";
	descriptionShort = "Build Anti-Air";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "O_static_AA_F";
	classWest = "B_static_AA_F";
	classGuer = "I_static_AA_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",400}};
};

class MCC_rts_fortAT
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\at.paa";
	#else
	picture = "mcc\rts\forts\data\at.paa";
	#endif

	displayName = "Anti-Tank";
	descriptionShort = "Build Anti-Tank";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "O_static_AT_F";
	classWest = "B_static_AT_F";
	classGuer = "I_static_AT_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",400}};
};

class MCC_rts_fortgmg
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\gmg.paa";
	#else
	picture = "mcc\rts\forts\data\gmg.paa";
	#endif

	displayName = "Grenade MG";
	descriptionShort = "Build Grenade MG";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "O_GMG_01_F";
	classWest = "B_GMG_01_F";
	classGuer = "I_GMG_01_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",800}};
};

class MCC_rts_fortgmgHigh
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\gmgHigh.paa";
	#else
	picture = "mcc\rts\forts\data\gmgHigh.paa";
	#endif

	displayName = "Grenade MG (High)";
	descriptionShort = "Build Grenade MG (High)";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "O_GMG_01_high_F";
	classWest = "B_GMG_01_high_F";
	classGuer = "I_GMG_01_high_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",800}};
};

class MCC_rts_fortmg
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\mg.paa";
	#else
	picture = "mcc\rts\forts\data\mg.paa";
	#endif

	displayName = "Heavy MG";
	descriptionShort = "Build Heavy MG";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "O_HMG_01_F";
	classWest = "B_HMG_01_F";
	classGuer = "I_HMG_01_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",400}};
};

class MCC_rts_fortmgHigh
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\mgHigh.paa";
	#else
	picture = "mcc\rts\forts\data\mgHigh.paa";
	#endif

	displayName = "Heavy MG (High)";
	descriptionShort = "Build Heavy MG (High)";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "O_HMG_01_high_F";
	classWest = "B_HMG_01_high_F";
	classGuer = "I_HMG_01_high_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",400}};
};

class MCC_rts_fortMortar
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\mortar.paa";
	#else
	picture = "mcc\rts\forts\data\mortar.paa";
	#endif

	displayName = "Mortar";
	descriptionShort = "Build Mortar";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "O_Mortar_01_F";
	classWest = "B_Mortar_01_F";
	classGuer = "I_Mortar_01_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",400}};
};

class MCC_rts_fortTower
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\metalTower.paa";
	#else
	picture = "mcc\rts\forts\data\metalTower.paa";
	#endif

	displayName = "Metal Tower";
	descriptionShort = "Build Metal Tower";
	condition = "";
	requiredBuildings[] = {{"workshop",1}};
	needelectricity = 0;
	classEast = "Land_Cargo_Patrol_V1_F";
	classWest = "Land_Cargo_Patrol_V1_F";
	classGuer = "Land_Cargo_Patrol_V1_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",150}};
};

class MCC_rts_targetHostage
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\popUp_hostage.paa";
	#else
	picture = "mcc\rts\forts\data\popUp_hostage.paa";
	#endif

	displayName = "Target-Hostage";
	condition = "";
	requiredBuildings[] = {};
	needelectricity = 0;
	classEast = "TargetP_Civ3_F";
	classWest = "TargetP_Civ3_F";
	classGuer = "TargetP_Civ3_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",50}};
};

class MCC_rts_target1
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\popUp_target1.paa";
	#else
	picture = "mcc\rts\forts\data\popUp_target1.paa";
	#endif

	displayName = "Target-Infantry";
	condition = "";
	requiredBuildings[] = {};
	needelectricity = 0;
	classEast = "TargetP_Inf_F";
	classWest = "TargetP_Inf_F";
	classGuer = "TargetP_Inf_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",50}};
};

class MCC_rts_target2
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\popUp_target2.paa";
	#else
	picture = "mcc\rts\forts\data\popUp_target2.paa";
	#endif

	displayName = "Target-Simple";
	condition = "";
	requiredBuildings[] = {};
	needelectricity = 0;
	classEast = "Target_F";
	classWest = "Target_F";
	classGuer = "Target_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",50}};
};

class MCC_rts_target3
{
	#ifdef MCCMODE
	picture = "\mcc_sandbox_mod\mcc\rts\forts\data\popUp_target3.paa";
	#else
	picture = "mcc\rts\forts\data\popUp_target3.paa";
	#endif

	displayName = "Target-Duel";
	condition = "";
	requiredBuildings[] = {};
	needelectricity = 0;
	classEast = "Land_Target_Dueling_01_F";
	classWest = "Land_Target_Dueling_01_F";
	classGuer = "Land_Target_Dueling_01_F";
	actionFNC = "MCC_fnc_buildFort";
	resources[] = {{"repair",50}};
};