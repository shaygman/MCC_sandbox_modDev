/*=================================================================MCC_fnc_curatorClientInit========================================================================
	CLIENT postInit: Zeus access without the old MCC menu.
	- CBA keybind "Open Zeus (MCC)" (default Ctrl+Delete, the old "Open MCC" key) opens the Zeus interface when the player
	  has a curator.
	- Tells the server the client is ready (MCC_curatorClientReady) so MCC_fnc_curatorAutoAssign can give it a curator.
	- Adds MCC's curator event handlers (MCC_curatorMouseOver used by MCC modules, init line on double click) to curators
	  created at runtime by MCC_fnc_curatorAutoAssign; init.sqf only handles the curators that exist at mission start.
	Params: none
	Returns: nothing
//==================================================================================================================================================================*/
if (!hasInterface) exitWith {};

if (!isNil "CBA_fnc_addKeybind") then {
	["MCC", "openZeusMCC", ["Open Zeus (MCC)", "Open the Zeus interface with all MCC modules (MCC users only)"], {
		if (!isNull curatorCamera || {!isNull (findDisplay 312)}) exitWith {false};
		if (dialog) exitWith {false};
		if (isNull (getAssignedCuratorLogic player)) exitWith {
			systemChat "MCC: you have no Zeus access";
			true
		};
		openCuratorInterface;
		true
	}, {}, [211, [false, true, false]], false] call CBA_fnc_addKeybind;
};

[] spawn {
	waitUntil {sleep 0.5; !isNull player && {!isNull (findDisplay 46)}};

	//init.sqf adds the handlers to the curators that exist when the main display opens
	sleep 3;
	private _known = allCurators;

	while {true} do {
		if (!isNull player && {!(player getVariable ["MCC_curatorClientReady", false])}) then {
			player setVariable ["MCC_curatorClientReady", true, true];
		};

		private _cur = getAssignedCuratorLogic player;
		if (!isNull _cur && {!(_cur in _known)} && {!(_cur getVariable ["MCC_curatorClientEHs", false])}) then {
			_cur setVariable ["MCC_curatorClientEHs", true];
			_cur addEventHandler ["CuratorObjectDoubleClicked", {missionNamespace setVariable ["BIS_fnc_initCuratorAttributes_target", (_this select 1)]; _this spawn MCC_fnc_curatorInitLine}];
			_cur addEventHandler ["CuratorObjectPlaced", {if (local (_this select 1)) then {missionNamespace setVariable ["MCC_curatorMouseOver", curatorMouseOver]}}];
		};

		sleep 5;
	};
};
