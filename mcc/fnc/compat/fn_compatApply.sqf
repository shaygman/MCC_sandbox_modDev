/*
	MCC_fnc_compatApply
	Swaps a class-list setting variable for the mod preset when the mission maker left it at the vanilla
	default, and expands the "auto" keyword (e.g. '["auto","my_mag"]' -> detected list + "my_mag").
	Called from the CBA setting scripts in classesSettings/mechanicsSettings, once at postInit for every
	known variable (MCC_fnc_compatInit), and after any of them changes (CBA_SettingChanged).
	Params:
		0: STRING - variable name, one of the keys in MCC_compat_settingKeys (e.g. "MCC_MWTanks")
	Returns: ARRAY - the value now stored in the variable (nil if the variable is not known/set)
*/
params [["_var", "", [""]]];

if (isNil "MCC_compat_settingKeys") then {
	MCC_compat_settingKeys = createHashMapFromArray [
		["mcc_convoyhvt", "convoyHVT"],
		["mcc_convoyhvtcar", "convoyHVTcar"],
		["mcc_mwhvt", "MWHVT"],
		["mcc_mwtanks", "MWTanks"],
		["mcc_mwaa", "MWAA"],
		["mcc_mwartillery", "MWArtillery"],
		["mcc_breacingammo", "slugAmmo"],
		["mcc_nonleathalammo", "slugAmmo"]
	];
};

private _key = MCC_compat_settingKeys getOrDefault [toLowerANSI _var, ""];
private _value = missionNamespace getVariable _var;
if (_key == "" || {isNil "_value"} || {!(_value isEqualType [])}) exitWith {_value};

private _new = _value;
if ("auto" in _value) then {
	private _preset = [_key] call MCC_fnc_compatPreset;
	_new = [];
	{
		if (_x isEqualTo "auto") then {
			{_new pushBackUnique _x} forEach _preset;
		} else {
			_new pushBackUnique _x;
		};
	} forEach _value;
} else {
	if (_value isEqualTo ([_key, "vanilla"] call MCC_fnc_compatPreset)) then {
		_new = [_key] call MCC_fnc_compatPreset;
	};
};

if !(_new isEqualTo _value) then {
	missionNamespace setVariable [_var, _new];
	if (missionNamespace getVariable ["MCC_debug", false]) then {
		diag_log format ["MCC compat: %1 set to mod preset %2", _var, _new];
	};
};

_new
