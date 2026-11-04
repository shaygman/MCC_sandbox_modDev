/*
	GAIA_fnc_cacheFar - cache stage 2: serialize a group (MCC_GAIA_CACHE_STAGE2 /
	GAIA_CACHE_<pos>) and delete its units and vehicles (deleteVehicle works on
	remote objects). The emptied group is flagged GAIA_CACHED_FAR so the group
	maintenance never respawns it; when it is not local (HC) its owner deletes it.
	In: [GROUP]
*/
if(!isServer) exitWith {};
private ["_group"];

_group 			= _this select 0; 
if (isNull _group) exitWith {};
_units  		= units _group;
_vehicles		=  [_group] call  BIS_fnc_groupVehicles;
_sf 				= [];
_uv 				= [];
_crew 			= [];
_gv					= [];


{
	_veh = _x;
	_crew = [];
	{
	 
		if 
			(
			 ( assignedVehicle _x == _veh)
			 and
			 ( alive _x)
			)
	  then
		{
			//player globalchat format ["%1, %2",_veh,_x];
			_crew = _crew + [[(typeof _x),(getpos _x),damage _x,skill _x,rank _x,(assignedVehicleRole _x),getdir _x]];
			_units = _units  - [_x];
			
		}
	}	foreach _units;
	
	_gv = _gv + [[(typeof _veh),position _veh,damage _veh,fuel _veh,_crew,getdir _x]];
	
} foreach _vehicles;

{
	if  ( alive _x) then 
	{
		_uv = _uv + [[typeof _x,(visiblePositionasl _x),damage _x,skill _x,rank _x,getdir _x]];
		//deleteVehicle _x;
	};
	
}
foreach _units;

_array = [];_waypoints=[];

if (((count (waypoints _group)) - currentWaypoint _group)>0) then
{
	{
		private "_waypoint";
		
		if (( (waypointposition _x) distance [0,0,0])>0) then 
		{
				_waypoint = [
					waypointposition _x,
					waypointtype _x,
					waypointbehaviour _x,
					waypointspeed _x,
					waypointcombatmode _x,
					waypointformation _x,
					waypointstatements _x,
					waypointtimeout _x,
					waypointhouseposition _x
				];
				
				_array set [count _array, _waypoint];
		};
		
	} foreach (waypoints _group);
	_waypoints = [_array, currentwaypoint _group];
};

_sf = 	[_gv  
				,_uv  
				,side _group
				,(_group getVariable  ["GAIA_zone_intend",[]])
				,behaviour (leader _group)
				,combatmode _group
				,speedmode _group
				,formation _group
				,_waypoints
				,(_group getVariable  ["MCC_GAIA_RESPAWN",-1])
				, (missionNamespace getVariable [ "GAIA_RESPAWN_" + str(_group),[] ])
				];

_pos = position leader _group;

MCC_GAIA_CACHE_STAGE2 = MCC_GAIA_CACHE_STAGE2+ [_pos];
_var2 = "GAIA_CACHE_" + str(_pos); 	
missionNamespace setVariable [_var2, _sf ];


//player globalchat format ["%1",_sf];

_group setVariable ["GAIA_CACHED_FAR", true, true];
[_group] call GAIA_fnc_unregisterGroup;

{deleteVehicle _x;} foreach units _group;
{deleteVehicle _x;} foreach _vehicles;
if (local _group) then {deletegroup _group;};

