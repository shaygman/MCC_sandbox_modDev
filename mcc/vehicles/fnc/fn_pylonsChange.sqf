/*========================================================= MCC_fnc_pylonsChange ================================================================
	Change pylons loadouts in available planes

================================================================================================================================================*/
#define	IDD_DISPLAY_PYLONCHANGE	1031981
#define	ID_PICTURE_UI	1200
#define	ID_PRESETCOMBO	2100
#define	ID_MIROR 2800
#define	ID_REARM 2801
#define	ID_REFUEL 2802
#define	ID_REPAIR 2803
#define	ID_CANCEL 2400
#define	ID_APPLY 2401


private ["_vehicle","_pylonsDialog","_pylonsAvailable","_zeus","_turrets","_config","_pylonComponent"];
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
missionNamespace setVariable ["MCC_fnc_pylonsChangeVehicle",_vehicle];

_config = configFile >> "CfgVehicles" >> typeOf _vehicle;
_pylonComponent = _config >> "Components" >> "TransportPylonsComponent";
_pylonsAvailable = (_pylonComponent >> "pylons") call BIS_fnc_returnChildren;
_turrets= (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};

MCC_fnc_pylonUpdate ={
	#define	IDD_DISPLAY_PYLONCHANGE	1031981
	#define	ID_PICTURE_UI	1200
	#define	ID_MIROR 2800

	params [
		["_selectedPrest",nil,[[],nil]]
	];

	private ["_vehicle","_ctrl","_display","_picPos","_uiPos","_index","_pylon","_currentMag","_config","_pylonComponent","_pylonsAvailable","_currentPylonMag","_mirror"];

	_vehicle = missionNamespace getVariable ["MCC_fnc_pylonsChangeVehicle",objNull];

	if (isNull _vehicle) exitWith {};

	_display = findDisplay IDD_DISPLAY_PYLONCHANGE;
	_mirror = cbChecked (_display displayCtrl ID_MIROR);
	_picPos = ctrlPosition (_display displayCtrl ID_PICTURE_UI);

	_config = configFile >> "CfgVehicles" >> typeOf _vehicle;
	_pylonComponent = _config >> "Components" >> "TransportPylonsComponent";
	_pylonsAvailable = (_pylonComponent >> "pylons") call BIS_fnc_returnChildren;

	{
		_pylon = _x;

		_currentMag = (GetPylonMagazines _vehicle) select _forEachIndex;

		_ctrl = _display displayCtrl (28000 + _foreachIndex);

		_currentPylonMag = _vehicle getCompatiblePylonMagazines (_forEachIndex + 1);

		if (isNull _ctrl) then {
			_ctrl = _display ctrlCreate ["MCC_RscCombo", (28000 + _foreachIndex)];
		    _uiPos = getArray (_pylon >> "UIposition");

		    _uiPos apply {if (_x isEqualType 0) then {_x} else {call compile _x}};

		    private ["_uiPosX","_uiPosY"];
		    _uiPosX = if ((_uiPos select 0) isEqualType 0) then {(_uiPos select 0)} else {call compile (_uiPos select 0)};
		    _uiPosY = if ((_uiPos select 1) isEqualType 0) then {(_uiPos select 1)} else {call compile (_uiPos select 1)};

		    _ctrl ctrlSetPosition [
		        (_picPos select 0) + _uiPosX,
		        (_picPos select 1) + _uiPosY,
		        0.1 * safezoneW,
		        0.02 * safezoneH
		    ];
		    _ctrl ctrlCommit 0;

		    _index = _ctrl lbadd "None";
		    _ctrl lbSetData [_index,""];

		    _index = 0;
		   	{
		    	_ctrl lbadd ( format ["(%2) %1",getText (configFile >> "cfgMagazines" >> _x >> "displayName"),getText (configFile >> "cfgMagazines" >> _x >> "displayNameShort")]);
		    	_ctrl lbSetData [(_forEachIndex+1),_x];

		    	if (_currentMag == _x) then {_index = (_foreachIndex +1)};

		    } forEach _currentPylonMag;
		};

		//If mirrored then disable
		_mirror = cbChecked (_display displayCtrl ID_MIROR);
		_mirroredPylon = getNumber ((_x >> "mirroredMissilePos"))-1;
		_ctrl ctrlEnable !(_mirroredPylon == -1 && _mirror);

	    //If we have presets
	    if (isNil "_selectedPrest") then {
	    	_ctrl lbSetCurSel _index;
	    	} else {
	    		_ctrl lbSetCurSel (if (count _selectedPrest > 0) then {_currentPylonMag find (_selectedPrest select _foreachIndex)} else {0});
	    	};


	    _ctrl ctrlAddEventHandler ["LBSelChanged",{
			#define	IDD_DISPLAY_PYLONCHANGE	1031981
			#define	ID_MIROR 2800

			params ["_ctrl","_selected"];
			private ["_display","_mirror","_mirroredPylon","_vehicle","_config","_pylonComponent","_selectedPylon"];

			_vehicle = missionNamespace getVariable ["MCC_fnc_pylonsChangeVehicle",objNull];
			_config = configFile >> "CfgVehicles" >> typeOf _vehicle;
			_pylonComponent = _config >> "Components" >> "TransportPylonsComponent";
			_selectedPylon = ((_pylonComponent >> "pylons") call BIS_fnc_returnChildren) select (ctrlIDC _ctrl - 28000);

			_display = findDisplay IDD_DISPLAY_PYLONCHANGE;
			_mirror = cbChecked (_display displayCtrl ID_MIROR);
			_mirroredPylon = getNumber ((_selectedPylon >> "mirroredMissilePos"))-1;

			if (_mirror && _mirroredPylon >=0) then {
				_ctrl = _display displayCtrl (28000 + _mirroredPylon);
				_ctrl lbSetCurSel _selected;
			};
		}];
	} forEach _pylonsAvailable;
};

