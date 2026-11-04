/*=================================================================MCC_fnc_curatorDeleteBrush=======================================================================
	Zeus module "Delete / Area Brush": runs MCC_fnc_deleteBrush on the server in a radius around the module
	(delete units/vehicles/markers/bodies, lights on/off, lock doors, warzone/sandstorm/snow atmosphere, N/V, flashlights).
	Replaces the old MCC menu Brushes/Delete tab.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _pos = getPosATL _module;
private _radii = [10,25,50,100,200,300,500,1000,2000];

//Same order as the types of MCC_fnc_deleteBrush (index = type)
private _actions = [
	"Delete All",
	"Delete All Units",
	"Delete Man",
	"Delete Vehicles",
	"Delete Tanks",
	"Delete Air",
	"Delete Ammoboxes",
	"Delete Markers",
	"Lights (Off)",
	"Lights (On)",
	"Lock Doors (All)",
	"Unlock Doors (All)",
	"Lock Doors (Random)",
	"Atmosphere - Warzone",
	"Atmosphere - Sandstorm",
	"Atmosphere - Blizzard",
	"Atmosphere - Snow",
	"Atmosphere - Heatwave",
	"Atmosphere - Clear",
	"Remove N/V from units",
	"Add Flashlights to all units",
	"Delete Bodies"
];

private _result = ["Delete / Area Brush", [
	["Action", _actions],
	["Radius (m)", _radii apply {str _x}],
	["Skip players (N/V, Flashlights)", true]
], "Players and their vehicles are never deleted."] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _type = _result select 0;
private _radius = _radii select (_result select 1);
private _ignorePlayers = _result select 2;

//Remove the module first so "Delete All" does not have to handle it
deleteVehicle _module;

[[_pos select 0, _pos select 1, 0], _radius, _type, _ignorePlayers] remoteExec ["MCC_fnc_deleteBrush", 2];
[objNull, format ["%1: %2 m", _actions select _type, _radius]] call BIS_fnc_showCuratorFeedbackMessage;
