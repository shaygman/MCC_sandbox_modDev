/*===================================================================MCC_fnc_LHDspawnVehicle======================================================================
	Handle spawn vehicles on LHD requests
 	INTERNAL USE ONLY

 		<IN>
		_array:	STRING - function type

		<OUT>
		Name of the LHD
==================================================================================================================================================================*/
#define MCC_PRICESFACTOR 0.2
#define CUP_WATERVEHICLES_FOLDABLE ["CUP_B_MV22_USMC","CUP_B_CH53E_USMC","CUP_AH1Z_base","CUP_B_UH1Y_Base"]
#define CUP_WATERVEHICLES_FOLDANIMS ["\cup\airvehicles\cup_airvehicles_mv22\scripts\pack.sqf","\cup\airvehicles\cup_airvehicles_CH53E\scripts\ch53_fold.sqf","\cup\airvehicles\cup_airvehicles_AH1Z\scripts\AH1Z_fold.sqf","\cup\airvehicles\cup_airvehicles_UH1Y\Scripts\UH1Y_fold.sqf"]

disableSerialization;
params [
	["_function","updateVehicleType",[""]],
	["_deck", 0, [0]],
	["_selection", "", [""]],
	["_operator", 0, [0]]
];

private ["_ctrl","_display","_ctrlPos","_vehiclesArray","_index","_ship","_side","_hideCtrls"];
_ship = (missionNamespace getVariable ["MCC_interatedLHD",objNull]);

if (isNull _ship) exitWith {diag_log "MCC_fnc_LHDspawnVehicle: Null ship"};

_side = _ship getVariable ["MCC_side",sideLogic];
_display = uiNamespace getVariable ["MCC_LHD_MENU", displayNull];
_ctrl = _display displayCtrl 2300;

_ctrlPos = ctrlPosition _ctrl;

//If close open it
if ((_ctrlPos select 2)<=0) then {

	//Hide ctel depends on the player status
	_hideCtrls = switch (_operator) do
				{
					//Mission maker
					case 0:
					{
						[1100,1101,1102,1103,1000,1001,1002,1003,81,82,83,84,91,92,93,94]
					};

					//Commander
					case 1:
					{
						[1103,1003,84,94]
					};

					//Grunt
					default
					{
						[1100,1101,1102,1000,1001,1002,81,82,83,91,92,93]
					};
				};
	{ctrlShow [_x,false]} forEach _hideCtrls;

    //Disable purchase button
    if (_operator != 0)  then {ctrlEnable [2400,false]};

	_ctrlPos set [0,0.05 * safezoneW + safezoneX];
	_ctrlPos set [1,0.5 * safezoneH + safezoneY];
	_ctrlPos set [2,0.5 * safezoneW];
	_ctrlPos set [3,0.4 * safezoneH];
	_ctrl ctrlSetPosition _ctrlPos;

	//disable purchase by defualt
	_ctrl ctrlCommit 0.1;
	sleep 0.1;


	//Faction
	_ctrl = _display displayCtrl 8008;
	lbClear _ctrl;
	{
		_displayname = format ["%1(%2)",_x select 0,_x select 1];
		_ctrl lbAdd _displayname;
	} foreach U_FACTIONS;
	_ctrl lbSetCurSel (missionNamespace getVariable ["MCC_faction_index",0]);

	//Type
	_ctrl = _display displayCtrl 1501;
	lbClear _ctrl;
	{
		_ctrl lbAdd _x;
	} foreach ["Vehicles", "Tracked/Static", "Helicopter", "Fixed-wing", "Ship"];
	_ctrl lbSetCurSel 0;

	//Change faction or vehicle type
	{
		_ctrl = _display displayCtrl _x;
		_ctrl ctrlAddEventHandler ["LBSelChanged",format ["['updateVehicleType',%1,'%2', %3] spawn MCC_fnc_LHDspawnVehicle;",_deck, _selection, _operator]];
		_ctrl ctrlCommit 0;
	} forEach [8008,1501];

	//Change class
	_ctrl = _display displayCtrl 1502;
	_ctrl ctrlAddEventHandler ["LBSelChanged",format ["['updateVehicleClass',%1,'%2', %3] spawn MCC_fnc_LHDspawnVehicle;",_deck, _selection, _operator]];
	_ctrl ctrlCommit 0;

	//Update
	["updateVehicleType",_deck, _selection, _operator] spawn MCC_fnc_LHDspawnVehicle;
};

