/*
	MCC_fnc_detectMods
	Detects optional mods (CBA, ACE3 and its components, RHS, CUP) once and stores the result in global flags.
	Runs at preInit; any function that needs the flags earlier calls it again (it only detects once).
	Flags set (all BOOL, local to every machine):
		MCC_isCBA, MCC_isACE, MCC_isACEMedical, MCC_isACECargo, MCC_isACERearm, MCC_isACERefuel,
		MCC_isRHS, MCC_isRHSAFRF, MCC_isRHSUSAF, MCC_isRHSGREF, MCC_isRHSSAF,
		MCC_isCUP, MCC_isCUPUnits, MCC_isCUPVehicles, MCC_isCUPWeapons
		MCC_compat_detected - true once detection ran
	Params: none
	Returns: BOOL - true
*/
if (!isNil "MCC_compat_detected") exitWith {true};

private _fnc_patch = {
	params ["_names"];
	(_names findIf {isClass (configFile >> "CfgPatches" >> _x)}) >= 0
};

// CBA / ACE3
MCC_isCBA			= [["cba_main"]] call _fnc_patch;
MCC_isACE			= [["ace_common"]] call _fnc_patch;
MCC_isACEMedical	= [["ace_medical"]] call _fnc_patch;
MCC_isACECargo		= [["ace_cargo"]] call _fnc_patch;
MCC_isACERearm		= [["ace_rearm"]] call _fnc_patch;
MCC_isACERefuel		= [["ace_refuel"]] call _fnc_patch;

// RHS (each faction pack has its own main patch)
MCC_isRHSAFRF	= [["rhs_main"]] call _fnc_patch;
MCC_isRHSUSAF	= [["rhsusf_main"]] call _fnc_patch;
MCC_isRHSGREF	= [["rhsgref_main"]] call _fnc_patch;
MCC_isRHSSAF	= [["rhssaf_main"]] call _fnc_patch;
MCC_isRHS		= MCC_isRHSAFRF || MCC_isRHSUSAF || MCC_isRHSGREF || MCC_isRHSSAF;

// CUP (Units / Vehicles / Weapons are separate downloads)
MCC_isCUPUnits		= [["CUP_Creatures_People_Core","CUP_Creatures_People_Civil_Russia"]] call _fnc_patch;
MCC_isCUPVehicles	= [["CUP_Vehicles_Core","CUP_AirVehicles_Core"]] call _fnc_patch;
MCC_isCUPWeapons	= [["CUP_Weapons_WeaponsCore"]] call _fnc_patch;
MCC_isCUP			= MCC_isCUPUnits || MCC_isCUPVehicles || MCC_isCUPWeapons || ([["CUP_BaseConfigs"]] call _fnc_patch);

MCC_compat_detected = true;

diag_log format [
	"MCC compat: CBA %1 | ACE %2 (medical %3, cargo %4, rearm %5, refuel %6) | RHS %7 (AFRF %8, USAF %9, GREF %10, SAF %11) | CUP %12 (units %13, vehicles %14, weapons %15)",
	MCC_isCBA, MCC_isACE, MCC_isACEMedical, MCC_isACECargo, MCC_isACERearm, MCC_isACERefuel,
	MCC_isRHS, MCC_isRHSAFRF, MCC_isRHSUSAF, MCC_isRHSGREF, MCC_isRHSSAF,
	MCC_isCUP, MCC_isCUPUnits, MCC_isCUPVehicles, MCC_isCUPWeapons
];

true
