/* ================================  MCC_fnc_RscAttributeVehicleCargo ===================================

*/
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

_mode = _this select 0;
_params = _this select 1;
_entity = _this select 2;

switch _mode do {
	case "onLoad": {

		_display = _params select 0;

		//--- Add handlers
		_ctrl = _display displayctrl 23753;

		//--- build listbox of all items
		if (isClass (configFile >> "CfgPatches" >> "ace_cargo")) then {
			// ACE EH
			[{
			    params ["_args", "_handler"];
			    private ["_cargoItems","_index","_class","_displayName"];
			    _args params ["_vehicle", "_ctrl"];

			    // Display closed or vehicle deleted
			    if (isNull _ctrl || {isNull _vehicle || {!alive _vehicle}}) exitWith {
			        [_handler] call CBA_fnc_removePerFrameHandler;
			    };

			    // Update cargo list
			   _cargoItems = _vehicle getVariable ["ACE_cargo_loaded", []];

			    lbClear _ctrl;
			    {
			        _class = if (_x isEqualType "") then {_x} else {typeOf _x};
			        _index = ctrl lbAdd (getText (configFile >> "CfgVehicles" >> _class >> "displayName"));
			        _ctrl lbSetPicture [_index, (getText (configFile >> "cfgVehicles" >> _class >> "editorPreview"))];
			    } forEach _cargoItems;
			}, 0.25, [_entity, _ctrl]] spawn CBA_fnc_addPerFrameHandler;
		} else {
			player setVariable ["interactWith",_entity];
			//MCC Cargo EH
			[{
			    params ["_args", "_handler"];
			    _args params ["_object", "_ctrl"];
			    private ["_cargoItems","_index"];
			    // Display closed or vehicle deleted
			    if (isNull _ctrl || {isNull _vehicle || {!alive _vehicle}}) exitWith {
			        [_handler] call CBA_fnc_removePerFrameHandler;
			    };

			    // Update cargo list
			    _cargoItems = _object getVariable ["MCC_logisticsCargo",[]];
			    lbClear _ctrl;
			    {
			        _index = _ctrl lbAdd (getText (configFile >> "cfgVehicles" >> (_x select 0) >> "displayname"));
					_ctrl lbSetPicture [_index, (getText (configFile >> "cfgVehicles" >> (_x select 0) >> "editorPreview"))];
					_ctrl lbsetData [_index, (_x select 0)];
			    } forEach _cargoItems;
			}, 0.25, [_entity, _ctrl]] call CBA_fnc_addPerFrameHandler;
		};

		_ctrl ctrladdeventhandler ["LBDblClick","['LBDblClick',[_this select 0,_this select 1,0.5]] spawn MCC_fnc_RscAttributeVehicleCargo;"];
		_ctrl ctrlcommit 0;
	};

	case "LBDblClick": {
		_control = _params select 0;
		_index = _params select 1;
		_delay = _params select 2;

		//Don't over use it put delay
		if !(missionNamespace getVariable ["MCC_fnc_RscAttributeVehicleCargo_runing",false]) then {
			missionNamespace setVariable ["MCC_fnc_RscAttributeVehicleCargo_runing",true];

			if (isClass (configFile >> "CfgPatches" >> "ace_cargo")) then {

			} else {
				//MCC Cargo
				[_control, _index] spawn MCC_fnc_logisticsCargoUnload;
			};

			sleep _delay;
			missionNamespace setVariable ["MCC_fnc_RscAttributeVehicleCargo_runing",false];
		};
	};

	case "confirmed": {
		_display = _params select 0;
		_selected = uinamespace getvariable ["MCC_RscAttributeLights_selected",0];
		_entities = if (typename _entity == typename grpnull) then {vehicle leader _entity} else {[_entity]};

		{
			[_x, _selected] remoteExec ["MCC_fnc_vehicleLights", _x];
		} foreach _entities;
		false
	};
	case "onUnload": {
		MCC_RscAttributeLights_selected = nil;
	};
};