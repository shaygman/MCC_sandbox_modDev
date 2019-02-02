#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

_mode = _this select 0;
_params = _this select 1;
_entity = _this select 2;


_idcs = [
	23603, //On
	23604,	//Off
	23605	//Auto
];

switch _mode do {
	case "onLoad": {

		_display = _params select 0;

		//--- Add handlers to all buttons
		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrladdeventhandler ["buttonclick","with uinamespace do {['onButtonClick',[_this select 0,0.1]] call MCC_RscAttributeEngine};"];
			_ctrl ctrlcommit 0;
		} foreach _idcs;

		//--- Select the current rank
		if (typename _entity == typename grpnull) then {_entity = vehicle leader _entity;};

		_idc = if (_entity getVariable ["MCCcuratorUnitEngine",-1] == 2) then {23605} else {
			if (isengineOn _entity) then {23603} else {23604};
		};

		['onButtonClick',[_display displayctrl _idc,0]] call MCC_RscAttributeEngine;
	};
	case "onButtonClick": {
		_control = _params select 0;
		_delay = _params select 1;
		_display = ctrlparent _control;
		{
			_ctrl = _display displayctrl _x;
			_ctrl ctrlsettextcolor [1,1,1,0.5];
			[_ctrl,1,_delay] call bis_fnc_ctrlsetscale;
		} foreach _idcs;
		_control ctrlsettextcolor [1,1,1,1];
		[_control,1.25,_delay] call bis_fnc_ctrlsetscale;
		MCC_RscAttributeEngine_selected = _idcs find (ctrlidc _control);
	};
	case "confirmed": {
		_display = _params select 0;
		_selected = uinamespace getvariable ["MCC_RscAttributeEngine_selected",0];
		_entities = if (typename _entity == typename grpnull) then {vehicle leader _entity} else {[_entity]};

		{
			[_x, _selected] remoteExec ["MCC_fnc_vehicleEngine", _x];
		} foreach _entities;
		false
	};
	case "onUnload": {
		MCC_RscAttributeEngine_selected = nil;
	};
};