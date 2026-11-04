/*=================================================================MCC_fnc_curatorAutoAssign========================================================================
	SERVER postInit: gives Zeus to every player allowed to use MCC while the CBA setting MCC_zeusForMCCUsers is on.
	Allowed = MCC_fnc_isAuthorizedOwner (same rule as the old MCC menu: MCC_allowedPlayers UIDs or "all", logged in
	admins / host when MCC_allowAdmin, or the MCC Access Rights module). Players that are not allowed get nothing, and
	lose the curator MCC gave them when they stop being allowed or the setting is turned off.
	- The first player gets MCC_curator (so MCC save/load keeps working), every other player gets an own ModuleCurator_F
	  with all addons (all MCC modules). A player keeps his curator (by UID) across respawn and reconnect.
	- Players that already have a curator (e.g. an Eden Game Master module) are left alone.
	- Every 20 s the objects editable by MCC curators are shared between all of them.
	- A player is only handled after his client is ready (MCC_fnc_curatorClientInit sets MCC_curatorClientReady).
	Params: none
	Returns: nothing
//==================================================================================================================================================================*/
if (!isServer) exitWith {};

[] spawn {
	waitUntil {sleep 1; time > 0};

	//MCC_curator is created by init.sqf - wait a bit for it, work without it too
	private _timeout = time + 60;
	waitUntil {sleep 1; !isNil "MCC_curator" || {time > _timeout}};

	private _map = createHashMap;		//player UID -> curator logic
	private _logicGroup = grpNull;
	private _nextSync = 0;

	private _fnc_newCurator = {
		if (isNull _logicGroup) then {_logicGroup = createGroup [sideLogic, false]};
		private _cur = _logicGroup createUnit ["ModuleCurator_F", [0, 90, 90], [], 0.5, "NONE"];
		_cur setVariable ["Addons", 3, true];
		_cur setVariable ["birdType", "", true];
		_cur setVariable ["showNotification", false, true];
		_cur setVariable ["mccIgnore", true];
		_cur setVariable ["MCC_autoCurator", true, true];
		_cur addCuratorAddons activatedAddons;
		{[_cur, _x, ["%ALL"]] call BIS_fnc_setCuratorAttributes} forEach ["player", "object", "group", "waypoint", "marker"];
		_cur
	};

	while {true} do {
		private _enabled = missionNamespace getVariable ["MCC_zeusForMCCUsers", true];
		private _players = allPlayers - (entities "HeadlessClient_F");

		{
			private _unit = _x;
			private _uid = getPlayerUID _unit;
			private _assigned = getAssignedCuratorLogic _unit;
			private _given = _map getOrDefault [_uid, objNull];

			if (_uid != "" && {_unit getVariable ["MCC_curatorClientReady", false]}) then {
				private _allowed = _enabled && {[owner _unit] call MCC_fnc_isAuthorizedOwner};

				if (_allowed) then {
					if (isNull _assigned) then {
						//Reuse this player's curator unless another player holds it now
						private _cur = _given;
						if (!isNull _cur) then {
							private _holder = getAssignedCuratorUnit _cur;
							if (!isNull _holder && {alive _holder} && {isPlayer _holder} && {getPlayerUID _holder != _uid}) then {_cur = objNull};
						};

						//MCC_curator first, if nobody has it and it isn't kept for another player
						if (isNull _cur && {!isNil "MCC_curator"} && {!isNull MCC_curator} && {isNull getAssignedCuratorUnit MCC_curator} && {!(MCC_curator in (values _map))}) then {
							_cur = MCC_curator;
						};

						if (isNull _cur) then {_cur = call _fnc_newCurator};

						//Share what the other MCC curators can already edit
						private _objects = [];
						{_objects append (curatorEditableObjects _x)} forEach ((values _map) select {!isNull _x && {_x != _cur}});
						if (!isNil "MCC_curator" && {!isNull MCC_curator} && {_cur != MCC_curator}) then {_objects append (curatorEditableObjects MCC_curator)};
						_objects = (_objects arrayIntersect _objects) select {!isNull _x && {!(_x isKindOf "Logic")}};
						if (_objects isNotEqualTo []) then {_cur addCuratorEditableObjects [_objects, false]};

						unassignCurator _cur;
						_unit assignCurator _cur;
						_map set [_uid, _cur];
						diag_log format ["MCC Zeus: assigned %1 to %2 (%3)", _cur, name _unit, _uid];
					};
				} else {
					//Take back only the curator MCC gave
					if (!isNull _assigned && {_assigned isEqualTo _given}) then {
						unassignCurator _assigned;
						diag_log format ["MCC Zeus: removed %1 from %2 (%3)", _assigned, name _unit, _uid];
					};
				};
			};
		} forEach _players;

		//Share editable objects between the MCC curators
		if (time >= _nextSync) then {
			_nextSync = time + 20;
			private _curators = (values _map) select {!isNull _x};
			if (!isNil "MCC_curator" && {!isNull MCC_curator}) then {_curators pushBackUnique MCC_curator};

			if (count _curators > 1) then {
				private _objects = [];
				{_objects append (curatorEditableObjects _x)} forEach _curators;
				_objects = (_objects arrayIntersect _objects) select {!isNull _x && {!(_x isKindOf "Logic")} && {!(_x getVariable ["mccIgnore", false])}};
				if (_objects isNotEqualTo []) then {
					{_x addCuratorEditableObjects [_objects, false]} forEach _curators;
				};
			};
		};

		sleep 10;
	};
};
