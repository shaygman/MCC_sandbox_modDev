/*===================================================== MCC_fnc_magazineRepack ======================================================================================================================

	Repack all the handguns and primary weapon magazines in the player's inventory

*/

private ["_fullCount","_mgazinesAmmo","_mgazinesClasses","_index","_totalAmmo","_success"];
_mgazinesAmmo = [];
_mgazinesClasses = [];

_success = ["Repacking Magazines",(count magazines player),player] call MCC_fnc_interactProgress;
if !(_success) exitWith {};
{
	_x params ["_magClass","_magCount","_loaded","_magType"];

	if (_magType in [-1,1,2]) then {

		//Sort only magazines in inventory
		if !(_loaded) then {

			if !(_magClass in _mgazinesClasses) then {
				_mgazinesClasses pushBack _magClass;
				_mgazinesAmmo set [(_mgazinesClasses find _magClass),0];
			};

			_index = _mgazinesClasses find _magClass;
			_mgazinesAmmo set [_index,(_mgazinesAmmo select _index) + _magCount];

			player removeMagazine _magClass;
		};
	};
} forEach (magazinesAmmoFull player);


//Pack magazines
{
	_x params ["_magClass"];
	_totalAmmo = _mgazinesAmmo select (_mgazinesClasses find _magClass);
	_fullCount = getNumber (configFile >> "CfgMagazines" >> _magClass >> "count");

	for "_i" from 1 to (_totalAmmo/_fullCount) step 1 do
	{
		player addMagazine _magClass;
	};

	if (_totalAmmo mod _fullCount > 0) then {
		player addMagazine [_magClass, _totalAmmo mod _fullCount];
	};
} forEach _mgazinesClasses;