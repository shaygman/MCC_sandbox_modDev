/*=================================================================MCC_fnc_curatorBroadcast=========================================================================
	Zeus module "Broadcast Message": shows a text to every player (small text at the bottom or big text in the middle).
	Replaces the old MCC menu Debug tab broadcast buttons.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _result = ["Broadcast Message", [
	["Style", ["Small (bottom)","Big (center)"]],
	["Text", ""]
]] call MCC_fnc_initDynamicDialog;

deleteVehicle _module;
if (_result isEqualTo []) exitWith {};

private _text = _result select 1;
if (_text isEqualTo "") exitWith {};

if ((_result select 0) == 0) then {
	[_text, "PLAIN DOWN"] remoteExec ["titleText", 0];
	60 remoteExec ["titleFadeOut", 0];
} else {
	//Plain text only: the big style is parsed as structured text
	_text = (_text splitString "<>") joinString "";
	private _str = "<t size='1' font='PuristaLight' color='#FFFFFF'>" + _text + "</t>";
	[_str, 0, 0.2, 5, 1, 0] remoteExec ["BIS_fnc_dynamicText", 0];
};
