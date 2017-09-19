private ["_pos", "_objects"];
_pos = _this select 0;

_objects = _pos nearEntities ["CAManBase", 15];
{
	private ["_eyePos", "_pos2"];
	_eyePos = eyePos _x;
	_pos2 = [_pos select 0,_pos select 1,(_pos select 2)+0.2];
	if (!lineIntersects [_eyePos, ATLtoASL _pos2,_x]) then {
		if (isPlayer _x) then {
			if(_x == player) then
			{
				private ["_direye", "_posFlash", "_angle", "_norm", "_unitPos", "_angle", "_script"];
				_direye = eyeDirection _x;
				_unitPos = getPosATL _x;
				_posFlash = [(_pos2 select 0)-(_unitPos select 0),(_pos2 select 1)-(_unitPos select 1),(_pos2 select 2)-(_unitPos select 2)];
				
				_norm = Sqrt((_posFlash select 0)^2+(_posFlash select 1)^2+(_posFlash select 2)^2);
					
				_angle = aCos ((_direye select 0)*((_posFlash select 0)/_norm)+((_posFlash select 1)/_norm)*(_direye select 1)+
					((_posFlash select 2)/_norm)*(_direye select 2));

				if (_angle < 90) then {
					_script = _x spawn SUPER_fnc_EffectOnPlayerFull;
				} else {
					_script = _x spawn SUPER_fnc_EffectOnPlayerLight;
				};
			};
		} else {
			if (alive _x) then {
				_script = [_x,5] spawn MCC_fnc_stunBehav;
			};
		};
	};
} count _objects;
_script = [_pos] spawn SUPER_fnc_HandleWindows;