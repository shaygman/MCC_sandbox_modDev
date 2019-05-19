/*===================================================  MCC_fnc_buildRandomComposition ====================================================
	Build random composotion in a given position if no empty space is found it will scan in a bigger radius until space is found

	<IN>
		0:		ARRAY - position
		1:		STRING - "military" - for militart composition "civ" - for civilian composition "random" - for a random composition

	<OUT>
		ARRAY - composition center position
*/
params [
		["_pos",[],[[]]],
		["_compType","random",[""]]
	];
/*
private ["_range","_spawnPos","_null"];

if (count _pos <= 0) exitWith {[]};

//Find an empry spot
_range = 50;
_spawnPos = [-500,-500,0];

//If we haven't find it in first time increase by 50;
while {str _spawnPos == "[-500,-500,0]" || (count (_spawnPos nearRoads 50) > 2)} do {
	_range = _range + 50;
	_spawnPos = [_pos,1,_range,30,0,0.35,0,[],[[-500,-500,0],[-500,-500,0]]] call BIS_fnc_findSafePos;
	sleep 0.1;
};

if (count _spawnPos <3) then {_spawnPos set [2,0]};
*/

private ["_compostion","_compTypeName"];

_compTypeName = switch (tolower _compType) do
						{
							case "military":{"MCC_MWSITESmilitary"};
							case "civ":{"MCC_MWSITES"};
							default	{["MCC_MWSITES","MCC_MWSITESmilitary"] call BIS_fnc_selectRandom};
						};

_compostion = (missionNamespace getVariable [_compTypeName,[[]]]) call BIS_fnc_selectRandom;

if (count _pos == 2) then {_pos set [2,0]};
_null = [_pos, random 360, _compostion] call MCC_fnc_compositionsPlace;

_pos;