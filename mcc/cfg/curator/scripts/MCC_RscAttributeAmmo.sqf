#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

_mode = _this select 0;
_params = _this select 1;
_unit = _this select 2;

switch _mode do {
	case "onLoad": {
		_display = _params select 0;
		_ctrlSlider = _display displayctrl 23702;
		_ctrlSlider slidersetposition (_unit getVariable ["MCC_ammoCountCurator",0.5]) * 10;
		_ctrlSlider ctrlenable alive _unit;
	};
	case "confirmed": {
		_display = _params select 0;
		_ctrlSlider = _display displayctrl 23702;
		_ammo = sliderposition _ctrlSlider * 0.1;
		_unit setVariable ["MCC_ammoCountCurator",_ammo,true];
		[_unit,_ammo] remoteExec ["setVehicleAmmo", _unit];
	};
	case "onUnload": {
	};
};