switch (_function) do
{
	case "updateVehicleType":
	{
		/*
		//Upadate faction
		_index = lbCurSel (_display displayCtrl 8008);
		if ((missionNamespace getVariable ["MCC_faction_index",-1]) != _index) then	{
			mcc_sidename = (U_FACTIONS select _index) select 1;
			mcc_faction = (U_FACTIONS select _index) select 2;
			MCC_faction_index = _index;
			0 = [false] call mcc_fnc_faction_choice;
		};
		*/

		//class
		_index = lbCurSel (_display displayCtrl 1501);
		_vehicleType = switch (_index) do
							{
								case 0:	{"vehicle"};
								case 1:	{"tank"};
								case 2:	{"heli"};
								case 3:	{"jet"};
								default	{"ship"};
							};

		_vehiclesArray = [_vehicleType, _side, "", true] call MCC_fnc_vehicleSpawnerBuildCostTable;
		missionNamespace setVariable ["MCC_fnc_LHDspawnMenuInitArray", _vehiclesArray];
		_ctrl = _display displayCtrl 1502;
		lbClear _ctrl;

		{
			_displayname = format ["%1",(_x select 1) select 0];
			_index = _ctrl lbAdd _displayname;
			_ctrl lbsetData [_index, (_x select 0)];
			_ctrl lbsetpicture [_index, (_x select 1) select 1];
		} foreach _vehiclesArray;

		if (count _vehiclesArray > 0) then {_ctrl lbSetCurSel 0};
	};

	case "updateVehicleClass":
	{
		private ["_selectedVehicle","_cfgclass","_costAmmo","_costRepair","_costFuel","_costValor","_array","_purchaseEnable","_cost"];
		_vehiclesArray = missionNamespace getVariable ["MCC_fnc_LHDspawnMenuInitArray", []];

		if (count _vehiclesArray <= 0) exitWith {};

		//Set info picture
		_ctrl = _display displayCtrl 111100;
		_ctrl ctrlSetText ((_vehiclesArray select (lbCurSel (_display displayCtrl 1502)) select 1) select 1);

		//Get costs
		_array = call compile format ["MCC_res%1",playerside];
		_selectedVehicle = _vehiclesArray select (lbCurSel (_display displayCtrl 1502));
		_cfgclass = _selectedVehicle select 0;
		_cost = _selectedVehicle select 2;
		_costAmmo = floor (_cost * 0.3 * MCC_PRICESFACTOR);
		_costRepair = floor (_cost * 0.5 * MCC_PRICESFACTOR);
		_costFuel = floor (_cost * 0.2 * MCC_PRICESFACTOR);
		_costValor = floor (_cost * 0.3);

		_ctrl = 1000;
	    _purchaseEnable = true;

	    switch (_operator) do
		{
			//Mission maker
			case 0:
			{
			};

			//Commander
			case 1:
			{
				//Load available resources
			    {_display displayCtrl _x ctrlSetText ([(_array select _forEachIndex)] call MCC_fnc_formatNumber)} foreach [81,82,83];

		    	//Do we have enough side resources
		        {
		            ctrlSetText [_ctrl, [_x] call MCC_fnc_formatNumber];
		            if (_x <= (_array select _foreachindex)) then {
		                (_display displayctrl _ctrl) ctrlSetTextColor [1,1,1,1];
		            } else {
		                (_display displayctrl _ctrl) ctrlSetTextColor [1,0,0,1];
		                 _purchaseEnable = false;
		            };
		            _ctrl = _ctrl +1;
		        } forEach [_costAmmo,_costRepair,_costFuel];
			};

			//Grunt
			default
			{
				//Load available valor
		    	 _display displayCtrl 84 ctrlSetText ([(player getVariable ["MCC_valorPoints",50])] call MCC_fnc_formatNumber);

		        //Do we have enough personal valor
		        _ctrl = _display displayctrl 1003;
		        _ctrl ctrlSetText ([_costValor] call MCC_fnc_formatNumber);

		        if ((player getVariable ["MCC_valorPoints",50]) >= _costValor) then {
		            _ctrl ctrlSetTextColor [1,1,1,1];
		        } else {
		            _ctrl ctrlSetTextColor [1,0,0,1];
		             _purchaseEnable = false;
		        };
			};
		};


	     ctrlEnable [2400,_purchaseEnable];
	};

	case "spawn":
	{
		private ["_vehicleClass","_direction","_cargo","_dummy","_str","_null","_isCUPLHD","_boundingBox","_boundingBoxIndecator","_costAmmo","_costRepair","_costFuel","_costValor","_array","_cost","_vehiclesArray","_selectedVehicle","_cfgclass"];

		if (_selection isEqualTo "" || _selection isEqualTo []) exitWith {};

		//Get costs

		_vehiclesArray = missionNamespace getVariable ["MCC_fnc_LHDspawnMenuInitArray", []];
		if (count _vehiclesArray <= 0) exitWith {};

		_array = call compile format ["MCC_res%1",playerside];
		_selectedVehicle = _vehiclesArray select (lbCurSel (_display displayCtrl 1502));
		_cfgclass = _selectedVehicle select 0;
		_cost = _selectedVehicle select 2;
		_costAmmo = floor (_cost * 0.3 * MCC_PRICESFACTOR);
		_costRepair = floor (_cost * 0.5 * MCC_PRICESFACTOR);
		_costFuel = floor (_cost * 0.2 * MCC_PRICESFACTOR);
		_costValor = floor (_cost * 0.3);

		_vehicleClass = (_display displayCtrl 1502) lbData (lbCurSel 1502);
		_isCUPLHD = _ship isKindOf "CUP_LHD_BASE";


		switch (true) do
		{
			case (_selection in ["fd_cargo_pos_2","fd_cargo_pos_3","fd_cargo_pos_4","fd_cargo_pos_5","fd_cargo_pos_6","fd_cargo_pos_11","fd_cargo_pos_12","fd_cargo_pos_13","fd_cargo_pos_14","fd_cargo_pos_16","fd_cargo_pos_18","[-30,70,24]","[-30,50,24]","[-30,30,24]","[-30,10,24]","[-30,-10,24]"]):
			{
				_direction = (direction _ship)+90;
				_boundingBoxIndecator = 0;
			};

			case (_selection in ["fd_cargo_pos_7","fd_cargo_pos_8","fd_cargo_pos_9","fd_cargo_pos_10","fd_cargo_pos_15","fd_cargo_pos_17","fd_cargo_pos_19","[20,50,24]","[37,70,24]","[-22,-55,24]","[5,-55,24]"]):
			{
				_direction = (direction _ship)+180;
				_boundingBoxIndecator = 1;
			};

			default {
				_direction =direction _ship;
				_boundingBoxIndecator = 0;
			};
		};

		_cargo = nil;

		// If valid class, spawn the vehicle, then move it into position
		if !(isClass (configFile >> "CfgVehicles" >> _vehicleClass)) exitWith {diag_log format["MCC: MCC_fnc_LHDspawnVehicle: ERROR %1 Vehicle Not in config", _vehicleClass]};

		//Check if available
		_dummy = "HeliH" createVehicleLocal [0,0,0];
		waitUntil {alive _dummy};

		if (_isCUPLHD) then {
			_dummy attachTo [_ship,[0,0,0],_selection]
		} else {
			_dummy attachTo [_ship,(call compile _selection)];
		};

		// Create the vehicle
		_cargo = createVehicle [_vehicleClass, [0,0,0], [], 0, "NONE"];
		_cargo setDamage 0;
		_cargo allowDamage false;
		_cargo setDir _direction;
		_boundingBox = (_cargo call BIS_fnc_boundingBoxDimensions) ;
		_maxDistance = _boundingBox select _boundingBoxIndecator;

		if (count (nearestObjects [getPosASL _dummy, ["Land","Air","Ship"], _maxDistance]) > 0 || (_selection isEqualTo "")) then {
			_str = "<t size='0.8' t font = 'puristaLight' color='#FFFFFF'>" + "Not enough space" + "</t>";
			_null = [_str,0,1.1,2,0.1,0.0] spawn bis_fnc_dynamictext;

			deleteVehicle _cargo;
			detach _dummy;
			deleteVehicle _dummy;
			_dummy = nil;
		} else {


			//Lets see if we need to pay for this spawn
			if (_operator > 0) then {
				_array = call compile format ["MCC_res%1",playerside];

				//Reduce resources
				if (_operator == 1) then {

				    _array = [(_array select 0) -_costAmmo,(_array select 1) -_costRepair,(_array select 2) -_costFuel,(_array select 3),(_array select 4)];
				    missionNamespace setVariable [format ["MCC_res%1",playerside],_array];
				    publicVariable format ["MCC_res%1",playerside];
				} else {

				     //Reduce valor
				    player setVariable ["MCC_valorPoints",(player getVariable ["MCC_valorPoints",50])-_costValor,true];
				};

				0 = ["updateVehicleClass",_deck,_selection, _operator] spawn MCC_fnc_LHDspawnVehicle;
			};


			detach _dummy;
			deleteVehicle _dummy;
			_dummy = nil;


			// Check to see if vehicle should be folded/packed
			{
				if (_cargo iskindof _x) then {
					private "_animscript";

					_animscript = CUP_WATERVEHICLES_FOLDANIMS select (CUP_WATERVEHICLES_FOLDABLE find _x);
					_script = [_cargo,1] execVM _animscript;
				};
			} foreach CUP_WATERVEHICLES_FOLDABLE;

			if (_isCUPLHD) then {
				_cargo attachTo [_ship, [0,0,(_boundingBox select 2)/2], _selection];
				_cargo setVariable ["CUP_WaterVehicles_LHD_respawnPosition", _selection, true];

				//Add catapult
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

			} else {
				_selection = call compile _selection;
				_selection set [2,(_selection select 2) + (_boundingBox select 2)/2];
				_cargo attachTo [_ship, _selection];
			};


			while {!(isnull attachedTo _cargo)} do {detach _cargo; sleep .1};
			_cargo setDir _direction;
			[netId _cargo,{{_x addCuratorEditableObjects [[objectFromNetId (_this)],true]} forEach allCurators}] remoteExec ["BIS_fnc_spawn",2];

			waitUntil {isTouchingGround _cargo};
			sleep 5;
			_cargo allowDamage true;

			/*
			if (_isCUPLHD) then {
				_cargo setFuel 0;

				// Get display name
				_displayName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");

				// For each vehicle add an action to detach from the ship - MP compliant
				[
					[_cargo,[format ["%1 %2",localize "STR_CUP_CFG_RELEASEVEHICLE", _displayName], {[_this, "CUP_fnc_detachFromShip", _this select 0, false, true] call BIS_fnc_MP},nil, 1.5, false, true]],
					"addAction", true, true
				] call BIS_fnc_MP;
			};
			*/
		};
	};

	case "close":
	{
		_ctrlPos set [2,0];
		_ctrlPos set [3,0];
		_ctrl ctrlSetPosition _ctrlPos;
		_ctrl ctrlCommit 0.1;
	};
};


//spawn Button
_ctrl = _display displayCtrl 2400;
_ctrl ctrlRemoveAllEventHandlers "MouseButtonUp";
_ctrl ctrlAddEventHandler ["MouseButtonUp",format ["['spawn',%1,'%2', %3] spawn MCC_fnc_LHDspawnVehicle;",_deck, _selection, _operator]];

//Close
_ctrl = _display displayCtrl 2401;
_ctrl ctrlRemoveAllEventHandlers "MouseButtonUp";
_ctrl ctrlAddEventHandler ["MouseButtonUp","['close'] spawn MCC_fnc_LHDspawnVehicle"];