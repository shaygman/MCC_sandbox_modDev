/* ----------------------------------------------------------------------------
Function: fnc_addWaypoint

Description:
	A function used to add a waypoint to a group.

Parameters:
	- Group 
	- Position 
	_ Zone
	_ Type

Returns:
	Waypoint

Author:
	Spirit, 7-1-2014

---------------------------------------------------------------------------- */

private ["_group","_position","_Zone","_waypoint","_ZoneBehaviour"];

_group 		= _this select 0;
_position = _this select 1;
_WPType		= _this select 2;

_Radius		= 40;

//Never send a group to an empty or map-center position (BIS_fnc_findSafePos failure value):
//hold where the leader is instead.
if !([_position] call GAIA_fnc_isValidPos) then {
	if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {diag_log format ["GAIA: rejected waypoint %1 for %2", _position, _group]};
	_position = getPosATL (leader _group);
};


_waypoint = _group addWaypoint 						[_position, 0];
_waypoint setWaypointType 								_WPType;

if (behaviour (leader _group) != "COMBAT") then
	{_waypoint setWaypointBehaviour 				"AWARE";};
	
_waypoint setWaypointCombatMode 					"RED";
_waypoint setWaypointSpeed 								"FULL" ;
_waypoint setWaypointFormation 						"VEE" ;
_waypoint setWaypointCompletionRadius 		_Radius;
_waypoint;


