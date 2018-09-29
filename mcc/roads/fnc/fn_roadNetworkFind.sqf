/* ======================================= MCC_fnc_roadNetworkFind =================================================================================================
	Find all the road networks in a current position - keep in mind that this function is very CPU demending and can take a long time to finish - best to use before mission start

	<IN>
		0:		ARRAY - Starting position to look from - note if no road was found in a 100 meter radius from the starting position will return empty array
		1:		ARRAY - End position to look to - note if no road was found in a 100 meter radius from the end position will return empty array
		2:		INTEGER (optional - 1000 by default) Radius to look for roads arund the starting position, distance over 3000 meters can take the function more then 10 seconds run on some machines
		3:		BOOLEAN  (optional - false by default)- Debug. If enabled will create markers for roads, junctions and dead ends

	<OUT>
		0:		ARRAY - all road segments as raw data
		1:		ARRAY - all crossroads segments
		2:		ARRAY - All deadend road segments
		3:		ARRAY - Road numbers and connecting roads as in [[0,[1,2]],[1,[3,4]],[2,[0]]] where allroas select 0 - will bring the road segments of road 0 which connect to road 1 and road 2 in the example
		4: 		ARRAY - Roads that are making the route from startpos to endpos as in [0,2,3,5,6]


		Example of how to get all the road segments for a route between two points and create markers:

			([getpos player, getpos target, 3000,false] call MCC_fnc_roadNetworkFind) params ["_allRoads","_crossRoads","_deadEnds","_allRoadsNumbers","_routeRoadNumbers"];

			_routes = [];

			{
				_currentRoute = _x;
				_route = [];
				{
					_route = _route + (_allroads select _x);
				} foreach _currentRoute;

				_routes pushback _route;
			} forEach _routeRoadNumbers;

			{
				_mapMarker = createMarkerLocal [format ["markername_%1",(["markername",1] call BIS_fnc_counter)],getPos _X];
				_mapMarker setMarkerShapeLocal "ICON";
				_mapMarker setMarkerTypeLocal "mil_dot";
				_mapMarker setMarkerColorLocal "ColorRed";
				_mapMarker setMarkerAlphaLocal 0.4;
			} forEach _route;
*/


params [
	["_startPos",[],[[]]],
	["_endPos",[],[]],
	["_radius",1000,[0]],
	["_debug",false,[false]]
];

if (_startPos isEqualTo []) exitWith {diag_log "MCC_fnc_roadNetworkFind: Start pos is empty"};

_startTime = time;
_results = [] call {
	_fnc_sortRoads = {
		private ["_branches"];
		params ["_road"];

		_branches = roadsConnectedTo _road;
		_branches = _branches select {!(_x in _explored)};
		_currentRoad = [];

		//Continue until road end or a junction
		while {(count _branches == 1) &&
			   !( _road in _explored) &&
			   (( _road distance2D _startPos) < _radius)
			  } do {

			_explored pushBack _road;
			_currentRoad pushBack _road;
			_road = _branches select 0;
			_branches = roadsConnectedTo _road;
			_branches = _branches select {!(_x in _explored)};
		};

		if (count _currentRoad > 0) then {
			_availableRoads pushBack _currentRoad;
		};

		//If we came here then we either: A - came to a dead end, B - came to a junction, C - out of roads (loop)
		switch (true) do
		{
			case (count _branches == 0):	//Dead End
			{
				_explored pushBack _road;
				_ends pushBack _road;
			};

			case (count _branches >= 2):	//Junction
			{
				_explored pushBack _road;
				_currentRoad pushBack _road;
				_connectingRoads = [];

				{
					if (_x distance2D _startPos < _radius) then {
						_connectingRoads pushBack _x;

						if !(_x in _explored) then {[_x] call _fnc_sortRoads};
					};
				} forEach _branches;

				_junctions pushBack [_road,_connectingRoads];
			};

			case (_road in _explored): //Out of roads
			{
				_loops pushBack _road;
			};
		};
	};

	//if we have 2 points then the max radius will be the distance between them * 1.2
	if !(_endPos isEqualTo []) then {
		_radius = (_startPos distance2D _endPos)*1.5;
	};

	_allRoads = _startPos nearRoads 100;
	_explored = [];
	_ends = [];
	_loops = [];
	_junctions = [];
	_availableRoads = [];


	{
		_road = _x;
		if !(_road in _explored) then {
			[_road] call _fnc_sortRoads;
		};
	} forEach _allRoads;

	[ _explored, _ends,  _loops, _junctions, _availableRoads, _startTime]
};

