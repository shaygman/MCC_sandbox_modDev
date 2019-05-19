/*====================================================== MCC_fnc_vehicleTireChange ===================================================================
Remove or install vehicle tire or truck

PARAMS
<IN>
	0: STING - model's hitpoint name
	1: BOOLEAN - true if tire false if track

=======================================================================================================================================================
*/

params [
	["_hp","",[""]],
	["_isTire",true,[true]]
];

private ["_availableWheels","_vehicle","_success","_dummy","_sparePart","_str","_sparePartName","_workTime"];

_vehicle = player getVariable ["interactWith",objNull];
_sparePart = if (_isTire) then {"Tire_Van_02_Cargo_F"} else {"Land_TankTracks_01_long_F"};
_sparePartName = if (_isTire) then {"Tire"} else {"Track"};
_workTime = 3;

if (isNull _vehicle || _hp == "") exitWith {diag_log "MCC_fnc_vehicleTireChange: Error can't replace null vehicle or null tire"};

//Are we installing or removing part?
if ((_vehicle getHitPointDamage _hp) >= 1) then {
	_availableWheels = (position player) nearObjects [_sparePart, 10];

	//Do we have spare part nearby
	if (count _availableWheels > 0) then {

		//Delete the closest part
		_availableWheels = _availableWheels apply { [_x distance player, _x] };
		_availableWheels sort true;
		deleteVehicle ( (_availableWheels select 0) select 1);

		_success = [format ["Installing %1",_sparePartName],_workTime,_vehicle,"Acts_carFixingWheel"] call MCC_fnc_interactProgress;
		if (_success) then {
			_vehicle setHitPointDamage [_hp,0];
		} else {
			//We didn't finish the proccess give the players the spare part back
			_dummy = createVehicle [_sparePart, position player, [], 1, "NONE"];
			_dummy setPos (player modelToworld [-2,0,1]);
		};
	} else {
		_str = "<t size='1' t font = 'puristaLight' color='#FFFFFF'>" + format ["No Spare %1 Nearby",_sparePartName] + "</t>";
		_0 = [_str,0,0.2,5,1,0.0] spawn bis_fnc_dynamictext;
	};

} else {
	_success = [format ["Removing %1",_sparePartName],_workTime,_vehicle,"Acts_carFixingWheel"] call MCC_fnc_interactProgress;
	if (_success) then {
		_vehicle setHitPointDamage [_hp,1];
		_dummy = createVehicle [_sparePart, position player, [], 1, "NONE"];
		_dummy setPos (player modelToworld [-2,0,1]);
	};
};