/*================================================MCC_fnc_MWnextZoneNumber===========================================================================================
	Reserve the next free MCC zone number.
	The number is picked and written into MCC_zones_numbers in one unscheduled block, so concurrent Mission Wizard /
	campaign AO generation never gets the same number twice. Call MCC_fnc_MWUpdateZone with the result right after.

	Params: none
	Returns: NUMBER - the reserved zone number (>= 1)
	Example: _zoneNumber = [] call MCC_fnc_MWnextZoneNumber;
//==================================================================================================================================================================*/
private _zoneNumber = 0;

isNil {
	private _zones = missionNamespace getVariable ["MCC_zones_numbers",[]];
	_zoneNumber = (count _zones) + 1;
	_zones set [_zoneNumber - 1, _zoneNumber];
	missionNamespace setVariable ["MCC_zones_numbers",_zones];
};

_zoneNumber
