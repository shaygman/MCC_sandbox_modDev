/*=================================================== MCC_fnc_edenWizardFactionCombo ===================================================
	attributeLoad / attributeSave of the Eden attribute controls MCC5MW_FactionComboMil and MCC5MW_FactionComboCiv
	(mcc\cfg\eden\attributesControls.hpp). Fills the drop-down list (idc 100 of the vanilla "Combo" attribute control) with
	the factions of CfgFactionClasses that have at least one man in CfgVehicles (scope 2), and returns the selected
	faction class name on save. The faction list is scanned once per game session (uiNamespace cache).

	Params:
		0: CONTROL - the attribute controls group
		1: STRING  - saved value (faction class name), nil on save
		2: STRING  - "mil" (BLUFOR/OPFOR/Independent), "civ" (civilians) or "save"
	Returns:
		load: nothing
		save: STRING - selected faction class name ("" when nothing is selected)
	Example: [_this, _value, 'mil'] call MCC_fnc_edenWizardFactionCombo;
*/
params [["_ctrlGroup", controlNull, [controlNull]], ["_value", "", [""]], ["_mode", "mil", [""]]];

private _combo = _ctrlGroup controlsGroupCtrl 100;

if (_mode == "save") exitWith {
	if (isNull _combo) exitWith {""};
	private _sel = lbCurSel _combo;
	if (_sel < 0) exitWith {""};
	_combo lbData _sel
};

if (isNull _combo) exitWith {diag_log "MCC Mission Wizard: faction attribute control has no idc 100 combo"};

//------------------------------------------- Faction list (cached for the session) -------------------------------------------
//[[sideNumber, displayName, className], ...] sorted by side, then name
private _factions = uiNamespace getVariable "MCC5MW_factionList";
if (isNil "_factions") then {
	private _withMen = createHashMap;
	{
		private _faction = getText (_x >> "faction");
		if (_faction != "" && {!(_faction in _withMen)} && {(configName _x) isKindOf "CAManBase"}) then {
			_withMen set [_faction, true];
		};
	} forEach ("getNumber (_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles"));

	_factions = [];
	{
		private _side = getNumber (_x >> "side");
		if ((configName _x) in _withMen && {_side in [0, 1, 2, 3]}) then {
			private _name = getText (_x >> "displayName");
			if (_name == "") then {_name = configName _x};
			_factions pushBack [_side, _name, configName _x];
		};
	} forEach ("true" configClasses (configFile >> "CfgFactionClasses"));

	_factions sort true;
	uiNamespace setVariable ["MCC5MW_factionList", _factions];
};

private _sideNames = ["OPFOR", "BLUFOR", "Independent", "Civilian"];
private _wantedSides = if (_mode == "civ") then {[3]} else {[0, 1, 2]};

lbClear _combo;
private _select = -1;
{
	_x params ["_side", "_name", "_class"];
	if (_side in _wantedSides) then {
		private _index = _combo lbAdd format ["%1 - %2 (%3)", _sideNames select _side, _name, _class];
		_combo lbSetData [_index, _class];
		if (_class == _value) then {_select = _index};
	};
} forEach _factions;

//A faction of a mod that is not loaded any more: keep it so the value is not lost
if (_select < 0 && {_value != ""}) then {
	_select = _combo lbAdd format ["%1 (not loaded)", _value];
	_combo lbSetData [_select, _value];
};

_combo lbSetCurSel (_select max 0);
