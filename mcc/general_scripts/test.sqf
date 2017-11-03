/*========================================================= MCC_fnc_pylonsChange ================================================================
	Change pylons loadouts in available planes

================================================================================================================================================*/


private ["_vehicle","_pylonsDialog","_pylonsAvailable","_mag","_resualt","_magType"];

_vehicle = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target",objNull];

if (isNull _vehicle) exitWith {};

_pylonsDialog = [];
_pylonsAvailable = (configFile >> "cfgVehicles" >> typeof _vehicle >> "Components" >> "TransportPylonsComponent" >> "pylons") call BIS_fnc_returnChildren;

{
	_mag = ["None"];

	{
		_mag pushBack ( format ["%1(%2)",getText (configFile >> "cfgMagazines" >> _x >> "displayName"),getText (configFile >> "cfgMagazines" >> _x >> "displayNameShort")]);
	} forEach (_vehicle getCompatiblePylonMagazines (_forEachIndex + 1));

	_text = format  ["Pylon %1:  ", _forEachIndex + 1];

	if (_forEachIndex < (count _pylonsAvailable)/2) then {
		for "_i" from 0 to _forEachIndex step 1 do
		{
			_text = _text + "-----";
		};

		_text = _text + "\";
	} else {
		for "_i" from (_forEachIndex +1) to (count _pylonsAvailable) step 1 do
		{
			_text = _text + "-----";
		};
		_text = _text + "/";
	};

	_pylonsDialog pushBack [_text,_mag];
} forEach _pylonsAvailable;

_resualt = ["Change Loadout",_pylonsDialog] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {};

{

	//Remove all prevoius turrets
	{
		_vehicle removeWeaponTurret [getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon"),[-1]];
		_vehicle removeWeaponTurret [getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon"),[0,0]];
	} forEach (_vehicle getCompatiblePylonMagazines _forEachIndex + 1);


	_magType = if ((_resualt select _forEachIndex) == 0) then {""} else {(_vehicle getCompatiblePylonMagazines (_forEachIndex + 1)) select (_resualt select _forEachIndex)-1};

	[_vehicle,  [configName _x, _magType,true]] remoteExecCall ["setPylonLoadOut", _vehicle];

} forEach _pylonsAvailable;