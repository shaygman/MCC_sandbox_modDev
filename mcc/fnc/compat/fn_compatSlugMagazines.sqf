/*
	MCC_fnc_compatSlugMagazines
	Finds every shotgun slug magazine in the loaded mods by scanning CfgMagazines once (result is cached).
	A magazine counts when its class name or its ammo class name contains "slug" and the ammo is a
	bullet/shell/spread type. Used for the breaching and non-lethal ammo settings (firedMan magazine names).
	Params: none
	Returns: ARRAY of STRING - magazine class names (a copy of the cache)
*/
if (isNil "MCC_compat_slugMagazines") then {
	private _result = [];
	private _sims = ["shotbullet","shotshell","shotspread"];

	{
		private _mag = configName _x;
		private _ammo = getText (_x >> "ammo");
		if (_ammo != "" && {((toLowerANSI _mag) find "slug") >= 0 || {((toLowerANSI _ammo) find "slug") >= 0}}) then {
			private _sim = toLowerANSI getText (configFile >> "CfgAmmo" >> _ammo >> "simulation");
			if (_sim in _sims) then {_result pushBackUnique _mag};
		};
	} forEach ("getNumber (_x >> 'scope') > 0" configClasses (configFile >> "CfgMagazines"));

	MCC_compat_slugMagazines = _result;
	diag_log format ["MCC compat: %1 slug magazines found: %2", count _result, _result];
};

+MCC_compat_slugMagazines
