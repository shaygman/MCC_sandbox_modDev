/*
	MCC_fnc_supplyNearBase
	Is an object at a side's base: near MCC_START_<side> or near a built RTS base building of that side.
	Params:
		0: OBJECT - object to test
		1: NUMBER - (optional) radius in meters, default MCC_logisticsBaseRadius (75)
	Returns: SIDE - the base's side, or sideUnknown when not at a base
*/
params [["_obj", objNull, [objNull]], ["_radius", -1, [0]]];

if (isNull _obj) exitWith {sideUnknown};
if (_radius < 0) then {_radius = missionNamespace getVariable ["MCC_logisticsBaseRadius", 75]};

private _pos = getPosATL _obj;
private _found = sideUnknown;

{
	private _start = missionNamespace getVariable [format ["MCC_START_%1", _x], []];
	if (_start isEqualType objNull) then {_start = if (isNull _start) then {[]} else {getPosATL _start}};
	if (_start isEqualType [] && {count _start >= 2} && {!(_start isEqualTo [0,0,0])} && {_pos distance2D _start <= _radius}) exitWith {
		_found = _x;
	};
} forEach [west, east, resistance];

if (_found isEqualTo sideUnknown) then {
	{
		private _bSide = _x getVariable ["mcc_side", sideLogic];
		if (!(isNull attachedTo _x) && {(_x getVariable ["mcc_constructionItemType", ""]) != ""} && {_bSide in [west, east, resistance]}) exitWith {
			_found = _bSide;
		};
	} forEach (_pos nearObjects ["UserTexture10m_F", _radius]);
};

_found
