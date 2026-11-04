//==================================================================MCC_fnc_rxHaltStop=========================================================================================
// Make an AI unit stop, face the unit that ordered it to halt, hold position for 2 seconds and then resume moving.
// Replaces remote code previously sent through BIS_fnc_spawn in MCC_fnc_doHaltAI. Must run where _target is local.
// Example: [_target, _unit] remoteExec ["MCC_fnc_rxHaltStop", _target];
// <IN>
//	_target:					OBJECT - the AI unit being halted
//	_men:						OBJECT - the unit enforcing the halt
//
// <OUT>
//		Nothing
//===========================================================================================================================================================================
params [["_target",objNull,[objNull]], ["_men",objNull,[objNull]]];

if (isNull _target || isNull _men) exitWith {};

(group _target) setFormDir ([_target,_men] call BIS_fnc_dirTo);
doStop _target;
_target disableAI "MOVE";
sleep 2;
_target enableAI "MOVE";
