/*=================================================== MCC_fnc_edenWizardZone ===================================================
	Editor-time Mission Wizard: creates an MCC zone the way a mission maker does it by hand - a trigger (the zone area)
	synced to an "MCC Create Zones" module (mcc_Module_createZones). At mission start MCC_fnc_createZonesInit takes the
	next free zone number (MCC_fnc_MWnextZoneNumber), builds the zone and puts every group synced to an "Assign to Zone"
	module (MCC_Module_AI_assignToZone) that is synced to the zone module under GAIA control.
	The assign modules are created on demand, one per GAIA behaviour, by MCC_fnc_edenWizardAssign.

	Params:
		0: ARRAY  - center (ATL)
		1: NUMBER - size A (m)
		2: NUMBER - size B (m)
		3: NUMBER - direction
		4: BOOL   - rectangle
		5: STRING - label (trigger text)
	Returns: HASHMAP - "pos", "a", "b", "dir", "rect", "trigger", "module", "assign" (HASHMAP behaviour -> module);
	         empty HASHMAP on failure
	Example: private _zone = [_pos, 300, 300, 0, false, "MW objective 1"] call MCC_fnc_edenWizardZone;
*/
params [
	["_pos", [0, 0, 0], [[]]],
	["_a", 300, [0]],
	["_b", 300, [0]],
	["_dir", 0, [0]],
	["_rect", false, [false]],
	["_label", "MCC Mission Wizard zone", [""]]
];

private _trigger = ["Trigger", "EmptyDetector", _pos, [
	["name", ["zoneArea"] call MCC_fnc_edenWizardName],
	["text", _label],
	["size3", [_a, _b, -1]],
	["IsRectangle", _rect],
	["rotation", _dir],
	["ActivationBy", "NONE"]
]] call MCC_fnc_edenWizardCreate;

if (isNull _trigger) exitWith {createHashMap};

private _module = ["Logic", "mcc_Module_createZones", _pos getPos [6, 0]] call MCC_fnc_edenWizardCreate;
if (isNull _module) exitWith {
	diag_log "MCC Mission Wizard: could not create the MCC Create Zones module";
	delete3DENEntities [_trigger];
	createHashMap
};

add3DENConnection ["Sync", [_trigger], _module];

createHashMapFromArray [
	["pos", _pos],
	["a", _a],
	["b", _b],
	["dir", _dir],
	["rect", _rect],
	["trigger", _trigger],
	["module", _module],
	["assign", createHashMap]
]
