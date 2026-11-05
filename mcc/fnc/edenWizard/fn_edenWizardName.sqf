/*=================================================== MCC_fnc_edenWizardName ===================================================
	Unique variable name for an entity of the editor-time Mission Wizard: mcc5mw_<token>_<tag>_<n>.
	The token is random per generation (MCC5MW_ctx "token"), so a second generated mission never reuses a name.

	Params:
		0: STRING - tag, e.g. "hvt", "task"
	Returns: STRING - variable name
	Example: private _name = ["hvt"] call MCC_fnc_edenWizardName;
*/
params [["_tag", "obj", [""]]];

private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
private _n = (_ctx getOrDefault ["counter", 0]) + 1;
_ctx set ["counter", _n];

format ["mcc5mw_%1_%2_%3", _ctx getOrDefault ["token", 0], _tag, _n]
