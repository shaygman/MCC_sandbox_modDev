//=================================================================MCC_fnc_rtsClearBuilding==============================================================================
//	Remove resources
//  Parameter(s):
//     _module: OBJECT the building to delete
//     _deleteModule: BOOLEAN should we delete the attached module
//==============================================================================================================================================================================
private ["_module","_deleteModule","_anchor","_side"];
_module			= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_deleteModule 	= [_this, 1, true, [true]] call BIS_fnc_param;

_anchor = _module getVariable ["mcc_construction_anchor",objNull];
_side = _anchor getVariable ["mcc_side",sideLogic];

{deletevehicle _x} foreach (attachedObjects _anchor);
deletevehicle _anchor;


if (_deleteModule) then {
	//Delete Marker
	[compile format ['deleteMarker "%1";',(_module getVariable ["mcc_markerName",""])],"BIS_fnc_spawn", _side,false] call BIS_fnc_MP;

	//Delete module
	deletevehicle _module;
};

//Remove old marker
if (!isnil "MCC_fnc_rtsMakeMarkersGroups") then {
	[] spawn MCC_fnc_rtsMakeMarkersGroups;
};
MCC_ConsoleGroupSelected = [];