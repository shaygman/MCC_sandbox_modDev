class MCC_rtsGroup_Transport
{
	picture = "\mcc_sandbox_mod\mcc\rts\data\groups\transport.paa";

	displayName = "Resources Transport";
	descriptionShort = "A basic truck to mobilize resources";
	condition = "";
	requiredBuildings[] = {{"barracks",1}};
	unitsEast[] = {"O_Truck_03_transport_F"};
	unitsWest[] = {"B_Truck_01_transport_F"};
	unitsGuer[] = {"I_Truck_02_transport_F"};
	needelectricity = 0;
	actions[] = {"MCC_rts_orderStop","MCC_rts_OrderGetout","MCC_rts_LoadResources","MCC_rts_UnLoadResources","","","","",""};
	actionFNC = "MCC_fnc_rtsCreateGroup";
	resources[] = {{"ammo",30},{"repair",30},{"fuel",15},{"food",100},{"time",15}};
};

class MCC_rtsGroup_FT
{
	picture = "\mcc_sandbox_mod\mcc\rts\data\groups\fireTeam.paa";

	displayName = "Fire Team";
	descriptionShort = "A basic combat group";
	condition = "";
	requiredBuildings[] = {{"barracks",1}};
	unitsEast[] = {"rhs_vdv_sergeant","rhs_vdv_arifleman","rhs_vdv_machinegunner_assistant","rhs_vdv_LAT"};
	unitsWest[] = {"rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_riflemanat"};
	unitsGuer[] = {"rhsgref_ins_g_rifleman","rhsgref_ins_g_machinegunner","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_RPG26"};
	needelectricity = 0;
	actions[] = {"MCC_rts_orderStop","","MCC_rts_orderStanceUp","MCC_rts_orderStanceDown","MCC_rts_orderPlaceSatchel","","MCC_rts_orderStealth","MCC_rts_orderAware","","","MCC_rts_takeControl","MCC_rts_respawnUnits"};
	actionFNC = "MCC_fnc_rtsCreateGroup";
	resources[] = {{"ammo",300},{"food",200},{"time",15}};
};

class MCC_rtsGroup_MG
{
	picture = "\mcc_sandbox_mod\mcc\rts\data\groups\ar.paa";

	displayName = "Machinegun Team";
	descriptionShort = "A heavy MG team";
	condition = "";
	requiredBuildings[] = {{"barracks",1}};
	unitsEast[] = {"rhs_vdv_machinegunner","rhs_vdv_machinegunner_assistant"};
	unitsWest[] = {"rhsusf_usmc_marpat_wd_machinegunner","rhsusf_usmc_marpat_wd_machinegunner_ass"};
	unitsGuer[] = {"rhsgref_ins_g_machinegunner","rhsgref_ins_g_rifleman_RPG26"};
	needelectricity = 0;
	actions[] = {"MCC_rts_orderStop","","MCC_rts_orderStanceUp","MCC_rts_orderStanceDown","MCC_rts_orderPlaceSatchel","","MCC_rts_orderStealth","MCC_rts_orderAware","","","MCC_rts_takeControl","MCC_rts_respawnUnits"};
	actionFNC = "MCC_fnc_rtsCreateGroup";
	resources[] = {{"ammo",400},{"food",100},{"time",15}};
};

class MCC_rtsGroup_AT
{
	picture = "\mcc_sandbox_mod\mcc\rts\data\groups\at.paa";

	displayName = "Anti-tank Team";
	descriptionShort = "A heavy Anti-tank team";
	condition = "";
	requiredBuildings[] = {{"barracks",2}};
	unitsEast[] = {"rhs_vdv_at","rhs_vdv_at"};
	unitsWest[] = {"rhsusf_usmc_marpat_wd_javelin","rhsusf_usmc_marpat_wd_javelin_assistant"};
	unitsGuer[] = {"rhsgref_ins_g_grenadier_rpg","rhsgref_ins_g_rifleman"};
	needelectricity = 0;
	actions[] = {"MCC_rts_orderStop","","MCC_rts_orderStanceUp","MCC_rts_orderStanceDown","MCC_rts_orderPlaceSatchel","","MCC_rts_orderStealth","MCC_rts_orderAware","","","MCC_rts_takeControl","MCC_rts_respawnUnits"};
	actionFNC = "MCC_fnc_rtsCreateGroup";
	resources[] = {{"ammo",500},{"food",100},{"time",15}};
};

