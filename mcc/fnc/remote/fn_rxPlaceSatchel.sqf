//==================================================================MCC_fnc_rxPlaceSatchel=====================================================================================
// Order a unit to move to a position, place a satchel charge there, return to its previous position; the charge detonates after 30 seconds.
// Replaces remote code previously sent through BIS_fnc_spawn in MCC_fnc_rtsOrderPlaceSatchel. Must run where _leader is local.
// Example: [_pos, _leader] remoteExec ["MCC_fnc_rxPlaceSatchel", _leader];
// <IN>
//	_pos:						ARRAY - position to place the satchel
//	_leader:					OBJECT - unit placing the satchel
//
// <OUT>
//		Nothing
//===========================================================================================================================================================================
params [["_pos",[0,0,0],[[]]], ["_leader",objNull,[objNull]]];
private ["_prepos","_mine"];

if (isNull _leader) exitWith {};

_prepos = getpos _leader;
_leader domove _pos;
waitUntil {!(alive _leader) || _leader distance _pos < 6};
if (!alive _leader) exitWith {};
_mine = createMine ['SatchelCharge_F',getpos _leader, [], 0];
_leader domove _prepos;
_mine spawn {sleep 30; _this setDamage 1};
