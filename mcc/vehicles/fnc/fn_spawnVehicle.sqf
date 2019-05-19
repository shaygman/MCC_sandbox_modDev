/*============================================== MCC_fnc_spawnVehicle =============================================================================

	Replace BIS_fnc_spawnVehicle allow spawning of random animations originally by  Joris-Jan van 't Land

	Parameter(s):
	_this select 0: desired position (Array).
	_this select 1: desired azimuth (Number).
	_this select 2: type of the vehicle (String).
	_this select 3: side or existing group (Side or Group).
	_this select 4: (optional) force precise position (Bool, default: true).

	Returns:
	Array:
	0: new vehicle (Object).
	1: all crew (Array of Objects).
	2: vehicle's group (Group).

====================================================================================================================================================
*/

//Validate parameter count
if ((count _this) < 4) exitWith {debugLog "Log: [spawnVehicle] Function requires at least 4 parameters!"; []};

private ["_grp", "_side", "_newGrp"];

_this params [
	["_pos",[0,0,0],[[]]],
	["_azi",0,[0]],
	["_type","",[""]],
	["_param4",sideEnemy,[sideEnemy,grpNull]],
	["_precisePosition",true,[true]],
	["_randomAnimations",true,[true]]
];

//Determine if an actual group was passed or a new one should be created.
if ((typeName _param4) == (typeName sideEnemy)) then
{
	_side = _param4;
	_grp = createGroup _side;
	_newGrp = true;
}
else
{
	_grp = _param4;
	_side = side _grp;
	_newGrp = false;
};

//Validate parameters
if ((typeName _pos) != (typeName [])) exitWith {debugLog "Log: [spawnVehicle] Position (0) must be an Array!"; []};
if ((typeName _azi) != (typeName 0)) exitWith {debugLog "Log: [spawnVehicle] Azimuth (1) must be a Number!"; []};
if ((typeName _type) != (typeName "")) exitWith {debugLog "Log: [spawnVehicle] Type (2) must be a String!"; []};
if ((typeName _grp) != (typeName grpNull)) exitWith {debugLog "Log: [spawnVehicle] Group (3) must be a Group!"; []};

private ["_sim", "_veh", "_crew"];
_sim = getText(configFile >> "CfgVehicles" >> _type >> "simulation");

switch (tolower _sim) do {
	case "soldier": {
		_veh = _grp createunit [_type,_pos,[],0,"none"];
	};
	case "airplanex";
	case "helicopterrtd";
	case "helicopterx": {
		//Make sure aircraft start at a reasonable height.
		if (count _pos == 2) then {_pos set [2,0];};
		_pos set [2,(_pos select 2) max 50];
		_veh = createVehicle [_type,_pos,[],0,"FLY"];
	};
	default {
		_veh = createvehicle [_type,_pos,[],0,"none"];
	};
};


//Set the correct direction.
_veh setDir _azi;

//Make sure the vehicle is where it should be.
if (_precisePosition) then
{
	_veh setPos _pos;
};

//Set a good velocity in the correct direction.
if (_sim == "airplanex") then {
	_veh setVelocity [100 * (sin _azi), 100 * (cos _azi), 0];
};

//Spawn the crew and add the vehicle to the group.
createvehiclecrew _veh;
_crew = crew _veh;
_crew joinsilent _grp;
_grp addVehicle _veh;

//If this is a new group, select a leader.
if (_newGrp) then
{
	_grp selectLeader (commander _veh);
};

//If we pick random animation
if (_randomAnimations) then {

	[_veh] spawn MCC_fnc_vehicleRandomAnimation;
};

[_veh, _crew, _grp]