/*
	MCC_fnc_rxAddIntel
	Adds a picked-up intel item to the player's diary and shows it on screen.
	Sent with remoteExec by pickItem.sqf to the side that shares the intel.
	Params:
		0: STRING - title
		1: STRING - text
		2: ARRAY  - marker names to link in the diary entry
*/
if (!hasInterface) exitWith {};
params ["_tittle","_text","_markers"];

//Add markers
private _oldText = _text;
{
	_text = _text + (format ["<marker name='%1'> Location</marker>", _x, _x]);
} forEach _markers;

_text = "<t size='1.0' font='PuristaBold'>" + _text +"</t>";

if !(player diarysubjectexists "MCC_intel") then {
	player creatediarysubject ["MCC_intel","Intel"];
};
player creatediaryrecord ["MCC_intel",[_tittle,_text]];

private _output =
[
	[_tittle,"<t size='1.0' font='PuristaBold'>%1</t><br/>",2],
	[_oldText,"<t size='1.0' font='PuristaMedium'>%1</t><br/>",5]
];

[_output,safezoneX,0,"<t color='#FFFFFFFF' align='left'>%1</t>"] spawn BIS_fnc_typeText;