_info =  format [ "explored : %1\n\n
			   Ends : %2\n\n
			   Loops : %3\n\n
			   Junction : %4\n\n
			   Roads\n%5\n\n
			   Time taken: %6", count( _results select 0 ), count( _results select 1 ), count( _results select 2 ), count ( _results select 3 ) , count ( _results select 4 ), time - _startTime];

if (_debug) then {hint _info};


_results params ["_explored","_ends","_loops","_junctions","_availableRoads"];

_connectedRoads = [];

//Lets find all the connecting roads
{
	_road = _x;
	_roadIndex = _foreachindex;
	_connectedCurrentRoad = [];
	_possibleJunctions = if (count _road >= 2) then {[_road select 0, _road select (count _road -1)]} else {[_road select 0]};

	//Search if start segment and last segments are a junction
	{
		_roadSegment = _x;

		{
			_connectedRoad = _x;

			{
				if (_connectedRoad in _x && _foreachindex != _roadIndex) then {
					_connectedCurrentRoad pushBack _foreachindex;
				};
			} forEach (_availableRoads - _road);
		} forEach (roadsConnectedTo _roadSegment);
	} forEach _possibleJunctions;

	_connectedRoads pushBack [_roadIndex, _connectedCurrentRoad];

} forEach _availableRoads;

_routesPaths = [];
//If we have an end pos then find the route
if !(_endPos isEqualTo []) then {

	private ["_destinationsRoads","_index"];

	_destinationsRoads = [];

	//Find the end pos and start pos closest roads

	{
		_allRoads = [];
		_radius = 10;
		_index = _foreachindex;
		_destinationsRoads set [_index,-1];

		while {count _allRoads <=0} do
		{
			_allRoads = _x nearRoads _radius;
			_radius = _radius + 10;
		};

		_roadSegment= _allRoads select 0;

		{
			if (_roadSegment in _x) exitWith {_destinationsRoads set [_index,_foreachindex]};
		} forEach _availableRoads;

	} forEach [_startPos, _endPos];


	//find the route
	_visitedPaths = [];

	_findRoute = {
		private ["_previousPath"];
		params ["_startRoad","_endRoad","_previousPath"];



		_roadInfo = (_connectedRoads select _startRoad) select 1;

		if (_startRoad isEqualTo _endRoad) then {
			_routesPaths pushBack _previousPath;
		};

		{
			if !(_x in _previousPath) then {
				[_x, _endRoad, _previousPath + [_x]] call _findRoute;
			};
		} forEach _roadInfo;
	};

	[_destinationsRoads select 0, _destinationsRoads select 1, [_destinationsRoads select 0]] call _findRoute;
};

if (_debug) then {
	private _markers = [];

	//Roads
	{

		_color = ["colorGreen","colorBlack","ColorRed","colorBlue"] select ( _foreachindex mod 4);
		_index = _foreachindex;

		if (({_index in _x} count _routesPaths > 0) || _endPos isEqualTo []) then {
			{
				_mapMarker = createMarkerLocal [format ["markername_%1",(["markername",1] call BIS_fnc_counter)],getPos _X];
				_mapMarker setMarkerShapeLocal "ICON";
				_mapMarker setMarkerTypeLocal "mil_dot";
				_mapMarker setMarkerColorLocal _color;
				_mapMarker setMarkerAlphaLocal 0.4;
				_mapMarker setMarkerTextLocal str _index;
				_markers pushBack _mapMarker;
			} forEach _x;
		};

	}forEach _availableRoads;

	//Loops
	{
		_mapMarker = createMarkerLocal [format ["markername_%1",(["markername",1] call BIS_fnc_counter)],getPos _X];
		_mapMarker setMarkerShapeLocal "ICON";
		_mapMarker setMarkerTypeLocal "hd_start";
		_mapMarker setMarkerColorLocal "ColorRed";
		_mapMarker setMarkerTextLocal "Loop";
		_mapMarker setMarkerAlphaLocal 0.4;
		_markers pushBack _mapMarker;

	}forEach ( _results select 2 );

	//Dead End
	{
			_mapMarker = createMarkerLocal [format ["markername_%1",(["markername",1] call BIS_fnc_counter)],getPos _X];
			_mapMarker setMarkerShapeLocal "ICON";
			_mapMarker setMarkerTypeLocal "hd_end";
			_mapMarker setMarkerColorLocal "ColorRed";
			_mapMarker setMarkerTextLocal "End";
			_mapMarker setMarkerAlphaLocal 0.4;
			_markers pushBack _mapMarker;
	} forEach ( _results select 1 );

	//junction
	{
			_mapMarker = createMarkerLocal [format ["markername_Junction%1",(["markername",1] call BIS_fnc_counter)],(getPos (_X select 0))];
			_mapMarker setMarkerShapeLocal "ICON";
			_mapMarker setMarkerTypeLocal "mil_destroy";
			_mapMarker setMarkerColorLocal "ColorRed";
			_mapMarker setMarkerTextLocal str _foreachindex;
			_mapMarker setMarkerAlphaLocal 0.4;
			_markers pushBack _mapMarker;
	} forEach ( _results select 3 );

	//Delete markers after 30 seconds
	_markers spawn {
		sleep 20;

		{
			deleteMarkerLocal _x;
		} forEach _this;
	};
};

[_availableRoads, _junctions, _ends, _connectedRoads, _routesPaths]