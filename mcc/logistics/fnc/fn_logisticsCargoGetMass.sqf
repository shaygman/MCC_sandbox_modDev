/*=========================================================== MCC_fnc_logisticsCargoGetMass =============================================================================
Calculate vehicle cargo mass

<IN>
	0: OBJECT - vehicle

<OUT>
	INTEGER - total mass
=======================================================================================================================================================================
*/
(getNumber (configfile >> "CfgVehicles" >> typeOf _this >> "transportMaxMagazines"))*4;