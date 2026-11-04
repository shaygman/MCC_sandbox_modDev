/*=================================================== MCC_fnc_edenGroupGAIA ===================================================
	Eden group attribute "MCC: GAIA Control" (Cfg3DEN >> Group, mcc\cfg\cfg3DEN.hpp). Puts an Eden placed group under GAIA
	control at mission start, the same way MCC_fnc_AI_assignToZone does in Zeus: sets GAIA_ZONE_INTEND [zone, intend]
	(public) and registers the group with GAIA_fnc_registerGroup on the server.
	The attribute expressions store the values on the group first (MCC_edenGaiaZone / MCC_edenGaiaIntend /
	MCC_edenGaiaCache); this function waits for the mission start so all of them are set.

	Params:
		0: GROUP - the group
	Returns: nothing (spawns)
	Example: [group this] call MCC_fnc_edenGroupGAIA;
*/
params [["_group", grpNull, [grpNull]]];

if (!isServer || {isNull _group}) exitWith {};
if (_group getVariable ["MCC_edenGaiaQueued", false]) exitWith {};
_group setVariable ["MCC_edenGaiaQueued", true];

[_group] spawn {
	params ["_group"];

	//All attribute expressions have run once the mission time starts
	waitUntil {sleep 0.5; time > 0};
	if (isNull _group || {count units _group == 0}) exitWith {};

	private _zone = _group getVariable ["MCC_edenGaiaZone", 0];
	if (_zone isEqualType "") then {_zone = parseNumber _zone};
	if (!(_zone isEqualType 0) || {_zone < 1}) exitWith {};

	private _intend = _group getVariable ["MCC_edenGaiaIntend", "MOVE"];
	if !(_intend isEqualType "") then {_intend = "MOVE"};

	private _cache = _group getVariable ["MCC_edenGaiaCache", false];
	if !(_cache isEqualType true) then {_cache = false};

	_group setVariable ["GAIA_ZONE_INTEND", [str (round _zone), _intend], true];
	_group setVariable ["mcc_gaia_cache", _cache, true];
	[_group] call GAIA_fnc_registerGroup;
};
