/*===================================================================MCC_fnc_startLocations===============================================================================
  Teleport the player when start location has been found
  Example: []  call MCC_fnc_startLocations;
  <IN>	Nothing
  <OUT>	Nothing
=================================================================================================================================================================*/
private ["_playerSideNr","_safePos","_null","_side","_startLocationName","_teleportAtStart","_helo","_cpActivated","_respawnDialog","_markerName","_pos","_respawnName","_starLoc","_openDialog"];

if (!local player || missionNameSpace getVariable ["MCC_startLocationsRuning", false]) exitWith {};

waituntil {alive player && !(IsNull (findDisplay 46))};

_playerSideNr =  [playerSide] call BIS_fnc_sideID;
missionNameSpace setVariable ["MCC_startLocationsRuning", true];

while {count ([player] call BIS_fnc_getRespawnPositions) < 1} do {sleep 1};

_startLocations = [player] call BIS_fnc_getRespawnPositions;

missionNameSpace setVariable ["MCC_startLocationsRuning", false];

//Is role selection on
_cpActivated = missionNamespace getVariable ["CP_activated",false];

//Respawn menu on
_respawnDialog = missionNamespace getVariable ["MCC_openRespawnMenu",true];

//Black Screen on mission startup
if (!_cpActivated && _respawnDialog) then {
	_openDialog = {(_x getVariable ["teleport",0]) != 0} count _startLocations > 0;

	if (_openDialog) then {
    waituntil {!dialog};

		cutText ["","BLACK",0.1];
		sleep 3;

		player setVariable ["cpReady",false,true];
		playerDeploy = false;
		sleep 0.1;

		_ok = createDialog "CP_RESPAWNPANEL";
		if !(_ok) exitWith { hint "createDialog failed"; diag_log  "CP: create respawn Dialog failed";};

		waituntil {playerDeploy};
		closedialog 0;
		waituntil {!dialog};
		//Respawning

		player setVariable ["cpReady",true,true];
	};
};

if (_cpActivated) then {
    0 spawn {
        _null=[] execVM MCC_path + "mcc\roleSelection\scripts\player_init.sqf"
    };
};


//--- Update markers---
//Player side
switch (_playerSideNr) do {
    case 0: {
      _startLocationName = "MCC_START_EAST";
      _markerName = "MCC_StartMarkerE";
      _respawnName = "RESPAWN_EAST";
    };

    case 1: {
      _startLocationName = "MCC_START_WEST";
      _markerName = "MCC_StartMarkerW";
      _respawnName = "RESPAWN_WEST";
    };

   case 2: {
      _startLocationName = "MCC_START_GUER";
      _markerName = "MCC_StartMarkerG";
      _respawnName = "RESPAWN_GUERRILA";
    };

    default {
      _startLocationName = "MCC_START_CIV";
      _markerName = "MCC_StartMarkerC";
      _respawnName = "RESPAWN_CIVILIANS";
    };
};

_pos = missionNamespace getVariable [_startLocationName,position player];

if (!isnil _markerName) then {deleteMarkerLocal _markerName};
missionNamespace setVariable [_markerName,createMarkerLocal [_markerName, _pos]];
_markerName setMarkerShapeLocal "ICON";
_markerName setMarkerTypeLocal  "mil_start";
_markerName setMarkerColorLocal "ColorGreen";

//create the respawn locations

if (str getMarkerPos _respawnName != "[0,0,0]") then {deleteMarkerLocal _respawnName};
//missionNamespace setVariable [_respawnName,createMarkerLocal [_respawnName, _pos]];
createMarkerLocal [_respawnName, _pos];
_respawnName setMarkerShapeLocal "ICON";
_respawnName setMarkerTypeLocal  "mil_objective";
_respawnName setMarkerColorLocal "ColorRed";