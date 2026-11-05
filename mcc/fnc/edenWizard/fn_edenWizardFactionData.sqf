/*=================================================== MCC_fnc_edenWizardFactionData ===================================================
	Collects what the editor-time Mission Wizard can place for one faction, from config only (CfgFactionClasses,
	CfgVehicles, CfgGroups). Cached per faction for the game session (uiNamespace "MCC5MW_factionData").

	Params:
		0: STRING - faction class name (CfgFactionClasses)
	Returns: HASHMAP - keys:
		"side" SIDE, "sideNum" NUMBER (0 east, 1 west, 2 resistance, 3 civilian), "name" STRING
		"men", "officers" - ARRAY of CfgVehicles soldier classes
		"carsArmed", "cars", "armor", "artySP", "staticMG", "mortars", "air" - ARRAY of CfgVehicles classes
		"grpInf", "grpMot", "grpMech", "grpAir", "grpStatic" - ARRAY of CfgGroups group CONFIGs
	Example: private _data = ["OPF_F"] call MCC_fnc_edenWizardFactionData;
*/
params [["_faction", "OPF_F", [""]]];

private _cache = uiNamespace getVariable "MCC5MW_factionData";
if (isNil "_cache") then {
	_cache = createHashMap;
	uiNamespace setVariable ["MCC5MW_factionData", _cache];
};

private _cached = _cache getOrDefault [toLowerANSI _faction, []];
if (_cached isNotEqualTo []) exitWith {_cached};

private _data = createHashMap;
private _factionCfg = configFile >> "CfgFactionClasses" >> _faction;
private _sideNum = getNumber (_factionCfg >> "side");
if !(_sideNum in [0, 1, 2, 3]) then {_sideNum = 0};

_data set ["sideNum", _sideNum];
_data set ["side", [east, west, resistance, civilian] select _sideNum];
_data set ["name", [getText (_factionCfg >> "displayName"), _faction] select (getText (_factionCfg >> "displayName") == "")];

//------------------------------------------------ CfgVehicles ------------------------------------------------
private _men = [];
private _officers = [];
private _carsArmed = [];
private _cars = [];
private _armor = [];
private _artySP = [];
private _staticMG = [];
private _mortars = [];
private _air = [];

//A turret weapon that is not a horn
private _fnc_armed = {
	params ["_cfg"];
	private _armed = false;
	{
		private _weapons = getArray (_x >> "weapons");
		if ((_weapons findIf {!("horn" in toLowerANSI _x) && {_x != ""}}) > -1) exitWith {_armed = true};
	} forEach ("isClass _x" configClasses (_cfg >> "Turrets"));
	_armed
};

{
	private _class = configName _x;
	private _lower = toLowerANSI _class;
	switch (true) do {
		case (_class isKindOf "CAManBase"): {
			private _vehClass = getText (_x >> "vehicleClass");
			if (
				!(_vehClass in ["MenDiver", "MenStory", "MenVR"])
				&& {(["_vr_", "diver", "pilot", "crew", "unarmed", "survivor", "story", "_ghillie_"] findIf {_x in _lower}) < 0}
			) then {
				_men pushBack _class;
				if ("officer" in _lower || {"commander" in _lower}) then {_officers pushBack _class};
			};
		};
		case (_class isKindOf "StaticMortar"): {_mortars pushBack _class};
		case (_class isKindOf "StaticWeapon"): {
			if ([_x] call _fnc_armed) then {_staticMG pushBack _class};
		};
		case (_class isKindOf "Tank" || {_class isKindOf "Wheeled_APC_F"}): {
			if (getNumber (_x >> "artilleryScanner") == 1) then {_artySP pushBack _class} else {_armor pushBack _class};
		};
		case (_class isKindOf "Car"): {
			if (getNumber (_x >> "artilleryScanner") == 1) then {
				_artySP pushBack _class;
			} else {
				if ([_x] call _fnc_armed) then {_carsArmed pushBack _class} else {_cars pushBack _class};
			};
		};
		case (_class isKindOf "Air"): {
			if !(_class isKindOf "ParachuteBase") then {_air pushBack _class};
		};
	};
} forEach (format ["getNumber (_x >> 'scope') == 2 && {getText (_x >> 'faction') == '%1'}", _faction] configClasses (configFile >> "CfgVehicles"));

_data set ["men", _men];
_data set ["officers", _officers];
_data set ["carsArmed", _carsArmed];
_data set ["cars", _cars];
_data set ["armor", _armor];
_data set ["artySP", _artySP];
_data set ["staticMG", _staticMG];
_data set ["mortars", _mortars];
_data set ["air", _air];

//------------------------------------------------ CfgGroups ------------------------------------------------
private _grpInf = [];
private _grpMot = [];
private _grpMech = [];
private _grpAir = [];
private _grpStatic = [];

{
	private _sideCfg = _x;
	if (configName _sideCfg != "Empty") then {
		{
			private _factionGroupsCfg = _x;
			private _isFaction = configName _factionGroupsCfg == _faction;
			{
				{
					private _grpCfg = _x;
					private _grpFaction = getText (_grpCfg >> "faction");
					if (_isFaction || {_grpFaction == _faction}) then {
						private _units = ("isClass _x" configClasses _grpCfg) apply {getText (_x >> "vehicle")};
						_units = _units select {isClass (configFile >> "CfgVehicles" >> _x)};
						if (_units isNotEqualTo []) then {
							switch (true) do {
								case ((_units findIf {_x isKindOf "Ship"}) > -1): {};
								case ((_units findIf {_x isKindOf "Air"}) > -1): {_grpAir pushBack _grpCfg};
								case ((_units findIf {_x isKindOf "StaticWeapon"}) > -1): {_grpStatic pushBack _grpCfg};
								case ((_units findIf {_x isKindOf "Tank" || {_x isKindOf "Wheeled_APC_F"}}) > -1): {_grpMech pushBack _grpCfg};
								case ((_units findIf {_x isKindOf "Car"}) > -1): {_grpMot pushBack _grpCfg};
								case ((_units findIf {!(_x isKindOf "CAManBase")}) < 0): {
									//No divers in a land mission
									if ((_units findIf {getText (configFile >> "CfgVehicles" >> _x >> "vehicleClass") == "MenDiver" || {"diver" in toLowerANSI _x}}) < 0) then {
										_grpInf pushBack _grpCfg;
									};
								};
							};
						};
					};
				} forEach ("isClass _x" configClasses _x);
			} forEach ("isClass _x" configClasses _factionGroupsCfg);
		} forEach ("isClass _x" configClasses _sideCfg);
	};
} forEach ("isClass _x" configClasses (configFile >> "CfgGroups"));

_data set ["grpInf", _grpInf];
_data set ["grpMot", _grpMot];
_data set ["grpMech", _grpMech];
_data set ["grpAir", _grpAir];
_data set ["grpStatic", _grpStatic];

diag_log format ["MCC Mission Wizard: faction %1 side %2 - men %3, inf groups %4, mot %5, mech %6, armed cars %7, armor %8, statics %9, mortars %10",
	_faction, _sideNum, count _men, count _grpInf, count _grpMot, count _grpMech, count _carsArmed, count _armor, count _staticMG, count _mortars];

_cache set [toLowerANSI _faction, _data];
_data
