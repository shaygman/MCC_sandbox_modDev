/*
	GAIA_fnc_getTurretWeapons
	In:  STRING (CfgVehicles class) or OBJECT (as _this)
	Out: ARRAY of [weapon, magazines, turret path, turret config string]
	Config only, so the result is cached per class in GAIA_TURRET_WEAPONS_CACHE
	(a copy is returned, callers may modify it).
*/
     private ["_result", "_getAnyMagazines", "_findRecurse", "_class", "_cacheKey", "_cached"];
     _cacheKey = switch (typeName _this) do {
         case "STRING" : {toLower _this};
         case "OBJECT" : {toLower (typeOf _this)};
         default {""};
     };
     if (isNil "GAIA_TURRET_WEAPONS_CACHE") then {GAIA_TURRET_WEAPONS_CACHE = createHashMap};
     _cached = GAIA_TURRET_WEAPONS_CACHE get _cacheKey;
     if (!isNil "_cached") exitWith {+_cached};
     _result = [];
     _getAnyMagazines = {
         private ["_weapon", "_mags"];
         _weapon = configFile >> "CfgWeapons" >> _this;
         _mags = [];
         {
             _mags = _mags + getArray (
                 (if (_x == "this") then { _weapon } else { _weapon >> _x }) >> "magazines"
             )
         } foreach getArray (_weapon >> "muzzles");
         _mags
     };
     _findRecurse = {
         private ["_root", "_class", "_path", "_currentPath"];
         _root = (_this select 0);
         _path = +(_this select 1);
         for "_i" from 0 to count _root -1 do {
             _class = _root select _i;
             if (isClass _class) then {
                 _currentPath = _path + [_i];
                 {
                     _result set [count _result, [_x, _x call _getAnyMagazines, _currentPath, str _class]];
                 } foreach getArray (_class >> "weapons");
                 _class = _class >> "turrets";
                 if (isClass _class) then {
                     [_class, _currentPath] call _findRecurse;
                 };
             };
         };
     };
     _class = (
         configFile >> "CfgVehicles" >> (
             switch (typeName _this) do {
                 case "STRING" : {_this};
                 case "OBJECT" : {typeOf _this};
                 default {nil}
             }
         ) >> "turrets"
     );
     [_class, []] call _findRecurse;
     if (_cacheKey != "") then {GAIA_TURRET_WEAPONS_CACHE set [_cacheKey, +_result]};
     _result;