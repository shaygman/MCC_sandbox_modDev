/*
	MCC_fnc_applyEdenAttributes  (postInit, server)
	Copies MCC scenario attributes set in Eden (Attributes > General > MCC) over the matching CBA settings.
	An attribute left at -1 ("Use addon setting") keeps the CBA value.
	MCC registers its CBA settings in PostInit, so this waits until the mission is running before applying,
	otherwise the CBA initial value would overwrite the Eden value.
	Missions without Eden attributes can set the same names in description.ext (e.g. MCC_logisticsMode = 2;).
*/
if (!isServer) exitWith {};

// [scenario attribute (property), missionNamespace variable]
MCC_edenAttributeMap = [
	["MCC_logisticsMode", "MCC_logisticsMode"],
	["MCC_MWmaxObjectives", "MCC_MWmaxObjectives"],
	["MCC_MWmissionSize", "MCC_MWmissionSize"],
	["MCC_MWmaxSpawnedUnits", "MCC_MWmaxSpawnedUnits"],
	["MCC_campaignMaxAOs", "MCC_campaignMaxAOs"],
	["MCC_campaignAOSize", "MCC_campaignAOSize"],
	["MCC_campaignAmbientCap", "MCC_campaignAmbientCap"]
];

[] spawn {
	waitUntil {time > 1};
	{
		_x params ["_attr", "_var"];
		private _value = getMissionConfigValue [_attr, -1];
		if (_value isEqualType "") then {_value = parseNumber _value};
		if (_value isEqualType 0 && {_value >= 0}) then {
			missionNamespace setVariable [_var, _value, true];
			diag_log format ["MCC: Eden attribute %1 = %2", _attr, _value];
		};
	} forEach MCC_edenAttributeMap;
};
