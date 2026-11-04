#define CP_RESPAWNPANEL_IDD (uiNamespace getVariable "CP_RESPAWNPANEL_IDD")

private ["_ok","_key","_index","_commander","_screen"];
disableSerialization;

_key = _this;
if (isnil "_key") then {_key = []};

//If we didn't came from the addAction
if (count _key > 4) then {
	_index = _key select 4;
} else {
	_index = (_key select 3) select 4;
};

_screen = missionNamespace getvariable ["MCC_mcc_screen",0];

// Index 0 used to open the old MCC main menu. MCC5 replaced it with Zeus: MCC users get a curator
// (MCC_fnc_curatorAutoAssign) and every old menu feature is an MCC Zeus or Eden module.
if (_index == 0) exitWith {
	if (!isNull (getAssignedCuratorLogic player)) then {
		if (isNull curatorCamera) then {openCuratorInterface};
	} else {
		systemChat "MCC: you don't have MCC access (Zeus). Ask the mission maker or an admin.";
	};
};

//Close dialog if it open
if (dialog) exitWith {
		while {dialog} do {closeDialog 0};
};

//Console
_commander = ((MCC_server getVariable [format ["CP_commander%1",side player],""]) == getPlayerUID player) or ("MCC_itemConsole" in (assignedItems player));
if ((_index == 1) && _commander && (missionNamespace getVariable ["MCC_allowConsole",true])) exitWith {
	if (dialog) then {
		while {dialog} do {closeDialog 0};
	} else {
		_null = [nil,nil,nil,[0]] spawn MCC_fnc_s_conoleOpenMenu;
	};
};

//Squad Dialog
if (_index == 2) exitWith {
	while {dialog} do {closeDialog 0; sleep 0.01};
	createDialog "CP_RESPAWNPANEL";
};

//SQL PDA
if (_index == 3 && ((count units player > 1) && (leader player == player)) && (missionNamespace getVariable ["MCC_allowsqlPDA",true])) exitWith {
	while {dialog} do {closeDialog 0};
	createDialog "MCC_SQLPDA";
};