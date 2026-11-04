/*
	MCC_fnc_supplyInit
	postInit: starts the limited logistics system. The server runs MCC_fnc_supplyLoop; every machine runs
	MCC_fnc_supplyFuelCoef. Both loops idle cheaply while MCC_logisticsMode is 0 (Off), so the mode can be
	changed during the mission.
	Params: none
	Returns: Nothing
*/
if (isServer) then {[] spawn MCC_fnc_supplyLoop};
if (!is3DEN) then {[] spawn MCC_fnc_supplyFuelCoef};
