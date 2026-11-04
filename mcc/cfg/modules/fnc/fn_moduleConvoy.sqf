/*=================================================== MCC_fnc_moduleConvoy ===================================================
	Eden module "MCC Convoy" (MCC_Module_convoy). Turns the synced crewed vehicles into one convoy that drives to a destination.
	Runs on the server only (isGlobal = 0). With a synced trigger the convoy starts when the trigger activates
	(isTriggerActivated = 1), otherwise at mission start (after Start Delay).

	Destination (first found):
		1. the marker named in "Destination Marker"
		2. a synced object that is not a crewed vehicle (e.g. a Game Logic or an invisible helipad)
		3. the waypoints already given to the lead vehicle's group in Eden (kept as they are)
	The vehicle closest to the destination leads. All crews join the lead group (column formation, safe, follow roads).

	HVT: when "HVT Class" is set, that unit rides as a captive (handcuffed with ACE, disarmed otherwise) in the middle vehicle.

	Params (module framework):
		0: OBJECT - the module logic
		1: ARRAY  - synced units (unused)
		2: BOOL   - activated
	Returns: nothing

	Module variables (public): "MCC_convoyState" - "waiting", "moving", "arrived", "destroyed"; "MCC_convoyVehicles" - ARRAY;
	"MCC_convoyHVT" - OBJECT (objNull when none).
*/
params [
	["_logic", objNull, [objNull]],
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if (!isServer || {isNull _logic} || {!_activated}) exitWith {};
if (_logic getVariable ["MCC_convoyStarted", false]) exitWith {};
_logic setVariable ["MCC_convoyStarted", true];

[_logic] spawn {
	params ["_logic"];

	_logic setVariable ["MCC_convoyState", "waiting", true];
	waitUntil {sleep 0.5; time > 0};
	private _initTimeout = diag_tickTime + 60;
	waitUntil {sleep 1; (missionNamespace getVariable ["MCC_initDone", false]) || {diag_tickTime > _initTimeout}};

	private _delay = _logic getVariable ["startDelay", 0];
	if !(_delay isEqualType 0) then {_delay = 0};
	if (_delay > 0) then {sleep _delay};

	private _synced = synchronizedObjects _logic;
	private _vehicles = _synced select {
		!(_x isKindOf "EmptyDetector") && {!(_x isKindOf "Man")} && {_x isKindOf "LandVehicle" || {_x isKindOf "Ship"}} && {alive _x}
	};

	//Synced units: use their vehicles
	{
		if (_x isKindOf "Man" && {vehicle _x != _x} && {alive vehicle _x}) then {_vehicles pushBackUnique (vehicle _x)};
	} forEach _synced;

	_vehicles = _vehicles select {alive driver _x};
	if (count _vehicles == 0) exitWith {
		diag_log "MCC Convoy module: no synced vehicles with a driver";
		_logic setVariable ["MCC_convoyState", "destroyed", true];
	};

	//------------------------------------------------ Destination ------------------------------------------------
	private _destination = [];
	private _marker = _logic getVariable ["destinationMarker", ""];
	if (_marker isEqualType "" && {_marker != ""} && {(getMarkerPos _marker) select 0 != 0}) then {
		_destination = getMarkerPos _marker;
	};
	if (count _destination == 0) then {
		private _idx = _synced findIf {
			!(_x isKindOf "EmptyDetector") && {!(_x in _vehicles)} && {!(_x isKindOf "Man")} && {count crew _x == 0}
		};
		if (_idx >= 0) then {_destination = getPosATL (_synced select _idx)};
	};

	//Lead = closest to the destination (or the first one)
	if (count _destination > 0) then {
		_vehicles = [_vehicles, [], {_x distance2D _destination}, "ASCEND"] call BIS_fnc_sortBy;
	};
	private _lead = _vehicles select 0;
	private _group = group driver _lead;

	if (count _destination == 0 && {count (waypoints _group) <= 1}) exitWith {
		diag_log "MCC Convoy module: no destination (marker, synced object or waypoints of the lead group)";
		_logic setVariable ["MCC_convoyState", "destroyed", true];
	};

	//------------------------------------------------ Build the convoy ------------------------------------------------
	{
		private _vehGroup = group driver _x;
		if !(_vehGroup isEqualTo _group) then {
			(units _vehGroup select {vehicle _x in _vehicles}) joinSilent _group;
		};
	} forEach _vehicles;

	_group selectLeader (effectiveCommander _lead);
	_group setFormation "COLUMN";
	_group setBehaviour "SAFE";
	_group setCombatMode "YELLOW";
	_group setSpeedMode "LIMITED";

	private _maxSpeed = _logic getVariable ["maxSpeed", 50];
	if !(_maxSpeed isEqualType 0) then {_maxSpeed = 50};
	private _separation = _logic getVariable ["separation", 30];
	if !(_separation isEqualType 0) then {_separation = 30};
	{
		_x setConvoySeparation _separation;
		_x forceFollowRoad true;
	} forEach _vehicles;
	//Only the lead is slowed down (m/s), the others catch up
	if (_maxSpeed > 0) then {_lead forceSpeed (_maxSpeed / 3.6)};

	//------------------------------------------------ HVT ------------------------------------------------
	private _hvt = objNull;
	private _hvtClass = _logic getVariable ["hvtClass", ""];
	if (_hvtClass isEqualType "" && {_hvtClass != ""} && {isClass (configFile >> "CfgVehicles" >> _hvtClass)}) then {
		private _hvtCar = objNull;
		private _ordered = [_vehicles select floor ((count _vehicles) / 2)] + _vehicles;
		private _carIdx = _ordered findIf {(_x emptyPositions "cargo") > 0};
		if (_carIdx >= 0) then {_hvtCar = _ordered select _carIdx};

		if (isNull _hvtCar) then {
			diag_log "MCC Convoy module: no free cargo seat for the HVT";
		} else {
			_hvt = _group createUnit [_hvtClass, getPosATL _hvtCar, [], 5, "NONE"];
			_hvt setCaptive true;
			removeAllWeapons _hvt;
			_hvt assignAsCargo _hvtCar;
			_hvt moveInCargo _hvtCar;
			if (missionNamespace getVariable ["MCC_isACE", false]) then {
				[_hvt, true] call ACE_captives_fnc_setHandcuffed;
			} else {
				_hvt setVariable ["MCC_disarmed", true, true];
			};
			_hvt setVariable ["MCC_convoyHVT", true, true];
		};
	};
	_logic setVariable ["MCC_convoyHVT", _hvt, true];

	//------------------------------------------------ Escort infantry ------------------------------------------------
	if ((_logic getVariable ["fillCargo", false]) isEqualTo true) then {
		if (isNil "mcc_make_array_grps") then {
			diag_log "MCC Convoy module: MCC not ready, escort infantry skipped";
		} else {
			{[_x] call MCC_fnc_populateVehicle} forEach _vehicles;
		};
	};

	//------------------------------------------------ Zeus ------------------------------------------------
	private _all = +_vehicles;
	{_all append (crew _x)} forEach _vehicles;
	{_x addCuratorEditableObjects [_all, false]} forEach allCurators;

	_logic setVariable ["MCC_convoyVehicles", _vehicles, true];

	//------------------------------------------------ Waypoints ------------------------------------------------
	private _endPos = _destination;
	if (count _destination > 0) then {
		for "_i" from (count waypoints _group - 1) to 0 step -1 do {deleteWaypoint [_group, _i]};
		private _wp = _group addWaypoint [_destination, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 30;
		_wp setWaypointFormation "COLUMN";
		_wp setWaypointBehaviour "SAFE";
		_wp setWaypointSpeed "LIMITED";
		_group setCurrentWaypoint _wp;
	} else {
		_endPos = waypointPosition [_group, (count waypoints _group) - 1];
	};

	_logic setVariable ["MCC_convoyState", "moving", true];

	//------------------------------------------------ Drive ------------------------------------------------
	private _arriveDistance = 60 max (_separation * 2);
	waitUntil {
		sleep 3;
		private _alive = _vehicles select {alive _x && {canMove _x} && {alive driver _x}};
		(count _alive == 0) || {((_alive select 0) distance2D _endPos) < _arriveDistance}
	};

	if (({alive _x && {canMove _x}} count _vehicles) == 0) exitWith {
		_logic setVariable ["MCC_convoyState", "destroyed", true];
	};

	_logic setVariable ["MCC_convoyState", "arrived", true];
	{_x forceSpeed -1} forEach _vehicles;

	//------------------------------------------------ On arrival ------------------------------------------------
	switch (_logic getVariable ["onArrival", 0]) do {
		//Dismount the passengers (not the crew)
		case 1: {
			{
				private _veh = _x;
				{
					if !(_x in [driver _veh, gunner _veh, commander _veh] || {_x isEqualTo _hvt}) then {
						unassignVehicle _x;
						moveOut _x;
					};
				} forEach crew _veh;
			} forEach _vehicles;
		};

		//Delete the convoy (leaves the area)
		case 2: {
			{
				private _veh = _x;
				{deleteVehicle _x} forEach crew _veh;
				deleteVehicle _veh;
			} forEach _vehicles;
		};

		//Hold
		default {
			{doStop _x} forEach _vehicles;
		};
	};
};
