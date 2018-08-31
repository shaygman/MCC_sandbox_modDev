/*========================================================= MCC_fnc_pylonsChange ================================================================
	Change pylons loadouts in available planes

================================================================================================================================================*/

private ["_vehicle","_pylonsDialog","_pylonsAvailable","_mag","_resualt","_magType","_zeus","_exit","_turrets","_success","_weapon","_fnc_rearm"];
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

//Rearm Function
_fnc_rearm = {
	params [
		["_vehicle",objNull,[objNull]],
		["_rearm",true,[true]],
		["_refuel",true,[true]],
		["_repair",true,[true]]
	];

	private _success = true;

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

	if (!_success) exitWith {};

	//Repair
	if (_repair) then {
		_success = ["Reparing...",(damage _vehicle) * 60,objNull,false] call MCC_fnc_interactProgress;

		if (_success && alive _vehicle && speed _vehicle < 5) then {
			[_vehicle, 0] remoteExec ["setDamage", _vehicle];
			playSound "gunReload";
		};
	};
};



_pylonsAvailable = (configFile >> "cfgVehicles" >> typeof _vehicle >> "Components" >> "TransportPylonsComponent" >> "pylons") call BIS_fnc_returnChildren;
_turrets= (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};

_pylonsDialog = [
		["Change Pylons",true],
		["Rearm",true],
		["Refuel",true],
		["Repair",true]
	];

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
if (count _pylonsAvailable == 0) exitWith {[_vehicle,true,true,true] spawn _fnc_rearm};


_resualt = ["Change Loadout",_pylonsDialog] call MCC_fnc_initDynamicDialog;

if (count _resualt == 0) exitWith {};

_resualt params [
	["_changePylons",true,[true]],
	["_rearm",true,[true]],
	["_refuel",true,[true]],
	["_repair",true,[true]]
];

/*
//If not Zeus lets create a progress bar
if !(_zeus) then {
	(count _resualt) spawn {
		missionNamespace setVariable ["MCC_fnc_pylonsChangeStoped",false];
		missionNamespace setVariable ["MCC_fnc_pylonsChangeStoped",["Rearming...",_this*3,objNull,false] call MCC_fnc_interactProgress];
	};
};
*/

//Rearm
_exit = false;

if (_changePylons) then {
	{
		[_vehicle,[_foreachIndex + 1,"",true]] remoteexec ["setPylonLoadOut",0];
		[_vehicle,[_foreachIndex + 1,0]] remoteexec ["SetAmmoOnPylon",0];
	} forEach GetPylonMagazines _vehicle;

	private _pylonsWeapons = [];
	{ _pylonsWeapons append getArray (_x >> "weapons") } forEach ([_vehicle, configNull] call BIS_fnc_getTurrets);
	{ [_vehicle,_x] remoteexec ["removeWeaponGlobal",0] } forEach ((weapons _vehicle) - _pylonsWeapons);

	//Remove all prevoius turrets

	/*
	{
		[_vehicle, [getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon"),[-1]]] remoteExecCall ["removeWeaponTurret", 0];
		[_vehicle, [getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon"),[0,0]]] remoteExecCall ["removeWeaponTurret", 0];
	} forEach (_vehicle getCompatiblePylonMagazines _forEachIndex + 1);
	*/

	{
		if (_exit) exitWith {};

		_magType = if ((_resualt select (_forEachIndex + 4)) == 0) then {""} else {(_vehicle getCompatiblePylonMagazines (_forEachIndex + 1)) select (_resualt select  (_forEachIndex + 4))-1};
		_weapon = configName _x;

		//If manual and still running
		playSound "gunReload";
		_success = if (_zeus) then {true} else {
			[format ["%1", getText (configFile >> "cfgMagazines" >> _magType >> "displayName")],5,objNull,false] call MCC_fnc_interactProgress};

		if (_success &&
		    alive _vehicle &&
		    speed _vehicle < 5) then {

			[_vehicle,[_weapon,"",true,(_turrets select _forEachIndex)]] remoteexec ["setPylonLoadOut",0];
			[_vehicle,  [_weapon, _magType,true,(_turrets select _forEachIndex)]] remoteExecCall ["setPylonLoadOut", 0];

		} else {
			_exit = true;
			missionNamespace setVariable ["MCC_fnc_interactProgress_running",false]
		};

		sleep 0.5;
	} forEach _pylonsAvailable;
};

[_vehicle,_rearm,_refuel,_repair] spawn _fnc_rearm;