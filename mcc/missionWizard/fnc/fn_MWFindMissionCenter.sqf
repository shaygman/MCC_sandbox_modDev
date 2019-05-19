/*============================================MCC_fnc_MWFindMissionCenter=========================================================================================================
	Find the mission Wizard's center
	Example: [_pos,_minRadius,_maxRadius,_isCQB] call MCC_fnc_MWFindMissionCenter;

	<IN>
		_pos				= position, from where to start looking.
		_minRadius 			= integer, minimum distance from _pos
		_maxRadius			= integer, Maximum distance from _pos
		_isCQB 			= Boolean, true - for CQB areay false if it doesn't matters.
		_isBasedLocations 	= Boolean, true if the map support locations

	<OUT>
 		Return - pos
//===========================================================================================================================================================================*/
private ["_pos","_minRadius","_centerFound","_buildingsArray","_newPos","_name","_type","_isBasedLocations","_locations","_location","_time","_radius"];

_pos 				= _this select 0;
_minRadius 			= _this select 1;
_isCQB 				= _this select 2;
_isBasedLocations 	= _this select 3;

_centerFound = false;
_newPos = nil;

if (_isBasedLocations) then {
	if (_isCQB) then
	{
		_locations = MCC_MWcityLocations + MCC_MWmilitaryLocations;
	}
	else
	{
		_locations = MCC_MWhillsLocations + MCC_MWnatureLocations + MCC_MWmarineLocations;
	};

	_location = _locations call BIS_fnc_selectRandom;
	_newPos = getpos (_location select 0);
} else {
	//Lets find a pice of land
	_time = time + 30;
	_newPos = [0,0];

	while {!_centerFound && time < _time} do {

		//first is whitelist second is blacklist, third is condition
		_radius = _minRadius;
		while {count _newPos <3 && time < _time} do
		{
			_newPos = [[[_pos,_radius]],["water"]] call BIS_fnc_randomPos;
			_radius = _radius + 50;
		};



		if (_isCQB) then
			{
				_buildingsArray	= nearestObjects  [_newPos,["House","Ruins","Church","FuelStation","Strategic"],_minRadius];	//Let's find the buildings in the area
				if ((count _buildingsArray > 0) && (!surfaceIsWater _newPos)) then
					{
						_newPos = getpos (_buildingsArray select 5);
						_centerFound = true;
					};
			}
				else
			{
				if (!surfaceIsWater _newPos) then {_centerFound = true};
			};
	};
};

if (isnil "_location") then {_location = [0,""]};
[_newPos,(_location select 1)];