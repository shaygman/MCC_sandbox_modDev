//==================================================================MCC_fnc_addItem=================================================================================
// Sets gear to role
// Example: [_currentWeapon], "MCC_fnc_addItem", true, false] spawn BIS_fnc_MP;
//========================================================================================================================================================================
private ["_currentWeapon","_mag","_index","_array","_unit"];
_currentWeapon = param [0,[0,"",0],[[]]];
_unit = param [1,player];

_mag = _currentWeapon param [1,"",[""]];
_index = _currentWeapon param [2,1,[0,[]]];

if (typeName _index != typeName 0) then {_index = 1};

if (_mag isEqualTo "" || isNil "_index") exitWith {};

for "_i" from 1 to _index step 1 do {
	switch (true) do {
		case ((tolower (getText (configFile >> "CfgWeapons" >> _mag >> "simulation"))) in ["itemmap","itemcompass","itemwatch","itemradio","itemgps"]): {
			_unit linkItem _mag;
		};
		case ((tolower (getText (configFile >> "CfgWeapons" >> _mag >> "simulation"))) in ["binocular"]): {
			_unit addWeapon _mag;
		};
	    case (isClass (configFile >> "CfgMagazines" >> _mag)): {_unit addmagazine _mag};
	    case (isClass (configFile >> "CfgWeapons" >> _mag)): {_unit addItem _mag; if !(_mag in (weapons _unit + items _unit)) then {_unit addWeapon _mag}};
	    case (isClass (configFile >> "CfgGlasses" >> _mag)): {_unit additem _mag};
	};
};

//Add magazines
if (typeName (_currentWeapon select 2) == typeName []) exitWith {
	if (count (_currentWeapon select 2) == 2) then {
		_array = [0];
		_array = _array + (_currentWeapon select 2);
		[_array] call MCC_fnc_addItem
	};
};