/*=================================================== MCC_fnc_edenWizardSetting ===================================================
	Editor-time Mission Wizard: class list of a Mission Wizard CBA setting (mcc\settings\MWSettings.sqf) without needing
	the mission to run. Order:
		1. the scenario's own value: MCC 5 Mission Settings attribute "MCC5S_<setting>" (Cfg3DEN >> Mission >> MCC5)
		2. the CBA setting value when CBA has it in the editor (missionNamespace <setting>)
		3. the mod preset for the loaded mods (MCC_fnc_compatPreset <key>), when a key is given
		4. the default list given here (= the CBA setting default)
	Only classes that exist in config are returned.

	Params:
		0: STRING - setting variable, e.g. "MCC_MWTanks"
		1: STRING - MCC_fnc_compatPreset key ("" = none), e.g. "MWTanks"
		2: ARRAY  - default list
		3: STRING - (optional) config root to check the classes in (default "CfgVehicles", "" = no check)
	Returns: ARRAY
	Example: private _tanks = ["MCC_MWTanks", "MWTanks", ["B_MBT_01_cannon_F"]] call MCC_fnc_edenWizardSetting;
*/
params [["_var", "", [""]], ["_presetKey", "", [""]], ["_default", [], [[]]], ["_cfgRoot", "CfgVehicles", [""]]];

private _list = [];

//1. Scenario attribute (string like the CBA EDITBOX: "[""a"",""b""]")
private _attr = "MCC5" get3DENMissionAttribute ("MCC5S_" + _var);
if (!isNil "_attr" && {_attr isEqualType ""} && {_attr != ""}) then {
	private _parsed = (parseSimpleArray ("[" + _attr + "]")) param [0, []];
	if (_parsed isEqualType [] && {_parsed isNotEqualTo []}) then {_list = _parsed};
};

//2. CBA setting
if (_list isEqualTo []) then {
	private _cba = missionNamespace getVariable [_var, []];
	if (_cba isEqualType [] && {_cba isNotEqualTo []}) then {_list = +_cba};
};

//3. Mod preset
if (_list isEqualTo [] && {_presetKey != ""} && {!isNil "MCC_fnc_compatPreset"}) then {
	private _preset = [_presetKey] call MCC_fnc_compatPreset;
	if (_preset isEqualType [] && {_preset isNotEqualTo []}) then {_list = _preset};
};

//4. Default
if (_list isEqualTo []) then {_list = +_default};

if (_cfgRoot != "") then {
	_list = _list select {_x isEqualType "" && {isClass (configFile >> _cfgRoot >> _x)}};
};

_list
