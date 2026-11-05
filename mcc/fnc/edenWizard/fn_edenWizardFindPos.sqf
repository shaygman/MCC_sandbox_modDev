/*=================================================== MCC_fnc_edenWizardFindPos ===================================================
	Terrain / position helpers of the editor-time Mission Wizard (terrain and config only, no runtime MCC data).
	The mission area is MCC5MW_ctx "area": [center, a, b, dir, isRectangle].

	Params: 0: STRING - mode, then per mode:
		"inArea",    scale (NUMBER 0-1, default 1), minDistToUsed (NUMBER, default 0)
		             -> random land position inside the (scaled) mission area, [] when none found
		"flat",      pos, radius, size (NUMBER, free space needed)
		             -> flat empty land position near pos (PositionATL), [] when none found
		"buildings", center, radius, minPositions (NUMBER, default 2)
		             -> [[building, [positions]], ...] terrain buildings with enough positions, nearest first
		"roads",     center, radius
		             -> road objects (not trails) inside the mission area
		"roadsEntering", center, radius
		             -> one road object per 45 degree sector on the ring 0.7-1.0 x radius (roads leading into the area)
		"roadDir",   road
		             -> direction (NUMBER) of the road segment
		"onRoadSide", road, offset (NUMBER)
		             -> position next to the road (offset m from its axis, right side)
	Returns: see modes
	Example: private _pos = ["inArea", 0.8, 150] call MCC_fnc_edenWizardFindPos;
*/
params [["_mode", "", [""]]];

private _ctx = missionNamespace getVariable ["MCC5MW_ctx", createHashMap];
(_ctx getOrDefault ["area", [[0, 0, 0], 500, 500, 0, false]]) params ["_center", "_a", "_b", "_dir", "_rect"];

switch (_mode) do {

	case "inArea": {
		private _scale = _this param [1, 1, [0]];
		private _minDist = _this param [2, 0, [0]];
		private _used = _ctx getOrDefault ["usedPos", []];
		private _result = [];
		for "_i" from 1 to 60 do {
			private _x0 = 0;
			private _y0 = 0;
			if (_rect) then {
				_x0 = (random 2 - 1) * _a * _scale;
				_y0 = (random 2 - 1) * _b * _scale;
			} else {
				private _r = sqrt (random 1);
				private _t = random 360;
				_x0 = _a * _scale * _r * (sin _t);
				_y0 = _b * _scale * _r * (cos _t);
			};
			//Rotate by the area direction (clockwise from north)
			private _p = [
				(_center select 0) + (_x0 * cos _dir) + (_y0 * sin _dir),
				(_center select 1) - (_x0 * sin _dir) + (_y0 * cos _dir),
				0
			];
			if (
				!(surfaceIsWater _p)
				&& {_minDist <= 0 || {(_used findIf {(_x distance2D _p) < _minDist}) < 0}}
			) exitWith {_result = _p};
		};
		_result
	};

	case "flat": {
		private _pos = _this param [1, [0, 0, 0], [[]]];
		private _radius = _this param [2, 100, [0]];
		private _size = _this param [3, 8, [0]];
		private _result = [];
		for "_i" from 0 to 40 do {
			private _p = if (_i == 0) then {+_pos} else {_pos getPos [random (_radius * (_i / 40)) + 5, random 360]};
			_p resize 2;
			if !(surfaceIsWater _p) then {
				private _flat = _p isFlatEmpty [_size, -1, 0.35, _size, 0, false, objNull];
				if (_flat isNotEqualTo [] && {!isOnRoad _p}) exitWith {_result = [_p select 0, _p select 1, 0]};
			};
			if (_result isNotEqualTo []) exitWith {};
		};
		_result
	};

	case "buildings": {
		private _pos = _this param [1, [0, 0, 0], [[]]];
		private _radius = _this param [2, 100, [0]];
		private _minPositions = _this param [3, 2, [0]];
		private _result = [];
		{
			private _positions = (_x buildingPos -1) select {!(surfaceIsWater _x)};
			if (count _positions >= _minPositions && {!isObjectHidden _x} && {damage _x < 1}) then {
				_result pushBack [_x, _positions];
			};
		} forEach (nearestTerrainObjects [_pos, ["HOUSE", "BUILDING", "CHURCH", "CHAPEL", "FUELSTATION", "HOSPITAL", "RUIN", "BUNKER", "FORTRESS", "VIEW-TOWER", "LIGHTHOUSE", "TRANSMITTER", "WATERTOWER"], _radius, true, true]);
		_result
	};

	case "roads": {
		private _pos = _this param [1, [0, 0, 0], [[]]];
		private _radius = _this param [2, 100, [0]];
		(_pos nearRoads _radius) select {
			private _info = getRoadInfo _x;
			!(_info select 2) && {(_info select 0) != "TRAIL"} && {(getPosATL _x) inArea [_center, _a, _b, _dir, _rect]}
		}
	};

	case "roadsEntering": {
		private _pos = _this param [1, [0, 0, 0], [[]]];
		private _radius = _this param [2, 300, [0]];
		private _sectors = createHashMap;
		{
			private _info = getRoadInfo _x;
			private _dist = _x distance2D _pos;
			if (
				!(_info select 2) && {(_info select 0) != "TRAIL"} && {_dist > _radius * 0.7}
				&& {count (roadsConnectedTo _x) > 0} && {!(_info select 8)}
			) then {
				private _sector = floor ((_pos getDir _x) / 45);
				if !(_sector in _sectors) then {_sectors set [_sector, _x]};
			};
		} forEach (_pos nearRoads _radius);
		values _sectors
	};

	case "roadDir": {
		private _road = _this param [1, objNull, [objNull]];
		private _info = getRoadInfo _road;
		private _beg = _info param [6, []];
		private _end = _info param [7, []];
		if (_beg isEqualTo [] || {_end isEqualTo []}) then {
			private _next = (roadsConnectedTo _road) param [0, objNull];
			if (isNull _next) then {getDir _road} else {_road getDir _next}
		} else {
			_beg getDir _end
		}
	};

	case "onRoadSide": {
		private _road = _this param [1, objNull, [objNull]];
		private _offset = _this param [2, 6, [0]];
		private _roadDir = ["roadDir", _road] call MCC_fnc_edenWizardFindPos;
		private _width = (getRoadInfo _road) param [1, 6];
		private _p = (getPosATL _road) getPos [(_width / 2) + _offset, _roadDir + 90];
		[_p select 0, _p select 1, 0]
	};

	default {[]};
};
