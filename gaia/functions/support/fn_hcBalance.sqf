/* ----------------------------------------------------------------------------
Function: GAIA_fnc_hcBalance

Description:
	Headless client load balancing for GAIA (server, called once per second by
	GAIA_fnc_perFrame, unscheduled).
	- Every 10 s: refreshes the list of connected headless clients
	  (GAIA_HC_OWNERS, owner ids, from allUsers + getUserInfo isHC). When the
	  legacy single HC target MCC_ownerHC is gone (HC disconnected), it is
	  pointed at another connected HC and broadcast, so old spawn code keeps
	  working.
	- Moves newly spawned GAIA groups to the headless clients, round robin:
	  GAIA_fnc_registerGroup queues every group it registers for the first time
	  after mission time 30 (GAIA_HC_QUEUE, [group, ready time]). After 5 s
	  (spawn scripts finish setting the group up) the group gets setGroupOwner
	  to the next HC.
	  Skipped: setting MCC_GAIA_HC_BALANCE off, no HC, groups with players,
	  groups not local to the server (already on an HC), garrisoning / FORTIFY
	  groups, groups flagged GAIA_noHC, MCC_noHC or acex_headless_blacklist.

Parameters:
	none

Returns:
	NUMBER - number of groups transferred in this call
---------------------------------------------------------------------------- */
if (!isServer) exitWith {0};

if (isNil "GAIA_HC_OWNERS") then {GAIA_HC_OWNERS = []};
if (isNil "GAIA_HC_QUEUE") then {GAIA_HC_QUEUE = []};
if (isNil "GAIA_HC_RR") then {GAIA_HC_RR = 0};
if (isNil "GAIA_HC_NEXT_REFRESH") then {GAIA_HC_NEXT_REFRESH = 0};

//------------------------------- HC list -------------------------------
if (time >= GAIA_HC_NEXT_REFRESH) then {
	GAIA_HC_NEXT_REFRESH = time + 10;
	private _hcs = [];
	{
		private _info = getUserInfo _x;
		if (count _info > 10 && {_info select 7} && {(_info select 1) > 2}) then {
			_hcs pushBack [_info select 1, _info select 10];
		};
	} forEach allUsers;

	private _owners = _hcs apply {_x select 0};
	if (_owners isNotEqualTo GAIA_HC_OWNERS && {missionNamespace getVariable ["MCC_GAIA_debug", false]}) then {
		diag_log format ["GAIA HC: headless clients %1 (was %2)", _owners, GAIA_HC_OWNERS];
	};
	GAIA_HC_OWNERS = _owners;

	//Legacy single HC target (mcc_setup_hc spawns): keep it on a connected HC
	if (_hcs isNotEqualTo []) then {
		private _current = missionNamespace getVariable ["MCC_ownerHC", objNull];
		if (!(_current isEqualType objNull) || {isNull _current} || {(_hcs findIf {(_x select 1) isEqualTo _current}) < 0}) then {
			private _idx = _hcs findIf {!isNull (_x select 1)};
			if (_idx > -1) then {
				MCC_ownerHC = (_hcs select _idx) select 1;
				publicVariable "MCC_ownerHC";
			};
		};
	};
};

//------------------------------- Queue -------------------------------
if (GAIA_HC_QUEUE isEqualTo []) exitWith {0};
if (!(missionNamespace getVariable ["MCC_GAIA_HC_BALANCE", true]) || {GAIA_HC_OWNERS isEqualTo []}) exitWith {
	GAIA_HC_QUEUE = [];
	0
};

private _moved = 0;
private _keep = [];
{
	_x params ["_group", "_ready"];
	if (!isNull _group) then {
		if (time < _ready) then {
			_keep pushBack _x;
		} else {
			private _leader = leader _group;
			if (
				(units _group) isNotEqualTo []
				&& {local _group}
				&& {((units _group) findIf {isPlayer _x}) < 0}
				&& {!(_group getVariable ["Garrisoning", false])}
				&& {((_group getVariable ["GAIA_ZONE_INTEND", []]) param [1, ""]) != "FORTIFY"}
				&& {!(_group getVariable ["GAIA_noHC", false])}
				&& {!(_group getVariable ["MCC_noHC", false])}
				&& {!(_group getVariable ["acex_headless_blacklist", false])}
				&& {!(_leader getVariable ["acex_headless_blacklist", false])}
			) then {
				private _owner = GAIA_HC_OWNERS select (GAIA_HC_RR mod (count GAIA_HC_OWNERS));
				GAIA_HC_RR = GAIA_HC_RR + 1;
				if (_group setGroupOwner _owner) then {
					_group setVariable ["GAIA_HC_OWNER", _owner];
					_moved = _moved + 1;
					if (missionNamespace getVariable ["MCC_GAIA_debug", false]) then {
						diag_log format ["GAIA HC: %1 (%2 units) moved to headless client %3", _group, count (units _group), _owner];
					};
				};
			};
		};
	};
} forEach GAIA_HC_QUEUE;
GAIA_HC_QUEUE = _keep;

_moved