class MCC_rtsGroup_AA
{
	picture = "\mcc_sandbox_mod\mcc\rts\data\groups\aa.paa";

	displayName = "Anti-air Team";
	descriptionShort = "A heavy Anti-air team";
	condition = "";
	requiredBuildings[] = {{"barracks",2}};
	unitsEast[] = {"rhs_vdv_aa","rhs_vdv_aa"};
	unitsWest[] = {"rhsusf_usmc_marpat_wd_stinger","rhsusf_usmc_marpat_wd_stinger"};
	unitsGuer[] = {"rhsgref_ins_g_specialist_aa","rhsgref_ins_g_rifleman"};
	needelectricity = 0;
	actions[] = {"MCC_rts_orderStop","","MCC_rts_orderStanceUp","MCC_rts_orderStanceDown","MCC_rts_orderPlaceSatchel","","MCC_rts_orderStealth","MCC_rts_orderAware","","","MCC_rts_takeControl","MCC_rts_respawnUnits"};
	actionFNC = "MCC_fnc_rtsCreateGroup";
	resources[] = {{"ammo",600},{"food",100},{"time",15}};
};

class MCC_rtsGroup_platoon
{
	picture = "\mcc_sandbox_mod\mcc\rts\data\groups\platoon.paa";

	displayName = "Platoon";
	descriptionShort = "A full platoon";
	condition = "";
	requiredBuildings[] = {{"barracks",3}};
	unitsEast[] = {"rhs_vdv_sergeant","rhs_vdv_efreitor","rhs_vdv_arifleman","rhs_vdv_machinegunner_assistant","rhs_vdv_grenadier","rhs_vdv_medic"};
	unitsWest[] = {"rhsusf_usmc_marpat_wd_squadleader","rhsusf_usmc_marpat_wd_teamleader","rhsusf_usmc_marpat_wd_autorifleman_m249","rhsusf_usmc_marpat_wd_autorifleman_m249_ass","rhsusf_usmc_marpat_wd_rifleman_m4","rhsusf_usmc_marpat_wd_marksman","rhsusf_usmc_marpat_wd_rifleman_law"};
	unitsGuer[] = {"rhsgref_ins_g_squadleader","rhsgref_ins_g_machinegunner","rhsgref_ins_g_grenadier","rhsgref_ins_g_grenadier_rpg","rhsgref_ins_g_rifleman_RPG26","rhsgref_ins_g_rifleman","rhsgref_ins_g_rifleman_aks74"};
	needelectricity = 0;
	actions[] = {"MCC_rts_orderStop","","MCC_rts_orderStanceUp","MCC_rts_orderStanceDown","MCC_rts_orderPlaceSatchel","","MCC_rts_orderStealth","MCC_rts_orderAware","","","MCC_rts_takeControl","MCC_rts_respawnUnits"};
	actionFNC = "MCC_fnc_rtsCreateGroup";
	resources[] = {{"ammo",700},{"food",350},{"time",15}};
};

class MCC_rtsGroup_sniper
{
	picture = "\mcc_sandbox_mod\mcc\rts\data\groups\sniper.paa";

	displayName = "Sniper Team";
	descriptionShort = "A sniper team";
	condition = "";
	requiredBuildings[] = {{"barracks",3}};
	unitsEast[] = {"rhs_vdv_recon_marksman","rhs_vdv_recon_rifleman_l"};
	unitsWest[] = {"rhsusf_usmc_marpat_wd_spotter","rhsusf_usmc_marpat_wd_sniper_m110"};
	unitsGuer[] = {"rhsgref_ins_g_sniper","rhsgref_ins_g_spotter"};
	needelectricity = 0;
	actions[] = {"MCC_rts_orderStop","","MCC_rts_orderStanceUp","MCC_rts_orderStanceDown","MCC_rts_orderPlaceSatchel","","MCC_rts_orderStealth","MCC_rts_orderAware","","","MCC_rts_takeControl","MCC_rts_respawnUnits"};
	actionFNC = "MCC_fnc_rtsCreateGroup";
	resources[] = {{"ammo",800},{"food",100},{"time",15}};
};

class MCC_rts_rtsBuildUIContainerBack
{
	picture = "\mcc_sandbox_mod\mcc\rts\data\back.paa";

	displayName = "Exit";
	descriptionShort = "Exit Fortifications Menu";
	condition = "";
	requiredBuildings[] = {};
	needelectricity = 0;
	actionFNC = "MCC_fnc_rtsBuildUIContainerBack";
	resources[] = {};
};