/*
	GAIA_fnc_detectAIMods  (preInit)
	Detects AI mods GAIA must cooperate with instead of overriding. GAIA is the commander (where groups go,
	which vehicle, support); unit combat and driving are left to these mods when they are loaded.
	Sets (missionNamespace):
		GAIA_hasLAMBS             - LAMBS Danger.fsm (contact tactics, flanking, buildings)
		GAIA_hasLAMBSSuppression  - LAMBS Suppression
		GAIA_hasHBQDriving        - HBQ Advanced Driving AI (unstuck, route recovery, collision avoidance)
	Each can be overridden with the CBA settings MCC_GAIA_compatLAMBS / MCC_GAIA_compatHBQ (0 auto, 1 on, 2 off).
*/
private _patches = configFile >> "CfgPatches";

private _lambs = isClass (_patches >> "lambs_danger");
private _lambsSup = isClass (_patches >> "lambs_suppression");
// HBQ's addon name is not documented; match any loaded addon named like hbq...driv...
private _hbq = ("'hbq' in toLowerANSI configName _x && {'driv' in toLowerANSI configName _x}" configClasses _patches) isNotEqualTo [];

missionNamespace setVariable ["GAIA_hasLAMBS", _lambs];
missionNamespace setVariable ["GAIA_hasLAMBSSuppression", _lambsSup];
missionNamespace setVariable ["GAIA_hasHBQDriving", _hbq];

diag_log format ["GAIA: AI mods detected - LAMBS Danger: %1, LAMBS Suppression: %2, HBQ Advanced Driving AI: %3", _lambs, _lambsSup, _hbq];
