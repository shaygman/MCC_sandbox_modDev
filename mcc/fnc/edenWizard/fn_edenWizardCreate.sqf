/*=================================================== MCC_fnc_edenWizardCreate ===================================================
	Creates one Eden entity for the editor-time Mission Wizard, moves it straight into the current wizard layer and
	applies its attributes. Everything the wizard places goes through here, so nothing ends up outside the layer.
	Uses the generation context MCC5MW_ctx (set by MCC_fnc_edenWizardGenerate): "curLayer", "entities", "units".

	Params:
		0: STRING - create3DENEntity mode: "Object", "Trigger", "Logic" or "Marker"
		1: STRING - class (CfgVehicles / CfgNonAIVehicles / CfgMarkers; "" = area marker)
		2: ARRAY  - position (ATL)
		3: ARRAY  - (optional) attributes [[property, value], ...] for set3DENAttribute
		4: BOOL   - (optional) true = vehicle without crew (default false)
		5: GROUP  - (optional) add the new unit to this Eden group (default grpNull = new group)
	Returns: OBJECT, or STRING for a marker; objNull / "" when it could not be created
	Example: private _box = ["Object", "Box_East_AmmoVeh_F", _pos, [["rotation", [0,0,90]]], true] call MCC_fnc_edenWizardCreate;
*/
params [
	["_mode", "Object", [""]],
	["_class", "", [""]],
	["_pos", [0, 0, 0], [[]]],
	["_attributes", [], [[]]],
	["_isEmpty", false, [false]],
	["_group", grpNull, [grpNull]]
];

private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
private _fail = [objNull, ""] select (_mode == "Marker");

if (_mode != "Marker" && {_class == "" || {!isClass (configFile >> (["CfgVehicles", "CfgNonAIVehicles"] select (_mode == "Trigger")) >> _class)}}) exitWith {
	diag_log format ["MCC Mission Wizard: class '%1' (%2) not found, skipped", _class, _mode];
	_fail
};

if (count _pos < 3) then {_pos = [_pos select 0, _pos select 1, 0]};

private _entity = if (!isNull _group && {_mode == "Object"}) then {
	_group create3DENEntity [_mode, _class, _pos]
} else {
	create3DENEntity [_mode, _class, _pos, _isEmpty]
};

if (isNil "_entity") exitWith {
	diag_log format ["MCC Mission Wizard: could not create %1 '%2' at %3", _mode, _class, _pos];
	_fail
};
if (_entity isEqualTo objNull || {_entity isEqualTo ""}) exitWith {
	diag_log format ["MCC Mission Wizard: could not create %1 '%2' at %3", _mode, _class, _pos];
	_fail
};

//Into the wizard layer first, so a failure below never leaves it outside
private _layer = _ctx getOrDefault ["curLayer", -1];
if (_layer >= 0) then {
	_entity set3DENLayer _layer;
	//Crew and the group of a unit / crewed vehicle follow it
	if (_mode == "Object") then {
		private _men = if (_entity isKindOf "CAManBase") then {[_entity]} else {crew _entity};
		private _groups = [];
		{
			if (_x != _entity) then {_x set3DENLayer _layer};
			_groups pushBackUnique (group _x);
		} forEach _men;
		{
			if (!isNull _x) then {_x set3DENLayer _layer};
		} forEach _groups;
	};
};
(_ctx getOrDefault ["entities", []]) pushBack _entity;

{
	_x params ["_property", "_value"];
	if !(_entity set3DENAttribute [_property, _value]) then {
		diag_log format ["MCC Mission Wizard: attribute '%1' = %2 not set on %3 '%4'", _property, _value, _mode, _class];
	};
} forEach _attributes;

//Count AI for the unit cap (a vehicle with crew counts its crew)
if (_mode == "Object") then {
	private _crew = if (_entity isKindOf "CAManBase") then {1} else {count crew _entity};
	if (_crew > 0) then {_ctx set ["units", (_ctx getOrDefault ["units", 0]) + _crew]};
};

_entity
