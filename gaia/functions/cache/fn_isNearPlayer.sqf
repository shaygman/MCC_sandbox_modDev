// F3 - Near Player Function
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
// In:  [position, distance]
// Out: true when a player is closer than distance to position
// On the server the player list is taken from GAIA_PLAYER_LIST (refreshed every
// second by the GAIA per-frame handler) instead of being rebuilt on every call.
// ====================================================================================

params ["_pos", "_distance"];

private _players = [];

if (isServer && {!isNil "GAIA_PLAYER_LIST_TIME"} && {(time - GAIA_PLAYER_LIST_TIME) < 2}) then {
	_players = GAIA_PLAYER_LIST;
} else {
	// Create a list of all players
	if (count(playableUnits)==0) then
	{
		_players = [player];
	}
	else
	{
		_players = playableUnits select {isPlayer _x};
	};
};

// Check whether a player is in the given distance - return true if yes
(_players findIf {(_x distance _pos) < _distance}) > -1
