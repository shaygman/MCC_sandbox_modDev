/*========================================================= MCC_fnc_pylonsChange ================================================================
	Change pylons loadouts in available planes

================================================================================================================================================*/

private ["_vehicle","_pylonsDialog","_pylonsAvailable","_mag","_resualt","_magType","_zeus","_exit","_turrets"];
_zeus = param [0,true,[true,objNull]];

//If we initilize the loadouts are
if (typeName _zeus isEqualTo typeName objNull) exitWith {

	//3den Module
	if (isnull curatorcamera) then {
		if (isServer) then {
			{
				_x setVariable ["MCC_fnc_pylonsChangeSource",true,true];
			} forEach (synchronizedObjects _zeus);
		};

	//Curator
	} else {
		if (local _zeus) then {

			private _object = missionNamespace getVariable ["MCC_curatorMouseOver",[]];

			//if no object selected or not a vehicle
			if (count _object >2) then {
				_object = _object select 1;
				_object setVariable ["MCC_fnc_pylonsChangeSource",true,true];
				deleteVehicle _zeus;
			} else {
				_zeus setVariable ["MCC_fnc_pylonsChangeSource",true,true];
			};
		};
	};
};

_vehicle = if (_zeus) then {missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target",objNull]} else {param [1,objNull,[objNull]]};
if (isNull _vehicle) exitWith {};

_pylonsDialog = [];
_pylonsAvailable = (configFile >> "cfgVehicles" >> typeof _vehicle >> "Components" >> "TransportPylonsComponent" >> "pylons") call BIS_fnc_returnChildren;
_turrets= (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};

{
	_mag = ["None"];
	//_turrets pushBack (getArray(_x >> "turret"));

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

//No pylons just rearm
if (count _pylonsAvailable == 0) exitWith {
	private _progress = ["Rearming...",10,objNull,false] call MCC_fnc_interactProgress;

	if (_progress) then {
		[_vehicle, 1] remoteExec ["setVehicleAmmo", _vehicle];
		playSound "gunReload";
	};
};

_resualt = ["Change Loadout",_pylonsDialog] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {};


//If not Zeus lets create a progress bar
if !(_zeus) then {
	(count _resualt) spawn {
		missionNamespace setVariable ["MCC_fnc_pylonsChangeStoped",false];
		missionNamespace setVariable ["MCC_fnc_pylonsChangeStoped",["Rearming...",_this*3,objNull,false] call MCC_fnc_interactProgress];
	};
};

//Rearm
_exit = false;

{

	//Remove all prevoius turrets
	/*
	{
		_vehicle removeWeaponTurret [getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon"),[-1]];
		_vehicle removeWeaponTurret [getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon"),[0,0]];
	} forEach (_vehicle getCompatiblePylonMagazines _forEachIndex + 1);
	*/

	[_vehicle,[configName _x,"",true,(_turrets select _forEachIndex)]] remoteexec ["setPylonLoadOut",0];
	sleep 0.1;

	_magType = if ((_resualt select _forEachIndex) == 0) then {""} else {(_vehicle getCompatiblePylonMagazines (_forEachIndex + 1)) select (_resualt select _forEachIndex)-1};

		//If manual and still running
	if (!_zeus) then {
		sleep 2.9;

		if !(((missionNamespace getVariable ["MCC_fnc_pylonsChangeStoped",false])) ||
		    !alive player ||
		    !alive driver _vehicle ||
		    speed _vehicle > 0) then {
				playSound "gunReload";
		} else {
			_exit = true;
		};
	};

	if (_exit) exitWith {
		missionNamespace setVariable ["MCC_fnc_interactProgress_running",false]
	};

	[_vehicle,  [configName _x, _magType,true,(_turrets select _forEachIndex)]] remoteExecCall ["setPylonLoadOut", 0];
	sleep 0.1;
} forEach _pylonsAvailable;