MCC_fnc_pylonApply = {
	#define	IDD_DISPLAY_PYLONCHANGE	1031981
	#define	ID_REARM 2801
	#define	ID_REFUEL 2802
	#define	ID_REPAIR 2803


	private ["_vehicle","_exit","_pylonsWeapons","_magType","_config","_pylonComponent","_pylonsAvailable","_ctrl","_success","_turrets","_display","_magData","_rearm","_refuel","_repair"];
	_vehicle = missionNamespace getVariable ["MCC_fnc_pylonsChangeVehicle",objNull];
	if (isNull _vehicle) exitWith {};

	_display = findDisplay IDD_DISPLAY_PYLONCHANGE;
	_config = configFile >> "CfgVehicles" >> typeOf _vehicle;
	_pylonComponent = _config >> "Components" >> "TransportPylonsComponent";
	_pylonsAvailable = (_pylonComponent >> "pylons") call BIS_fnc_returnChildren;
	_turrets= (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};

	//Get the selected turrets
	_magData = [];
	{
		_ctrl = _display displayCtrl (28000 + _foreachIndex);
		_magData pushBack (_ctrl lbData (lbCurSel _ctrl));
	} forEach _pylonsAvailable;

	_rearm = (cbChecked (_display displayCtrl ID_REARM));
	_refuel = (cbChecked (_display displayCtrl ID_REFUEL));
	_repair = (cbChecked (_display displayCtrl ID_REPAIR));

	//Close dialog
	missionNamespace setVariable ["MCC_fnc_pylonsChangeVehicle",nil];
	closeDialog 2;

	//Rearm
	_exit = false;

	{
		[_vehicle,[_foreachIndex + 1,"",true]] remoteexec ["setPylonLoadOut",0];
		[_vehicle,[_foreachIndex + 1,0]] remoteexec ["SetAmmoOnPylon",0];
	} forEach GetPylonMagazines _vehicle;

	_pylonsWeapons = [];
	{ _pylonsWeapons append getArray (_x >> "weapons") } forEach ([_vehicle, configNull] call BIS_fnc_getTurrets);
	{ [_vehicle,_x] remoteexec ["removeWeaponGlobal",0] } forEach ((weapons _vehicle) - _pylonsWeapons);


	{
		if (_exit) exitWith {};

		_magType = _magData select _forEachIndex;
		_weapon = configName _x;

		//If manual and still running
		playSound "gunReload";
		_success = if !(isNull curatorCamera) then {true} else {
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

	//Open rearm for non curatro
	if (isNull curatorCamera) then {
		[_vehicle,_repair,_rearm,_refuel] spawn MCC_fnc_vehicleService;
	};
};

//No pylons just rearm
if (count _pylonsAvailable == 0) exitWith {[_vehicle,true,true,true] spawn MCC_fnc_vehicleService};


while {dialog} do {closeDialog 0};
createDialog "MCC_displayPylonChange";
waitUntil {dialog};

private ["_ctrl","_display","_picPos","_index"];

_display = findDisplay IDD_DISPLAY_PYLONCHANGE;

//Disable refuel,rearm,repair for curator
if !(isNull curatorCamera) then {
	{
		ctrlShow [_x,false];
	} forEach [1001,1002,1003,ID_REARM,ID_REFUEL,ID_REPAIR];
};
ctrlSetText [ID_PICTURE_UI, getText (_pylonComponent >> "uiPicture")];

//Update pylons
[] call MCC_fnc_pylonUpdate;

//Mirror checkbox
_ctrl = _display displayCtrl ID_MIROR;
_ctrl ctrlAddEventHandler ["CheckedChanged", {[] call MCC_fnc_pylonUpdate}];

//Cancel
_ctrl = _display displayCtrl ID_CANCEL;
_ctrl ctrlAddEventHandler ["ButtonClick", {
	missionNamespace setVariable ["MCC_fnc_pylonsChangeVehicle",nil];
	closeDialog 2;
}];

//Apply
_ctrl = _display displayCtrl ID_APPLY;
_ctrl ctrlAddEventHandler ["ButtonClick", {[] spawn MCC_fnc_pylonApply}];

//----Loadouts
_ctrl = _display displayCtrl ID_PRESETCOMBO;
{
	_index = _ctrl lbadd getText (_x >> "displayName");
    _ctrl lbSetData [_index,configName _x];
} forEach ("true" configClasses (_pylonComponent >> "Presets"));
 _ctrl lbSetCurSel 0;

_ctrl ctrlAddEventHandler ["LBSelChanged", {
	params ["_ctrl","_selected"];
	private ["_preSets","_selectedPrest","_config","_pylonComponent","_vehicle"];

	_vehicle = missionNamespace getVariable ["MCC_fnc_pylonsChangeVehicle",objNull];
	if (isNull _vehicle) exitWith {};

	_config = configFile >> "CfgVehicles" >> typeOf _vehicle;
	_pylonComponent = _config >> "Components" >> "TransportPylonsComponent";

	_preSets = "true" configClasses (_pylonComponent >> "Presets");
	_selectedPrest = getArray ((_preSets select _selected) >> "attachment");

	[_selectedPrest] call MCC_fnc_pylonUpdate;
}];
