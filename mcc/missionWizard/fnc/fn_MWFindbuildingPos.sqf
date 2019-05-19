/*======================================================MCC_fnc_MWFindbuildingPos==========================================================================================
	 return all buildings found a given radius sorted by distance from the center and their building positions in array [[BUILDING1,[POS1,POS2,POS3]],[BUILDING2,[POS1,POS2,POS3]]]

	 <in>
		0:	ARRAY or OBJECT - center of the radius
		1:	INTEGER - radius to start scan

	 <out>
	 	array - all buildings found in the radius sorted by distance from the center and their building positions in array [[BUILDING1,[POS1,POS2,POS3]],[BUILDING2,[POS1,POS2,POS3]]]
//=======================================================================================================================================================================*/
private ["_objPos","_radius","_buildingsArray","_building","_buildingPos","_buildingsArraySorted","_foundBuildings"];

_objPos = param [0,[0,0,0],[[],objNull]];
_radius = param [1,200,[0]];
_foundBuildings = [];


//If given an object
if (typeName _objPos == typeName objNull) then {
	_objPos = position _objPos;
};



while {count _foundBuildings == 0} do
{
	_buildingsArray	= nearestObjects  [_objPos,["House","Ruins","Church","FuelStation","Strategic"],_radius];	//Let's find the buildings in the area
	_radius = _radius + 50; 	//increase by 50 meters in nothing is found.


	if (!isnil "_buildingsArray") then {
		_buildingsArraySorted = [_buildingsArray, [_objPos], { _input0 distance _x }, "ASCEND"] call BIS_fnc_sortBy;

		{
			_building = _x;
			_buildingPos = _building call MCC_fnc_buildingPosCount;

			//If the building have an interrior positions
			if (_buildingPos > 3) then
			{
				_foundBuildings pushBack [_building,_buildingPos];
			};

		} forEach _buildingsArraySorted;
	};

	sleep 0.01;
};

_foundBuildings