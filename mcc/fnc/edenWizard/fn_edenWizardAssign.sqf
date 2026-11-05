/*=================================================== MCC_fnc_edenWizardAssign ===================================================
	Editor-time Mission Wizard: puts a group under GAIA control in a wizard zone. Syncs the group leader to the zone's
	"Assign to Zone" module for the behaviour (created on first use and synced to the zone's Create Zones module).
	The group's own "MCC: GAIA Control" attributes are NOT used: the zone number only exists at mission start
	(MCC_fnc_createZonesInit takes the next free number), so the zone module does the assignment. To change a group's
	behaviour in the editor, sync its leader to another Assign to Zone module of the same zone.

	Params:
		0: GROUP   - Eden group
		1: HASHMAP - zone (MCC_fnc_edenWizardZone)
		2: STRING  - behaviour "MOVE" (aggressive), "NOFOLLOW" (defensive) or "FORTIFY"
	Returns: BOOL - true when the group was synced
	Example: [_group, _zone, "FORTIFY"] call MCC_fnc_edenWizardAssign;
*/
params [["_group", grpNull, [grpNull]], ["_zone", createHashMap, [createHashMap]], ["_intend", "MOVE", [""]]];

if (isNull _group || {count _zone == 0}) exitWith {false};

private _behaviour = ["MOVE", "NOFOLLOW", "FORTIFY"] find _intend;
if (_behaviour < 0) then {_behaviour = 0; _intend = "MOVE"};

private _assign = _zone get "assign";
private _module = _assign getOrDefault [_intend, objNull];

if (isNull _module) then {
	private _pos = (_zone get "pos") getPos [10 + (4 * _behaviour), 90];
	_module = ["Logic", "MCC_Module_AI_assignToZone", _pos, [["behavior", _behaviour]]] call MCC_fnc_edenWizardCreate;
	if (!isNull _module) then {
		add3DENConnection ["Sync", [_module], _zone get "module"];
		_assign set [_intend, _module];
	};
};

if (isNull _module) exitWith {false};

private _leader = leader _group;
if (isNull _leader) then {_leader = (units _group) param [0, objNull]};
if (isNull _leader) exitWith {false};

add3DENConnection ["Sync", [_leader], _module];

true
