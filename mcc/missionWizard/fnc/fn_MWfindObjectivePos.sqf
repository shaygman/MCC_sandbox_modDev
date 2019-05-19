/*================================================MCC_fnc_MWfindObjectivePos===============================================================================================
// Find the mission Wizard's center
// Example:[_missionCenter,_isCQB,_minObjectivesDistance, _objFirstTime] call MCC_fnc_MWfindObjectivePos;
// _missionCenter 			= position, from where to start looking.
//_isCQB 				= Boolean, true - for CQB areay false if it doesn't matters.
//_minObjectivesDistance 	= integer, minimum distance between objectives
// Return - pos
//================================================================================================================================================================*/

private ["_missionCenter","_isCQB","_minObjectivesDistance","_buildingsArray","_farEnough","_range","_flatPos","_availablePos","_time","_radius","_markerName","_objectivesMarkers","_ambient"];

_missionCenter 			= _this select 0;
_isCQB 					= _this select 1;
_minObjectivesDistance 	= _this select 2;
_maxObjectivesDistance 	= param [3,500,[500]];

_farEnough = false;
_range = 100;
_availablePos = [];

//Lets find a pice of land
_time = time + 20;

_objectivesMarkers = missionNamespace getVariable ["MCC_MWObjectiveMarkers",[]];

_ambient = if (_isCQB) then {"houses + meadow "} else {"meadow + houses + hills "};

//if it is the first time then find objective close to the center
while {(count _availablePos) == 0 && (_range < (_maxObjectivesDistance*3))} do {

	_availablePos = selectBestPlaces [_missionCenter, _range, _ambient, 10, 5];

	if (count _availablePos > 0) then {
		_availablePos = (_availablePos select 0) select 0;
		_availablePos set [2,0];

		//are we far enough from all other objectives
		_farEnough = {(getMarkerPos _x) distance2d _availablePos <= (_minObjectivesDistance*0.5)} count _objectivesMarkers == 0;

		//Ig we are not far enough and also too far from mission center
		if (!_farEnough) then {_availablePos = []};
	};

	_range = _range + 100;
	sleep 0.01;
};

if (missionNamespace getVariable ["MCC_debug",false]) then {
	systemChat format ["found position: %1, have time: %2, farenough: %3",(count _availablePos) > 0, time < _time,_farEnough];
	diag_log format ["found position: %1, have time: %2, farenough: %3",(count _availablePos) > 0, time < _time,_farEnough];
};

if (count _availablePos == 0) exitWith {
	diag_log "MCC: Mission Wizard Error: No mission objective's postion found, make a bigger zone";
	/*
	MCC_MWisGenerating = false;
	publicVariable "MCC_MWisGenerating";
	0 = ["MCC: Mission Wizard Error: No mission objective's postion found, make a bigger zone"] spawn MCC_fnc_halt;
	*/
	_availablePos
};

if (_farEnough || (count _objectivesMarkers == 0)) then {
	if (_isCQB) then {
		_buildingsArray = [];
		_radius = 200;

		while {count _buildingsArray <= 1} do
		{
			_buildingsArray	= [_availablePos,_radius] call MCC_fnc_MWFindbuildingPos;
			_radius = _radius + 100;
			sleep 0.1;
		};


		_availablePos = getpos ((_buildingsArray call BIS_fnc_selectRandom) select 0);
	};

	_markerName = format ["Objective_%1",count _objectivesMarkers];

	createmarkerlocal [_markerName,_availablePos];
	_markerName setmarkertypelocal "mil_box";
	_markerName setMarkerTextLocal _markerName;
	_markerName setmarkerColorlocal "ColorRed";
	_markerName setMarkerSizeLocal [0.3, 0.3];
	_markerName setMarkerAlphaLocal 0;

	_objectivesMarkers pushBack _markerName;
	missionNamespace setVariable ["MCC_MWObjectiveMarkers",_objectivesMarkers];
	publicVariable "MCC_MWObjectiveMarkers";
};

_availablePos;