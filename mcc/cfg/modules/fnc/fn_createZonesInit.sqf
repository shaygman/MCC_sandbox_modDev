//==================================================================MCC_fnc_createZonesInit============================================================================
// Sync with triggers to create MCC zones
//==============================================================================================================================================================
params [
	["_module",objNull,[objNull]]
];

// Exit if player or HC
if (!isServer) exitWith {};

if (isNull _module) exitWith {};

//3den
if (isNull curatorCamera) exitWith {
	_module spawn {
		params ["_module"];

		private ["_behavior","_zoneNumber","_triggers","_assignAImodule"];
		waitUntil {time > 0};

		//Who synced with the module
		_triggers = [];
		_assignAImodule = [];


		{
			switch (true) do
			{
				case (_x isKindOf "EmptyDetector"):	{_triggers pushBack _x};
				case (_x isKindOf "MCC_Module_AI_assignToZone"):{_assignAImodule pushBack _x};
			};
		} forEach (synchronizedobjects _module);


		if (count _triggers > 0) then {
			//Create the zone
			_zoneNumber = (count (missionNamespace getVariable ["MCC_zones_numbers",[]]))+1;
			[_zoneNumber ,position (_triggers select 0), triggerArea (_triggers select 0)] call MCC_fnc_MWUpdateZone;

			//Find out all AI that need to be assigned to this zone
			{
				_module = _x;
				_behavior = _module getVariable	["behavior",0];

				{
					if (_x isEqualType grpNull) then {
						_x setVariable ["GAIA_ZONE_INTEND",[str _zoneNumber ,((MCC_spawn_behaviors select _behavior) select 1)], true];
					};

					if (_x isEqualType objNull) then {
						if (side group _x in [west,resistance,east,civilian]) then {
							(group _x) setVariable ["GAIA_ZONE_INTEND",[str _zoneNumber ,((MCC_spawn_behaviors select _behavior) select 1)], true];
						};
					};
				} forEach (synchronizedobjects _module);
			} forEach _assignAImodule;
		};
	};
};


//Not curator exit
if (!(local _module) || isnull curatorcamera) exitWith {};

private ["_zones"];
_pos = getpos _module;
_zones = ["New"];
{
 	_zones pushBack str _x;
 } forEach (missionNamespace getVariable ["MCC_zones_numbers",[]]); ;

_resualt = ["Create Zone",[
			["Zone",_zones],
			["size X",2000],
			["size Y",2000],
			["Angle",360]
		  ]] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {deleteVehicle _module};

//New Zone
_zoneNumber = if ((_resualt select 0) == 0) then {
					(count (missionNamespace getVariable ["MCC_zones_numbers",[]]))+1;
				} else {
					((_resualt select 0))
				};

[_zoneNumber , _pos, [_resualt select 1, _resualt select 2, _resualt select 3]] call MCC_fnc_MWUpdateZone;

[objNull, localize "STR_DISP_CURATOR_ERROR_CREATEZONE_ZONECREATED"] call bis_fnc_showCuratorFeedbackMessage;
deleteVehicle _module