if(!isServer) exitWith {};

_sf   			= _this select 0 select 0;

_respawn    = _this select 1;
_cache			= _this select 2;
_zoneIntend	= _this select 3;

if (_respawn >=0)  then
{
			_uv 				= [];
			_crew 			= [];
			_gv					= [];

			_group = creategroup (_sf select 2);
			if (isnull _group) exitwith {};
			_group  setVariable ["GAIA_zone_intend", _zoneIntend,true];
			_group  setVariable ["mcc_gaia_cache", _cache];

			//Create Vehicles in group
			{
					_veh = _x;
					//_cv  = (_veh select 0)  createvehicle (_veh select 1);
					_cv = createVehicle [(_veh select 0), (_veh select 1), [], 0, "CAN_COLLIDE"] ;
					//_cv  setPosasl (_veh select 1);
					_cv setdamage (_veh select 2);
					_cv setfuel (_veh select 3);
					_cv setdir  (_veh select 5);


					{
						_un = _group createUnit [(_x select 0), (_x select 1), [], 0, "FORM"] ;
						_un setdamage 		(_x select 2);
						_un setskill  		(_x select 3);
						_un setrank   		(_x select 4);

						// Move to vehicle position
						_role = (_x select 5);
						[_cv, _un, _role] call BIS_fnc_moveIn;

					}	foreach (_veh select 4);

					_group setFormDir (_veh select 5);

					//Add to curatror
					{_x addCuratorEditableObjects [[_cv],true]} forEach allCurators;

			} foreach (_sf select 0);


			//Create Infantry in group
			{
				//player globalchat format [" going  %1",(_x select 0)];
				//_un=(_x select 0) createUnit [(_x select 1), _group,"",(_x select 3),(_x select 4)];
				_un = _group createUnit [(_x select 0), (_x select 1), [], 0, "CAN_COLLIDE"] ;

				_un setdamage 		(_x select 2);
				_un setskill  		(_x select 3);
				_un setrank   		(_x select 4);
				_un setPosasl 		(_x select 1);

				_un setdir			 	(_x select 5);

				//Add to curatror
				{_x addCuratorEditableObjects [[_un],false]} forEach allCurators;

			} foreach (_sf select 1);

			//Update the respawn
			[_group,(_respawn-1)] spawn GAIA_fnc_respawnSet;

			_group setspeedmode 	(_sf select 6);
			_group setformation 	(_sf select 7);
			_group setbehaviour 	(_sf select 4);
			_group setcombatmode (_sf select 5);

			// Clear all way points
			while {(count (waypoints _group)) > 0} do
			{
			 	deleteWaypoint ((waypoints _group) select 0);
			};

			if (count (_sf select 8)>1) then
			{
				_array = (_sf select 8) select 0;
				_current = (_sf select 8) select 1;



				{
					private "_waypoint";
					if (( (_x select 0) distance [0,0,0])>0) then
					{
						_waypoint = _group addwaypoint [(_x select 0), 0];

						_waypoint setwaypointtype (_x select 1);

						_waypoint setwaypointbehaviour (_x select 2);
						_waypoint setwaypointspeed (_x select 3);
						_waypoint setwaypointcombatmode (_x select 4);
						_waypoint setwaypointformation (_x select 5);
						_waypoint setwaypointstatements (_x select 6);
						_waypoint setwaypointtimeout (_x select 7);
						_waypoint setwaypointhouseposition (_x select 8);
					};

				} foreach _array;

				_group setcurrentwaypoint [_group,_current];
			};
};