/*===================================== MCC_fnc_hideTerrainObjectsArea ===================================================================================================
Hide all terrain objects in given area

	<IN>
		0:		ARRAY - position
		1:		INTEGER	 - Radius
		2:		BOOLEAN - hide/unhide

	<OUT>
		NOTHING
=========================================================================================================================================================================*/
private ["_hidingCode","_found"];
params [
	["_pos",[0,0,0],[[],objNull]],
	["_radius",50,[0]],
	["_hide",true,[true]]
];

_hidingCode = if (_hide) then {
		{_x hideObjectGlobal true;_x allowDamage false;}
	} else {
		{_x hideObjectGlobal false;_x allowDamage true;}
	};

_found = nearestTerrainObjects [_pos,[],_radius,false,true];

_hidingCode forEach (_found inAreaArray [_pos, _radius, _radius, 0, false]);
