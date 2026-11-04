/*
	MCC_fnc_compatInit
	postInit: applies mod presets to every class-list setting that is still at its vanilla default
	(covers settings whose CBA script does not call MCC_fnc_compatApply itself, e.g. MWSettings.sqf),
	and re-applies them whenever one of those CBA settings changes later in the mission.
	Params: none
	Returns: nothing
*/
if (isNil "MCC_compat_detected") then {call MCC_fnc_detectMods};

private _vars = ["MCC_convoyHVT","MCC_convoyHVTcar","MCC_MWHVT","MCC_MWTanks","MCC_MWAA","MCC_MWArtillery","MCC_breacingAmmo","MCC_nonLeathalAmmo"];
{[_x] call MCC_fnc_compatApply} forEach _vars;

if (!isNil "CBA_fnc_addEventHandler" && {isNil "MCC_compat_settingEH"}) then {
	MCC_compat_settingEH = ["CBA_SettingChanged", {
		params [["_setting", "", [""]]];
		if ((toLowerANSI _setting) in ["mcc_convoyhvt","mcc_convoyhvtcar","mcc_mwhvt","mcc_mwtanks","mcc_mwaa","mcc_mwartillery","mcc_breacingammo","mcc_nonleathalammo"]) then {
			// next frame: let the setting's own script store the parsed value first
			[{[_this] call MCC_fnc_compatApply}, _setting] call CBA_fnc_execNextFrame;
		};
	}] call CBA_fnc_addEventHandler;
};
