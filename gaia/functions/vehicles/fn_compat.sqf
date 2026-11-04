/*
	GAIA_fnc_compat
	Whether GAIA should cooperate with an AI mod right now (detection + mission maker override).
	Params:
		0: STRING - "LAMBS" or "HBQ"
	Returns: BOOL
*/
params [["_mod", "", [""]]];

private _setting = missionNamespace getVariable [format ["MCC_GAIA_compat%1", _mod], 0];
if (_setting isEqualTo 1) exitWith {true};
if (_setting isEqualTo 2) exitWith {false};
switch (_mod) do {
	case "LAMBS": {missionNamespace getVariable ["GAIA_hasLAMBS", false]};
	case "HBQ": {missionNamespace getVariable ["GAIA_hasHBQDriving", false]};
	default {false};
}
