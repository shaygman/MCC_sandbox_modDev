/*
	MCC_fnc_compatPreset
	Returns the default class list for a setting, chosen for the loaded mods (vanilla / RHS / CUP).
	Mod classes are checked with isClass, so anything missing from the loaded mod version is dropped.
	The "vanilla" lists must stay identical to the default values of the matching CBA settings
	(MCC_fnc_compatApply uses them to see if the mission maker changed a setting).
	Params:
		0: STRING - preset key: "convoyHVT", "convoyHVTcar", "MWHVT", "MWTanks", "MWAA", "MWArtillery",
		            "supplyTrucks", "slugAmmo"
		1: STRING - (optional) "auto" (default) best list for the loaded mods, or "vanilla" the plain default
	Returns: ARRAY - class list (strings, or [displayName, class] pairs for convoy lists); [] for unknown keys
	Merge modes:
		"append"   - vanilla list followed by the mod entries (lists the player picks from)
		"sideFill" - mod entries first, then vanilla entries only for sides the mods do not cover
		             (lists MCC picks from by side)
*/
params [["_key", "", [""]], ["_mode", "auto", [""]]];

if (isNil "MCC_compat_detected") then {call MCC_fnc_detectMods};

if (isNil "MCC_compat_presetTable") then {
	MCC_compat_presetTable = createHashMapFromArray [
		// [vanilla, RHS, CUP, merge mode]
		["convoyhvt", [
			[["None","0"],["B.Officer","B_officer_F"],["B. Pilot","B_Helipilot_F"],["O. Officer","O_officer_F"],["O. Pilot","O_helipilot_F"],["I.Commander","I_officer_F"],["Citizen","C_man_polo_1_F"],["C.Pilot","C_man_pilot_F"],["Orestes","C_Orestes"],["Nikos","C_Nikos"],["Hunter","C_man_hunter_1_F"],["Kerry","I_G_Story_Protagonist_F"]],
			[["US Officer (RHS)","rhsusf_army_ocp_officer"],["RU Officer (RHS)","rhs_msv_emr_officer"]],
			[["RU Officer (CUP)","CUP_O_RU_Officer_M_EMR"],["TK Officer (CUP)","CUP_O_TK_Officer"],["CDF Commander (CUP)","CUP_B_CDF_Commander_FST"],["BAF Officer (CUP)","CUP_B_BAF_Soldier_Officer_DPM"],["NAPA Commander (CUP)","CUP_I_GUE_Commander"]],
			"append"
		]],
		["convoyhvtcar", [
			[["Default",""],["Hunter","B_Hunter_F"],["MRAP","I_MRAP_03_F"],["Quadbike","B_Quadbike_F"],["Ifrit","O_Ifrit_F"],["Offroad","C_Offroad_01_F"],["SUV","C_SUV_01_F"],["Hatchback","C_Hatchback_01_F"]],
			[["M1025 (RHS)","rhsusf_m1025_w"],["M1151 (RHS)","rhsusf_m1151_usarmy_wd"],["Tigr (RHS)","rhs_tigr_msv"],["UAZ (RHS)","rhs_uaz_vv"],["UAZ Ins. (RHS)","rhsgref_ins_uaz"]],
			[["M1151 (CUP)","CUP_B_M1151_WDL_USA"],["UAZ (CUP)","CUP_O_UAZ_Unarmed_RU"],["Vodnik (CUP)","CUP_O_GAZ_Vodnik_Unarmed_RU"],["Land Rover (CUP)","CUP_O_LR_Transport_TKA"],["UAZ CDF (CUP)","CUP_B_UAZ_Unarmed_CDF"]],
			"append"
		]],
		["mwhvt", [
			["B_officer_F","O_officer_F","I_officer_F","C_Nikos"],
			["rhsusf_army_ocp_officer","rhs_msv_emr_officer"],
			["CUP_B_BAF_Soldier_Officer_DPM","CUP_O_RU_Officer_M_EMR","CUP_I_GUE_Commander"],
			"sideFill"
		]],
		["mwtanks", [
			["B_MBT_01_cannon_F","O_MBT_02_cannon_F"],
			["rhsusf_m1a2sep1wd_usarmy","rhsusf_m1a1aimwd_usarmy","rhs_t90sm_tv","rhs_t72be_tv","rhs_t80uk"],
			["CUP_B_M1A2SEP_Woodland_US_Army","CUP_B_M1A1SA_Woodland_US_Army","CUP_O_T72_RU","CUP_O_T90_RU","CUP_I_T72_RACS","CUP_I_M60A3_RACS"],
			"sideFill"
		]],
		["mwaa", [
			["B_APC_Tracked_01_AA_F","O_APC_Tracked_02_AA_F","I_APC_Wheeled_03_cannon_F"],
			["RHS_M6_wd","rhs_zsu234_aa","rhsgref_nat_ural_Zu23"],
			["CUP_B_M6LineBacker_USA_W","CUP_B_M163_Vulcan_USA","CUP_O_ZSU23_SLA","CUP_I_M163_Vulcan_RACS"],
			"sideFill"
		]],
		["mwartillery", [
			["B_MBT_01_arty_F","B_MBT_01_mlrs_F","O_MBT_02_arty_F","O_Mortar_01_F","I_Mortar_01_F"],
			["rhsusf_m109_usarmy","RHS_M119_WD","rhs_2s3_tv","RHS_BM21_VV_01"],
			["CUP_B_M270_HE_USA","CUP_O_BM21_RU","CUP_I_M270_HE_RACS"],
			"sideFill"
		]],
		["supplytrucks", [
			[],
			["rhsusf_M1078A1P2_WD_fmtv_usarmy","RHS_Ural_MSV_01","rhs_kamaz5350_msv","rhsgref_cdf_zil131"],
			["CUP_B_MTVR_USA","CUP_O_Ural_RU","CUP_O_Kamaz_RU","CUP_I_MTVR_RACS"],
			"append"
		]],
		["slugammo", [
			["prpl_8Rnd_12Gauge_Slug","prpl_6Rnd_12Gauge_Slug","rhsusf_8Rnd_Slug","rhsusf_5Rnd_Slug"],
			[],
			[],
			"slug"
		]]
	];
};

