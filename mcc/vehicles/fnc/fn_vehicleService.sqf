/*===================== MCC_fnc_vehicleService ============================
Rearm repair and refuel given vehicel

With Limited Logistics on (MCC_logisticsMode 1 = fuel, 2 = fuel+ammo+repair) every service costs
the player's side resources (MCC_fnc_supplyVehicleCost, scaled by what is missing) and is refused
when the side does not have enough. Mode 0 (Off): free, as before.

<IN>
	0:	OBJECT vehicle
	1:	BOOLEAN repair
	2:	BOOLEAN rearm
	3:	BOOLEAN refuel

<OUT>
	Nothing
*/
params [
		["_vehicle",objNull,[objNull]],
		["_repair",true,[true]],
		["_rearm",true,[true]],
		["_refuel",true,[true]]
	];

	private _success = true;
	private _mode = missionNamespace getVariable ["MCC_logisticsMode",0];
	private _side = playerSide;
	private _price = [_vehicle] call MCC_fnc_supplyVehicleCost;

	//Returns the price to pay (0 = free) or -1 when the side can't afford it
	private _fnc_cost = {
		params ["_index","_missing","_name"];
		private _limited = (_mode > 1) || {_mode == 1 && _index == 2};
		if (!_limited) exitWith {0};
		private _cost = ceil ((_missing max 0) * (_price select _index));
		if (_cost <= 0) exitWith {0};
		if !([_side,[_name,_cost]] call MCC_fnc_checkRes) exitWith {
			[9989,format ["Not enough %1 resources (%2 needed)",_name,_cost],5,true] call MCC_fnc_setIDCText;
			systemChat format ["Not enough %1 resources (%2 needed)",_name,_cost];
			-1
		};
		_cost
	};

	//Tell the supply tracker this vehicle is serviced by script, so nearby supply points don't charge it too
	if (_mode > 0) then {_vehicle setVariable ["MCC_supplyServiced",serverTime,true]};

	//Repair
	if (_repair) then {
		private _cost = [1, 1 - (([_vehicle] call MCC_fnc_supplySnapshot) select 1), "repair"] call _fnc_cost;
		if (_cost < 0) exitWith {};

		_success = ["Reparing...",(damage _vehicle) * 60,objNull,false] call MCC_fnc_interactProgress;

		if (_success && alive _vehicle && speed _vehicle < 5) then {
			[_vehicle, 0] remoteExec ["setDamage", _vehicle];
			playSound "gunReload";
			if (_cost > 0) then {[_side, 1, -_cost] call MCC_fnc_resChange};
		};
	};

	if (!_success) exitWith {};

	//Rearm
	if (_rearm) then {
		private _cost = [0, 1 - (([_vehicle] call MCC_fnc_supplySnapshot) select 0), "ammo"] call _fnc_cost;
		if (_cost < 0) exitWith {};

		_success = ["Rearming...",10,objNull,false] call MCC_fnc_interactProgress;

		if (_success && alive _vehicle && speed _vehicle < 5) then {
			[_vehicle, 1] remoteExec ["setVehicleAmmo", _vehicle];
			playSound "gunReload";
			if (_cost > 0) then {[_side, 0, -_cost] call MCC_fnc_resChange};
		};
	};

	if (!_success) exitWith {};

	//Refuel
	if (_refuel) then {
		private _cost = [2, 1 - (fuel _vehicle), "fuel"] call _fnc_cost;
		if (_cost < 0) exitWith {};

		_success = ["Refuelling...",(1 - fuel _vehicle) * 30,objNull,false] call MCC_fnc_interactProgress;

		if (_success && alive _vehicle && speed _vehicle < 5) then {
			[_vehicle, 1] remoteExec ["setFuel", _vehicle];
			playSound "gunReload";
			if (_cost > 0) then {[_side, 2, -_cost] call MCC_fnc_resChange};
		};
	};

	if (_mode > 0) then {_vehicle setVariable ["MCC_supplyServiced",serverTime,true]};
