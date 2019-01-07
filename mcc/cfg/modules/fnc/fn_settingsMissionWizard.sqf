/*=========================================================== MCC_fnc_settingsMissionWizard ========================================================================

		Sets default variables for the mission wizard feature of MCC
*/

_module = param [0, objNull, [objNull]];
if (isNull _module) exitWith {deleteVehicle _module};

private ["_varClases","_synced","_varName"];

_varName = switch (_module getvariable ["VariableName",0]) do
			{
				case 0:	{"MCC_MWHVT"};
				case 1:	{"MCC_MWRadio"};
				case 2:	{"MCC_MWFuelTanks"};
				case 3:	{"MCC_MWTanks"};
				case 4:	{"MCC_MWAir"};
				case 5:	{"MCC_MWcache"};
				case 6:	{"MCC_MWradar"};
				case 7:	{"MCC_MWIntelObjects"};
				case 8:	{"MCC_MWIED"};
				case 9:	{"MCC_MWAA"};
				case 10:	{"MCC_MWArtillery"};

				default	{"MCC_MWHVT"};
			};
_varClases = call compile (_module getvariable ["VariableClass","[]"]);

waituntil {missionNamespace getVariable ["MCC_initDone",false]};

if (isNil "_varClases") then {
	_varClases = [];
};

if (typeName _varClases != typeName []) then {
	_varClases = [];
};

//Who synced with the module
_synced = synchronizedobjects _module;

{
	_varClases pushBack (typeof vehicle _x);
	deleteVehicle _x;
} forEach _synced;

