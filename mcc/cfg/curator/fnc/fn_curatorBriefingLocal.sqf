/*=================================================================MCC_fnc_curatorBriefingLocal=====================================================================
	Clients (and JIP): adds a diary entry sent by the Zeus "Briefing" module.
	Params:
		0: STRING - title
		1: STRING - text
		2: SIDE   - only players of this side, sideLogic = everyone
	Returns: nothing
	Example: ["Situation", "text", west] remoteExec ["MCC_fnc_curatorBriefingLocal", 0, true];
//==================================================================================================================================================================*/
params [
	["_title", "", [""]],
	["_text", "", [""]],
	["_side", sideLogic, [sideLogic]]
];

if (!hasInterface || {_text isEqualTo ""}) exitWith {};

[_title, _text, _side] spawn {
	params ["_title", "_text", "_side"];
	waitUntil {sleep 1; !isNull player};
	if (_side != sideLogic && {playerSide != _side}) exitWith {};
	player createDiaryRecord ["Diary", [_title, _text]];
};
