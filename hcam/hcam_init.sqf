hcam_basepath = MCC_path + "hcam\";
hcam_configpath = "";
hcamNVG = 0;	//Regular cam
if (isDedicated) exitWith {};

hcam_active = false;
hcam_id = 0;
hcam_zoom = 1;

hcam_ui_init = {
	_disp = _this select 0;
	uiNamespace setVariable ["hcam_ui_disp", _disp];
	uiNamespace setVariable ["hcam_ctrl_pip", _disp displayCtrl 0];
	uiNamespace setVariable ["hcam_ctrl_title", _disp displayCtrl 1];
	uiNamespace setVariable ["hcam_ctrl_back", _disp displayCtrl 2];
	uiNamespace setVariable ["hcam_ctrl_front", _disp displayCtrl 3];
	(_disp displayCtrl 0) ctrlSetText "#(argb,256,256,1)r2t(rendertarget0,1.0)";
};

// Init
waitUntil {!isNull (findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["KeyDown"," nul=[_this select 1,_this select 2,_this select 3,_this select 4] execVM (hcam_basepath+'input.sqf'); "];
