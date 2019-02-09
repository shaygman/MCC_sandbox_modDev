/*===================== MCC_fnc_vehicleService ============================
Rearm repair and refuel given vehicel

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

	//Repair
	if (_repair) then {
		_success = ["Reparing...",(damage _vehicle) * 60,objNull,false] call MCC_fnc_interactProgress;

		if (_success && alive _vehicle && speed _vehicle < 5) then {
			[_vehicle, 0] remoteExec ["setDamage", _vehicle];
			playSound "gunReload";
		};
	};

	if (!_success) exitWith {};

	//Rearm
	if (_rearm) then {
		_success = ["Rearming...",10,objNull,false] call MCC_fnc_interactProgress;

		if (_success && alive _vehicle && speed _vehicle < 5) then {
			[_vehicle, 1] remoteExec ["setVehicleAmmo", _vehicle];
			playSound "gunReload";
		};
	};

	if (!_success) exitWith {};

	//Refuel
	if (_refuel) then {
		_success = ["Refuelling...",(1 - fuel _vehicle) * 30,objNull,false] call MCC_fnc_interactProgress;

		if (_success && alive _vehicle && speed _vehicle < 5) then {
			[_vehicle, 1] remoteExec ["setFuel", _vehicle];
			playSound "gunReload";
		};
	};

