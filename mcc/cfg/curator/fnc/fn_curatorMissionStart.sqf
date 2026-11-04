/*=================================================================MCC_fnc_curatorMissionStart======================================================================
	Zeus module "Respawn / Mission Start": teleport every player to his side's start location now
	(MCC_fnc_startLocations), disable respawn (start the mission), or toggle MCC role selection (admin / host only).
	Replaces the old MCC menu "Disable respawn" button and Start Location tab actions.
	Params:
		0: OBJECT - the placed module
	Returns: nothing
//==================================================================================================================================================================*/
params [["_module", objNull, [objNull]]];
if (isNull _module) exitWith {};

//Not curator exit
if (!(local _module) || {isNull curatorCamera}) exitWith {};

private _cpOn = missionNamespace getVariable ["CP_activated", false];

private _result = ["Respawn / Mission Start", [
	["Action", [
		"Teleport players to their start location now",
		"Start mission: disable respawn",
		[ "Enable role selection", "Disable role selection"] select _cpOn
	]]
], "Role selection can only be changed by a logged in admin or the host."] call MCC_fnc_initDynamicDialog;

deleteVehicle _module;
if (_result isEqualTo []) exitWith {};

switch (_result select 0) do {
	case 0: {
		[] remoteExec ["MCC_fnc_startLocations", 0];
		[objNull, "Players sent to their start locations"] call BIS_fnc_showCuratorFeedbackMessage;
	};

	case 1: {
		MCC_TRAINING = false;
		publicVariable "MCC_TRAINING";
		MCC_enable_respawn = false;
		["Mission started, respawn is off"] remoteExec ["MCC_fnc_globalHint", 0, true];
	};

	case 2: {
		if !(serverCommandAvailable "#lock" || {isServer}) exitWith {
			[objNull, "Must be a logged admin or the server host"] call BIS_fnc_showCuratorFeedbackMessage;
		};

		CP_activated = !(missionNamespace getVariable ["CP_activated", false]);
		publicVariable "CP_activated";
		if (CP_activated) then {[] spawn MCC_fnc_s_player_init};

		//Set tickets on the server (old menu behaviour)
		if (isServer) then {
			{
				private _tickets = missionNamespace getVariable [format ["MCC_tickets%1", _x], 200];
				[_x, _tickets] call BIS_fnc_respawnTickets;
			} forEach [west, east, resistance];
		};

		[objNull, format ["Role selection %1", ["disabled", "enabled"] select CP_activated]] call BIS_fnc_showCuratorFeedbackMessage;
	};
};
