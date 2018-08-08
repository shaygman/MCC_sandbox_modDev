/*===================================================================MCC_fnc_LHDspawnVehicle======================================================================
	Handle spawn vehicles on LHD requests
 	INTERNAL USE ONLY

 		<IN>
		_array:	STRING - function type

		<OUT>
		Name of the LHD
==================================================================================================================================================================*/
private ["_factions","_factionIndex","_index","_display","_ctrl","_ctrlPos","_vehiclesArray","_index","_vehicleClass"];
disableSerialization;

#define MCC_FACTION 8008
#define CUP_WATERVEHICLES_FOLDABLE ["CUP_B_MV22_USMC","CUP_B_CH53E_USMC","CUP_AH1Z_base","CUP_B_UH1Y_Base"]
#define CUP_WATERVEHICLES_FOLDANIMS ["\cup\airvehicles\cup_airvehicles_mv22\scripts\pack.sqf","\cup\airvehicles\cup_airvehicles_CH53E\scripts\ch53_fold.sqf","\cup\airvehicles\cup_airvehicles_AH1Z\scripts\AH1Z_fold.sqf","\cup\airvehicles\cup_airvehicles_UH1Y\Scripts\UH1Y_fold.sqf"]

params [
	["_fnc", "", [""]],
	["_deck", 0, [0]],
	["_selection", "", ["",[]]],
	["_lhdType", "", ["",objNull]]
];

_display = uiNamespace getVariable ["MCC_LHD_MENU", displayNull];
_ctrl = _display displayCtrl 2300;

switch (tolower _fnc) do
{
	case "close":
	{
		_ctrlPos = ctrlPosition _ctrl;
		_ctrlPos set [2,0];
		_ctrlPos set [3,0];
		_ctrl ctrlSetPosition _ctrlPos;
		_ctrl ctrlCommit 0.1;
	};

	case "spawn":
	{
		private ["_lhd","_vehicleClass","_direction","_cargo","_dummy","_str","_null","_isCUPLHD"];

		if (_selection isEqualTo "" || _selection isEqualTo []) exitWith {};

		_lhd = (missionNamespace getVariable [_lhdType,objNull]);
		_vehicleClass = (_display displayCtrl 1502) lbData (lbCurSel 1502);
		_isCUPLHD = _lhd isKindOf "CUP_LHD_BASE";


		_direction = switch (true) do
					{
						case (_selection in ["fd_cargo_pos_2","fd_cargo_pos_3","fd_cargo_pos_4","fd_cargo_pos_5","fd_cargo_pos_6","fd_cargo_pos_11","fd_cargo_pos_12","fd_cargo_pos_13","fd_cargo_pos_14","fd_cargo_pos_16","fd_cargo_pos_18","[-30,70,24]","[-30,50,24]","[-30,30,24]","[-30,10,24]","[-30,-10,24]"]):
						{
							(direction _lhd)+90
						};

						case (_selection in ["fd_cargo_pos_7","fd_cargo_pos_8","fd_cargo_pos_9","fd_cargo_pos_10","fd_cargo_pos_15","fd_cargo_pos_17","fd_cargo_pos_19","[20,50,24]","[37,70,24]","[-22,-55,24]","[5,-55,24]"]):
						{
							(direction _lhd)+180
						};

						default{direction _lhd};
					};

		_cargo = nil;

		// If valid class, spawn the vehicle, then move it into position
		if !(isClass (configFile >> "CfgVehicles" >> _vehicleClass)) exitWith {diag_log format["MCC: MCC_fnc_LHDspawnVehicle: ERROR %1 Vehicle Not in config", _vehicleClass]};

		//Check if available
		_dummy = "HeliH" createVehicle [0,0,0];
		waitUntil {alive _dummy};

		if (_isCUPLHD) then {
			_dummy attachTo [_lhd,[0,0,0],_selection]
		} else {
			_dummy attachTo [_lhd,(call compile _selection)];
		};

		if (count (nearestObjects [getPosASL _dummy, ["Land","Air"], 5]) > 0 || (_selection isEqualTo "")) then {
			_str = "<t size='0.8' t font = 'puristaLight' color='#FFFFFF'>" + "Spawn point is occupied" + "</t>";
			_null = [_str,0,1.1,2,0.1,0.0] spawn bis_fnc_dynamictext;

			detach _dummy;
			deleteVehicle _dummy;
			_dummy = nil;
		} else {

			detach _dummy;
			deleteVehicle _dummy;
			_dummy = nil;

			// Create the vehicle
			_cargo = createVehicle [_vehicleClass, [0,0,0], [], 0, "NONE"];

			// Ensure it doesn't get damaged while we move it around
			_cargo setDamage 0;
			_cargo allowDamage false;

			// Check to see if vehicle should be folded/packed
			{
				if (_cargo iskindof _x) then {
					private "_animscript";

					_animscript = CUP_WATERVEHICLES_FOLDANIMS select (CUP_WATERVEHICLES_FOLDABLE find _x);
					_script = [_cargo,1] execVM _animscript;
				};
			} foreach CUP_WATERVEHICLES_FOLDABLE;

			if (_isCUPLHD) then {
				_cargo attachTo [_lhd, [0,0,1], _selection];
				_cargo setVariable ["CUP_WaterVehicles_LHD_respawnPosition", _selection, true];
			} else {
				_selection = call compile _selection;
				_selection set [2,(_selection select 2) + ((_cargo call BIS_fnc_boundingBoxDimensions) select 2)/2];
				_cargo attachTo [_lhd, _selection];

				detach _cargo;
				waitUntil {isNull attachedTo _cargo};
				_cargo setDir _direction;
			};

			_cargo setDir _direction;
			sleep 0.5;
			_cargo allowDamage true;

			if (_isCUPLHD) then {
				_cargo setFuel 0;

				if (_cargo isKindOf "air") then {

					[_cargo,["<t color=""#ff1111"">Steam Catapult</t>",{
						_target = (_this select 0);
						driver (_target) action ["ENGINEON", _target];
						addCamShake [5, 4, 15];
						for [{_i=1},{_i<=50},{_i=_i+5}] do {
							_target setvelocity [_i* sin (getdir _target),_i * cos (getdir _target),.15];
							sleep 0.02;
						};
						},[],1,true,true,"action","(driver _target == _this) && (isEngineOn _target) &&(_target distance2D (missionNamespace getVariable ['MCC_startfly',[0,0,0]])<15)"]] remoteExec ["addAction",0];
				};

				// Get display name
				_displayName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");

				// For each vehicle add an action to detach from the ship - MP compliant
				[
					[_cargo,[format ["%1 %2",localize "STR_CUP_CFG_RELEASEVEHICLE", _displayName], {[_this, "CUP_fnc_detachFromShip", _this select 0, false, true] call BIS_fnc_MP},nil, 1.5, false, true]],
					"addAction", true, true
				] call BIS_fnc_MP;
			};

			[netId _cargo,{{_x addCuratorEditableObjects [[objectFromNetId (_this)],true]} forEach allCurators}] remoteExec ["BIS_fnc_spawn",2];

			//{[[_x,_cargo],{(_this select 0) addCuratorEditableObjects [[_this select 1],true];}] remoteExec ["BIS_fnc_spawn",_x]} forEach allCurators;
		};
	};
};