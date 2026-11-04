/*
	MCC_fnc_supplyFuelCoef
	Runs on every machine (server, headless clients, players): applies the MCC_logisticsFuelConsumption
	setting to vehicles local to this machine with setFuelConsumptionCoef (Arma 3 2.16+, argument local).
	Only active while MCC_logisticsMode > 0; puts vehicles back to 1 when the mode is turned off.
	Re-checks every 15 s so vehicles that change locality get the coefficient from their new owner.
	Params: none
	Returns: Nothing
*/
if (!isNil "MCC_supplyFuelCoefRunning") exitWith {};
MCC_supplyFuelCoefRunning = true;

while {true} do {
	sleep 15;
	private _mode = missionNamespace getVariable ["MCC_logisticsMode", 0];
	private _coef = if (_mode > 0) then {missionNamespace getVariable ["MCC_logisticsFuelConsumption", 1]} else {1};

	{
		if (local _x && {alive _x} && {(_x getVariable ["MCC_fuelCoefSet", 1]) != _coef}) then {
			_x setFuelConsumptionCoef _coef;
			_x setVariable ["MCC_fuelCoefSet", _coef];
		};
	} forEach (vehicles select {_x isKindOf "LandVehicle" || {_x isKindOf "Air"} || {_x isKindOf "Ship"}});
};
