//==================================================================MCC_fnc_ACEdropAmmobox=======================================================================================
//Drop MCC ammbox in ACE
// Example: ["MCC_ammoBoxMag","MCC_ammoBox"] call MCC_fnc_ACEdropAmmobox;
// <IN>
//  _mag:                    STRING: magazine class name  - will be removed from the player
//  _itemClass:              STRING: object class name  - will be spawned next the player
//
// <OUT>
//      <nothing>
//
//===========================================================================================================================================================================
private ["_mag","_itemClass","_handPos","_utility"];
_mag = param [0, "", [""]];
_itemClass = param [1, "", [""]];

if (_mag == "" || _itemClass == "") exitWith {};

player removeItem _mag;
player playactionNow "putdown";
sleep 0.3;
_handPos = player selectionPosition "LeftHand";
_utility = _itemClass createvehicle (player modelToWorld [(_handPos select 0),(_handPos select 1)+1.8,(_handPos select 2)]);
_utility setpos (player modelToWorld [(_handPos select 0),(_handPos select 1)+1,(_handPos select 2)]);
_utility setdir getdir player;
0 = [_utility,(owner player)] remoteExec ["setOwner", 2];

if (_itemClass in ["MCC_ammoBox"]) then {
	if (missionNamespace getVariable ["MCC_isACE",false]) then {
		[_utility, "Use ACE keys to resupply"] remoteExec ["MCC_fnc_createHelper",2];
	} else {
		[_utility, "Hold %1 to resupply"] remoteExec ["MCC_fnc_createHelper",2];
	};

	_utility spawn	{
		private ["_t"];
		_t = time + 600;
		while {alive _this && time < _t} do {sleep 5};
		if (alive _this) exitWith {deleteVehicle _this};
	};
};