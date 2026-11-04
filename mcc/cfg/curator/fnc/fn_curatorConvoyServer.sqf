/*=================================================================MCC_fnc_curatorConvoyServer======================================================================
	SERVER: spawns a convoy for the Zeus convoy module through the old convoy script (MCC_fnc_s_place_convoy).
	That script needs unused vehicle slots to be nil, which cannot be sent over the network, so this wrapper builds the
	argument array on the server.
	Params:
		0: ARRAY  - vehicle classes, 1 to 5 (lead first)
		1: ARRAY  - start position
		2: ARRAY  - position the convoy faces
		3: STRING - side "west", "east", "guer" or "civ"
		4: STRING - HVT class, "0" = no HVT
		5: STRING - HVT vehicle class, "" = keep the middle vehicle
	Returns: nothing
	Example: [["B_MRAP_01_F"], _pos, _headingPos, "west", "0", ""] remoteExec ["MCC_fnc_curatorConvoyServer", 2];
//==================================================================================================================================================================*/
params [
	["_classes", [], [[]]],
	["_start", [0,0,0], [[]]],
	["_heading", [0,0,0], [[]]],
	["_side", "west", [""]],
	["_vip", "0", [""]],
	["_vipCar", "", [""]]
];

if (!isServer) exitWith {};
if !(["MCC_fnc_curatorConvoyServer"] call MCC_fnc_remoteAllowed) exitWith {};

_classes = (_classes select {_x isEqualType "" && {isClass (configFile >> "CfgVehicles" >> _x)}}) select [0, 5];
if (_classes isEqualTo []) exitWith {};
if !(toLower _side in ["west", "east", "guer", "civ"]) exitWith {};
if (_vip != "0" && {!isClass (configFile >> "CfgVehicles" >> _vip)}) then {_vip = "0"};
if (_vipCar != "" && {!isClass (configFile >> "CfgVehicles" >> _vipCar)}) then {_vipCar = ""};

private _args = [nil, nil, nil, nil, nil, _start, _heading, toLower _side, _vip, _vipCar];
{_args set [_forEachIndex, _x]} forEach _classes;

_args spawn MCC_fnc_s_place_convoy;
