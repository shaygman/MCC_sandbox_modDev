/*===================================================== MCC_fnc_isVisableToPlayers =======================================================================================
	Check if an object/unit is visable by players

	IN:
		0:		OBJECT/ARRAY - object/unit/position that should be visible
		1:		NUMBER - minimum distance in meters that the object should be from the players or it will return false no matter if the object is visiable or not

	OUT
		BOOLEAN 	true if visible false if not

*/

private ["_spawnCenters","_isVisibale"];
params [
	["_object",objNull,[objNull,[]]],
	["_radius",0,[0]]
];

_spawnCenters = if (isMultiplayer) then {playableUnits} else {[player]};

if (_object isEqualType objNull) then {
	_isVisibale = (({(_x distance _object < _radius) || !(lineintersects [eyepos _x,getposasl _object,_x,_object])} count _spawnCenters)>0);
} else {

	_isVisibale = (({(_x distance _object < _radius) || !(lineintersects [eyepos _x,AGLToASL _pos])} count _spawnCenters)>0);
};

_isVisibale

