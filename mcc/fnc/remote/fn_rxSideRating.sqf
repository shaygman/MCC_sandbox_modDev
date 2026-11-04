//==================================================================MCC_fnc_rxSideRating=====================================================================================
// Adjust the local player's rating after an enemy/friendly base object was destroyed: +500 if the player is not on the
// owning side, -1000 if the player is on the owning side. Runs on the machine of the destroying unit.
// Replaces remote code previously sent through BIS_fnc_spawn in MCC_fnc_construct_base.
// Example: [_side] remoteExec ["MCC_fnc_rxSideRating", _source];
// <IN>
//	_side:					SIDE - side owning the destroyed object
//
// <OUT>
//		Nothing
//===========================================================================================================================================================================
params [["_side",sideUnknown,[sideUnknown]]];

if (!hasInterface || isNull player) exitWith {};
player addRating (if (playerSide != _side) then {500} else {-1000});
