/*=================================================== MCC_fnc_edenWizardTask ===================================================
	Editor-time Mission Wizard: creates a task that works at runtime without any MCC runtime data:
		- a Game Logic whose init creates the task on the server (BIS_fnc_taskCreate, owner = player side), as a child of
		  the operation task when the mission has several objectives
		- a server-only trigger that sets the task SUCCEEDED when its condition is true
		- optionally a server-only trigger that sets it FAILED
	All of it is placed in the current wizard layer, so the mission maker can read and change the conditions.

	Params:
		0: STRING - task id
		1: STRING - title
		2: STRING - description (structured text)
		3: ARRAY  - objective position (ATL)
		4: STRING - variable name of the objective object ("" = position task)
		5: STRING - task type (CfgTaskTypes, e.g. "kill", "destroy", "help", "search", "download", "mine", "attack")
		6: STRING - success condition (SQF, "" = none)
		7: STRING - fail condition (SQF, "" = none)
		8: ARRAY  - (optional) area success: [activationBy, radius] - trigger "NOT PRESENT" of that side in the radius
	Returns: BOOL - true when the task logic was created
	Example: ["t1", "Kill X", "...", _pos, "mcc5mw_1_hvt_3", "kill", "!alive mcc5mw_1_hvt_3", ""] call MCC_fnc_edenWizardTask;
*/
params [
	["_id", "", [""]],
	["_title", "", [""]],
	["_description", "", [""]],
	["_pos", [0, 0, 0], [[]]],
	["_objVar", "", [""]],
	["_type", "default", [""]],
	["_successCond", "", [""]],
	["_failCond", "", [""]],
	["_areaSuccess", [], [[]]]
];

private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
private _opts = _ctx getOrDefault ["opts", createHashMap];
private _precise = _opts getOrDefault ["precise", true];
private _sideCode = _ctx getOrDefault ["playerSideCode", "west"];
private _parent = _ctx getOrDefault ["parentTask", ""];

//Task id: child of the operation task when there is one
private _idCode = if (_parent == "") then {str _id} else {str [_id, _parent]};

//Destination: the object itself (precise) or a spot up to 300 m away (old wizard behaviour)
private _destCode = if (_precise) then {
	if (_objVar != "") then {
		format ["[missionNamespace getVariable [%1, objNull], true]", str _objVar]
	} else {
		str [_pos select 0, _pos select 1, 0]
	}
} else {
	str [(_pos select 0) + (random 300 - random 300), (_pos select 1) + (random 300 - random 300), 0]
};

private _init = format [
	"if (isServer) then {0 = [] spawn {sleep 1; [%1, %2, [%3, %4, ''], %5, 'CREATED', 1, true, %6, %7] call BIS_fnc_taskCreate;};};",
	_sideCode, _idCode, str _description, str _title, _destCode, str _type, _precise && {_objVar != ""}
];

private _logic = ["Logic", "Logic", _pos getPos [3, 180], [
	["Name", ["task"] call MCC_fnc_edenWizardName],
	["Init", _init]
]] call MCC_fnc_edenWizardCreate;

if (isNull _logic) exitWith {false};

(_ctx getOrDefault ["taskIds", []]) pushBack _id;

private _fnc_trigger = {
	params ["_condition", "_state", "_text"];
	["Trigger", "EmptyDetector", _pos getPos [6, 180], [
		["name", ["taskTrg"] call MCC_fnc_edenWizardName],
		["text", _text],
		["size3", [0, 0, -1]],
		["ActivationBy", "NONE"],
		["isServerOnly", true],
		["condition", format ["time > 5 && {!(%2 call BIS_fnc_taskCompleted)} && {%1}", _condition, str _id]],
		["onActivation", format ["[%1, '%2'] call BIS_fnc_taskSetState;", str _id, _state]]
	]] call MCC_fnc_edenWizardCreate;
};

if (_areaSuccess isNotEqualTo []) then {
	_areaSuccess params [["_activationBy", "EAST", [""]], ["_radius", 100, [0]]];
	["Trigger", "EmptyDetector", _pos, [
		["name", ["taskTrg"] call MCC_fnc_edenWizardName],
		["text", format ["%1: cleared", _title]],
		["size3", [_radius, _radius, -1]],
		["IsRectangle", false],
		["ActivationBy", _activationBy],
		["activationType", "NOT PRESENT"],
		["isServerOnly", true],
		["condition", format ["this && {time > 30} && {!(%1 call BIS_fnc_taskCompleted)}", str _id]],
		["onActivation", format ["[%1, 'SUCCEEDED'] call BIS_fnc_taskSetState;", str _id]]
	]] call MCC_fnc_edenWizardCreate;
};

if (_successCond != "") then {[_successCond, "SUCCEEDED", format ["%1: done", _title]] call _fnc_trigger};
if (_failCond != "") then {[_failCond, "FAILED", format ["%1: failed", _title]] call _fnc_trigger};

true
