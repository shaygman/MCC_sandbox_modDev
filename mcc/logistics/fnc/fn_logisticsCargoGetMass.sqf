/*=========================================================== MCC_fnc_logisticsCargoGetMass =============================================================================
Calculate vehicle cargo mass

<IN>
	0: OBJECT - vehicle

<OUT>
	INTEGER - total mass
=======================================================================================================================================================================
*/

_this params ["_object"];

(getNumber (configfile >> "CfgVehicles" >> typeOf _object >> "transportMaxBackpacks"))*50;