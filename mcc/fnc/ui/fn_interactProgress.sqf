//==================================================================MCC_fnc_interactProgress===============================================================================================
// Create a progress bar and anim for the player
// Example: [_text,_time] call MCC_fnc_interactProgress;
//==================================================================================================================================================================================
private ["_text","_time","_ctrl","_object","_success","_endActionEH"];
_text = param [0,"",[""]];
_time = param [1,10,[0]];
_object = param [2,objNull,[objNull]];

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
player playMoveNow "AinvPknlMstpSlayWrflDnon_medic";

(["MCC_interactionPB"] call BIS_fnc_rscLayer) cutRsc ["MCC_interactionPB", "PLAIN"];
_ctrl = ((uiNamespace getVariable "MCC_interactionPB") displayCtrl 2);
_ctrl ctrlSetText _text;
_ctrl = ((uiNamespace getVariable "MCC_interactionPB") displayCtrl 1);

for [{_x=1},{_x<_time},{_x=_x+0.1}]  do {
	_ctrl progressSetPosition (_x/_time);
	if ((animationState player)!="AinvPknlMstpSlayWrflDnon_medic") then {player playMoveNow "AinvPknlMstpSlayWrflDnon_medic"};
	sleep 0.1;
	if (!alive player || getDammage player >= 0.8 || player distance _object > 7 || !(missionNamespace getVariable ["MCC_fnc_interactProgress_running",true])) exitWith {_success = false};
};

(["MCC_interactionPB"] call BIS_fnc_rscLayer) cutText ["", "PLAIN"];

player playMoveNow "AmovPknlMstpSlowWrflDnon";

//Clean up
(findDisplay 46) displayRemoveEventHandler ["KeyDown", _endActionEH];
missionNamespace setVariable ["MCC_fnc_interactProgress_running",false];

_success
