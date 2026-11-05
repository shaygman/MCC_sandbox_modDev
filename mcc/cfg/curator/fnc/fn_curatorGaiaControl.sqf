/*
	MCC_fnc_curatorGaiaControl
	Zeus module "GAIA: Control Group". Puts AI groups (any side, e.g. BLUFOR friendlies or the group a player is in)
	under GAIA. Groups: the group the module was dropped on, otherwise every group selected in Zeus.
	Orders:
		- Follow the tasks: the group goes to the nearest unfinished task of its side, fights there, then the next one
		- Attack / patrol the nearest MCC zone
		- Defend the nearest MCC zone (fortify)
		- Release from GAIA
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

private _result = [format ["GAIA: Control %1 group(s)", count _groups], [
	["Order", ["Follow the tasks (objectives)", "Attack / patrol the nearest zone", "Defend the nearest zone", "Release from GAIA"]],
	["Use vehicles (find rides, dismount at objective)", true]
]] call MCC_fnc_initDynamicDialog;
if (_result isEqualTo []) exitWith {};

[_groups, _result select 0, _result select 1] remoteExec ["MCC_fnc_gaiaControlGroups", 2];
[objNull, format ["GAIA now controls %1 group(s)", count _groups]] call BIS_fnc_showCuratorFeedbackMessage;
