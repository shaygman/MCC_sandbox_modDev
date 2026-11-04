/*
	MCC_fnc_curatorMenuButton  (postInit, clients)
	Adds an "MCC 5" button to the Zeus screen, like the MCC 5 menu in the Eden editor.
	Clicking it opens a list of every MCC Zeus module (grouped by category). Picking one places that module at the
	center of the screen and opens its options, exactly as if it had been dragged from the Zeus module tree.
	For modules that act on a specific unit or object, drag them from Zeus > Modules > MCC onto that unit instead.
	Params: none
	Returns: nothing
*/
if (!hasInterface) exitWith {};

#define IDC_MCC5_BUTTON 31250
#define IDC_MCC5_LIST 31251

// All MCC Zeus modules, built once from config: [[category, displayName, class], ...]
MCC_curatorMenuModules = [];
{
	private _cat = getText (_x >> "category");
	if (toLowerANSI _cat find "mcc" == 0 && {getNumber (_x >> "scopeCurator") == 2}) then {
		private _catName = getText (configFile >> "CfgFactionClasses" >> _cat >> "displayName");
		if (_catName == "") then {_catName = _cat};
		MCC_curatorMenuModules pushBack [_catName, getText (_x >> "displayName"), configName _x];
	};
} forEach ("isClass _x" configClasses (configFile >> "CfgVehicles"));
MCC_curatorMenuModules sort true;

MCC_fnc_curatorMenuPlace = {
	params [["_class", "", [""]]];
	if (_class == "" || {isNull (getAssignedCuratorLogic player)}) exitWith {};
	private _pos = screenToWorld [0.5, 0.5];
	private _grp = createGroup [sideLogic, true];
	private _logic = _grp createUnit [_class, _pos, [], 0, "CAN_COLLIDE"];
	(getAssignedCuratorLogic player) addCuratorEditableObjects [[_logic], false];
};

MCC_fnc_curatorMenuCreate = {
	params ["_display"];
	private _w = 0.09 * safezoneW;
	private _h = 0.035 * safezoneH;
	private _x0 = safezoneX + safezoneW * 0.5 - _w * 2.6;
	private _y0 = safezoneY + 0.005 * safezoneH;

	private _btn = _display ctrlCreate ["RscButton", IDC_MCC5_BUTTON];
	_btn ctrlSetPosition [_x0, _y0, _w, _h];
	_btn ctrlSetText "MCC 5";
	_btn ctrlSetTooltip "MCC 5 tools: place an MCC module at the screen center";
	_btn ctrlSetBackgroundColor [0.15, 0.35, 0.1, 0.9];
	_btn ctrlCommit 0;

	private _list = _display ctrlCreate ["RscListBox", IDC_MCC5_LIST];
	_list ctrlSetPosition [_x0, _y0 + _h, _w * 2.4, 0.55 * safezoneH];
	_list ctrlSetBackgroundColor [0, 0, 0, 0.85];
	_list ctrlShow false;
	_list ctrlCommit 0;

	{
		_x params ["_cat", "_name", "_class"];
		private _i = _list lbAdd format ["%1: %2", _cat, _name];
		_list lbSetData [_i, _class];
	} forEach MCC_curatorMenuModules;

	_btn ctrlAddEventHandler ["ButtonClick", {
		params ["_btn"];
		private _list = (ctrlParent _btn) displayCtrl IDC_MCC5_LIST;
		_list ctrlShow !(ctrlShown _list);
		if (ctrlShown _list) then {ctrlSetFocus _list};
	}];
	_list ctrlAddEventHandler ["LBDblClick", {
		params ["_list", "_index"];
		private _class = _list lbData _index;
		_list ctrlShow false;
		[_class] call MCC_fnc_curatorMenuPlace;
	}];
};

[] spawn {
	while {true} do {
		waitUntil {sleep 0.5; !isNull (findDisplay 312)};
		private _display = findDisplay 312;
		if (isNull (_display displayCtrl IDC_MCC5_BUTTON)) then {[_display] call MCC_fnc_curatorMenuCreate};
		waitUntil {sleep 0.5; isNull (findDisplay 312)};
	};
};
