/*
	MCC_fnc_curatorGaiaControl
	Zeus module "GAIA: Control Group". Puts AI groups (any side, e.g. BLUFOR friendlies or the group a player is in)
	under GAIA. Groups: the group the module was dropped on, otherwise every group selected in Zeus.
	No questions asked: GAIA takes over, uses vehicles, works through the side's tasks (nearest first),
	and when no task is left the group patrols its area.
	Params:
		0: OBJECT - the placed module
*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _groups = [];
private _over = missionNamespace getVariable ["MCC_curatorMouseOver", []];
if (count _over > 1) then {
	private _o = _over select 1;
	if (_o isEqualType grpNull) then {_groups pushBack _o};
	if (_o isEqualType objNull && {!isNull group _o}) then {_groups pushBack (group _o)};
};
if (_groups isEqualTo []) then {
	_groups = (curatorSelected param [1, []]) select {!isNull _x};
	{
		if (!isNull group _x) then {_groups pushBackUnique (group _x)};
	} forEach ((curatorSelected param [0, []]) select {_x isKindOf "CAManBase"});
};
_groups = _groups select {!isPlayer leader _x && {({alive _x} count units _x) > 0}};

deleteVehicle _module;

if (_groups isEqualTo []) exitWith {
	[objNull, "Drop this on an AI group, or select AI groups first (groups led by a player can't be given to GAIA)"] call BIS_fnc_showCuratorFeedbackMessage;
};

[_groups, 0, true] remoteExec ["MCC_fnc_gaiaControlGroups", 2];
[objNull, format ["GAIA now controls %1 group(s): they work through the tasks, then patrol", count _groups]] call BIS_fnc_showCuratorFeedbackMessage;