private _entry = MCC_compat_presetTable getOrDefault [toLowerANSI _key, []];
if (_entry isEqualTo []) exitWith {
	diag_log format ["MCC compat: unknown preset key '%1'", _key];
	[]
};

_entry params ["_vanilla", "_rhs", "_cup", "_merge"];

if (_mode == "vanilla") exitWith {+_vanilla};

if (_merge == "slug") exitWith {[] call MCC_fnc_compatSlugMagazines};

// class name of an entry: "class" or ["display","class"]
private _fnc_class = {
	params ["_item"];
	if (_item isEqualType []) then {_item param [1, ""]} else {_item}
};

private _mod = [];
if (MCC_isRHS) then {_mod append _rhs};
if (MCC_isCUP) then {_mod append _cup};
_mod = _mod select {isClass (configFile >> "CfgVehicles" >> ([_x] call _fnc_class))};

if (_mod isEqualTo []) exitWith {+_vanilla};

private _result = [];
switch (_merge) do {
	case "sideFill": {
		private _modSides = [];
		{_modSides pushBackUnique getNumber (configFile >> "CfgVehicles" >> ([_x] call _fnc_class) >> "side")} forEach _mod;
		_result = +_mod;
		{
			if !((getNumber (configFile >> "CfgVehicles" >> ([_x] call _fnc_class) >> "side")) in _modSides) then {_result pushBack _x};
		} forEach _vanilla;
	};
	default {
		_result = (+_vanilla) + _mod;
	};
};

_result
