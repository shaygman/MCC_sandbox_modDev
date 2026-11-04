//=================================================================MCC_fnc_baseResourceReduce==============================================================================
//	Remove resources
//  Parameter(s):
//     0: ARRAY of [_var, _level] pairs
//        _var:string "ammo","repair","fuel","food", "med", "time"
//        _level: INTEGER the ammount of reousrces to reduce
//     1: SIDE (optional, default playerSide) side to take the resources from
//  The change is applied by the server (MCC_fnc_resChange) and broadcast from there.
//==============================================================================================================================================================================
params [["_res",[],[[]]], ["_side",playerSide,[west]]];

private _changes = [];
{
	_x params [["_var","",[""]], ["_level",0,[0]]];
	if ((toLowerANSI _var) in ["ammo","repair","fuel","food","med"]) then {
		_changes pushBack [_var, -_level];
	};
} forEach _res;

if (count _changes > 0) then {[_side, _changes] call MCC_fnc_resChange};
