/*==================================================MCC_fnc_interactProgress===============================================================================================
 Create a progress bar and anim for the player
 Example: [_text,_time] call MCC_fnc_interactProgress;
====================================================================================================================================================================*/
private ["_text","_time","_ctrl","_object","_success","_endActionEH","_anim","_defaultAnim"];
_text = param [0,"",[""]];
_time = param [1,10,[0]];
_object = param [2,objNull,[objNull]];
_anim = param [3,true,[true,""]];

_defaultAnim = "AinvPknlMstpSlayWrflDnon_medic";

if (isNull _object) then {_object = player};

_endActionEH = (findDisplay 46) displayAddEventHandler ["KeyDown", {
	_keyDown = _this select 1;

	if (_keyDown == 1) then {
		missionNamespace setVariable ["MCC_fnc_interactProgress_running",false];
	};

	false;
}];

_success = true;
disableSerialization;

missionNamespace setVariable ["MCC_fnc_interactProgress_running",true];

//Should we use the default anim or custom one
if (typeName _anim isequalto typename "") then {
	_defaultAnim = _anim;
	_anim = true;
};

if (_anim) then {player playMoveNow _defaultAnim};

(["MCC_interactionPB"] call BIS_fnc_rscLayer) cutRsc ["MCC_interactionPB", "PLAIN"];
_ctrl = ((uiNamespace getVariable "MCC_interactionPB") displayCtrl 2);
_ctrl ctrlSetText _text;
_ctrl = ((uiNamespace getVariable "MCC_interactionPB") displayCtrl 1);

for [{_x=1},{_x<_time},{_x=_x+0.1}]  do {
	_ctrl progressSetPosition (_x/_time);
	if ((animationState player)!= _defaultAnim && _anim) then {player playMoveNow _defaultAnim};
	sleep 0.1;
	if (!alive player || getDammage player >= 0.8 || player distance _object > 7 || !(missionNamespace getVariable ["MCC_fnc_interactProgress_running",true])) then {_success = false;
		_x = _time;
	};
};

(["MCC_interactionPB"] call BIS_fnc_rscLayer) cutText ["", "PLAIN"];

if (_anim) then {player playMoveNow "AmovPknlMstpSlowWrflDnon"};

//Clean up
(findDisplay 46) displayRemoveEventHandler ["KeyDown", _endActionEH];
missionNamespace setVariable ["MCC_fnc_interactProgress_running",false];

_success
