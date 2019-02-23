/*======================== MCC_fnc_AI_assignToZone =====================================================
*/


private ["_object","_resualt","_zones","_zoneNumber"];

params [
	["_module",objNull,[objNull]]
];

if (!(local _module) || isnull curatorcamera) exitWith {};

deleteVehicle _module;
_object = missionNamespace getVariable ["MCC_curatorMouseOver",[]];

if (count _object <2) exitWith {[objNull, localize "STR_DISP_CURATOR_ERROR_CREATEZONE_NOUNIT"] call bis_fnc_showCuratorFeedbackMessage;};
_object = _object select 1;

_zones = [];
{
 	_zones pushBack str _x;
 } forEach (missionNamespace getVariable ["MCC_zones_numbers",[]]); ;

_resualt = ["Assign to Zone",[
			["Zone",_zones],
			["Behavior",["aggressive","Defensive","Fortify","Default","BIS Defence","BIS Patrol"]]
		  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

_zoneNumber = (_resualt select 0)+1;

if (_object isEqualType grpNull) then {
	_object setVariable ["GAIA_ZONE_INTEND",[str _zoneNumber ,((MCC_spawn_behaviors select (_resualt select 1)) select 1)], true];
	[objNull, localize "STR_DISP_CURATOR_ERROR_ASSIGNTOZONE_SUCCESS"] call bis_fnc_showCuratorFeedbackMessage;
};

if (_object isEqualType objNull) then {
	if (side group _object in [west,resistance,east,civilian]) then {
		(group _object) setVariable ["GAIA_ZONE_INTEND",[str _zoneNumber ,((MCC_spawn_behaviors select (_resualt select 1)) select 1)], true];
		[objNull, localize "STR_DISP_CURATOR_ERROR_ASSIGNTOZONE_SUCCESS"] call bis_fnc_showCuratorFeedbackMessage;
	};
};