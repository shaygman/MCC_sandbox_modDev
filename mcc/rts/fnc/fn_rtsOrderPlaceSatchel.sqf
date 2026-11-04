//=================================================================MCC_fnc_rtsOrderPlaceSatchel==============================================================================
//	Order land
//  Parameter(s):
//     _ctrl: CONTROL
//==============================================================================================================================================================================
private ["_group","_pos","_statment","_leader"];
_res = param [1, [], [[]]];

if (count MCC_ConsoleGroupSelected <=0) exitWith {};
_pos = uiNamespace getVariable ["MCC_rtsMenuLeftClickXYpos",[0,0]];
_group = MCC_ConsoleGroupSelected select 0;

if !(vehicle leader _group isKindOf "man") exitWith {"not a man unit"};

[9989,"Left click to place",5,true] spawn MCC_fnc_setIDCText;

waitUntil {str (uiNamespace getVariable ["MCC_rtsMenuLeftClickXYpos",[0,0]]) != str _pos};
_pos = screenToWorld (uiNamespace getVariable ["MCC_rtsMenuLeftClickXYpos",[0,0]]);

//remove resources
[_res] spawn MCC_fnc_baseResourceReduce;

_leader = leader _group;

[_pos, _leader] remoteExec ["MCC_fnc_rxPlaceSatchel", _leader];