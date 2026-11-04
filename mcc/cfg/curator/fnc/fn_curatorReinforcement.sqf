/*=================================================================MCC_fnc_curatorReinforcement=====================================================================
	Zeus module "Reinforcements": calls AI reinforcements to the module position - helicopter paradrop / drop-off /
	fast-rope (MCC_fnc_paratroops) or a motorized column (MCC_fnc_reinforcement). Replaces the old MCC menu
	"Reinforcement" spawn type.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _pos = getPosATL _module;
private _factions = missionNamespace getVariable ["U_FACTIONS", []];
if (_factions isEqualTo []) exitWith {
	[objNull, "MCC factions are not ready yet"] call BIS_fnc_showCuratorFeedbackMessage;
	deleteVehicle _module;
};

//Index 0-8 = MCC_fnc_paratroops types, 9-11 = MCC_fnc_reinforcement sizes
private _types = [
	"Paradrop: small - Spec-Ops","Paradrop: medium - QRF","Paradrop: large - Airborne",
	"Drop-off: small - Spec-Ops","Drop-off: medium - QRF","Drop-off: large - Airborne",
	"Fast-rope: small - Spec-Ops","Fast-rope: medium - QRF","Fast-rope: large - Airborne",
	"Motorized: small","Motorized: medium","Motorized: large"
];
private _behaviors = [["Patrol around","bisp"],["Defend","bisd"],["Seek & destroy","bis"],["GAIA aggressive (zone)","MOVE"],["GAIA defensive (zone)","NOFOLLOW"],["GAIA fortify (zone)","FORTIFY"]];
private _headings = ["North","North-East","East","South-East","South","South-West","West","North-West"];
private _distances = [1000,2000,3000];

private _result = ["Reinforcements", [
	["Faction", _factions apply {format ["%1 (%2)", _x select 0, _x select 1]}],
	["Type", _types],
	["Coming from", _headings],
	["Start distance (m)", _distances apply {str _x}],
	["Behavior after landing (air)", _behaviors apply {_x select 0}],
	["MCC zone number (GAIA / motorized)", ""]
], "Motorized reinforcements need a road near the start point."] call MCC_fnc_initDynamicDialog;

if (_result isEqualTo []) exitWith {deleteVehicle _module};

private _factionClass = (_factions select (_result select 0)) select 2;
private _side = (getNumber (configFile >> "CfgFactionClasses" >> _factionClass >> "side")) call BIS_fnc_sideType;
private _type = _result select 1;
private _startPos = _pos getPos [_distances select (_result select 3), (_result select 2) * 45];
private _behavior = (_behaviors select (_result select 4)) select 1;
private _zone = _result select 5;
private _endPos = [_pos select 0, _pos select 1, 0];

if (_type < 9) then {
	[_endPos, _side, _type, _zone, _behavior, "AWARE", _factionClass, _startPos] remoteExec ["MCC_fnc_paratroops", 2];
} else {
	[_endPos, _side, _type, _zone, _factionClass, _startPos] remoteExec ["MCC_fnc_reinforcement", 2];
};

[objNull, format ["Reinforcements: %1", _types select _type]] call BIS_fnc_showCuratorFeedbackMessage;
deleteVehicle _module;
