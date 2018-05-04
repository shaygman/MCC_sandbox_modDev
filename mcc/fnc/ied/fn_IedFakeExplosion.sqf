/*==================================================MCC_fnc_IedFakeExplosion===============================================================================================
// Create a fake explosion, explosion dimiter will be decided by the _trapvolume
// Example: [_pos,_trapvolume] spawn MCC_fnc_IedFakeExplosion;
// _pos = position, center of the explosion.
// _trapvolume = string, "small", "medium", "large"
/===========================================================================================================================================================*/
private ["_pos", "_volume","_vehicle","_class","_effected","_dist","_vel","_relVel"];
_pos = _this select 0;
_volume = _this select 1;

switch (_volume) do {
	case "medium":{
		_class = "SmallSecondary";
		_dist = 30;
		_vel = 15;
	};

	case "large":{
		_class = "SmallSecondary";
		_dist = 40;
		_vel = 20;
	};

	default {
		_class = "SmallSecondary";
		_dist = 20;
		_vel = 10;
	};
};


_bomb = _class createVehicle _pos;
_bomb setpos _pos;

//ShockWave effect
_effected = (allPlayers inAreaArray [_pos, _dist*2, _dist*2, 0, false, _dist]) select {vehicle _x == _x};
_effected = +_effected + (vehicles inAreaArray [_pos, _dist*2, _dist*2, 0, false, _dist]);

{
	_relVel = (_vel * (1 - ((_pos distance2D vehicle _x)/_dist))) max 1;
	[_x,_relVel,(_relVel/10),_pos] remoteExec ["MCC_fnc_addVelocity",_x];
} forEach _effected;