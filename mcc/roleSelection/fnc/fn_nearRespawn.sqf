/*===================================================================  MCC_fnc_nearRespawn ================================================================================
	find in an object/unit is near its respawn position

	<IN>
		0:	OBJECT/ARRAY unit or position
		1:	OBJECT/GROUP/SIDE repsawn will be checked to the given object/group/side
		2:	INTEGER - distance in meters


	<OUT>
		BOOLEAN - true if a respawn position is close



===========================================================================================================================================================================*/

params [
	["_object",objNull,[objNull,[0,0,0]]],
	["_respawn",objNull,[objNull, grpNull, sideUnknown]],
	["_distance",50,[0]]
];

({_object distance2d _x <= _distance} count ([_respawn] call BIS_fnc_getRespawnPositions)) > 0;